mkdir -p /var/jail/{dev,etc,lib,lib64,usr,bin}
mkdir -p /var/jail/usr/bin
chown root.root /var/jail
mknod -m 666 /var/jail/dev/null c 1 3
cp /etc/ld.so.cache /var/jail/etc/
cp /etc/ld.so.conf /var/jail/etc/
cp /etc/nsswitch.conf /var/jail/etc/
cp /etc/hosts/ /var/jail/etc/
cp /usr/bin/ls /var/jail/usr/bin/
cp /usr/bin/bash /var/jail/usr/bin/bash

# copy the deps for your binaries 
#binpath=$(ldd /bin/ls | grep -Po ".+(?= =>)" | awk '{print $1}' | xargs whereis | awk '{print $2}')

#for sshusers:
# in /etc/ssh/sshd_config : 
#Match group sshusers
#	Chroot Directory /var/jail
#	X11Forwarding no
#	AllowTcpForwarding no


