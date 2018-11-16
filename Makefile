folder=generated_files/
bootdisk=${folder}disk.img
blocksize=512
disksize=100

boot1=boot1

# preencha esses valores para rodar o segundo estágio do bootloader
boot2=boot2
boot2pos=1
boot2size=2

# preencha esses valores para rodar o kernel
kernel=kernel
kernelpos=3
kernelsize=50

ASMFLAGS=-f bin
file = $(bootdisk)

# adicionem os targets do kernel e do segundo estágio para usar o make all com eles

all: clean create_folder mydisk boot1 write_boot1 boot2 write_boot2 kernel write_kernel hexdump launchqemu

create_folder:
	mkdir -p generated_files

mydisk:
	dd if=/dev/zero of=$(bootdisk) bs=$(blocksize) count=$(disksize) status=noxfer

boot1:
	nasm $(ASMFLAGS) $(boot1).asm -o ${folder}$(boot1).bin

boot2:
	nasm $(ASMFLAGS) $(boot2).asm -o ${folder}$(boot2).bin

kernel:
	nasm $(ASMFLAGS) $(kernel).asm -o ${folder}$(kernel).bin

write_boot1:
	dd if=${folder}$(boot1).bin of=$(bootdisk) bs=$(blocksize) count=1 conv=notrunc status=noxfer

write_boot2:
	dd if=${folder}$(boot2).bin of=$(bootdisk) bs=$(blocksize) seek=$(boot2pos) count=$(boot2size) conv=notrunc status=noxfer

write_kernel:
	dd if=${folder}$(kernel).bin of=$(bootdisk) bs=$(blocksize) seek=$(kernelpos) count=$(kernelsize) conv=notrunc

hexdump:
	hexdump $(file)

disasm:
	ndisasm $(boot1).asm

launchqemu:
	qemu-system-i386 -fda $(bootdisk)

clean:
	rm -f *.bin $(bootdisk) *~
	rm -rf generated_files
