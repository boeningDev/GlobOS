all: clean globos.img
clean:
	rm -rf Build/*
globos.img: boot.bin kernel.bin
	dd if=/dev/zero of=Build/globos.img bs=512 count=2880
	mkfs.fat -F 12 -n "GLOBOS" Build/globos.img
	dd if=Build/boot.bin of=Build/globos.img conv=notrunc
	mcopy -i Build\globos.img Build/kernel.bin

boot.bin:
	nasm -f bin -o Build/boot.bin src/boot.s
kernel.bin:
	nasm -f bin -o Build/kernel.bin src/kernel.s