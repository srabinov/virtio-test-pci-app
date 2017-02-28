#!/bin/bash

if (($# < 1))
then
	echo "syntax: $0 <num iter>"
	exit 1
fi

id=$(id | grep root)

if [ -z "$id" ]
then
	echo "you must use sudo to run this script..."
	exit 1
fi

drv=$(lsmod | grep virtio_test_pci)

if [ -z "$drv" ]
then
	echo "please load virtio_test_pci driver first!"
	echo "# sudo modprobe virtio_test_pci"
	exit 1
fi

MAJOR=$(dmesg | grep "test_pci driver(major" | awk -F"major " '{print $2}' | cut -d ')' -f 1)

if [ -z "$MAJOR" ]
then
	echo "your dmesg does not contain driver major!"
	echo "you must unload & load the driver."
	echo "# sudo modprobe -r virtio_test_pci && sudo modprobe virtio_test_pci"
	exit 1
fi

if [ -e "/dev/test_pci" ] 
then
	echo "remove previous /dev/test_pci..."
	rm -f /dev/test_pci
fi

mknod /dev/test_pci c $MAJOR 0

for i in `seq 1 $1`
do
	echo -n "$i..." && ./test_pci_user > /dev/null
done

echo "done!"

