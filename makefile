clean:
	rm -r ./build
	mkdir build

bootsector.bin:
	nasm ./src/bootsector.asm -f bin -o ./build/bootsector.bin

kernel.bin:
	nasm ./src/kernel.asm -f bin -o ./build/kernel.bin

os.bin: bootsector.bin kernel.bin
	cat ./build/bootsector.bin ./build/kernel.bin > ./build/os.bin