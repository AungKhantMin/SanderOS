#include <system.h>


void insmod(unsigned char* path,void* arguments){
	printf("--INSMOD--\n");
	printf("  -> loading file\n");
	unsigned char* msx = readCDROM(path);
	if(strcmp(msx,(unsigned char*)"ERROR")==0){
		printf(" -> Unable to locate kernelmodule\n");
	}else{
		printf("  -> parsing file\n");
		void* location = elf_load_file(msx);
		if(location==NULL){
			printf("\n  -> insmod returned error!\n");
		}else{
			printf("  -> calling file at %x \n",location);
			void (*foo)(void*) = (void*)location;
			foo(arguments);
			printf("\n  -> insmod returned succesfully!\n");
		}
	}
}

void* loadExecutable(unsigned char* path){
	unsigned char* msx = readCDROM(path);
	if(strcmp(msx,(unsigned char*)"ERROR")==0){
		printf("UNABLE TO LOAD %s !!\n",path);
		return NULL;
	}else{
		return elf_load_file(msx);
	}
}

int exec(unsigned char* path){
	printf("--EXEC--\n");
	printf("  -> loading file\n");
	unsigned char* msx = readCDROM(path);
	if(strcmp(msx,(unsigned char*)"ERROR")==0){
		printf(" -> Unable to locate executable\n");
		return 1;
	}else{
		printf("  -> parsing file\n");
		void* location = elf_load_file(msx);
		if(location==NULL){
			printf("\n  -> exec returned error!\n");
			return 2;
		}else{
			printf("  -> calling file at %x \n",location);
			void (*foo)() = (void*)location;
			foo();
			return 0;
		}
	}
}
