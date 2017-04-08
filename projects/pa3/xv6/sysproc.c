#include "types.h"
#include "x86.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
  return fork();
}

int
sys_exit(void)
{
  exit();
  return 0;  // not reached
}

int
sys_wait(void)
{
  return wait();
}

int
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
  return kill(pid);
}

int
sys_getpid(void)
{
  return proc->pid;
}

int
sys_sbrk(void)
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = proc->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

int
sys_sleep(void)
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(proc->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}

int sys_callcount(void) {
  cprintf("Alexander_Lerma_A20315236\n");
  int n;
  if(argint(0, &n) < 0)
    return -1;
  return proc->callcount[n];
}

int sys_memcount(void) {
  uint present = 0, writable = 0, user = 0;
  uint pde_flags, pte_flags;
  uint i, j; 
  pde_t *pde, *pte;

  for (i = 0; i < NPDENTRIES; i++) {
    pde = &proc->pgdir[i];
    pde_flags = PTE_FLAGS(*pde);

    //check if page directory entry is valid
    if((PTE_P | PTE_W | PTE_U) & pde_flags) {
      for(j = 0; j< NPTENTRIES; j++) {
        pte = &pde[j];
        pte_flags = PTE_FLAGS(*pte);

        //check each individual flag on each page table entry
        if(PTE_P & pte_flags)
          present++;
        if(PTE_W & pte_flags)
          writable++;
        if(PTE_U & pte_flags)
          user++;
      }
    }
  }

  uint pages = PGROUNDUP(proc->sz) / PGSIZE;

  cprintf("Pages used by current process: %d\n", pages);
  cprintf("Pages free: %d\n", kfreepagecount());
  cprintf("Pages present: %d\n", present);
  cprintf("Pages writable: %d\n", writable);
  cprintf("Pages user accessible: %d\n", user);

  return pages;
}
