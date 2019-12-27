#!/bin/sh
# checking libs using at fs.install, same with hostTools/libcreduction/Makefile
LIST2=`find -L targets/RAX20/fs.install/bin targets/RAX20/fs.install/usr/lib targets/RAX20/fs.install/usr/lib -type f | file -f - | grep "ELF 32-bit" | cut -d':' -f1`

for k in $LIST2
do 
echo checking $k
/opt/toolchains/crosstools-arm-gcc-5.5-linux-4.1-glibc-2.26-binutils-2.28.1/usr/bin/arm-buildroot-linux-gnueabi-readelf -d $k | grep NEEDED | cut -d'[' -f2 | sed -e 's/]//g' | sort | uniq
done;
