#ifndef INTERRUPT_H
#define INTERRUPT_H

#include "os_type.h"

class InterruptManager
{
	private:
		uint32 *IDT;
		
		uint32 IRQ0_8259A_MASTER;	//主片的起始向量号
		uint32 IRQ0_8259A_SLAVE;	//从片的起始向量号
	public:
		InterruptManager();
		void initialize();
		
		void setInterruptDescriptor(uint32 index, uint32 address, byte DPL);
		// 开启时钟中断
    		void enableTimeInterrupt();
 	   	// 禁止时钟中断
    		void disableTimeInterrupt();
 		// 设置时钟中断处理函数
   		 void setTimeInterrupt(void *handler);

	private:
   		 // 初始化8259A芯片
   		 void initialize8259A();
};

#endif
