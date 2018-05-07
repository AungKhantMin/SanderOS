clear

mkdir build

echo "========================="
echo "BUILDING KERNELMODULES"
echo "-------------------------"
echo ""
echo ""
cc -c programmas/hdd.c -o programmas/hdd.skm -std=gnu99 -ffreestanding -m32 -mtune=i386 -Isrc/include


echo "========================="
echo "BUILDING KERNEL"
echo "-------------------------"
echo ""
echo ""
nasm -felf32 src/boot.asm -o build/boot.o
nasm -felf32 src/interrupt.asm -o build/interrupt.o
as src/switch.s -o build/switch.o --32 #-mtune=i386 --32
cc -c src/kernel.c -o build/kernel.o -std=gnu99 -ffreestanding -O2 -Wall -m32 -Wextra -mtune=i386 -Isrc/include
cc -c src/screen.c -o build/screen.o -std=gnu99 -ffreestanding -O2 -Wall -m32 -Wextra -mtune=i386 -Isrc/include
cc -c src/idt.c -o build/idt.o -std=gnu99 -ffreestanding -O2 -Wall -m32 -Wextra -mtune=i386 -Isrc/include
cc -c src/ports.c -o build/ports.o -std=gnu99 -ffreestanding -O2 -Wall -m32 -Wextra -mtune=i386 -Isrc/include
cc -c src/pci.c -o build/pci.o -std=gnu99 -ffreestanding -O2 -Wall -m32 -Wextra -mtune=i386 -Isrc/include
#cc -c src/acpi.c -o build/acpi.o -std=gnu99 -ffreestanding -O2 -Wall -m32 -Wextra -mtune=i386 -Isrc/include
cc -c src/keyboard.c -o build/keyboard.o -std=gnu99 -ffreestanding -O2 -Wall -m32 -Wextra -mtune=i386 -Isrc/include
cc -c src/atapi.c -o build/atapi.o -std=gnu99 -ffreestanding -O2 -Wall -m32 -Wextra -mtune=i386 -Isrc/include
cc -c src/ata.c -o build/ata.o -std=gnu99 -ffreestanding -O2 -Wall -m32 -Wextra -mtune=i386 -Isrc/include
#cc -c src/mouse.c -o build/mouse.o -std=gnu99 -ffreestanding -O2 -Wall -m32 -Wextra -mtune=i386 -Isrc/include
cc -c src/iso.c -o build/iso.o -std=gnu99 -ffreestanding -O2 -Wall -m32 -Wextra -mtune=i386 -Isrc/include
cc -c src/elf.c -o build/elf.o -std=gnu99 -ffreestanding -O2 -Wall -m32 -Wextra -mtune=i386 -Isrc/include
cc -c src/module.c -o build/module.o -std=gnu99 -ffreestanding -O2 -Wall -m32 -Wextra -mtune=i386 -Isrc/include
cc -c src/memory.c -o build/memory.o -std=gnu99 -ffreestanding -O2 -Wall -m32 -Wextra -mtune=i386 -Isrc/include
cc -c src/filesystem.c -o build/filesystem.o -std=gnu99 -ffreestanding -O2 -Wall -m32 -Wextra -mtune=i386 -Isrc/include
cc -c src/task.c -o build/task.o -std=gnu99 -ffreestanding -O2 -Wall -m32 -Wextra -mtune=i386 -Isrc/include
ld -n -T src/linker.ld -o myos.bin -O2 -nostdlib build/boot.o build/kernel.o build/ata.o build/keyboard.o build/pci.o build/atapi.o build/idt.o build/interrupt.o build/screen.o build/ports.o build/iso.o build/elf.o build/module.o build/memory.o build/filesystem.o build/task.o build/switch.o -m elf_i386
if grub-file --is-x86-multiboot myos.bin; then
  	

	echo "========================="
	echo "CREATING ISO"
	echo "-------------------------"
	echo ""
	echo ""
	mkdir -p isodir/boot/grub
	cp myos.bin isodir/boot/myos.bin
	cp src/grub.cfg isodir/boot/grub/grub.cfg
	cp programmas/hdd.skm -a isodir/modules/hdd.skm
	grub-mkrescue -o myos.iso isodir
	
	

	echo "========================="
	echo "STARTING EMULATOR"
	echo "-------------------------"
	echo ""
	echo ""
	qemu-system-i386 -cdrom myos.iso
else
  echo the file is not multiboot
fi


echo "========================="
echo "CLEANUP"
echo "-------------------------"
echo ""
echo ""
rm -r build



echo "========================="
echo "PUSH TO GIT"
echo "-------------------------"
echo ""
echo ""
git add --all .
git commit -a -m "auto"
git push origin master



echo "========================="
echo "FINISHED"
echo "-------------------------"
echo ""
echo ""
