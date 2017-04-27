#include "types.h"
#include "syscall.h"
#include "user.h"

char (*syscallnames[]) = {
	[SYS_fork]    "fork",
	[SYS_exit]    "exit",
	[SYS_wait]    "wait",
	[SYS_pipe]    "pipe",
	[SYS_read]    "read",
	[SYS_kill]    "kill",
	[SYS_exec]    "exec",
	[SYS_fstat]   "fstat",
	[SYS_chdir]   "chdir",
	[SYS_dup]     "dup",
	[SYS_getpid]  "getpid",
	[SYS_sbrk]    "sbrk",
	[SYS_sleep]   "sleep",
	[SYS_uptime]  "uptime",
	[SYS_open]    "open",
	[SYS_write]   "write",
	[SYS_mknod]   "mknod",
	[SYS_unlink]  "unlink",
	[SYS_link]    "link",
	[SYS_mkdir]   "mkdir",
	[SYS_close]   "close",
	[SYS_callcount] "callcount",
};

int fibs(int n) {
	if(n == 0) return 0;
	if(n == 1) return 1;
	return fibs(n-1) + fibs(n-2);
}

void sys_callcount_test() {
	printf(1, "Initial Total System Calls: %d\n", callcount(0));
	printf(1, "Testing callcount...\n");
	printf(1, "\nWoah\n\n");
	printf(1, "\n\tTaking a snooze...\n\n");
	sleep(100);
	printf(1, "\n\t\t\tGood morning\n\n");

	printf(1,"heres fibs(5): %d", fibs(5));

	printf(1, "\nTired again..\n\n");
	printf(1, "\n\tTaking a snooze...\n\n");
	sleep(100);
	printf(1, "\n\t\t\tGood morning\n\n");

	printf(1, "Printing Calls Per Syscall For Work... \n");

//	int i;
//	for (i = 1; i < NUM_CALLS; i++) {
//		printf(1, "So far Syscall %s has been called %d times\n", syscallnames[i], callcount(i));
//	}

	printf(1, "Total System Calls Without Write: %d\n", callcount(0) - callcount(SYS_write));
	printf(1, "Final Total System Calls Including Write: %d\n", callcount(0));

}

int main(void) { 
	
	sys_callcount_test();
	exit();
}