#!/usr/bin/env sh

if [ $# -lt 2 ]
then
	echo "Usage: $0 <binary> </path/to/copy/to/>"
	exit 1
fi



if [ -d "$2" ]
then
	echo "Path must be a valid directory"
	exit 1
fi

cp /bin/$1 $2/bin/
cp /usr/bin/$1 $2/usr/bin/ 

# copy the deps for your binaries 
for i in $(ldd /bin/$1 | grep -Po ".+(?= =>)" | awk '{print $1}' | xargs whereis | grep -Po "(?<=: ).+" | tr "\r\n" " ")
do
	cp --parents $i $2
	cp $i $2/lib
	cp $i $2/lib64
done
