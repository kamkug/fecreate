#!/bin/bash

#Script was created by Kamil Kugler
#Free to be reproduced if such a will arise.


#check for user inputs
if [ -z $1 ] || [ -z $2 ];
then
	echo "[-] usage: $0 {source_process} {destination}"
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
	echo "[-] Required entry is not present inside of an audit.log" 
	exit 2
fi
#Get some basic info for the name of that module
TARGET=$( cut -d : -f 9 $FILENAME | uniq -d )
SOURCE=$( cut -d : -f 6 $FILENAME | uniq -d )

#Create and apply the module automatically
audit2allow -M $SOURCE'-'$TARGET -i $FILENAME &> /dev/null
semodule -i $SOURCE'-'$TARGET.pp

#clean afterwards
rm -rf dummy.se

echo "[+] The whole operation was successful"
