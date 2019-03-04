#!/usr/bin/env sh

if [ $# -eq 0 ]
then
	echo "Usage: $0 <username>"
	exit 1
fi


mkdir -p /var/jail/$1/{dev,etc,lib,lib64,usr,bin}
mkdir -p /var/jail/$1/usr/bin
chown root.root /var/jail
mknod -m 666 /var/jail/$1/dev/null c 1 3
cp /etc/ld.so.cache /var/jail/$1/etc/
cp /etc/ld.so.conf /var/jail/$1/etc/
cp /etc/nsswitch.conf /var/jail/$1/etc/
cp /etc/hosts /var/jail/$1/etc/
cp /usr/bin/{ls,bash,cat} /var/jail/$1/usr/bin/ 

# copy the deps for your binaries 
binpath=$(ldd /bin/{ls,bash,cat} | grep -Po ".+(?= =>)" | awk '{print $1}' | xargs whereis | awk '{print $2}')
for i in $binpath
do
	cp --parents $i $(echo "/var/jail/$1")
done


#for sshusers:
# in /etc/ssh/sshd_config : 
echo "Match group sshusers\n\tChroot Directory /var/jail\n\tX11Forwarding no\n\tAllowTcpForwarding no" >> /etc/ssh/sshd_config


