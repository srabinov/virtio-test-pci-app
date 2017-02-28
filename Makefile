
all:
	gcc -Wall test_pci_user.c -o test_pci_user
	@echo run: "#" sudo mknod /dev/test_pci c MAJOR 0 

clean:
	rm test_pci_user
