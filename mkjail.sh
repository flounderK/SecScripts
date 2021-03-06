#!/usr/bin/env sh

if [ $# -eq 0 ]
then
	echo "Usage: $0 <username>"
	exit 1
fi
base="/var/jail/$1"

mkdir -p $base/{dev,etc,lib,lib64,usr,bin}
mkdir -p $base/usr/bin
chown root.root $base
mknod -m 666 $base/dev/null c 1 3
cp /etc/ld.so.cache $base/etc/
cp /etc/ld.so.conf $base/etc/
cp /etc/nsswitch.conf $base/etc/
cp /etc/hosts $base/etc/
#cp /bin/{ls,bash,cat} $base/bin/
#cp /usr/bin/{ls,bash,cat} $base/usr/bin/ 

# copy the deps for your binaries 
#for i in $(ldd /bin/{ls,bash,cat} | grep -Po ".+(?= =>)" | awk '{print $1}' | xargs whereis | grep -Po "(?<=: ).+" | tr "\r\n" " ")
#do
#	cp --parents $i $base
#	cp $i $base/lib
#	cp $i $base/lib64
#done

#useradd --shell "$base/usr/bin/bash" --root "$base" "$1"
#for sshusers:
# in /etc/ssh/sshd_config : 
#echo "Match group sshusers\n\tChroot Directory /var/jail\n\tX11Forwarding no\n\tAllowTcpForwarding no" >> /etc/ssh/sshd_config


