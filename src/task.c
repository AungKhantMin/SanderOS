#include "system.h"
 //
// M U L T I T A S K I N G
// TutorialURL: http://wiki.osdev.org/Kernel_Multitasking

extern void switchTask(unsigned long a,unsigned long b);

static int tpoint = 0;
Task tasks[12];

static void otherMain() {
    
	while(1){
		printf("Y");
	}
}

void initTasking() {
    // Get EFLAGS and CR3
    register long counter asm("esp");
    createTask(0,counter);
    createTask(1,otherMain);
    tpoint = 0;
}

void createTask(unsigned char taskpointer, void (*main)()) {
	register long counter asm("esp");
    asm volatile("movl %%cr3, %%eax; movl %%eax, %0;":"=m"(tasks[taskpointer].regs.cr3)::"%eax");
    asm volatile("pushfl; movl (%%esp), %%eax; movl %%eax, %0; popfl;":"=m"(tasks[taskpointer].regs.eflags)::"%eax");
    tasks[taskpointer].regs.eax = 0;
    tasks[taskpointer].regs.ebx = 0;
    tasks[taskpointer].regs.ecx = 0;
    tasks[taskpointer].regs.edx = 0;
    tasks[taskpointer].regs.esi = 0;
    tasks[taskpointer].regs.edi = 0;
    tasks[taskpointer].regs.eip = (unsigned long) main;
    tasks[taskpointer].regs.esp = (unsigned long) main;//mainTask.regs.esp;//allocPage() + 0x1000; // Not implemented here
    tasks[taskpointer].next = 0;
}

void yield() {
	switchTask((unsigned long)&tasks[tpoint],(unsigned long)&tasks[1]);
	tpoint = 1;
//    Task *last = runningTask;
//    runningTask = (Task *)runningTask->next;
//    switchTask((unsigned long)&last->regs, (unsigned long)&runningTask->regs);
}