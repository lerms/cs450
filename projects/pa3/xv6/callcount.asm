
_callcount:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
	printf(1, "Total System Calls Without Write: %d\n", callcount(0) - callcount(SYS_write));
	printf(1, "Final Total System Calls Including Write: %d\n", callcount(0));

}

int main(void) { 
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
	
	sys_callcount_test();
   6:	e8 55 00 00 00       	call   60 <sys_callcount_test>
	exit();
   b:	e8 22 04 00 00       	call   432 <exit>

00000010 <fibs>:
[SYS_mkdir]   "mkdir",
[SYS_close]   "close",
[SYS_callcount] "callcount",
};

int fibs(int n) {
  10:	55                   	push   %ebp
  11:	89 e5                	mov    %esp,%ebp
  13:	56                   	push   %esi
  14:	53                   	push   %ebx
  15:	83 ec 10             	sub    $0x10,%esp
  18:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if(n == 0) return 0;
  1b:	85 db                	test   %ebx,%ebx
  1d:	74 35                	je     54 <fibs+0x44>
	if(n == 1) return 1;
  1f:	83 fb 01             	cmp    $0x1,%ebx
  22:	74 34                	je     58 <fibs+0x48>
  24:	31 f6                	xor    %esi,%esi
  26:	eb 05                	jmp    2d <fibs+0x1d>
  28:	83 fb 01             	cmp    $0x1,%ebx
  2b:	74 1b                	je     48 <fibs+0x38>
  2d:	8d 43 ff             	lea    -0x1(%ebx),%eax
	return fibs(n-1) + fibs(n-2);
  30:	89 04 24             	mov    %eax,(%esp)
  33:	e8 d8 ff ff ff       	call   10 <fibs>
  38:	01 c6                	add    %eax,%esi
[SYS_close]   "close",
[SYS_callcount] "callcount",
};

int fibs(int n) {
	if(n == 0) return 0;
  3a:	83 eb 02             	sub    $0x2,%ebx
  3d:	75 e9                	jne    28 <fibs+0x18>
	if(n == 1) return 1;
	return fibs(n-1) + fibs(n-2);
}
  3f:	83 c4 10             	add    $0x10,%esp
  42:	89 f0                	mov    %esi,%eax
  44:	5b                   	pop    %ebx
  45:	5e                   	pop    %esi
  46:	5d                   	pop    %ebp
  47:	c3                   	ret    
  48:	83 c4 10             	add    $0x10,%esp
  4b:	83 c6 01             	add    $0x1,%esi
  4e:	89 f0                	mov    %esi,%eax
  50:	5b                   	pop    %ebx
  51:	5e                   	pop    %esi
  52:	5d                   	pop    %ebp
  53:	c3                   	ret    
[SYS_close]   "close",
[SYS_callcount] "callcount",
};

int fibs(int n) {
	if(n == 0) return 0;
  54:	31 f6                	xor    %esi,%esi
  56:	eb e7                	jmp    3f <fibs+0x2f>
	if(n == 1) return 1;
  58:	be 01 00 00 00       	mov    $0x1,%esi
  5d:	eb e0                	jmp    3f <fibs+0x2f>
  5f:	90                   	nop

00000060 <sys_callcount_test>:
	return fibs(n-1) + fibs(n-2);
}

void sys_callcount_test() {
  60:	55                   	push   %ebp
  61:	89 e5                	mov    %esp,%ebp
  63:	53                   	push   %ebx
	printf(1, "\n\t\t\tGood morning\n\n");

	printf(1, "Printing Calls Per Syscall For Work... \n");

	int i;
	for (i = 1; i < NUM_CALLS + 1; i++) {
  64:	bb 01 00 00 00       	mov    $0x1,%ebx
	if(n == 0) return 0;
	if(n == 1) return 1;
	return fibs(n-1) + fibs(n-2);
}

void sys_callcount_test() {
  69:	83 ec 14             	sub    $0x14,%esp
	printf(1, "Initial Total System Calls: %d\n", callcount(0));
  6c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  73:	e8 5a 04 00 00       	call   4d2 <callcount>
  78:	c7 44 24 04 e8 08 00 	movl   $0x8e8,0x4(%esp)
  7f:	00 
  80:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  87:	89 44 24 08          	mov    %eax,0x8(%esp)
  8b:	e8 f0 04 00 00       	call   580 <printf>
	printf(1, "Testing callcount...\n");
  90:	c7 44 24 04 b8 09 00 	movl   $0x9b8,0x4(%esp)
  97:	00 
  98:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  9f:	e8 dc 04 00 00       	call   580 <printf>
	printf(1, "\nWoah\n\n");
  a4:	c7 44 24 04 ce 09 00 	movl   $0x9ce,0x4(%esp)
  ab:	00 
  ac:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  b3:	e8 c8 04 00 00       	call   580 <printf>
	printf(1, "\n\tTaking a snooze...\n\n");
  b8:	c7 44 24 04 d6 09 00 	movl   $0x9d6,0x4(%esp)
  bf:	00 
  c0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  c7:	e8 b4 04 00 00       	call   580 <printf>
	sleep(100);
  cc:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
  d3:	e8 ea 03 00 00       	call   4c2 <sleep>
	printf(1, "\n\t\t\tGood morning\n\n");
  d8:	c7 44 24 04 ed 09 00 	movl   $0x9ed,0x4(%esp)
  df:	00 
  e0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  e7:	e8 94 04 00 00       	call   580 <printf>

	printf(1,"heres fibs(5): %d", fibs(5));
  ec:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  f3:	e8 18 ff ff ff       	call   10 <fibs>
  f8:	c7 44 24 04 00 0a 00 	movl   $0xa00,0x4(%esp)
  ff:	00 
 100:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 107:	89 44 24 08          	mov    %eax,0x8(%esp)
 10b:	e8 70 04 00 00       	call   580 <printf>

	printf(1, "\nTired again..\n\n");
 110:	c7 44 24 04 12 0a 00 	movl   $0xa12,0x4(%esp)
 117:	00 
 118:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 11f:	e8 5c 04 00 00       	call   580 <printf>
	printf(1, "\n\tTaking a snooze...\n\n");
 124:	c7 44 24 04 d6 09 00 	movl   $0x9d6,0x4(%esp)
 12b:	00 
 12c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 133:	e8 48 04 00 00       	call   580 <printf>
	sleep(100);
 138:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
 13f:	e8 7e 03 00 00       	call   4c2 <sleep>
	printf(1, "\n\t\t\tGood morning\n\n");
 144:	c7 44 24 04 ed 09 00 	movl   $0x9ed,0x4(%esp)
 14b:	00 
 14c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 153:	e8 28 04 00 00       	call   580 <printf>

	printf(1, "Printing Calls Per Syscall For Work... \n");
 158:	c7 44 24 04 08 09 00 	movl   $0x908,0x4(%esp)
 15f:	00 
 160:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 167:	e8 14 04 00 00       	call   580 <printf>
 16c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

	int i;
	for (i = 1; i < NUM_CALLS + 1; i++) {
		printf(1, "So far Syscall %s has been called %d times\n", syscallnames[i], callcount(i));
 170:	89 1c 24             	mov    %ebx,(%esp)
 173:	e8 5a 03 00 00       	call   4d2 <callcount>
 178:	c7 44 24 04 34 09 00 	movl   $0x934,0x4(%esp)
 17f:	00 
 180:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 187:	89 44 24 0c          	mov    %eax,0xc(%esp)
 18b:	8b 04 9d 80 0d 00 00 	mov    0xd80(,%ebx,4),%eax
	printf(1, "\n\t\t\tGood morning\n\n");

	printf(1, "Printing Calls Per Syscall For Work... \n");

	int i;
	for (i = 1; i < NUM_CALLS + 1; i++) {
 192:	83 c3 01             	add    $0x1,%ebx
		printf(1, "So far Syscall %s has been called %d times\n", syscallnames[i], callcount(i));
 195:	89 44 24 08          	mov    %eax,0x8(%esp)
 199:	e8 e2 03 00 00       	call   580 <printf>
	printf(1, "\n\t\t\tGood morning\n\n");

	printf(1, "Printing Calls Per Syscall For Work... \n");

	int i;
	for (i = 1; i < NUM_CALLS + 1; i++) {
 19e:	83 fb 17             	cmp    $0x17,%ebx
 1a1:	75 cd                	jne    170 <sys_callcount_test+0x110>
		printf(1, "So far Syscall %s has been called %d times\n", syscallnames[i], callcount(i));
	}

	printf(1, "Total System Calls Without Write: %d\n", callcount(0) - callcount(SYS_write));
 1a3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 1aa:	e8 23 03 00 00       	call   4d2 <callcount>
 1af:	c7 04 24 10 00 00 00 	movl   $0x10,(%esp)
 1b6:	89 c3                	mov    %eax,%ebx
 1b8:	e8 15 03 00 00       	call   4d2 <callcount>
 1bd:	c7 44 24 04 60 09 00 	movl   $0x960,0x4(%esp)
 1c4:	00 
 1c5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1cc:	29 c3                	sub    %eax,%ebx
 1ce:	89 5c 24 08          	mov    %ebx,0x8(%esp)
 1d2:	e8 a9 03 00 00       	call   580 <printf>
	printf(1, "Final Total System Calls Including Write: %d\n", callcount(0));
 1d7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 1de:	e8 ef 02 00 00       	call   4d2 <callcount>
 1e3:	c7 44 24 04 88 09 00 	movl   $0x988,0x4(%esp)
 1ea:	00 
 1eb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1f2:	89 44 24 08          	mov    %eax,0x8(%esp)
 1f6:	e8 85 03 00 00       	call   580 <printf>

}
 1fb:	83 c4 14             	add    $0x14,%esp
 1fe:	5b                   	pop    %ebx
 1ff:	5d                   	pop    %ebp
 200:	c3                   	ret    
 201:	66 90                	xchg   %ax,%ax
 203:	66 90                	xchg   %ax,%ax
 205:	66 90                	xchg   %ax,%ax
 207:	66 90                	xchg   %ax,%ax
 209:	66 90                	xchg   %ax,%ax
 20b:	66 90                	xchg   %ax,%ax
 20d:	66 90                	xchg   %ax,%ax
 20f:	90                   	nop

00000210 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 210:	55                   	push   %ebp
 211:	89 e5                	mov    %esp,%ebp
 213:	8b 45 08             	mov    0x8(%ebp),%eax
 216:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 219:	53                   	push   %ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 21a:	89 c2                	mov    %eax,%edx
 21c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 220:	83 c1 01             	add    $0x1,%ecx
 223:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 227:	83 c2 01             	add    $0x1,%edx
 22a:	84 db                	test   %bl,%bl
 22c:	88 5a ff             	mov    %bl,-0x1(%edx)
 22f:	75 ef                	jne    220 <strcpy+0x10>
    ;
  return os;
}
 231:	5b                   	pop    %ebx
 232:	5d                   	pop    %ebp
 233:	c3                   	ret    
 234:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 23a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000240 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 240:	55                   	push   %ebp
 241:	89 e5                	mov    %esp,%ebp
 243:	8b 55 08             	mov    0x8(%ebp),%edx
 246:	53                   	push   %ebx
 247:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 24a:	0f b6 02             	movzbl (%edx),%eax
 24d:	84 c0                	test   %al,%al
 24f:	74 2d                	je     27e <strcmp+0x3e>
 251:	0f b6 19             	movzbl (%ecx),%ebx
 254:	38 d8                	cmp    %bl,%al
 256:	74 0e                	je     266 <strcmp+0x26>
 258:	eb 2b                	jmp    285 <strcmp+0x45>
 25a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 260:	38 c8                	cmp    %cl,%al
 262:	75 15                	jne    279 <strcmp+0x39>
    p++, q++;
 264:	89 d9                	mov    %ebx,%ecx
 266:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 269:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
 26c:	8d 59 01             	lea    0x1(%ecx),%ebx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 26f:	0f b6 49 01          	movzbl 0x1(%ecx),%ecx
 273:	84 c0                	test   %al,%al
 275:	75 e9                	jne    260 <strcmp+0x20>
 277:	31 c0                	xor    %eax,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
 279:	29 c8                	sub    %ecx,%eax
}
 27b:	5b                   	pop    %ebx
 27c:	5d                   	pop    %ebp
 27d:	c3                   	ret    
 27e:	0f b6 09             	movzbl (%ecx),%ecx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 281:	31 c0                	xor    %eax,%eax
 283:	eb f4                	jmp    279 <strcmp+0x39>
 285:	0f b6 cb             	movzbl %bl,%ecx
 288:	eb ef                	jmp    279 <strcmp+0x39>
 28a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000290 <strlen>:
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
 290:	55                   	push   %ebp
 291:	89 e5                	mov    %esp,%ebp
 293:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 296:	80 39 00             	cmpb   $0x0,(%ecx)
 299:	74 12                	je     2ad <strlen+0x1d>
 29b:	31 d2                	xor    %edx,%edx
 29d:	8d 76 00             	lea    0x0(%esi),%esi
 2a0:	83 c2 01             	add    $0x1,%edx
 2a3:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 2a7:	89 d0                	mov    %edx,%eax
 2a9:	75 f5                	jne    2a0 <strlen+0x10>
    ;
  return n;
}
 2ab:	5d                   	pop    %ebp
 2ac:	c3                   	ret    
uint
strlen(char *s)
{
  int n;

  for(n = 0; s[n]; n++)
 2ad:	31 c0                	xor    %eax,%eax
    ;
  return n;
}
 2af:	5d                   	pop    %ebp
 2b0:	c3                   	ret    
 2b1:	eb 0d                	jmp    2c0 <memset>
 2b3:	90                   	nop
 2b4:	90                   	nop
 2b5:	90                   	nop
 2b6:	90                   	nop
 2b7:	90                   	nop
 2b8:	90                   	nop
 2b9:	90                   	nop
 2ba:	90                   	nop
 2bb:	90                   	nop
 2bc:	90                   	nop
 2bd:	90                   	nop
 2be:	90                   	nop
 2bf:	90                   	nop

000002c0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 2c0:	55                   	push   %ebp
 2c1:	89 e5                	mov    %esp,%ebp
 2c3:	8b 55 08             	mov    0x8(%ebp),%edx
 2c6:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 2c7:	8b 4d 10             	mov    0x10(%ebp),%ecx
 2ca:	8b 45 0c             	mov    0xc(%ebp),%eax
 2cd:	89 d7                	mov    %edx,%edi
 2cf:	fc                   	cld    
 2d0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 2d2:	89 d0                	mov    %edx,%eax
 2d4:	5f                   	pop    %edi
 2d5:	5d                   	pop    %ebp
 2d6:	c3                   	ret    
 2d7:	89 f6                	mov    %esi,%esi
 2d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000002e0 <strchr>:

char*
strchr(const char *s, char c)
{
 2e0:	55                   	push   %ebp
 2e1:	89 e5                	mov    %esp,%ebp
 2e3:	8b 45 08             	mov    0x8(%ebp),%eax
 2e6:	53                   	push   %ebx
 2e7:	8b 55 0c             	mov    0xc(%ebp),%edx
  for(; *s; s++)
 2ea:	0f b6 18             	movzbl (%eax),%ebx
 2ed:	84 db                	test   %bl,%bl
 2ef:	74 1d                	je     30e <strchr+0x2e>
    if(*s == c)
 2f1:	38 d3                	cmp    %dl,%bl
 2f3:	89 d1                	mov    %edx,%ecx
 2f5:	75 0d                	jne    304 <strchr+0x24>
 2f7:	eb 17                	jmp    310 <strchr+0x30>
 2f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 300:	38 ca                	cmp    %cl,%dl
 302:	74 0c                	je     310 <strchr+0x30>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 304:	83 c0 01             	add    $0x1,%eax
 307:	0f b6 10             	movzbl (%eax),%edx
 30a:	84 d2                	test   %dl,%dl
 30c:	75 f2                	jne    300 <strchr+0x20>
    if(*s == c)
      return (char*)s;
  return 0;
 30e:	31 c0                	xor    %eax,%eax
}
 310:	5b                   	pop    %ebx
 311:	5d                   	pop    %ebp
 312:	c3                   	ret    
 313:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 319:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000320 <gets>:

char*
gets(char *buf, int max)
{
 320:	55                   	push   %ebp
 321:	89 e5                	mov    %esp,%ebp
 323:	57                   	push   %edi
 324:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 325:	31 f6                	xor    %esi,%esi
  return 0;
}

char*
gets(char *buf, int max)
{
 327:	53                   	push   %ebx
 328:	83 ec 2c             	sub    $0x2c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 32b:	8d 7d e7             	lea    -0x19(%ebp),%edi
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 32e:	eb 31                	jmp    361 <gets+0x41>
    cc = read(0, &c, 1);
 330:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 337:	00 
 338:	89 7c 24 04          	mov    %edi,0x4(%esp)
 33c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 343:	e8 02 01 00 00       	call   44a <read>
    if(cc < 1)
 348:	85 c0                	test   %eax,%eax
 34a:	7e 1d                	jle    369 <gets+0x49>
      break;
    buf[i++] = c;
 34c:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 350:	89 de                	mov    %ebx,%esi
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
 352:	8b 55 08             	mov    0x8(%ebp),%edx
    if(c == '\n' || c == '\r')
 355:	3c 0d                	cmp    $0xd,%al

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
 357:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 35b:	74 0c                	je     369 <gets+0x49>
 35d:	3c 0a                	cmp    $0xa,%al
 35f:	74 08                	je     369 <gets+0x49>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 361:	8d 5e 01             	lea    0x1(%esi),%ebx
 364:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 367:	7c c7                	jl     330 <gets+0x10>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 369:	8b 45 08             	mov    0x8(%ebp),%eax
 36c:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 370:	83 c4 2c             	add    $0x2c,%esp
 373:	5b                   	pop    %ebx
 374:	5e                   	pop    %esi
 375:	5f                   	pop    %edi
 376:	5d                   	pop    %ebp
 377:	c3                   	ret    
 378:	90                   	nop
 379:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000380 <stat>:

int
stat(char *n, struct stat *st)
{
 380:	55                   	push   %ebp
 381:	89 e5                	mov    %esp,%ebp
 383:	56                   	push   %esi
 384:	53                   	push   %ebx
 385:	83 ec 10             	sub    $0x10,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 388:	8b 45 08             	mov    0x8(%ebp),%eax
 38b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 392:	00 
 393:	89 04 24             	mov    %eax,(%esp)
 396:	e8 d7 00 00 00       	call   472 <open>
  if(fd < 0)
 39b:	85 c0                	test   %eax,%eax
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 39d:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
 39f:	78 27                	js     3c8 <stat+0x48>
    return -1;
  r = fstat(fd, st);
 3a1:	8b 45 0c             	mov    0xc(%ebp),%eax
 3a4:	89 1c 24             	mov    %ebx,(%esp)
 3a7:	89 44 24 04          	mov    %eax,0x4(%esp)
 3ab:	e8 da 00 00 00       	call   48a <fstat>
  close(fd);
 3b0:	89 1c 24             	mov    %ebx,(%esp)
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
  r = fstat(fd, st);
 3b3:	89 c6                	mov    %eax,%esi
  close(fd);
 3b5:	e8 a0 00 00 00       	call   45a <close>
  return r;
 3ba:	89 f0                	mov    %esi,%eax
}
 3bc:	83 c4 10             	add    $0x10,%esp
 3bf:	5b                   	pop    %ebx
 3c0:	5e                   	pop    %esi
 3c1:	5d                   	pop    %ebp
 3c2:	c3                   	ret    
 3c3:	90                   	nop
 3c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
 3c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 3cd:	eb ed                	jmp    3bc <stat+0x3c>
 3cf:	90                   	nop

000003d0 <atoi>:
  return r;
}

int
atoi(const char *s)
{
 3d0:	55                   	push   %ebp
 3d1:	89 e5                	mov    %esp,%ebp
 3d3:	8b 4d 08             	mov    0x8(%ebp),%ecx
 3d6:	53                   	push   %ebx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3d7:	0f be 11             	movsbl (%ecx),%edx
 3da:	8d 42 d0             	lea    -0x30(%edx),%eax
 3dd:	3c 09                	cmp    $0x9,%al
int
atoi(const char *s)
{
  int n;

  n = 0;
 3df:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 3e4:	77 17                	ja     3fd <atoi+0x2d>
 3e6:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
 3e8:	83 c1 01             	add    $0x1,%ecx
 3eb:	8d 04 80             	lea    (%eax,%eax,4),%eax
 3ee:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3f2:	0f be 11             	movsbl (%ecx),%edx
 3f5:	8d 5a d0             	lea    -0x30(%edx),%ebx
 3f8:	80 fb 09             	cmp    $0x9,%bl
 3fb:	76 eb                	jbe    3e8 <atoi+0x18>
    n = n*10 + *s++ - '0';
  return n;
}
 3fd:	5b                   	pop    %ebx
 3fe:	5d                   	pop    %ebp
 3ff:	c3                   	ret    

00000400 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 400:	55                   	push   %ebp
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 401:	31 d2                	xor    %edx,%edx
  return n;
}

void*
memmove(void *vdst, void *vsrc, int n)
{
 403:	89 e5                	mov    %esp,%ebp
 405:	56                   	push   %esi
 406:	8b 45 08             	mov    0x8(%ebp),%eax
 409:	53                   	push   %ebx
 40a:	8b 5d 10             	mov    0x10(%ebp),%ebx
 40d:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 410:	85 db                	test   %ebx,%ebx
 412:	7e 12                	jle    426 <memmove+0x26>
 414:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 418:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 41c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 41f:	83 c2 01             	add    $0x1,%edx
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 422:	39 da                	cmp    %ebx,%edx
 424:	75 f2                	jne    418 <memmove+0x18>
    *dst++ = *src++;
  return vdst;
}
 426:	5b                   	pop    %ebx
 427:	5e                   	pop    %esi
 428:	5d                   	pop    %ebp
 429:	c3                   	ret    

0000042a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 42a:	b8 01 00 00 00       	mov    $0x1,%eax
 42f:	cd 40                	int    $0x40
 431:	c3                   	ret    

00000432 <exit>:
SYSCALL(exit)
 432:	b8 02 00 00 00       	mov    $0x2,%eax
 437:	cd 40                	int    $0x40
 439:	c3                   	ret    

0000043a <wait>:
SYSCALL(wait)
 43a:	b8 03 00 00 00       	mov    $0x3,%eax
 43f:	cd 40                	int    $0x40
 441:	c3                   	ret    

00000442 <pipe>:
SYSCALL(pipe)
 442:	b8 04 00 00 00       	mov    $0x4,%eax
 447:	cd 40                	int    $0x40
 449:	c3                   	ret    

0000044a <read>:
SYSCALL(read)
 44a:	b8 05 00 00 00       	mov    $0x5,%eax
 44f:	cd 40                	int    $0x40
 451:	c3                   	ret    

00000452 <write>:
SYSCALL(write)
 452:	b8 10 00 00 00       	mov    $0x10,%eax
 457:	cd 40                	int    $0x40
 459:	c3                   	ret    

0000045a <close>:
SYSCALL(close)
 45a:	b8 15 00 00 00       	mov    $0x15,%eax
 45f:	cd 40                	int    $0x40
 461:	c3                   	ret    

00000462 <kill>:
SYSCALL(kill)
 462:	b8 06 00 00 00       	mov    $0x6,%eax
 467:	cd 40                	int    $0x40
 469:	c3                   	ret    

0000046a <exec>:
SYSCALL(exec)
 46a:	b8 07 00 00 00       	mov    $0x7,%eax
 46f:	cd 40                	int    $0x40
 471:	c3                   	ret    

00000472 <open>:
SYSCALL(open)
 472:	b8 0f 00 00 00       	mov    $0xf,%eax
 477:	cd 40                	int    $0x40
 479:	c3                   	ret    

0000047a <mknod>:
SYSCALL(mknod)
 47a:	b8 11 00 00 00       	mov    $0x11,%eax
 47f:	cd 40                	int    $0x40
 481:	c3                   	ret    

00000482 <unlink>:
SYSCALL(unlink)
 482:	b8 12 00 00 00       	mov    $0x12,%eax
 487:	cd 40                	int    $0x40
 489:	c3                   	ret    

0000048a <fstat>:
SYSCALL(fstat)
 48a:	b8 08 00 00 00       	mov    $0x8,%eax
 48f:	cd 40                	int    $0x40
 491:	c3                   	ret    

00000492 <link>:
SYSCALL(link)
 492:	b8 13 00 00 00       	mov    $0x13,%eax
 497:	cd 40                	int    $0x40
 499:	c3                   	ret    

0000049a <mkdir>:
SYSCALL(mkdir)
 49a:	b8 14 00 00 00       	mov    $0x14,%eax
 49f:	cd 40                	int    $0x40
 4a1:	c3                   	ret    

000004a2 <chdir>:
SYSCALL(chdir)
 4a2:	b8 09 00 00 00       	mov    $0x9,%eax
 4a7:	cd 40                	int    $0x40
 4a9:	c3                   	ret    

000004aa <dup>:
SYSCALL(dup)
 4aa:	b8 0a 00 00 00       	mov    $0xa,%eax
 4af:	cd 40                	int    $0x40
 4b1:	c3                   	ret    

000004b2 <getpid>:
SYSCALL(getpid)
 4b2:	b8 0b 00 00 00       	mov    $0xb,%eax
 4b7:	cd 40                	int    $0x40
 4b9:	c3                   	ret    

000004ba <sbrk>:
SYSCALL(sbrk)
 4ba:	b8 0c 00 00 00       	mov    $0xc,%eax
 4bf:	cd 40                	int    $0x40
 4c1:	c3                   	ret    

000004c2 <sleep>:
SYSCALL(sleep)
 4c2:	b8 0d 00 00 00       	mov    $0xd,%eax
 4c7:	cd 40                	int    $0x40
 4c9:	c3                   	ret    

000004ca <uptime>:
SYSCALL(uptime)
 4ca:	b8 0e 00 00 00       	mov    $0xe,%eax
 4cf:	cd 40                	int    $0x40
 4d1:	c3                   	ret    

000004d2 <callcount>:
SYSCALL(callcount)
 4d2:	b8 16 00 00 00       	mov    $0x16,%eax
 4d7:	cd 40                	int    $0x40
 4d9:	c3                   	ret    
 4da:	66 90                	xchg   %ax,%ax
 4dc:	66 90                	xchg   %ax,%ax
 4de:	66 90                	xchg   %ax,%ax

000004e0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 4e0:	55                   	push   %ebp
 4e1:	89 e5                	mov    %esp,%ebp
 4e3:	57                   	push   %edi
 4e4:	56                   	push   %esi
 4e5:	89 c6                	mov    %eax,%esi
 4e7:	53                   	push   %ebx
 4e8:	83 ec 4c             	sub    $0x4c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4eb:	8b 5d 08             	mov    0x8(%ebp),%ebx
 4ee:	85 db                	test   %ebx,%ebx
 4f0:	74 09                	je     4fb <printint+0x1b>
 4f2:	89 d0                	mov    %edx,%eax
 4f4:	c1 e8 1f             	shr    $0x1f,%eax
 4f7:	84 c0                	test   %al,%al
 4f9:	75 75                	jne    570 <printint+0x90>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 4fb:	89 d0                	mov    %edx,%eax
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 4fd:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 504:	89 75 c0             	mov    %esi,-0x40(%ebp)
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 507:	31 ff                	xor    %edi,%edi
 509:	89 ce                	mov    %ecx,%esi
 50b:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 50e:	eb 02                	jmp    512 <printint+0x32>
  do{
    buf[i++] = digits[x % base];
 510:	89 cf                	mov    %ecx,%edi
 512:	31 d2                	xor    %edx,%edx
 514:	f7 f6                	div    %esi
 516:	8d 4f 01             	lea    0x1(%edi),%ecx
 519:	0f b6 92 a4 0a 00 00 	movzbl 0xaa4(%edx),%edx
  }while((x /= base) != 0);
 520:	85 c0                	test   %eax,%eax
    x = xx;
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 522:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
  }while((x /= base) != 0);
 525:	75 e9                	jne    510 <printint+0x30>
  if(neg)
 527:	8b 55 c4             	mov    -0x3c(%ebp),%edx
    x = xx;
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 52a:	89 c8                	mov    %ecx,%eax
 52c:	8b 75 c0             	mov    -0x40(%ebp),%esi
  }while((x /= base) != 0);
  if(neg)
 52f:	85 d2                	test   %edx,%edx
 531:	74 08                	je     53b <printint+0x5b>
    buf[i++] = '-';
 533:	8d 4f 02             	lea    0x2(%edi),%ecx
 536:	c6 44 05 d8 2d       	movb   $0x2d,-0x28(%ebp,%eax,1)

  while(--i >= 0)
 53b:	8d 79 ff             	lea    -0x1(%ecx),%edi
 53e:	66 90                	xchg   %ax,%ax
 540:	0f b6 44 3d d8       	movzbl -0x28(%ebp,%edi,1),%eax
 545:	83 ef 01             	sub    $0x1,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 548:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 54f:	00 
 550:	89 5c 24 04          	mov    %ebx,0x4(%esp)
 554:	89 34 24             	mov    %esi,(%esp)
 557:	88 45 d7             	mov    %al,-0x29(%ebp)
 55a:	e8 f3 fe ff ff       	call   452 <write>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 55f:	83 ff ff             	cmp    $0xffffffff,%edi
 562:	75 dc                	jne    540 <printint+0x60>
    putc(fd, buf[i]);
}
 564:	83 c4 4c             	add    $0x4c,%esp
 567:	5b                   	pop    %ebx
 568:	5e                   	pop    %esi
 569:	5f                   	pop    %edi
 56a:	5d                   	pop    %ebp
 56b:	c3                   	ret    
 56c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 570:	89 d0                	mov    %edx,%eax
 572:	f7 d8                	neg    %eax
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
 574:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
 57b:	eb 87                	jmp    504 <printint+0x24>
 57d:	8d 76 00             	lea    0x0(%esi),%esi

00000580 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 580:	55                   	push   %ebp
 581:	89 e5                	mov    %esp,%ebp
 583:	57                   	push   %edi
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 584:	31 ff                	xor    %edi,%edi
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 586:	56                   	push   %esi
 587:	53                   	push   %ebx
 588:	83 ec 3c             	sub    $0x3c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 58b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 58e:	8d 45 10             	lea    0x10(%ebp),%eax
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 591:	8b 75 08             	mov    0x8(%ebp),%esi
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 594:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  for(i = 0; fmt[i]; i++){
 597:	0f b6 13             	movzbl (%ebx),%edx
 59a:	83 c3 01             	add    $0x1,%ebx
 59d:	84 d2                	test   %dl,%dl
 59f:	75 39                	jne    5da <printf+0x5a>
 5a1:	e9 c2 00 00 00       	jmp    668 <printf+0xe8>
 5a6:	66 90                	xchg   %ax,%ax
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 5a8:	83 fa 25             	cmp    $0x25,%edx
 5ab:	0f 84 bf 00 00 00    	je     670 <printf+0xf0>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 5b1:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 5b4:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 5bb:	00 
 5bc:	89 44 24 04          	mov    %eax,0x4(%esp)
 5c0:	89 34 24             	mov    %esi,(%esp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 5c3:	88 55 e2             	mov    %dl,-0x1e(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 5c6:	e8 87 fe ff ff       	call   452 <write>
 5cb:	83 c3 01             	add    $0x1,%ebx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5ce:	0f b6 53 ff          	movzbl -0x1(%ebx),%edx
 5d2:	84 d2                	test   %dl,%dl
 5d4:	0f 84 8e 00 00 00    	je     668 <printf+0xe8>
    c = fmt[i] & 0xff;
    if(state == 0){
 5da:	85 ff                	test   %edi,%edi
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 5dc:	0f be c2             	movsbl %dl,%eax
    if(state == 0){
 5df:	74 c7                	je     5a8 <printf+0x28>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 5e1:	83 ff 25             	cmp    $0x25,%edi
 5e4:	75 e5                	jne    5cb <printf+0x4b>
      if(c == 'd'){
 5e6:	83 fa 64             	cmp    $0x64,%edx
 5e9:	0f 84 31 01 00 00    	je     720 <printf+0x1a0>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 5ef:	25 f7 00 00 00       	and    $0xf7,%eax
 5f4:	83 f8 70             	cmp    $0x70,%eax
 5f7:	0f 84 83 00 00 00    	je     680 <printf+0x100>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 5fd:	83 fa 73             	cmp    $0x73,%edx
 600:	0f 84 a2 00 00 00    	je     6a8 <printf+0x128>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 606:	83 fa 63             	cmp    $0x63,%edx
 609:	0f 84 35 01 00 00    	je     744 <printf+0x1c4>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 60f:	83 fa 25             	cmp    $0x25,%edx
 612:	0f 84 e0 00 00 00    	je     6f8 <printf+0x178>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 618:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 61b:	83 c3 01             	add    $0x1,%ebx
 61e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 625:	00 
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 626:	31 ff                	xor    %edi,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 628:	89 44 24 04          	mov    %eax,0x4(%esp)
 62c:	89 34 24             	mov    %esi,(%esp)
 62f:	89 55 d0             	mov    %edx,-0x30(%ebp)
 632:	c6 45 e6 25          	movb   $0x25,-0x1a(%ebp)
 636:	e8 17 fe ff ff       	call   452 <write>
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 63b:	8b 55 d0             	mov    -0x30(%ebp),%edx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 63e:	8d 45 e7             	lea    -0x19(%ebp),%eax
 641:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 648:	00 
 649:	89 44 24 04          	mov    %eax,0x4(%esp)
 64d:	89 34 24             	mov    %esi,(%esp)
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 650:	88 55 e7             	mov    %dl,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 653:	e8 fa fd ff ff       	call   452 <write>
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 658:	0f b6 53 ff          	movzbl -0x1(%ebx),%edx
 65c:	84 d2                	test   %dl,%dl
 65e:	0f 85 76 ff ff ff    	jne    5da <printf+0x5a>
 664:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 668:	83 c4 3c             	add    $0x3c,%esp
 66b:	5b                   	pop    %ebx
 66c:	5e                   	pop    %esi
 66d:	5f                   	pop    %edi
 66e:	5d                   	pop    %ebp
 66f:	c3                   	ret    
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 670:	bf 25 00 00 00       	mov    $0x25,%edi
 675:	e9 51 ff ff ff       	jmp    5cb <printf+0x4b>
 67a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 680:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 683:	b9 10 00 00 00       	mov    $0x10,%ecx
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 688:	31 ff                	xor    %edi,%edi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 68a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 691:	8b 10                	mov    (%eax),%edx
 693:	89 f0                	mov    %esi,%eax
 695:	e8 46 fe ff ff       	call   4e0 <printint>
        ap++;
 69a:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 69e:	e9 28 ff ff ff       	jmp    5cb <printf+0x4b>
 6a3:	90                   	nop
 6a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      } else if(c == 's'){
        s = (char*)*ap;
 6a8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
        ap++;
 6ab:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
        s = (char*)*ap;
 6af:	8b 38                	mov    (%eax),%edi
        ap++;
        if(s == 0)
          s = "(null)";
 6b1:	b8 9d 0a 00 00       	mov    $0xa9d,%eax
 6b6:	85 ff                	test   %edi,%edi
 6b8:	0f 44 f8             	cmove  %eax,%edi
        while(*s != 0){
 6bb:	0f b6 07             	movzbl (%edi),%eax
 6be:	84 c0                	test   %al,%al
 6c0:	74 2a                	je     6ec <printf+0x16c>
 6c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 6c8:	88 45 e3             	mov    %al,-0x1d(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 6cb:	8d 45 e3             	lea    -0x1d(%ebp),%eax
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
 6ce:	83 c7 01             	add    $0x1,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 6d1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 6d8:	00 
 6d9:	89 44 24 04          	mov    %eax,0x4(%esp)
 6dd:	89 34 24             	mov    %esi,(%esp)
 6e0:	e8 6d fd ff ff       	call   452 <write>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 6e5:	0f b6 07             	movzbl (%edi),%eax
 6e8:	84 c0                	test   %al,%al
 6ea:	75 dc                	jne    6c8 <printf+0x148>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 6ec:	31 ff                	xor    %edi,%edi
 6ee:	e9 d8 fe ff ff       	jmp    5cb <printf+0x4b>
 6f3:	90                   	nop
 6f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 6f8:	8d 45 e5             	lea    -0x1b(%ebp),%eax
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 6fb:	31 ff                	xor    %edi,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 6fd:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 704:	00 
 705:	89 44 24 04          	mov    %eax,0x4(%esp)
 709:	89 34 24             	mov    %esi,(%esp)
 70c:	c6 45 e5 25          	movb   $0x25,-0x1b(%ebp)
 710:	e8 3d fd ff ff       	call   452 <write>
 715:	e9 b1 fe ff ff       	jmp    5cb <printf+0x4b>
 71a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 720:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 723:	b9 0a 00 00 00       	mov    $0xa,%ecx
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 728:	66 31 ff             	xor    %di,%di
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 72b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 732:	8b 10                	mov    (%eax),%edx
 734:	89 f0                	mov    %esi,%eax
 736:	e8 a5 fd ff ff       	call   4e0 <printint>
        ap++;
 73b:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 73f:	e9 87 fe ff ff       	jmp    5cb <printf+0x4b>
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 744:	8b 45 d4             	mov    -0x2c(%ebp),%eax
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 747:	31 ff                	xor    %edi,%edi
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 749:	8b 00                	mov    (%eax),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 74b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 752:	00 
 753:	89 34 24             	mov    %esi,(%esp)
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 756:	88 45 e4             	mov    %al,-0x1c(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 759:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 75c:	89 44 24 04          	mov    %eax,0x4(%esp)
 760:	e8 ed fc ff ff       	call   452 <write>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
 765:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 769:	e9 5d fe ff ff       	jmp    5cb <printf+0x4b>
 76e:	66 90                	xchg   %ax,%ax

00000770 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 770:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 771:	a1 dc 0d 00 00       	mov    0xddc,%eax
static Header base;
static Header *freep;

void
free(void *ap)
{
 776:	89 e5                	mov    %esp,%ebp
 778:	57                   	push   %edi
 779:	56                   	push   %esi
 77a:	53                   	push   %ebx
 77b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 77e:	8b 08                	mov    (%eax),%ecx
void
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
 780:	8d 53 f8             	lea    -0x8(%ebx),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 783:	39 d0                	cmp    %edx,%eax
 785:	72 11                	jb     798 <free+0x28>
 787:	90                   	nop
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 788:	39 c8                	cmp    %ecx,%eax
 78a:	72 04                	jb     790 <free+0x20>
 78c:	39 ca                	cmp    %ecx,%edx
 78e:	72 10                	jb     7a0 <free+0x30>
 790:	89 c8                	mov    %ecx,%eax
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 792:	39 d0                	cmp    %edx,%eax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 794:	8b 08                	mov    (%eax),%ecx
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 796:	73 f0                	jae    788 <free+0x18>
 798:	39 ca                	cmp    %ecx,%edx
 79a:	72 04                	jb     7a0 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 79c:	39 c8                	cmp    %ecx,%eax
 79e:	72 f0                	jb     790 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 7a0:	8b 73 fc             	mov    -0x4(%ebx),%esi
 7a3:	8d 3c f2             	lea    (%edx,%esi,8),%edi
 7a6:	39 cf                	cmp    %ecx,%edi
 7a8:	74 1e                	je     7c8 <free+0x58>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 7aa:	89 4b f8             	mov    %ecx,-0x8(%ebx)
  if(p + p->s.size == bp){
 7ad:	8b 48 04             	mov    0x4(%eax),%ecx
 7b0:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
 7b3:	39 f2                	cmp    %esi,%edx
 7b5:	74 28                	je     7df <free+0x6f>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 7b7:	89 10                	mov    %edx,(%eax)
  freep = p;
 7b9:	a3 dc 0d 00 00       	mov    %eax,0xddc
}
 7be:	5b                   	pop    %ebx
 7bf:	5e                   	pop    %esi
 7c0:	5f                   	pop    %edi
 7c1:	5d                   	pop    %ebp
 7c2:	c3                   	ret    
 7c3:	90                   	nop
 7c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7c8:	03 71 04             	add    0x4(%ecx),%esi
 7cb:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 7ce:	8b 08                	mov    (%eax),%ecx
 7d0:	8b 09                	mov    (%ecx),%ecx
 7d2:	89 4b f8             	mov    %ecx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 7d5:	8b 48 04             	mov    0x4(%eax),%ecx
 7d8:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
 7db:	39 f2                	cmp    %esi,%edx
 7dd:	75 d8                	jne    7b7 <free+0x47>
    p->s.size += bp->s.size;
 7df:	03 4b fc             	add    -0x4(%ebx),%ecx
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
 7e2:	a3 dc 0d 00 00       	mov    %eax,0xddc
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 7e7:	89 48 04             	mov    %ecx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 7ea:	8b 53 f8             	mov    -0x8(%ebx),%edx
 7ed:	89 10                	mov    %edx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
}
 7ef:	5b                   	pop    %ebx
 7f0:	5e                   	pop    %esi
 7f1:	5f                   	pop    %edi
 7f2:	5d                   	pop    %ebp
 7f3:	c3                   	ret    
 7f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 7fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000800 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 800:	55                   	push   %ebp
 801:	89 e5                	mov    %esp,%ebp
 803:	57                   	push   %edi
 804:	56                   	push   %esi
 805:	53                   	push   %ebx
 806:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 809:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 80c:	8b 1d dc 0d 00 00    	mov    0xddc,%ebx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 812:	8d 48 07             	lea    0x7(%eax),%ecx
 815:	c1 e9 03             	shr    $0x3,%ecx
  if((prevp = freep) == 0){
 818:	85 db                	test   %ebx,%ebx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 81a:	8d 71 01             	lea    0x1(%ecx),%esi
  if((prevp = freep) == 0){
 81d:	0f 84 9b 00 00 00    	je     8be <malloc+0xbe>
 823:	8b 13                	mov    (%ebx),%edx
 825:	8b 7a 04             	mov    0x4(%edx),%edi
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 828:	39 fe                	cmp    %edi,%esi
 82a:	76 64                	jbe    890 <malloc+0x90>
 82c:	8d 04 f5 00 00 00 00 	lea    0x0(,%esi,8),%eax
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < 4096)
 833:	bb 00 80 00 00       	mov    $0x8000,%ebx
 838:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 83b:	eb 0e                	jmp    84b <malloc+0x4b>
 83d:	8d 76 00             	lea    0x0(%esi),%esi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 840:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 842:	8b 78 04             	mov    0x4(%eax),%edi
 845:	39 fe                	cmp    %edi,%esi
 847:	76 4f                	jbe    898 <malloc+0x98>
 849:	89 c2                	mov    %eax,%edx
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 84b:	3b 15 dc 0d 00 00    	cmp    0xddc,%edx
 851:	75 ed                	jne    840 <malloc+0x40>
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < 4096)
 853:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 856:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 85c:	bf 00 10 00 00       	mov    $0x1000,%edi
 861:	0f 43 fe             	cmovae %esi,%edi
 864:	0f 42 c3             	cmovb  %ebx,%eax
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 867:	89 04 24             	mov    %eax,(%esp)
 86a:	e8 4b fc ff ff       	call   4ba <sbrk>
  if(p == (char*)-1)
 86f:	83 f8 ff             	cmp    $0xffffffff,%eax
 872:	74 18                	je     88c <malloc+0x8c>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 874:	89 78 04             	mov    %edi,0x4(%eax)
  free((void*)(hp + 1));
 877:	83 c0 08             	add    $0x8,%eax
 87a:	89 04 24             	mov    %eax,(%esp)
 87d:	e8 ee fe ff ff       	call   770 <free>
  return freep;
 882:	8b 15 dc 0d 00 00    	mov    0xddc,%edx
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 888:	85 d2                	test   %edx,%edx
 88a:	75 b4                	jne    840 <malloc+0x40>
        return 0;
 88c:	31 c0                	xor    %eax,%eax
 88e:	eb 20                	jmp    8b0 <malloc+0xb0>
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 890:	89 d0                	mov    %edx,%eax
 892:	89 da                	mov    %ebx,%edx
 894:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(p->s.size == nunits)
 898:	39 fe                	cmp    %edi,%esi
 89a:	74 1c                	je     8b8 <malloc+0xb8>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 89c:	29 f7                	sub    %esi,%edi
 89e:	89 78 04             	mov    %edi,0x4(%eax)
        p += p->s.size;
 8a1:	8d 04 f8             	lea    (%eax,%edi,8),%eax
        p->s.size = nunits;
 8a4:	89 70 04             	mov    %esi,0x4(%eax)
      }
      freep = prevp;
 8a7:	89 15 dc 0d 00 00    	mov    %edx,0xddc
      return (void*)(p + 1);
 8ad:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 8b0:	83 c4 1c             	add    $0x1c,%esp
 8b3:	5b                   	pop    %ebx
 8b4:	5e                   	pop    %esi
 8b5:	5f                   	pop    %edi
 8b6:	5d                   	pop    %ebp
 8b7:	c3                   	ret    
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
 8b8:	8b 08                	mov    (%eax),%ecx
 8ba:	89 0a                	mov    %ecx,(%edx)
 8bc:	eb e9                	jmp    8a7 <malloc+0xa7>
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 8be:	c7 05 dc 0d 00 00 e0 	movl   $0xde0,0xddc
 8c5:	0d 00 00 
    base.s.size = 0;
 8c8:	ba e0 0d 00 00       	mov    $0xde0,%edx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 8cd:	c7 05 e0 0d 00 00 e0 	movl   $0xde0,0xde0
 8d4:	0d 00 00 
    base.s.size = 0;
 8d7:	c7 05 e4 0d 00 00 00 	movl   $0x0,0xde4
 8de:	00 00 00 
 8e1:	e9 46 ff ff ff       	jmp    82c <malloc+0x2c>
