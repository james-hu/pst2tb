#!/bin/bash

# Copyright 2011 James HU (http://james-hu.users.sourceforge.net/blog)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

readpst -V >/dev/null
if [ $? != 0 ]; then
	echo "\"readpst\" must be installed first!"
	echo "Try something simillar to \"yum install readpst\"."
	echo "Or, download the binary from http://www.five-ten-sg.com/libpst/packages/ and install by yourself." 
	exit
fi

ensure_dir_exists ()
{
	if [ ! -d "$1" ]; then
		mkdir -p "$1"
	fi
}

convert_one ()
{
	if [ "$2" == "" ]; then
		output_dir="."
	else
		output_dir="$2"
	fi

	base_name=`basename $1 .pst`
	export_dir="$output_dir/$base_name.tb"

	echo "  ****** Converting contacts ******"
	export_dir_contacts="$export_dir/Contacts"
	ensure_dir_exists "$export_dir_contacts"
	readpst -t c -c v "$1" -o "$export_dir_contacts"
	find "$export_dir_contacts" -type f | xargs -d '\n' -I{} mv "{}" "{}_$base_name.vcf"

	echo "  ****** Converting e-mails ******"
	export_dir_mail="$export_dir/Mail"
	ensure_dir_exists "$export_dir_mail"
	readpst -r -t e "$1" -o "$export_dir_mail"
	find "$export_dir_mail" -type d -path "`echo "$export_dir_mail/*"`" | tac | xargs -d '\n' -I{} mv "{}" "{}.sbd"
	find "$export_dir_mail" -empty -type d | tac | xargs -d '\n' -I{} rmdir "{}"
	if [ `find "$export_dir_mail" -name 'mbox' -type f | wc -l` -gt 0 ]; then
		find "$export_dir_mail" -name 'mbox' -type f | xargs -d '\n' -I{} echo '"{}" "{}"' | sed -e 's/\.sbd\/mbox"$/"/' | xargs -L 1 mv
	fi
	find "$export_dir_mail" -empty -type d | tac | xargs -d '\n' -I{} rmdir "{}"
	find "$export_dir_mail" -type d -name '*.sbd' | sed -e 's/\.sbd$//' | xargs -d '\n' -I{} touch "{}"

	if [ `ls "$export_dir_contacts" | wc -l` -gt 0 ]; then
		ensure_dir_exists "$output_dir/Contacts"
		mv "$export_dir_contacts"/* "$output_dir/Contacts"
	fi
	if [ `ls "$export_dir_mail" | wc -l` -gt 0 ]; then
		ensure_dir_exists "$output_dir/Mail"
		mv "$export_dir_mail"/* "$output_dir/Mail"
	fi
	rm -rf "$export_dir"
}

echo
echo "======================================================================="
echo "What is the location of those .pst files which will be converted?"
echo "     You may specify a directory in which *.pst files will be searched."
echo "     Or, you may specify a single file."
echo "======================================================================="
echo "Please enter the location:"
echo "(Don't quote directory with blank characters with \"\"!)"
input_valid=0
while [ $input_valid == 0 ]; do
	read location_input
	if [ -d "$location_input" ]; then
		IFS='
'
		files=(`find "$location_input" -type f -name '*.pst'`)
		if [ ${#files[*]} == 0 ]; then
			echo "No *.pst file found."
			echo "Please specify another location:"
		else
			input_valid=1
		fi
	else
		if [ -f "$location_input" ]; then
			files=("$location_input")
			input_valid=1
		else
			echo "The location you specified does not seem to be valid."
			echo "Please specify another location:"
		fi
	fi
done

echo
echo "======================================================================="
echo "Where do you want the output files to be written?"
echo "     Please specify a directory."
echo "     Or, just enter \".\" if you want to specify current directory."
echo "======================================================================="
echo "Please enter the location:"
echo "(Don't quote directory with blank characters with \"\"!)"
input_valid=0
while [ $input_valid == 0 ]; do
	read location_output
	if [ -d "$location_output" ]; then
		input_valid=1
	else
		echo "The directory specified does not exist."
		echo "Creating directory: $location_output"
		mkdir "$location_output"
		if [ -d "$location_output" ]; then
			echo "Directory created."
			input_valid=1
		else
			echo "Failed to create the directory."
			echo "Please specify another location:"
		fi
	fi
done

echo
echo "======================================================================="
echo "Please confirm:"
echo "   Files to be converted:"
for i in ${files[*]}; do
	echo "    \"$i\""
done
echo "   Output directory:"
echo "    \"$location_output\""
echo "======================================================================="
echo "Proceed? (y/n)"
read proceed
if [ "$proceed" != "y" ]; then
	echo "Quited."
	exit
fi

count=1
total=${#files[*]}
for i in ${files[*]}; do
	echo "------------------------------------------------------------------"
	echo "Converting $count of $total : \"$i \""
	echo "------------------------------------------------------------------"
	convert_one "$i" "$location_output"
	let count++
done
echo "----------------------------------------"
echo "Finished."



