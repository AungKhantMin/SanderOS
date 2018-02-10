#include <system.h>
#include <stdarg.h>

#define SCREEN_MAX_X 80
#define SCREEN_MAX_Y 25

char* videomemory = (char*) 0xb8000;
int videopointer = 0;
char backgroundcolor = 0x07;

int curX = 0;
int curY = 0;

void putc(const char a){
	if(a=='\n'){
	
	}else if(a=='\t'){
	
	}else if(a=='\r'){
	
	}else{
		videopointer = ((curY*SCREEN_MAX_X)+(curX))*2;
		videomemory[videopointer++] = a;
		videomemory[videopointer++] = backgroundcolor;
		curX++;
		if(curX==SCREEN_MAX_X){
			curY++;
			curX = 0;
		}
	}
}

void printf(const char* format,...){
	va_list parameters;
	va_start(parameters, format);
	int xcount = 0;
	char deze;
	while((deze = format[xcount++])!='\0'){
		if(deze=='%'){
			deze = format[xcount++];
			if(deze=='c'){
				char c = (char) va_arg(parameters, int /* char promotes to int */);
				putc(c);
			}
		}else{
			putc(deze);
		}
	}
}
