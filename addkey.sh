#!/usr/bin/env sh

if [ "$#" -ne 4 ]
then
	echo "Usage: $0 <hostname/ip> <username> <password> </path/to/pub/key>"
	exit 1
fi

# ssh-keygen -t rsa -b 4096 -f <file> -N ""
pubkey=$(cat $4)
sshpass -p "$3" ssh -oStrictHostKeyChecking=no -tt -T $2@$1 "echo '$pubkey' >> ~/.ssh/authorized_keys"
