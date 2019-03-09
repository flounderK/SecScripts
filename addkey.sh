#!/usr/bin/env sh

usage ()
{
	echo "Usage: $0 <-a|--ipaddress> <-u|--username> <-p|--password> <-k|--public-key> [[-i|--host-file] [-c|--cred-file]]"
	exit 1
}

install_key ()
{
	# Usage: <hostname/ip> <username> <password> </path/to/pub/key>
	if [ ! -f $4 ]
	then
		echo "Public key file does not not exist"
		exit 1
	fi

	pubkey=$(cat $4)
	sshpass -p "$3" ssh -oStrictHostKeyChecking=no -tt -T $2@$1 "echo '$pubkey' >> ~/.ssh/authorized_keys" 2> /dev/null
}

install_key_multiple_hosts ()
{
	# Usage: <host list file> <username> <password> </path/to/pub/key>
	if [ ! -f $1 ] 
	then
		echo "Host list file does not exist"
		exit 1
	fi

	for host in $(cat $1)
	do
		install_key "$host" "$2" "$3" "$4"
	done
}

install_key_multiple_users ()
{
	# Usage: <hostname/ip> </path/to/cred/file> </path/to/pub/key>
	# format: "username password"
	if [ ! -f $2 ]
	then
		echo "Cred file does not exist"
		exit 1
	fi
		
	OIFS=$IFS
	IFS=$'\n'
	for line in $(cat $2)
	do
		IFS=$OIFS
		arr=($line)
		install_key "$1" "${arr[0]}" "${arr[1]}" "$4"
	done
}

install_key_multiple_users_multiple_hosts ()
{
	# who says brute force administration isn't valid?
	# usage: <host file list> </path/to/cred/file> </path/to/pub/key>
	
	if [ ! -f $1 ] 
	then
		echo "Host list file does not exist"
		exit 1
	fi

	if [ ! -f $2 ]
	then
		echo "Cred file does not exist"
		exit 1
	fi
	echo "y'ought'n't've done that, but ok. Brute force it is"
	for host in $(cat $1)
	do
		OIFS=$IFS
		IFS=$'\n'
		for line in $(cat $2)
		do
			IFS=$OIFS
			arr=($line)
			install_key "$host" "${arr[0]}" "${arr[1]}" "$3"
		done
	done

}
if [ "$#" -eq 0 ]
then
	usage
fi

POSITIONAL=()
while [[ $# -gt 0 ]]
do
	key="$1"

	case $key in 
		-a|--ipaddress)
		IPADDRESS="$2"
		shift
		shift
		;;
		-u|--username)
		USERNAME="$2"
		shift
		shift
		;;
		-p|--password)
		PASSWORD="$2"
		shift
		shift
		;;
		-k|--public-key)
		PUB_KEY_PATH="$2"
		shift
		shift
		;;
		-i|--host-file)
		HOST_FILE="$2"
		shift
		shift
		;;
		-c|--cred-file)
		CRED_FILE="$2"
		shift
		shift
		;;
		--default)
		DEFAULT=YES
		shift
		;;
		*)
		POSITIONAL+=("$1")
		shift
		;;
	esac
done
set -- "${POSITIONAL[@]}"
# I'll probably get around to positional args eventually

if [ -n $HOST_FILE ] && [ -n $CRED_FILE ]
then 
	install_key_multiple_users_multiple_hosts "$HOST_FILE" "$CRED_FILE" "$PUB_KEY_PATH"
	exit 0
fi


if [ -n $HOST_FILE ]
then
	install_key_multiple_hosts "$HOST_FILE" "$USERNAME" "$PASSWORD" "$PUB_KEY_PATH"
	exit 0
fi

if [ -n $CRED_FILE ]
then
	install_key_multiple_users "$IPADDRESS" "$CRED_FILE" "$PUB_KEY_PATH"
	exit 0
fi

install_key "$IPADDRESS" "$USERNAME" "$PASSWORD" "$PUB_KEY_PATH"


# ssh-keygen -t rsa -b 4096 -f <file> -N ""
