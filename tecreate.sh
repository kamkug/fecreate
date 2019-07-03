#!/bin/bash

#Script was created by Kamil Kugler
#I can not take responsibility for any bugs
#it might be introducing as I am dong it only
#for fun. Use at own risk!
#Free to be reproduced if such a will arise.

#--------------------------DESCRIPTION-----------------------------
#
#The script itself create a module.te file only and any further 
#action has to be manually performed, at least as of now.
#This script is to be run using a permissive mode set to 1
#which can be achieved in a following way:
#>>> setenforce permissive
#due to the fact that selinux needs to allow required actions to let 
#a specific process to access its desired destination

#The template it is based on:

#module mypolicy 1.0;
#
#require {
#	type default_t;
#	type httpd_t;
#	class file getattr;
#}
#
#============= httpd_t ==============
#allow httpd_t default_t:file getattr;


#check for user inputs
if [ -z $1 ] || [ -z $2 ];
then
	echo "usage: $0 {source_process} {destination}"
	exit 1
fi

#define essential variables
PROCESS=$1
PROCESS_DEST=$2
FILENAME='dummy.se'

#Collect necessary information that are required by the template 
$(grep $PROCESS /var/log/audit/audit.log | grep -e 'avc.*denied.*'$PROCESS_DEST'.*1$' | uniq -f 5 > $FILENAME)

RESULT=( $(cat $FILENAME) )

if [ -z $RESULT ]; 
then  
	echo "Required entry is not present inside of an audit.log" 
	exit 2
fi

PERMS=( $( grep -oe {.*} $FILENAME | cut -d ' ' -f 2 ) )
TARGET=$( cut -d : -f 9 $FILENAME | uniq -d )
SOURCE=$( cut -d : -f 6 $FILENAME | uniq -d )
CLASS=$(grep -oE 'tclass=.*[ ]' $FILENAME | uniq -d | cut -d = -f 2)

#FOR testing only, can be removed
#cat $FILENAME
#echo $CLASS
#echo $TARGET
#echo $SOURCE
#echo $ENTRIES
#echo ${PERMS[@]}

#Compose a .te file based on the above template
echo -e "module mypolicy 1.0;\n\nrequire {\n    type "$TARGET"\n    type "$SOURCE"\n    class "$CLASS "{ "${PERMS[@]}" }\n}"\
"\n\n============= "$SOURCE" ==============\nallow "$SOURCE $TARGET:$CLASS "{ "${PERMS[@]}" };" > $SOURCE"-to-"$TARGET".te"

#clean afterwards
rm -rf dummy.se

echo "[+] The file has been succesfully created"
