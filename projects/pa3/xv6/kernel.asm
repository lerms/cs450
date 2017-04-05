
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4 0f                	in     $0xf,%al

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc d0 b5 10 80       	mov    $0x8010b5d0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 50 2e 10 80       	mov    $0x80102e50,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb 14 b6 10 80       	mov    $0x8010b614,%ebx
  struct buf head;
} bcache;

void
binit(void)
{
80100049:	83 ec 14             	sub    $0x14,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010004c:	c7 44 24 04 c0 6d 10 	movl   $0x80106dc0,0x4(%esp)
80100053:	80 
80100054:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
8010005b:	e8 40 41 00 00       	call   801041a0 <initlock>

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
80100060:	ba dc fc 10 80       	mov    $0x8010fcdc,%edx

  initlock(&bcache.lock, "bcache");

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
80100065:	c7 05 2c fd 10 80 dc 	movl   $0x8010fcdc,0x8010fd2c
8010006c:	fc 10 80 
  bcache.head.next = &bcache.head;
8010006f:	c7 05 30 fd 10 80 dc 	movl   $0x8010fcdc,0x8010fd30
80100076:	fc 10 80 
80100079:	eb 09                	jmp    80100084 <binit+0x44>
8010007b:	90                   	nop
8010007c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 da                	mov    %ebx,%edx
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100082:	89 c3                	mov    %eax,%ebx
80100084:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->next = bcache.head.next;
80100087:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008a:	c7 43 50 dc fc 10 80 	movl   $0x8010fcdc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100091:	89 04 24             	mov    %eax,(%esp)
80100094:	c7 44 24 04 c7 6d 10 	movl   $0x80106dc7,0x4(%esp)
8010009b:	80 
8010009c:	e8 ef 3f 00 00       	call   80104090 <initsleeplock>
    bcache.head.next->prev = b;
801000a1:	a1 30 fd 10 80       	mov    0x8010fd30,%eax
801000a6:	89 58 50             	mov    %ebx,0x50(%eax)

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a9:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
801000af:	3d dc fc 10 80       	cmp    $0x8010fcdc,%eax
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
    bcache.head.next = b;
801000b4:	89 1d 30 fd 10 80    	mov    %ebx,0x8010fd30

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000ba:	75 c4                	jne    80100080 <binit+0x40>
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
}
801000bc:	83 c4 14             	add    $0x14,%esp
801000bf:	5b                   	pop    %ebx
801000c0:	5d                   	pop    %ebp
801000c1:	c3                   	ret    
801000c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 1c             	sub    $0x1c,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
static struct buf*
bget(uint dev, uint blockno)
{
  struct buf *b;

  acquire(&bcache.lock);
801000dc:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000e3:	8b 7d 0c             	mov    0xc(%ebp),%edi
static struct buf*
bget(uint dev, uint blockno)
{
  struct buf *b;

  acquire(&bcache.lock);
801000e6:	e8 35 41 00 00       	call   80104220 <acquire>

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000eb:	8b 1d 30 fd 10 80    	mov    0x8010fd30,%ebx
801000f1:	81 fb dc fc 10 80    	cmp    $0x8010fcdc,%ebx
801000f7:	75 12                	jne    8010010b <bread+0x3b>
801000f9:	eb 25                	jmp    80100120 <bread+0x50>
801000fb:	90                   	nop
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb dc fc 10 80    	cmp    $0x8010fcdc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	90                   	nop
8010011c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }

  // Not cached; recycle some unused buffer and clean buffer
  // "clean" because B_DIRTY and not locked means log.c
  // hasn't yet committed the changes to the buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 2c fd 10 80    	mov    0x8010fd2c,%ebx
80100126:	81 fb dc fc 10 80    	cmp    $0x8010fcdc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 58                	jmp    80100188 <bread+0xb8>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb dc fc 10 80    	cmp    $0x8010fcdc,%ebx
80100139:	74 4d                	je     80100188 <bread+0xb8>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
80100161:	e8 ea 41 00 00       	call   80104350 <release>
      acquiresleep(&b->lock);
80100166:	8d 43 0c             	lea    0xc(%ebx),%eax
80100169:	89 04 24             	mov    %eax,(%esp)
8010016c:	e8 5f 3f 00 00       	call   801040d0 <acquiresleep>
bread(uint dev, uint blockno)
{
  struct buf *b;

  b = bget(dev, blockno);
  if(!(b->flags & B_VALID)) {
80100171:	f6 03 02             	testb  $0x2,(%ebx)
80100174:	75 08                	jne    8010017e <bread+0xae>
    iderw(b);
80100176:	89 1c 24             	mov    %ebx,(%esp)
80100179:	e8 92 1f 00 00       	call   80102110 <iderw>
  }
  return b;
}
8010017e:	83 c4 1c             	add    $0x1c,%esp
80100181:	89 d8                	mov    %ebx,%eax
80100183:	5b                   	pop    %ebx
80100184:	5e                   	pop    %esi
80100185:	5f                   	pop    %edi
80100186:	5d                   	pop    %ebp
80100187:	c3                   	ret    
      release(&bcache.lock);
      acquiresleep(&b->lock);
      return b;
    }
  }
  panic("bget: no buffers");
80100188:	c7 04 24 ce 6d 10 80 	movl   $0x80106dce,(%esp)
8010018f:	e8 cc 01 00 00       	call   80100360 <panic>
80100194:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010019a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801001a0 <bwrite>:
}

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001a0:	55                   	push   %ebp
801001a1:	89 e5                	mov    %esp,%ebp
801001a3:	53                   	push   %ebx
801001a4:	83 ec 14             	sub    $0x14,%esp
801001a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801001ad:	89 04 24             	mov    %eax,(%esp)
801001b0:	e8 bb 3f 00 00       	call   80104170 <holdingsleep>
801001b5:	85 c0                	test   %eax,%eax
801001b7:	74 10                	je     801001c9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001b9:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001bc:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001bf:	83 c4 14             	add    $0x14,%esp
801001c2:	5b                   	pop    %ebx
801001c3:	5d                   	pop    %ebp
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
  b->flags |= B_DIRTY;
  iderw(b);
801001c4:	e9 47 1f 00 00       	jmp    80102110 <iderw>
// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
801001c9:	c7 04 24 df 6d 10 80 	movl   $0x80106ddf,(%esp)
801001d0:	e8 8b 01 00 00       	call   80100360 <panic>
801001d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801001d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801001e0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001e0:	55                   	push   %ebp
801001e1:	89 e5                	mov    %esp,%ebp
801001e3:	56                   	push   %esi
801001e4:	53                   	push   %ebx
801001e5:	83 ec 10             	sub    $0x10,%esp
801001e8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001eb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ee:	89 34 24             	mov    %esi,(%esp)
801001f1:	e8 7a 3f 00 00       	call   80104170 <holdingsleep>
801001f6:	85 c0                	test   %eax,%eax
801001f8:	74 5b                	je     80100255 <brelse+0x75>
    panic("brelse");

  releasesleep(&b->lock);
801001fa:	89 34 24             	mov    %esi,(%esp)
801001fd:	e8 2e 3f 00 00       	call   80104130 <releasesleep>

  acquire(&bcache.lock);
80100202:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
80100209:	e8 12 40 00 00       	call   80104220 <acquire>
  b->refcnt--;
  if (b->refcnt == 0) {
8010020e:	83 6b 4c 01          	subl   $0x1,0x4c(%ebx)
80100212:	75 2f                	jne    80100243 <brelse+0x63>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100214:	8b 43 54             	mov    0x54(%ebx),%eax
80100217:	8b 53 50             	mov    0x50(%ebx),%edx
8010021a:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
8010021d:	8b 43 50             	mov    0x50(%ebx),%eax
80100220:	8b 53 54             	mov    0x54(%ebx),%edx
80100223:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100226:	a1 30 fd 10 80       	mov    0x8010fd30,%eax
    b->prev = &bcache.head;
8010022b:	c7 43 50 dc fc 10 80 	movl   $0x8010fcdc,0x50(%ebx)
  b->refcnt--;
  if (b->refcnt == 0) {
    // no one is waiting for it.
    b->next->prev = b->prev;
    b->prev->next = b->next;
    b->next = bcache.head.next;
80100232:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    bcache.head.next->prev = b;
80100235:	a1 30 fd 10 80       	mov    0x8010fd30,%eax
8010023a:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
8010023d:	89 1d 30 fd 10 80    	mov    %ebx,0x8010fd30
  }
  
  release(&bcache.lock);
80100243:	c7 45 08 e0 b5 10 80 	movl   $0x8010b5e0,0x8(%ebp)
}
8010024a:	83 c4 10             	add    $0x10,%esp
8010024d:	5b                   	pop    %ebx
8010024e:	5e                   	pop    %esi
8010024f:	5d                   	pop    %ebp
    b->prev = &bcache.head;
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
  
  release(&bcache.lock);
80100250:	e9 fb 40 00 00       	jmp    80104350 <release>
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("brelse");
80100255:	c7 04 24 e6 6d 10 80 	movl   $0x80106de6,(%esp)
8010025c:	e8 ff 00 00 00       	call   80100360 <panic>
80100261:	66 90                	xchg   %ax,%ax
80100263:	66 90                	xchg   %ax,%ax
80100265:	66 90                	xchg   %ax,%ax
80100267:	66 90                	xchg   %ax,%ax
80100269:	66 90                	xchg   %ax,%ax
8010026b:	66 90                	xchg   %ax,%ax
8010026d:	66 90                	xchg   %ax,%ax
8010026f:	90                   	nop

80100270 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100270:	55                   	push   %ebp
80100271:	89 e5                	mov    %esp,%ebp
80100273:	57                   	push   %edi
80100274:	56                   	push   %esi
80100275:	53                   	push   %ebx
80100276:	83 ec 1c             	sub    $0x1c,%esp
80100279:	8b 7d 08             	mov    0x8(%ebp),%edi
8010027c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010027f:	89 3c 24             	mov    %edi,(%esp)
80100282:	e8 f9 14 00 00       	call   80101780 <iunlock>
  target = n;
  acquire(&cons.lock);
80100287:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010028e:	e8 8d 3f 00 00       	call   80104220 <acquire>
  while(n > 0){
80100293:	8b 55 10             	mov    0x10(%ebp),%edx
80100296:	85 d2                	test   %edx,%edx
80100298:	0f 8e bc 00 00 00    	jle    8010035a <consoleread+0xea>
8010029e:	8b 5d 10             	mov    0x10(%ebp),%ebx
801002a1:	eb 26                	jmp    801002c9 <consoleread+0x59>
801002a3:	90                   	nop
801002a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(input.r == input.w){
      if(proc->killed){
801002a8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801002ae:	8b 40 24             	mov    0x24(%eax),%eax
801002b1:	85 c0                	test   %eax,%eax
801002b3:	75 73                	jne    80100328 <consoleread+0xb8>
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002b5:	c7 44 24 04 20 a5 10 	movl   $0x8010a520,0x4(%esp)
801002bc:	80 
801002bd:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
801002c4:	e8 37 3a 00 00       	call   80103d00 <sleep>

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
801002c9:	a1 c0 ff 10 80       	mov    0x8010ffc0,%eax
801002ce:	3b 05 c4 ff 10 80    	cmp    0x8010ffc4,%eax
801002d4:	74 d2                	je     801002a8 <consoleread+0x38>
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
801002d6:	8d 50 01             	lea    0x1(%eax),%edx
801002d9:	89 15 c0 ff 10 80    	mov    %edx,0x8010ffc0
801002df:	89 c2                	mov    %eax,%edx
801002e1:	83 e2 7f             	and    $0x7f,%edx
801002e4:	0f b6 8a 40 ff 10 80 	movzbl -0x7fef00c0(%edx),%ecx
801002eb:	0f be d1             	movsbl %cl,%edx
    if(c == C('D')){  // EOF
801002ee:	83 fa 04             	cmp    $0x4,%edx
801002f1:	74 56                	je     80100349 <consoleread+0xd9>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
801002f3:	83 c6 01             	add    $0x1,%esi
    --n;
801002f6:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
801002f9:	83 fa 0a             	cmp    $0xa,%edx
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
801002fc:	88 4e ff             	mov    %cl,-0x1(%esi)
    --n;
    if(c == '\n')
801002ff:	74 52                	je     80100353 <consoleread+0xe3>
  int c;

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
80100301:	85 db                	test   %ebx,%ebx
80100303:	75 c4                	jne    801002c9 <consoleread+0x59>
80100305:	8b 45 10             	mov    0x10(%ebp),%eax
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
  }
  release(&cons.lock);
80100308:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010030f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100312:	e8 39 40 00 00       	call   80104350 <release>
  ilock(ip);
80100317:	89 3c 24             	mov    %edi,(%esp)
8010031a:	e8 91 13 00 00       	call   801016b0 <ilock>
8010031f:	8b 45 e4             	mov    -0x1c(%ebp),%eax

  return target - n;
80100322:	eb 1d                	jmp    80100341 <consoleread+0xd1>
80100324:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
      if(proc->killed){
        release(&cons.lock);
80100328:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010032f:	e8 1c 40 00 00       	call   80104350 <release>
        ilock(ip);
80100334:	89 3c 24             	mov    %edi,(%esp)
80100337:	e8 74 13 00 00       	call   801016b0 <ilock>
        return -1;
8010033c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
80100341:	83 c4 1c             	add    $0x1c,%esp
80100344:	5b                   	pop    %ebx
80100345:	5e                   	pop    %esi
80100346:	5f                   	pop    %edi
80100347:	5d                   	pop    %ebp
80100348:	c3                   	ret    
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
    if(c == C('D')){  // EOF
      if(n < target){
80100349:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010034c:	76 05                	jbe    80100353 <consoleread+0xe3>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
8010034e:	a3 c0 ff 10 80       	mov    %eax,0x8010ffc0
80100353:	8b 45 10             	mov    0x10(%ebp),%eax
80100356:	29 d8                	sub    %ebx,%eax
80100358:	eb ae                	jmp    80100308 <consoleread+0x98>
  int c;

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
8010035a:	31 c0                	xor    %eax,%eax
8010035c:	eb aa                	jmp    80100308 <consoleread+0x98>
8010035e:	66 90                	xchg   %ax,%ax

80100360 <panic>:
    release(&cons.lock);
}

void
panic(char *s)
{
80100360:	55                   	push   %ebp
80100361:	89 e5                	mov    %esp,%ebp
80100363:	56                   	push   %esi
80100364:	53                   	push   %ebx
80100365:	83 ec 40             	sub    $0x40,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100368:	fa                   	cli    
  int i;
  uint pcs[10];

  cli();
  cons.locking = 0;
  cprintf("cpu with apicid %d: panic: ", cpu->apicid);
80100369:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
8010036f:	8d 5d d0             	lea    -0x30(%ebp),%ebx
{
  int i;
  uint pcs[10];

  cli();
  cons.locking = 0;
80100372:	c7 05 54 a5 10 80 00 	movl   $0x0,0x8010a554
80100379:	00 00 00 
8010037c:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("cpu with apicid %d: panic: ", cpu->apicid);
8010037f:	0f b6 00             	movzbl (%eax),%eax
80100382:	c7 04 24 ed 6d 10 80 	movl   $0x80106ded,(%esp)
80100389:	89 44 24 04          	mov    %eax,0x4(%esp)
8010038d:	e8 be 02 00 00       	call   80100650 <cprintf>
  cprintf(s);
80100392:	8b 45 08             	mov    0x8(%ebp),%eax
80100395:	89 04 24             	mov    %eax,(%esp)
80100398:	e8 b3 02 00 00       	call   80100650 <cprintf>
  cprintf("\n");
8010039d:	c7 04 24 e6 72 10 80 	movl   $0x801072e6,(%esp)
801003a4:	e8 a7 02 00 00       	call   80100650 <cprintf>
  getcallerpcs(&s, pcs);
801003a9:	8d 45 08             	lea    0x8(%ebp),%eax
801003ac:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801003b0:	89 04 24             	mov    %eax,(%esp)
801003b3:	e8 08 3e 00 00       	call   801041c0 <getcallerpcs>
  for(i=0; i<10; i++)
    cprintf(" %p", pcs[i]);
801003b8:	8b 03                	mov    (%ebx),%eax
801003ba:	83 c3 04             	add    $0x4,%ebx
801003bd:	c7 04 24 09 6e 10 80 	movl   $0x80106e09,(%esp)
801003c4:	89 44 24 04          	mov    %eax,0x4(%esp)
801003c8:	e8 83 02 00 00       	call   80100650 <cprintf>
  cons.locking = 0;
  cprintf("cpu with apicid %d: panic: ", cpu->apicid);
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
801003cd:	39 f3                	cmp    %esi,%ebx
801003cf:	75 e7                	jne    801003b8 <panic+0x58>
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
801003d1:	c7 05 58 a5 10 80 01 	movl   $0x1,0x8010a558
801003d8:	00 00 00 
801003db:	eb fe                	jmp    801003db <panic+0x7b>
801003dd:	8d 76 00             	lea    0x0(%esi),%esi

801003e0 <consputc>:
}

void
consputc(int c)
{
  if(panicked){
801003e0:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
801003e6:	85 d2                	test   %edx,%edx
801003e8:	74 06                	je     801003f0 <consputc+0x10>
801003ea:	fa                   	cli    
801003eb:	eb fe                	jmp    801003eb <consputc+0xb>
801003ed:	8d 76 00             	lea    0x0(%esi),%esi
  crt[pos] = ' ' | 0x0700;
}

void
consputc(int c)
{
801003f0:	55                   	push   %ebp
801003f1:	89 e5                	mov    %esp,%ebp
801003f3:	57                   	push   %edi
801003f4:	56                   	push   %esi
801003f5:	53                   	push   %ebx
801003f6:	89 c3                	mov    %eax,%ebx
801003f8:	83 ec 1c             	sub    $0x1c,%esp
    cli();
    for(;;)
      ;
  }

  if(c == BACKSPACE){
801003fb:	3d 00 01 00 00       	cmp    $0x100,%eax
80100400:	0f 84 ac 00 00 00    	je     801004b2 <consputc+0xd2>
    uartputc('\b'); uartputc(' '); uartputc('\b');
  } else
    uartputc(c);
80100406:	89 04 24             	mov    %eax,(%esp)
80100409:	e8 e2 54 00 00       	call   801058f0 <uartputc>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010040e:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100413:	b8 0e 00 00 00       	mov    $0xe,%eax
80100418:	89 fa                	mov    %edi,%edx
8010041a:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010041b:	be d5 03 00 00       	mov    $0x3d5,%esi
80100420:	89 f2                	mov    %esi,%edx
80100422:	ec                   	in     (%dx),%al
{
  int pos;

  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
  pos = inb(CRTPORT+1) << 8;
80100423:	0f b6 c8             	movzbl %al,%ecx
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100426:	89 fa                	mov    %edi,%edx
80100428:	c1 e1 08             	shl    $0x8,%ecx
8010042b:	b8 0f 00 00 00       	mov    $0xf,%eax
80100430:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100431:	89 f2                	mov    %esi,%edx
80100433:	ec                   	in     (%dx),%al
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);
80100434:	0f b6 c0             	movzbl %al,%eax
80100437:	09 c1                	or     %eax,%ecx

  if(c == '\n')
80100439:	83 fb 0a             	cmp    $0xa,%ebx
8010043c:	0f 84 0d 01 00 00    	je     8010054f <consputc+0x16f>
    pos += 80 - pos%80;
  else if(c == BACKSPACE){
80100442:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
80100448:	0f 84 e8 00 00 00    	je     80100536 <consputc+0x156>
    if(pos > 0) --pos;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
8010044e:	0f b6 db             	movzbl %bl,%ebx
80100451:	80 cf 07             	or     $0x7,%bh
80100454:	8d 79 01             	lea    0x1(%ecx),%edi
80100457:	66 89 9c 09 00 80 0b 	mov    %bx,-0x7ff48000(%ecx,%ecx,1)
8010045e:	80 

  if(pos < 0 || pos > 25*80)
8010045f:	81 ff d0 07 00 00    	cmp    $0x7d0,%edi
80100465:	0f 87 bf 00 00 00    	ja     8010052a <consputc+0x14a>
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
8010046b:	81 ff 7f 07 00 00    	cmp    $0x77f,%edi
80100471:	7f 68                	jg     801004db <consputc+0xfb>
80100473:	89 f8                	mov    %edi,%eax
80100475:	89 fb                	mov    %edi,%ebx
80100477:	c1 e8 08             	shr    $0x8,%eax
8010047a:	89 c6                	mov    %eax,%esi
8010047c:	8d 8c 3f 00 80 0b 80 	lea    -0x7ff48000(%edi,%edi,1),%ecx
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100483:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100488:	b8 0e 00 00 00       	mov    $0xe,%eax
8010048d:	89 fa                	mov    %edi,%edx
8010048f:	ee                   	out    %al,(%dx)
80100490:	89 f0                	mov    %esi,%eax
80100492:	b2 d5                	mov    $0xd5,%dl
80100494:	ee                   	out    %al,(%dx)
80100495:	b8 0f 00 00 00       	mov    $0xf,%eax
8010049a:	89 fa                	mov    %edi,%edx
8010049c:	ee                   	out    %al,(%dx)
8010049d:	89 d8                	mov    %ebx,%eax
8010049f:	b2 d5                	mov    $0xd5,%dl
801004a1:	ee                   	out    %al,(%dx)

  outb(CRTPORT, 14);
  outb(CRTPORT+1, pos>>8);
  outb(CRTPORT, 15);
  outb(CRTPORT+1, pos);
  crt[pos] = ' ' | 0x0700;
801004a2:	b8 20 07 00 00       	mov    $0x720,%eax
801004a7:	66 89 01             	mov    %ax,(%ecx)
  if(c == BACKSPACE){
    uartputc('\b'); uartputc(' '); uartputc('\b');
  } else
    uartputc(c);
  cgaputc(c);
}
801004aa:	83 c4 1c             	add    $0x1c,%esp
801004ad:	5b                   	pop    %ebx
801004ae:	5e                   	pop    %esi
801004af:	5f                   	pop    %edi
801004b0:	5d                   	pop    %ebp
801004b1:	c3                   	ret    
    for(;;)
      ;
  }

  if(c == BACKSPACE){
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004b2:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004b9:	e8 32 54 00 00       	call   801058f0 <uartputc>
801004be:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004c5:	e8 26 54 00 00       	call   801058f0 <uartputc>
801004ca:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004d1:	e8 1a 54 00 00       	call   801058f0 <uartputc>
801004d6:	e9 33 ff ff ff       	jmp    8010040e <consputc+0x2e>

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004db:	c7 44 24 08 60 0e 00 	movl   $0xe60,0x8(%esp)
801004e2:	00 
    pos -= 80;
801004e3:	8d 5f b0             	lea    -0x50(%edi),%ebx

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004e6:	c7 44 24 04 a0 80 0b 	movl   $0x800b80a0,0x4(%esp)
801004ed:	80 
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801004ee:	8d b4 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%esi

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004f5:	c7 04 24 00 80 0b 80 	movl   $0x800b8000,(%esp)
801004fc:	e8 3f 3f 00 00       	call   80104440 <memmove>
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100501:	b8 d0 07 00 00       	mov    $0x7d0,%eax
80100506:	29 f8                	sub    %edi,%eax
80100508:	01 c0                	add    %eax,%eax
8010050a:	89 34 24             	mov    %esi,(%esp)
8010050d:	89 44 24 08          	mov    %eax,0x8(%esp)
80100511:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100518:	00 
80100519:	e8 82 3e 00 00       	call   801043a0 <memset>
8010051e:	89 f1                	mov    %esi,%ecx
80100520:	be 07 00 00 00       	mov    $0x7,%esi
80100525:	e9 59 ff ff ff       	jmp    80100483 <consputc+0xa3>
    if(pos > 0) --pos;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");
8010052a:	c7 04 24 0d 6e 10 80 	movl   $0x80106e0d,(%esp)
80100531:	e8 2a fe ff ff       	call   80100360 <panic>
  pos |= inb(CRTPORT+1);

  if(c == '\n')
    pos += 80 - pos%80;
  else if(c == BACKSPACE){
    if(pos > 0) --pos;
80100536:	85 c9                	test   %ecx,%ecx
80100538:	8d 79 ff             	lea    -0x1(%ecx),%edi
8010053b:	0f 85 1e ff ff ff    	jne    8010045f <consputc+0x7f>
80100541:	b9 00 80 0b 80       	mov    $0x800b8000,%ecx
80100546:	31 db                	xor    %ebx,%ebx
80100548:	31 f6                	xor    %esi,%esi
8010054a:	e9 34 ff ff ff       	jmp    80100483 <consputc+0xa3>
  pos = inb(CRTPORT+1) << 8;
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);

  if(c == '\n')
    pos += 80 - pos%80;
8010054f:	89 c8                	mov    %ecx,%eax
80100551:	ba 67 66 66 66       	mov    $0x66666667,%edx
80100556:	f7 ea                	imul   %edx
80100558:	c1 ea 05             	shr    $0x5,%edx
8010055b:	8d 04 92             	lea    (%edx,%edx,4),%eax
8010055e:	c1 e0 04             	shl    $0x4,%eax
80100561:	8d 78 50             	lea    0x50(%eax),%edi
80100564:	e9 f6 fe ff ff       	jmp    8010045f <consputc+0x7f>
80100569:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100570 <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
80100570:	55                   	push   %ebp
80100571:	89 e5                	mov    %esp,%ebp
80100573:	57                   	push   %edi
80100574:	56                   	push   %esi
80100575:	89 d6                	mov    %edx,%esi
80100577:	53                   	push   %ebx
80100578:	83 ec 1c             	sub    $0x1c,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
8010057b:	85 c9                	test   %ecx,%ecx
8010057d:	74 61                	je     801005e0 <printint+0x70>
8010057f:	85 c0                	test   %eax,%eax
80100581:	79 5d                	jns    801005e0 <printint+0x70>
    x = -xx;
80100583:	f7 d8                	neg    %eax
80100585:	bf 01 00 00 00       	mov    $0x1,%edi
  else
    x = xx;

  i = 0;
8010058a:	31 c9                	xor    %ecx,%ecx
8010058c:	eb 04                	jmp    80100592 <printint+0x22>
8010058e:	66 90                	xchg   %ax,%ax
  do{
    buf[i++] = digits[x % base];
80100590:	89 d9                	mov    %ebx,%ecx
80100592:	31 d2                	xor    %edx,%edx
80100594:	f7 f6                	div    %esi
80100596:	8d 59 01             	lea    0x1(%ecx),%ebx
80100599:	0f b6 92 38 6e 10 80 	movzbl -0x7fef91c8(%edx),%edx
  }while((x /= base) != 0);
801005a0:	85 c0                	test   %eax,%eax
  else
    x = xx;

  i = 0;
  do{
    buf[i++] = digits[x % base];
801005a2:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
801005a6:	75 e8                	jne    80100590 <printint+0x20>

  if(sign)
801005a8:	85 ff                	test   %edi,%edi
  else
    x = xx;

  i = 0;
  do{
    buf[i++] = digits[x % base];
801005aa:	89 d8                	mov    %ebx,%eax
  }while((x /= base) != 0);

  if(sign)
801005ac:	74 08                	je     801005b6 <printint+0x46>
    buf[i++] = '-';
801005ae:	8d 59 02             	lea    0x2(%ecx),%ebx
801005b1:	c6 44 05 d8 2d       	movb   $0x2d,-0x28(%ebp,%eax,1)

  while(--i >= 0)
801005b6:	83 eb 01             	sub    $0x1,%ebx
801005b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    consputc(buf[i]);
801005c0:	0f be 44 1d d8       	movsbl -0x28(%ebp,%ebx,1),%eax
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
801005c5:	83 eb 01             	sub    $0x1,%ebx
    consputc(buf[i]);
801005c8:	e8 13 fe ff ff       	call   801003e0 <consputc>
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
801005cd:	83 fb ff             	cmp    $0xffffffff,%ebx
801005d0:	75 ee                	jne    801005c0 <printint+0x50>
    consputc(buf[i]);
}
801005d2:	83 c4 1c             	add    $0x1c,%esp
801005d5:	5b                   	pop    %ebx
801005d6:	5e                   	pop    %esi
801005d7:	5f                   	pop    %edi
801005d8:	5d                   	pop    %ebp
801005d9:	c3                   	ret    
801005da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  uint x;

  if(sign && (sign = xx < 0))
    x = -xx;
  else
    x = xx;
801005e0:	31 ff                	xor    %edi,%edi
801005e2:	eb a6                	jmp    8010058a <printint+0x1a>
801005e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801005ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801005f0 <consolewrite>:
  return target - n;
}

int
consolewrite(struct inode *ip, char *buf, int n)
{
801005f0:	55                   	push   %ebp
801005f1:	89 e5                	mov    %esp,%ebp
801005f3:	57                   	push   %edi
801005f4:	56                   	push   %esi
801005f5:	53                   	push   %ebx
801005f6:	83 ec 1c             	sub    $0x1c,%esp
  int i;

  iunlock(ip);
801005f9:	8b 45 08             	mov    0x8(%ebp),%eax
  return target - n;
}

int
consolewrite(struct inode *ip, char *buf, int n)
{
801005fc:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
801005ff:	89 04 24             	mov    %eax,(%esp)
80100602:	e8 79 11 00 00       	call   80101780 <iunlock>
  acquire(&cons.lock);
80100607:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010060e:	e8 0d 3c 00 00       	call   80104220 <acquire>
80100613:	8b 7d 0c             	mov    0xc(%ebp),%edi
  for(i = 0; i < n; i++)
80100616:	85 f6                	test   %esi,%esi
80100618:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010061b:	7e 12                	jle    8010062f <consolewrite+0x3f>
8010061d:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100620:	0f b6 07             	movzbl (%edi),%eax
80100623:	83 c7 01             	add    $0x1,%edi
80100626:	e8 b5 fd ff ff       	call   801003e0 <consputc>
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
8010062b:	39 df                	cmp    %ebx,%edi
8010062d:	75 f1                	jne    80100620 <consolewrite+0x30>
    consputc(buf[i] & 0xff);
  release(&cons.lock);
8010062f:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100636:	e8 15 3d 00 00       	call   80104350 <release>
  ilock(ip);
8010063b:	8b 45 08             	mov    0x8(%ebp),%eax
8010063e:	89 04 24             	mov    %eax,(%esp)
80100641:	e8 6a 10 00 00       	call   801016b0 <ilock>

  return n;
}
80100646:	83 c4 1c             	add    $0x1c,%esp
80100649:	89 f0                	mov    %esi,%eax
8010064b:	5b                   	pop    %ebx
8010064c:	5e                   	pop    %esi
8010064d:	5f                   	pop    %edi
8010064e:	5d                   	pop    %ebp
8010064f:	c3                   	ret    

80100650 <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
80100650:	55                   	push   %ebp
80100651:	89 e5                	mov    %esp,%ebp
80100653:	57                   	push   %edi
80100654:	56                   	push   %esi
80100655:	53                   	push   %ebx
80100656:	83 ec 1c             	sub    $0x1c,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
80100659:	a1 54 a5 10 80       	mov    0x8010a554,%eax
  if(locking)
8010065e:	85 c0                	test   %eax,%eax
{
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
80100660:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
80100663:	0f 85 27 01 00 00    	jne    80100790 <cprintf+0x140>
    acquire(&cons.lock);

  if (fmt == 0)
80100669:	8b 45 08             	mov    0x8(%ebp),%eax
8010066c:	85 c0                	test   %eax,%eax
8010066e:	89 c1                	mov    %eax,%ecx
80100670:	0f 84 2b 01 00 00    	je     801007a1 <cprintf+0x151>
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100676:	0f b6 00             	movzbl (%eax),%eax
80100679:	31 db                	xor    %ebx,%ebx
8010067b:	89 cf                	mov    %ecx,%edi
8010067d:	8d 75 0c             	lea    0xc(%ebp),%esi
80100680:	85 c0                	test   %eax,%eax
80100682:	75 4c                	jne    801006d0 <cprintf+0x80>
80100684:	eb 5f                	jmp    801006e5 <cprintf+0x95>
80100686:	66 90                	xchg   %ax,%ax
    if(c != '%'){
      consputc(c);
      continue;
    }
    c = fmt[++i] & 0xff;
80100688:	83 c3 01             	add    $0x1,%ebx
8010068b:	0f b6 14 1f          	movzbl (%edi,%ebx,1),%edx
    if(c == 0)
8010068f:	85 d2                	test   %edx,%edx
80100691:	74 52                	je     801006e5 <cprintf+0x95>
      break;
    switch(c){
80100693:	83 fa 70             	cmp    $0x70,%edx
80100696:	74 72                	je     8010070a <cprintf+0xba>
80100698:	7f 66                	jg     80100700 <cprintf+0xb0>
8010069a:	83 fa 25             	cmp    $0x25,%edx
8010069d:	8d 76 00             	lea    0x0(%esi),%esi
801006a0:	0f 84 a2 00 00 00    	je     80100748 <cprintf+0xf8>
801006a6:	83 fa 64             	cmp    $0x64,%edx
801006a9:	75 7d                	jne    80100728 <cprintf+0xd8>
    case 'd':
      printint(*argp++, 10, 1);
801006ab:	8d 46 04             	lea    0x4(%esi),%eax
801006ae:	b9 01 00 00 00       	mov    $0x1,%ecx
801006b3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801006b6:	8b 06                	mov    (%esi),%eax
801006b8:	ba 0a 00 00 00       	mov    $0xa,%edx
801006bd:	e8 ae fe ff ff       	call   80100570 <printint>
801006c2:	8b 75 e4             	mov    -0x1c(%ebp),%esi

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006c5:	83 c3 01             	add    $0x1,%ebx
801006c8:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801006cc:	85 c0                	test   %eax,%eax
801006ce:	74 15                	je     801006e5 <cprintf+0x95>
    if(c != '%'){
801006d0:	83 f8 25             	cmp    $0x25,%eax
801006d3:	74 b3                	je     80100688 <cprintf+0x38>
      consputc('%');
      break;
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
      consputc(c);
801006d5:	e8 06 fd ff ff       	call   801003e0 <consputc>

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006da:	83 c3 01             	add    $0x1,%ebx
801006dd:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801006e1:	85 c0                	test   %eax,%eax
801006e3:	75 eb                	jne    801006d0 <cprintf+0x80>
      consputc(c);
      break;
    }
  }

  if(locking)
801006e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
801006e8:	85 c0                	test   %eax,%eax
801006ea:	74 0c                	je     801006f8 <cprintf+0xa8>
    release(&cons.lock);
801006ec:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
801006f3:	e8 58 3c 00 00       	call   80104350 <release>
}
801006f8:	83 c4 1c             	add    $0x1c,%esp
801006fb:	5b                   	pop    %ebx
801006fc:	5e                   	pop    %esi
801006fd:	5f                   	pop    %edi
801006fe:	5d                   	pop    %ebp
801006ff:	c3                   	ret    
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
    switch(c){
80100700:	83 fa 73             	cmp    $0x73,%edx
80100703:	74 53                	je     80100758 <cprintf+0x108>
80100705:	83 fa 78             	cmp    $0x78,%edx
80100708:	75 1e                	jne    80100728 <cprintf+0xd8>
    case 'd':
      printint(*argp++, 10, 1);
      break;
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
8010070a:	8d 46 04             	lea    0x4(%esi),%eax
8010070d:	31 c9                	xor    %ecx,%ecx
8010070f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100712:	8b 06                	mov    (%esi),%eax
80100714:	ba 10 00 00 00       	mov    $0x10,%edx
80100719:	e8 52 fe ff ff       	call   80100570 <printint>
8010071e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
      break;
80100721:	eb a2                	jmp    801006c5 <cprintf+0x75>
80100723:	90                   	nop
80100724:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case '%':
      consputc('%');
      break;
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
80100728:	b8 25 00 00 00       	mov    $0x25,%eax
8010072d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80100730:	e8 ab fc ff ff       	call   801003e0 <consputc>
      consputc(c);
80100735:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80100738:	89 d0                	mov    %edx,%eax
8010073a:	e8 a1 fc ff ff       	call   801003e0 <consputc>
8010073f:	eb 99                	jmp    801006da <cprintf+0x8a>
80100741:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
      break;
    case '%':
      consputc('%');
80100748:	b8 25 00 00 00       	mov    $0x25,%eax
8010074d:	e8 8e fc ff ff       	call   801003e0 <consputc>
      break;
80100752:	e9 6e ff ff ff       	jmp    801006c5 <cprintf+0x75>
80100757:	90                   	nop
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
80100758:	8d 46 04             	lea    0x4(%esi),%eax
8010075b:	8b 36                	mov    (%esi),%esi
8010075d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        s = "(null)";
80100760:	b8 20 6e 10 80       	mov    $0x80106e20,%eax
80100765:	85 f6                	test   %esi,%esi
80100767:	0f 44 f0             	cmove  %eax,%esi
      for(; *s; s++)
8010076a:	0f be 06             	movsbl (%esi),%eax
8010076d:	84 c0                	test   %al,%al
8010076f:	74 16                	je     80100787 <cprintf+0x137>
80100771:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100778:	83 c6 01             	add    $0x1,%esi
        consputc(*s);
8010077b:	e8 60 fc ff ff       	call   801003e0 <consputc>
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
80100780:	0f be 06             	movsbl (%esi),%eax
80100783:	84 c0                	test   %al,%al
80100785:	75 f1                	jne    80100778 <cprintf+0x128>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
80100787:	8b 75 e4             	mov    -0x1c(%ebp),%esi
8010078a:	e9 36 ff ff ff       	jmp    801006c5 <cprintf+0x75>
8010078f:	90                   	nop
  uint *argp;
  char *s;

  locking = cons.locking;
  if(locking)
    acquire(&cons.lock);
80100790:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100797:	e8 84 3a 00 00       	call   80104220 <acquire>
8010079c:	e9 c8 fe ff ff       	jmp    80100669 <cprintf+0x19>

  if (fmt == 0)
    panic("null fmt");
801007a1:	c7 04 24 27 6e 10 80 	movl   $0x80106e27,(%esp)
801007a8:	e8 b3 fb ff ff       	call   80100360 <panic>
801007ad:	8d 76 00             	lea    0x0(%esi),%esi

801007b0 <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007b0:	55                   	push   %ebp
801007b1:	89 e5                	mov    %esp,%ebp
801007b3:	57                   	push   %edi
801007b4:	56                   	push   %esi
  int c, doprocdump = 0;
801007b5:	31 f6                	xor    %esi,%esi

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007b7:	53                   	push   %ebx
801007b8:	83 ec 1c             	sub    $0x1c,%esp
801007bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int c, doprocdump = 0;

  acquire(&cons.lock);
801007be:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
801007c5:	e8 56 3a 00 00       	call   80104220 <acquire>
801007ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  while((c = getc()) >= 0){
801007d0:	ff d3                	call   *%ebx
801007d2:	85 c0                	test   %eax,%eax
801007d4:	89 c7                	mov    %eax,%edi
801007d6:	78 48                	js     80100820 <consoleintr+0x70>
    switch(c){
801007d8:	83 ff 10             	cmp    $0x10,%edi
801007db:	0f 84 2f 01 00 00    	je     80100910 <consoleintr+0x160>
801007e1:	7e 5d                	jle    80100840 <consoleintr+0x90>
801007e3:	83 ff 15             	cmp    $0x15,%edi
801007e6:	0f 84 d4 00 00 00    	je     801008c0 <consoleintr+0x110>
801007ec:	83 ff 7f             	cmp    $0x7f,%edi
801007ef:	90                   	nop
801007f0:	75 53                	jne    80100845 <consoleintr+0x95>
        input.e--;
        consputc(BACKSPACE);
      }
      break;
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
801007f2:	a1 c8 ff 10 80       	mov    0x8010ffc8,%eax
801007f7:	3b 05 c4 ff 10 80    	cmp    0x8010ffc4,%eax
801007fd:	74 d1                	je     801007d0 <consoleintr+0x20>
        input.e--;
801007ff:	83 e8 01             	sub    $0x1,%eax
80100802:	a3 c8 ff 10 80       	mov    %eax,0x8010ffc8
        consputc(BACKSPACE);
80100807:	b8 00 01 00 00       	mov    $0x100,%eax
8010080c:	e8 cf fb ff ff       	call   801003e0 <consputc>
consoleintr(int (*getc)(void))
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
80100811:	ff d3                	call   *%ebx
80100813:	85 c0                	test   %eax,%eax
80100815:	89 c7                	mov    %eax,%edi
80100817:	79 bf                	jns    801007d8 <consoleintr+0x28>
80100819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        }
      }
      break;
    }
  }
  release(&cons.lock);
80100820:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100827:	e8 24 3b 00 00       	call   80104350 <release>
  if(doprocdump) {
8010082c:	85 f6                	test   %esi,%esi
8010082e:	0f 85 ec 00 00 00    	jne    80100920 <consoleintr+0x170>
    procdump();  // now call procdump() wo. cons.lock held
  }
}
80100834:	83 c4 1c             	add    $0x1c,%esp
80100837:	5b                   	pop    %ebx
80100838:	5e                   	pop    %esi
80100839:	5f                   	pop    %edi
8010083a:	5d                   	pop    %ebp
8010083b:	c3                   	ret    
8010083c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
    switch(c){
80100840:	83 ff 08             	cmp    $0x8,%edi
80100843:	74 ad                	je     801007f2 <consoleintr+0x42>
        input.e--;
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100845:	85 ff                	test   %edi,%edi
80100847:	74 87                	je     801007d0 <consoleintr+0x20>
80100849:	a1 c8 ff 10 80       	mov    0x8010ffc8,%eax
8010084e:	89 c2                	mov    %eax,%edx
80100850:	2b 15 c0 ff 10 80    	sub    0x8010ffc0,%edx
80100856:	83 fa 7f             	cmp    $0x7f,%edx
80100859:	0f 87 71 ff ff ff    	ja     801007d0 <consoleintr+0x20>
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
8010085f:	8d 50 01             	lea    0x1(%eax),%edx
80100862:	83 e0 7f             	and    $0x7f,%eax
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
80100865:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
80100868:	89 15 c8 ff 10 80    	mov    %edx,0x8010ffc8
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
8010086e:	0f 84 b8 00 00 00    	je     8010092c <consoleintr+0x17c>
        input.buf[input.e++ % INPUT_BUF] = c;
80100874:	89 f9                	mov    %edi,%ecx
80100876:	88 88 40 ff 10 80    	mov    %cl,-0x7fef00c0(%eax)
        consputc(c);
8010087c:	89 f8                	mov    %edi,%eax
8010087e:	e8 5d fb ff ff       	call   801003e0 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100883:	83 ff 04             	cmp    $0x4,%edi
80100886:	a1 c8 ff 10 80       	mov    0x8010ffc8,%eax
8010088b:	74 19                	je     801008a6 <consoleintr+0xf6>
8010088d:	83 ff 0a             	cmp    $0xa,%edi
80100890:	74 14                	je     801008a6 <consoleintr+0xf6>
80100892:	8b 0d c0 ff 10 80    	mov    0x8010ffc0,%ecx
80100898:	8d 91 80 00 00 00    	lea    0x80(%ecx),%edx
8010089e:	39 d0                	cmp    %edx,%eax
801008a0:	0f 85 2a ff ff ff    	jne    801007d0 <consoleintr+0x20>
          input.w = input.e;
          wakeup(&input.r);
801008a6:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
        consputc(c);
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
          input.w = input.e;
801008ad:	a3 c4 ff 10 80       	mov    %eax,0x8010ffc4
          wakeup(&input.r);
801008b2:	e8 f9 35 00 00       	call   80103eb0 <wakeup>
801008b7:	e9 14 ff ff ff       	jmp    801007d0 <consoleintr+0x20>
801008bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
801008c0:	a1 c8 ff 10 80       	mov    0x8010ffc8,%eax
801008c5:	3b 05 c4 ff 10 80    	cmp    0x8010ffc4,%eax
801008cb:	75 2b                	jne    801008f8 <consoleintr+0x148>
801008cd:	e9 fe fe ff ff       	jmp    801007d0 <consoleintr+0x20>
801008d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
801008d8:	a3 c8 ff 10 80       	mov    %eax,0x8010ffc8
        consputc(BACKSPACE);
801008dd:	b8 00 01 00 00       	mov    $0x100,%eax
801008e2:	e8 f9 fa ff ff       	call   801003e0 <consputc>
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
801008e7:	a1 c8 ff 10 80       	mov    0x8010ffc8,%eax
801008ec:	3b 05 c4 ff 10 80    	cmp    0x8010ffc4,%eax
801008f2:	0f 84 d8 fe ff ff    	je     801007d0 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
801008f8:	83 e8 01             	sub    $0x1,%eax
801008fb:	89 c2                	mov    %eax,%edx
801008fd:	83 e2 7f             	and    $0x7f,%edx
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100900:	80 ba 40 ff 10 80 0a 	cmpb   $0xa,-0x7fef00c0(%edx)
80100907:	75 cf                	jne    801008d8 <consoleintr+0x128>
80100909:	e9 c2 fe ff ff       	jmp    801007d0 <consoleintr+0x20>
8010090e:	66 90                	xchg   %ax,%ax
  acquire(&cons.lock);
  while((c = getc()) >= 0){
    switch(c){
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
80100910:	be 01 00 00 00       	mov    $0x1,%esi
80100915:	e9 b6 fe ff ff       	jmp    801007d0 <consoleintr+0x20>
8010091a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  }
  release(&cons.lock);
  if(doprocdump) {
    procdump();  // now call procdump() wo. cons.lock held
  }
}
80100920:	83 c4 1c             	add    $0x1c,%esp
80100923:	5b                   	pop    %ebx
80100924:	5e                   	pop    %esi
80100925:	5f                   	pop    %edi
80100926:	5d                   	pop    %ebp
      break;
    }
  }
  release(&cons.lock);
  if(doprocdump) {
    procdump();  // now call procdump() wo. cons.lock held
80100927:	e9 74 36 00 00       	jmp    80103fa0 <procdump>
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
8010092c:	c6 80 40 ff 10 80 0a 	movb   $0xa,-0x7fef00c0(%eax)
        consputc(c);
80100933:	b8 0a 00 00 00       	mov    $0xa,%eax
80100938:	e8 a3 fa ff ff       	call   801003e0 <consputc>
8010093d:	a1 c8 ff 10 80       	mov    0x8010ffc8,%eax
80100942:	e9 5f ff ff ff       	jmp    801008a6 <consoleintr+0xf6>
80100947:	89 f6                	mov    %esi,%esi
80100949:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100950 <consoleinit>:
  return n;
}

void
consoleinit(void)
{
80100950:	55                   	push   %ebp
80100951:	89 e5                	mov    %esp,%ebp
80100953:	83 ec 18             	sub    $0x18,%esp
  initlock(&cons.lock, "console");
80100956:	c7 44 24 04 30 6e 10 	movl   $0x80106e30,0x4(%esp)
8010095d:	80 
8010095e:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100965:	e8 36 38 00 00       	call   801041a0 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  picenable(IRQ_KBD);
8010096a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
void
consoleinit(void)
{
  initlock(&cons.lock, "console");

  devsw[CONSOLE].write = consolewrite;
80100971:	c7 05 8c 09 11 80 f0 	movl   $0x801005f0,0x8011098c
80100978:	05 10 80 
  devsw[CONSOLE].read = consoleread;
8010097b:	c7 05 88 09 11 80 70 	movl   $0x80100270,0x80110988
80100982:	02 10 80 
  cons.locking = 1;
80100985:	c7 05 54 a5 10 80 01 	movl   $0x1,0x8010a554
8010098c:	00 00 00 

  picenable(IRQ_KBD);
8010098f:	e8 5c 28 00 00       	call   801031f0 <picenable>
  ioapicenable(IRQ_KBD, 0);
80100994:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010099b:	00 
8010099c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801009a3:	e8 f8 18 00 00       	call   801022a0 <ioapicenable>
}
801009a8:	c9                   	leave  
801009a9:	c3                   	ret    
801009aa:	66 90                	xchg   %ax,%ax
801009ac:	66 90                	xchg   %ax,%ax
801009ae:	66 90                	xchg   %ax,%ax

801009b0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
801009b0:	55                   	push   %ebp
801009b1:	89 e5                	mov    %esp,%ebp
801009b3:	57                   	push   %edi
801009b4:	56                   	push   %esi
801009b5:	53                   	push   %ebx
801009b6:	81 ec 1c 01 00 00    	sub    $0x11c,%esp
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;

  begin_op();
801009bc:	e8 bf 21 00 00       	call   80102b80 <begin_op>

  if((ip = namei(path)) == 0){
801009c1:	8b 45 08             	mov    0x8(%ebp),%eax
801009c4:	89 04 24             	mov    %eax,(%esp)
801009c7:	e8 14 15 00 00       	call   80101ee0 <namei>
801009cc:	85 c0                	test   %eax,%eax
801009ce:	89 c3                	mov    %eax,%ebx
801009d0:	74 37                	je     80100a09 <exec+0x59>
    end_op();
    return -1;
  }
  ilock(ip);
801009d2:	89 04 24             	mov    %eax,(%esp)
801009d5:	e8 d6 0c 00 00       	call   801016b0 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
801009da:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
801009e0:	c7 44 24 0c 34 00 00 	movl   $0x34,0xc(%esp)
801009e7:	00 
801009e8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801009ef:	00 
801009f0:	89 44 24 04          	mov    %eax,0x4(%esp)
801009f4:	89 1c 24             	mov    %ebx,(%esp)
801009f7:	e8 44 0f 00 00       	call   80101940 <readi>
801009fc:	83 f8 34             	cmp    $0x34,%eax
801009ff:	74 1f                	je     80100a20 <exec+0x70>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100a01:	89 1c 24             	mov    %ebx,(%esp)
80100a04:	e8 e7 0e 00 00       	call   801018f0 <iunlockput>
    end_op();
80100a09:	e8 e2 21 00 00       	call   80102bf0 <end_op>
  }
  return -1;
80100a0e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100a13:	81 c4 1c 01 00 00    	add    $0x11c,%esp
80100a19:	5b                   	pop    %ebx
80100a1a:	5e                   	pop    %esi
80100a1b:	5f                   	pop    %edi
80100a1c:	5d                   	pop    %ebp
80100a1d:	c3                   	ret    
80100a1e:	66 90                	xchg   %ax,%ax
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100a20:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a27:	45 4c 46 
80100a2a:	75 d5                	jne    80100a01 <exec+0x51>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100a2c:	e8 3f 5d 00 00       	call   80106770 <setupkvm>
80100a31:	85 c0                	test   %eax,%eax
80100a33:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100a39:	74 c6                	je     80100a01 <exec+0x51>
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100a3b:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100a42:	00 
80100a43:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi

  if((pgdir = setupkvm()) == 0)
    goto bad;

  // Load program into memory.
  sz = 0;
80100a49:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100a50:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100a53:	0f 84 da 00 00 00    	je     80100b33 <exec+0x183>
80100a59:	31 ff                	xor    %edi,%edi
80100a5b:	eb 18                	jmp    80100a75 <exec+0xc5>
80100a5d:	8d 76 00             	lea    0x0(%esi),%esi
80100a60:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100a67:	83 c7 01             	add    $0x1,%edi
80100a6a:	83 c6 20             	add    $0x20,%esi
80100a6d:	39 f8                	cmp    %edi,%eax
80100a6f:	0f 8e be 00 00 00    	jle    80100b33 <exec+0x183>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100a75:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100a7b:	c7 44 24 0c 20 00 00 	movl   $0x20,0xc(%esp)
80100a82:	00 
80100a83:	89 74 24 08          	mov    %esi,0x8(%esp)
80100a87:	89 44 24 04          	mov    %eax,0x4(%esp)
80100a8b:	89 1c 24             	mov    %ebx,(%esp)
80100a8e:	e8 ad 0e 00 00       	call   80101940 <readi>
80100a93:	83 f8 20             	cmp    $0x20,%eax
80100a96:	0f 85 84 00 00 00    	jne    80100b20 <exec+0x170>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100a9c:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100aa3:	75 bb                	jne    80100a60 <exec+0xb0>
      continue;
    if(ph.memsz < ph.filesz)
80100aa5:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100aab:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100ab1:	72 6d                	jb     80100b20 <exec+0x170>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100ab3:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100ab9:	72 65                	jb     80100b20 <exec+0x170>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100abb:	89 44 24 08          	mov    %eax,0x8(%esp)
80100abf:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100ac5:	89 44 24 04          	mov    %eax,0x4(%esp)
80100ac9:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100acf:	89 04 24             	mov    %eax,(%esp)
80100ad2:	e8 69 5f 00 00       	call   80106a40 <allocuvm>
80100ad7:	85 c0                	test   %eax,%eax
80100ad9:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100adf:	74 3f                	je     80100b20 <exec+0x170>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
80100ae1:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100ae7:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100aec:	75 32                	jne    80100b20 <exec+0x170>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100aee:	8b 95 14 ff ff ff    	mov    -0xec(%ebp),%edx
80100af4:	89 44 24 04          	mov    %eax,0x4(%esp)
80100af8:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100afe:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80100b02:	89 54 24 10          	mov    %edx,0x10(%esp)
80100b06:	8b 95 08 ff ff ff    	mov    -0xf8(%ebp),%edx
80100b0c:	89 04 24             	mov    %eax,(%esp)
80100b0f:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100b13:	e8 68 5e 00 00       	call   80106980 <loaduvm>
80100b18:	85 c0                	test   %eax,%eax
80100b1a:	0f 89 40 ff ff ff    	jns    80100a60 <exec+0xb0>
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100b20:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100b26:	89 04 24             	mov    %eax,(%esp)
80100b29:	e8 22 60 00 00       	call   80106b50 <freevm>
80100b2e:	e9 ce fe ff ff       	jmp    80100a01 <exec+0x51>
    if(ph.vaddr % PGSIZE != 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100b33:	89 1c 24             	mov    %ebx,(%esp)
80100b36:	e8 b5 0d 00 00       	call   801018f0 <iunlockput>
80100b3b:	90                   	nop
80100b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  end_op();
80100b40:	e8 ab 20 00 00       	call   80102bf0 <end_op>
  ip = 0;

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100b45:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100b4b:	05 ff 0f 00 00       	add    $0xfff,%eax
80100b50:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b55:	8d 90 00 20 00 00    	lea    0x2000(%eax),%edx
80100b5b:	89 44 24 04          	mov    %eax,0x4(%esp)
80100b5f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100b65:	89 54 24 08          	mov    %edx,0x8(%esp)
80100b69:	89 04 24             	mov    %eax,(%esp)
80100b6c:	e8 cf 5e 00 00       	call   80106a40 <allocuvm>
80100b71:	85 c0                	test   %eax,%eax
80100b73:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100b79:	75 18                	jne    80100b93 <exec+0x1e3>
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100b7b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100b81:	89 04 24             	mov    %eax,(%esp)
80100b84:	e8 c7 5f 00 00       	call   80106b50 <freevm>
  if(ip){
    iunlockput(ip);
    end_op();
  }
  return -1;
80100b89:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100b8e:	e9 80 fe ff ff       	jmp    80100a13 <exec+0x63>
  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100b93:	8b 9d ec fe ff ff    	mov    -0x114(%ebp),%ebx
80100b99:	89 d8                	mov    %ebx,%eax
80100b9b:	2d 00 20 00 00       	sub    $0x2000,%eax
80100ba0:	89 44 24 04          	mov    %eax,0x4(%esp)
80100ba4:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100baa:	89 04 24             	mov    %eax,(%esp)
80100bad:	e8 1e 60 00 00       	call   80106bd0 <clearpteu>
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100bb2:	8b 45 0c             	mov    0xc(%ebp),%eax
80100bb5:	8b 00                	mov    (%eax),%eax
80100bb7:	85 c0                	test   %eax,%eax
80100bb9:	0f 84 66 01 00 00    	je     80100d25 <exec+0x375>
80100bbf:	8b 7d 0c             	mov    0xc(%ebp),%edi
80100bc2:	31 f6                	xor    %esi,%esi
80100bc4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80100bc7:	89 f2                	mov    %esi,%edx
80100bc9:	89 fe                	mov    %edi,%esi
80100bcb:	89 d7                	mov    %edx,%edi
80100bcd:	83 c1 04             	add    $0x4,%ecx
80100bd0:	eb 0e                	jmp    80100be0 <exec+0x230>
80100bd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100bd8:	83 c1 04             	add    $0x4,%ecx
    if(argc >= MAXARG)
80100bdb:	83 ff 20             	cmp    $0x20,%edi
80100bde:	74 9b                	je     80100b7b <exec+0x1cb>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100be0:	89 04 24             	mov    %eax,(%esp)
80100be3:	89 8d f0 fe ff ff    	mov    %ecx,-0x110(%ebp)
80100be9:	e8 d2 39 00 00       	call   801045c0 <strlen>
80100bee:	f7 d0                	not    %eax
80100bf0:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100bf2:	8b 06                	mov    (%esi),%eax

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100bf4:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100bf7:	89 04 24             	mov    %eax,(%esp)
80100bfa:	e8 c1 39 00 00       	call   801045c0 <strlen>
80100bff:	83 c0 01             	add    $0x1,%eax
80100c02:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100c06:	8b 06                	mov    (%esi),%eax
80100c08:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80100c0c:	89 44 24 08          	mov    %eax,0x8(%esp)
80100c10:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100c16:	89 04 24             	mov    %eax,(%esp)
80100c19:	e8 12 61 00 00       	call   80106d30 <copyout>
80100c1e:	85 c0                	test   %eax,%eax
80100c20:	0f 88 55 ff ff ff    	js     80100b7b <exec+0x1cb>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100c26:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
80100c2c:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c32:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100c39:	83 c7 01             	add    $0x1,%edi
80100c3c:	8b 01                	mov    (%ecx),%eax
80100c3e:	89 ce                	mov    %ecx,%esi
80100c40:	85 c0                	test   %eax,%eax
80100c42:	75 94                	jne    80100bd8 <exec+0x228>
80100c44:	89 fe                	mov    %edi,%esi
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c46:	8d 04 b5 04 00 00 00 	lea    0x4(,%esi,4),%eax
80100c4d:	89 d9                	mov    %ebx,%ecx
80100c4f:	29 c1                	sub    %eax,%ecx

  sp -= (3+argc+1) * 4;
80100c51:	83 c0 0c             	add    $0xc,%eax
80100c54:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100c56:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100c5a:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100c60:	89 54 24 08          	mov    %edx,0x8(%esp)
80100c64:	89 5c 24 04          	mov    %ebx,0x4(%esp)
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100c68:	c7 84 b5 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%esi,4)
80100c6f:	00 00 00 00 
  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100c73:	89 04 24             	mov    %eax,(%esp)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
80100c76:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100c7d:	ff ff ff 
  ustack[1] = argc;
80100c80:	89 b5 5c ff ff ff    	mov    %esi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c86:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100c8c:	e8 9f 60 00 00       	call   80106d30 <copyout>
80100c91:	85 c0                	test   %eax,%eax
80100c93:	0f 88 e2 fe ff ff    	js     80100b7b <exec+0x1cb>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100c99:	8b 45 08             	mov    0x8(%ebp),%eax
80100c9c:	0f b6 10             	movzbl (%eax),%edx
80100c9f:	84 d2                	test   %dl,%dl
80100ca1:	74 19                	je     80100cbc <exec+0x30c>
80100ca3:	8b 4d 08             	mov    0x8(%ebp),%ecx
80100ca6:	83 c0 01             	add    $0x1,%eax
    if(*s == '/')
      last = s+1;
80100ca9:	80 fa 2f             	cmp    $0x2f,%dl
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100cac:	0f b6 10             	movzbl (%eax),%edx
    if(*s == '/')
      last = s+1;
80100caf:	0f 44 c8             	cmove  %eax,%ecx
80100cb2:	83 c0 01             	add    $0x1,%eax
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100cb5:	84 d2                	test   %dl,%dl
80100cb7:	75 f0                	jne    80100ca9 <exec+0x2f9>
80100cb9:	89 4d 08             	mov    %ecx,0x8(%ebp)
    if(*s == '/')
      last = s+1;
  safestrcpy(proc->name, last, sizeof(proc->name));
80100cbc:	8b 45 08             	mov    0x8(%ebp),%eax
80100cbf:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80100cc6:	00 
80100cc7:	89 44 24 04          	mov    %eax,0x4(%esp)
80100ccb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100cd1:	83 c0 6c             	add    $0x6c,%eax
80100cd4:	89 04 24             	mov    %eax,(%esp)
80100cd7:	e8 a4 38 00 00       	call   80104580 <safestrcpy>

  // Commit to the user image.
  oldpgdir = proc->pgdir;
80100cdc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  proc->pgdir = pgdir;
80100ce2:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
    if(*s == '/')
      last = s+1;
  safestrcpy(proc->name, last, sizeof(proc->name));

  // Commit to the user image.
  oldpgdir = proc->pgdir;
80100ce8:	8b 70 04             	mov    0x4(%eax),%esi
  proc->pgdir = pgdir;
80100ceb:	89 48 04             	mov    %ecx,0x4(%eax)
  proc->sz = sz;
80100cee:	8b 8d ec fe ff ff    	mov    -0x114(%ebp),%ecx
80100cf4:	89 08                	mov    %ecx,(%eax)
  proc->tf->eip = elf.entry;  // main
80100cf6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100cfc:	8b 8d 3c ff ff ff    	mov    -0xc4(%ebp),%ecx
80100d02:	8b 50 18             	mov    0x18(%eax),%edx
80100d05:	89 4a 38             	mov    %ecx,0x38(%edx)
  proc->tf->esp = sp;
80100d08:	8b 50 18             	mov    0x18(%eax),%edx
80100d0b:	89 5a 44             	mov    %ebx,0x44(%edx)
  switchuvm(proc);
80100d0e:	89 04 24             	mov    %eax,(%esp)
80100d11:	e8 1a 5b 00 00       	call   80106830 <switchuvm>
  freevm(oldpgdir);
80100d16:	89 34 24             	mov    %esi,(%esp)
80100d19:	e8 32 5e 00 00       	call   80106b50 <freevm>
  return 0;
80100d1e:	31 c0                	xor    %eax,%eax
80100d20:	e9 ee fc ff ff       	jmp    80100a13 <exec+0x63>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100d25:	8b 9d ec fe ff ff    	mov    -0x114(%ebp),%ebx
80100d2b:	31 f6                	xor    %esi,%esi
80100d2d:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100d33:	e9 0e ff ff ff       	jmp    80100c46 <exec+0x296>
80100d38:	66 90                	xchg   %ax,%ax
80100d3a:	66 90                	xchg   %ax,%ax
80100d3c:	66 90                	xchg   %ax,%ax
80100d3e:	66 90                	xchg   %ax,%ax

80100d40 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100d40:	55                   	push   %ebp
80100d41:	89 e5                	mov    %esp,%ebp
80100d43:	83 ec 18             	sub    $0x18,%esp
  initlock(&ftable.lock, "ftable");
80100d46:	c7 44 24 04 49 6e 10 	movl   $0x80106e49,0x4(%esp)
80100d4d:	80 
80100d4e:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
80100d55:	e8 46 34 00 00       	call   801041a0 <initlock>
}
80100d5a:	c9                   	leave  
80100d5b:	c3                   	ret    
80100d5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100d60 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d60:	55                   	push   %ebp
80100d61:	89 e5                	mov    %esp,%ebp
80100d63:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d64:	bb 14 00 11 80       	mov    $0x80110014,%ebx
}

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d69:	83 ec 14             	sub    $0x14,%esp
  struct file *f;

  acquire(&ftable.lock);
80100d6c:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
80100d73:	e8 a8 34 00 00       	call   80104220 <acquire>
80100d78:	eb 11                	jmp    80100d8b <filealloc+0x2b>
80100d7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d80:	83 c3 18             	add    $0x18,%ebx
80100d83:	81 fb 74 09 11 80    	cmp    $0x80110974,%ebx
80100d89:	74 25                	je     80100db0 <filealloc+0x50>
    if(f->ref == 0){
80100d8b:	8b 43 04             	mov    0x4(%ebx),%eax
80100d8e:	85 c0                	test   %eax,%eax
80100d90:	75 ee                	jne    80100d80 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100d92:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    if(f->ref == 0){
      f->ref = 1;
80100d99:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100da0:	e8 ab 35 00 00       	call   80104350 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100da5:	83 c4 14             	add    $0x14,%esp
  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    if(f->ref == 0){
      f->ref = 1;
      release(&ftable.lock);
      return f;
80100da8:	89 d8                	mov    %ebx,%eax
    }
  }
  release(&ftable.lock);
  return 0;
}
80100daa:	5b                   	pop    %ebx
80100dab:	5d                   	pop    %ebp
80100dac:	c3                   	ret    
80100dad:	8d 76 00             	lea    0x0(%esi),%esi
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80100db0:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
80100db7:	e8 94 35 00 00       	call   80104350 <release>
  return 0;
}
80100dbc:	83 c4 14             	add    $0x14,%esp
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
80100dbf:	31 c0                	xor    %eax,%eax
}
80100dc1:	5b                   	pop    %ebx
80100dc2:	5d                   	pop    %ebp
80100dc3:	c3                   	ret    
80100dc4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100dca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80100dd0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100dd0:	55                   	push   %ebp
80100dd1:	89 e5                	mov    %esp,%ebp
80100dd3:	53                   	push   %ebx
80100dd4:	83 ec 14             	sub    $0x14,%esp
80100dd7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100dda:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
80100de1:	e8 3a 34 00 00       	call   80104220 <acquire>
  if(f->ref < 1)
80100de6:	8b 43 04             	mov    0x4(%ebx),%eax
80100de9:	85 c0                	test   %eax,%eax
80100deb:	7e 1a                	jle    80100e07 <filedup+0x37>
    panic("filedup");
  f->ref++;
80100ded:	83 c0 01             	add    $0x1,%eax
80100df0:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100df3:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
80100dfa:	e8 51 35 00 00       	call   80104350 <release>
  return f;
}
80100dff:	83 c4 14             	add    $0x14,%esp
80100e02:	89 d8                	mov    %ebx,%eax
80100e04:	5b                   	pop    %ebx
80100e05:	5d                   	pop    %ebp
80100e06:	c3                   	ret    
struct file*
filedup(struct file *f)
{
  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("filedup");
80100e07:	c7 04 24 50 6e 10 80 	movl   $0x80106e50,(%esp)
80100e0e:	e8 4d f5 ff ff       	call   80100360 <panic>
80100e13:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100e19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100e20 <fileclose>:
}

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100e20:	55                   	push   %ebp
80100e21:	89 e5                	mov    %esp,%ebp
80100e23:	57                   	push   %edi
80100e24:	56                   	push   %esi
80100e25:	53                   	push   %ebx
80100e26:	83 ec 1c             	sub    $0x1c,%esp
80100e29:	8b 7d 08             	mov    0x8(%ebp),%edi
  struct file ff;

  acquire(&ftable.lock);
80100e2c:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
80100e33:	e8 e8 33 00 00       	call   80104220 <acquire>
  if(f->ref < 1)
80100e38:	8b 57 04             	mov    0x4(%edi),%edx
80100e3b:	85 d2                	test   %edx,%edx
80100e3d:	0f 8e 89 00 00 00    	jle    80100ecc <fileclose+0xac>
    panic("fileclose");
  if(--f->ref > 0){
80100e43:	83 ea 01             	sub    $0x1,%edx
80100e46:	85 d2                	test   %edx,%edx
80100e48:	89 57 04             	mov    %edx,0x4(%edi)
80100e4b:	74 13                	je     80100e60 <fileclose+0x40>
    release(&ftable.lock);
80100e4d:	c7 45 08 e0 ff 10 80 	movl   $0x8010ffe0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100e54:	83 c4 1c             	add    $0x1c,%esp
80100e57:	5b                   	pop    %ebx
80100e58:	5e                   	pop    %esi
80100e59:	5f                   	pop    %edi
80100e5a:	5d                   	pop    %ebp

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
80100e5b:	e9 f0 34 00 00       	jmp    80104350 <release>
    return;
  }
  ff = *f;
80100e60:	0f b6 47 09          	movzbl 0x9(%edi),%eax
80100e64:	8b 37                	mov    (%edi),%esi
80100e66:	8b 5f 0c             	mov    0xc(%edi),%ebx
  f->ref = 0;
  f->type = FD_NONE;
80100e69:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100e6f:	88 45 e7             	mov    %al,-0x19(%ebp)
80100e72:	8b 47 10             	mov    0x10(%edi),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100e75:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100e7c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100e7f:	e8 cc 34 00 00       	call   80104350 <release>

  if(ff.type == FD_PIPE)
80100e84:	83 fe 01             	cmp    $0x1,%esi
80100e87:	74 0f                	je     80100e98 <fileclose+0x78>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100e89:	83 fe 02             	cmp    $0x2,%esi
80100e8c:	74 22                	je     80100eb0 <fileclose+0x90>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100e8e:	83 c4 1c             	add    $0x1c,%esp
80100e91:	5b                   	pop    %ebx
80100e92:	5e                   	pop    %esi
80100e93:	5f                   	pop    %edi
80100e94:	5d                   	pop    %ebp
80100e95:	c3                   	ret    
80100e96:	66 90                	xchg   %ax,%ax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);

  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
80100e98:	0f be 75 e7          	movsbl -0x19(%ebp),%esi
80100e9c:	89 1c 24             	mov    %ebx,(%esp)
80100e9f:	89 74 24 04          	mov    %esi,0x4(%esp)
80100ea3:	e8 f8 24 00 00       	call   801033a0 <pipeclose>
80100ea8:	eb e4                	jmp    80100e8e <fileclose+0x6e>
80100eaa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  else if(ff.type == FD_INODE){
    begin_op();
80100eb0:	e8 cb 1c 00 00       	call   80102b80 <begin_op>
    iput(ff.ip);
80100eb5:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100eb8:	89 04 24             	mov    %eax,(%esp)
80100ebb:	e8 00 09 00 00       	call   801017c0 <iput>
    end_op();
  }
}
80100ec0:	83 c4 1c             	add    $0x1c,%esp
80100ec3:	5b                   	pop    %ebx
80100ec4:	5e                   	pop    %esi
80100ec5:	5f                   	pop    %edi
80100ec6:	5d                   	pop    %ebp
  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
80100ec7:	e9 24 1d 00 00       	jmp    80102bf0 <end_op>
{
  struct file ff;

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
80100ecc:	c7 04 24 58 6e 10 80 	movl   $0x80106e58,(%esp)
80100ed3:	e8 88 f4 ff ff       	call   80100360 <panic>
80100ed8:	90                   	nop
80100ed9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100ee0 <filestat>:
}

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100ee0:	55                   	push   %ebp
80100ee1:	89 e5                	mov    %esp,%ebp
80100ee3:	53                   	push   %ebx
80100ee4:	83 ec 14             	sub    $0x14,%esp
80100ee7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100eea:	83 3b 02             	cmpl   $0x2,(%ebx)
80100eed:	75 31                	jne    80100f20 <filestat+0x40>
    ilock(f->ip);
80100eef:	8b 43 10             	mov    0x10(%ebx),%eax
80100ef2:	89 04 24             	mov    %eax,(%esp)
80100ef5:	e8 b6 07 00 00       	call   801016b0 <ilock>
    stati(f->ip, st);
80100efa:	8b 45 0c             	mov    0xc(%ebp),%eax
80100efd:	89 44 24 04          	mov    %eax,0x4(%esp)
80100f01:	8b 43 10             	mov    0x10(%ebx),%eax
80100f04:	89 04 24             	mov    %eax,(%esp)
80100f07:	e8 04 0a 00 00       	call   80101910 <stati>
    iunlock(f->ip);
80100f0c:	8b 43 10             	mov    0x10(%ebx),%eax
80100f0f:	89 04 24             	mov    %eax,(%esp)
80100f12:	e8 69 08 00 00       	call   80101780 <iunlock>
    return 0;
  }
  return -1;
}
80100f17:	83 c4 14             	add    $0x14,%esp
{
  if(f->type == FD_INODE){
    ilock(f->ip);
    stati(f->ip, st);
    iunlock(f->ip);
    return 0;
80100f1a:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80100f1c:	5b                   	pop    %ebx
80100f1d:	5d                   	pop    %ebp
80100f1e:	c3                   	ret    
80100f1f:	90                   	nop
80100f20:	83 c4 14             	add    $0x14,%esp
    ilock(f->ip);
    stati(f->ip, st);
    iunlock(f->ip);
    return 0;
  }
  return -1;
80100f23:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100f28:	5b                   	pop    %ebx
80100f29:	5d                   	pop    %ebp
80100f2a:	c3                   	ret    
80100f2b:	90                   	nop
80100f2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f30 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100f30:	55                   	push   %ebp
80100f31:	89 e5                	mov    %esp,%ebp
80100f33:	57                   	push   %edi
80100f34:	56                   	push   %esi
80100f35:	53                   	push   %ebx
80100f36:	83 ec 1c             	sub    $0x1c,%esp
80100f39:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f3c:	8b 75 0c             	mov    0xc(%ebp),%esi
80100f3f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100f42:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100f46:	74 68                	je     80100fb0 <fileread+0x80>
    return -1;
  if(f->type == FD_PIPE)
80100f48:	8b 03                	mov    (%ebx),%eax
80100f4a:	83 f8 01             	cmp    $0x1,%eax
80100f4d:	74 49                	je     80100f98 <fileread+0x68>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100f4f:	83 f8 02             	cmp    $0x2,%eax
80100f52:	75 63                	jne    80100fb7 <fileread+0x87>
    ilock(f->ip);
80100f54:	8b 43 10             	mov    0x10(%ebx),%eax
80100f57:	89 04 24             	mov    %eax,(%esp)
80100f5a:	e8 51 07 00 00       	call   801016b0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f5f:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80100f63:	8b 43 14             	mov    0x14(%ebx),%eax
80100f66:	89 74 24 04          	mov    %esi,0x4(%esp)
80100f6a:	89 44 24 08          	mov    %eax,0x8(%esp)
80100f6e:	8b 43 10             	mov    0x10(%ebx),%eax
80100f71:	89 04 24             	mov    %eax,(%esp)
80100f74:	e8 c7 09 00 00       	call   80101940 <readi>
80100f79:	85 c0                	test   %eax,%eax
80100f7b:	89 c6                	mov    %eax,%esi
80100f7d:	7e 03                	jle    80100f82 <fileread+0x52>
      f->off += r;
80100f7f:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100f82:	8b 43 10             	mov    0x10(%ebx),%eax
80100f85:	89 04 24             	mov    %eax,(%esp)
80100f88:	e8 f3 07 00 00       	call   80101780 <iunlock>
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
    ilock(f->ip);
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f8d:	89 f0                	mov    %esi,%eax
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
80100f8f:	83 c4 1c             	add    $0x1c,%esp
80100f92:	5b                   	pop    %ebx
80100f93:	5e                   	pop    %esi
80100f94:	5f                   	pop    %edi
80100f95:	5d                   	pop    %ebp
80100f96:	c3                   	ret    
80100f97:	90                   	nop
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
80100f98:	8b 43 0c             	mov    0xc(%ebx),%eax
80100f9b:	89 45 08             	mov    %eax,0x8(%ebp)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
80100f9e:	83 c4 1c             	add    $0x1c,%esp
80100fa1:	5b                   	pop    %ebx
80100fa2:	5e                   	pop    %esi
80100fa3:	5f                   	pop    %edi
80100fa4:	5d                   	pop    %ebp
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
80100fa5:	e9 a6 25 00 00       	jmp    80103550 <piperead>
80100faa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
fileread(struct file *f, char *addr, int n)
{
  int r;

  if(f->readable == 0)
    return -1;
80100fb0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100fb5:	eb d8                	jmp    80100f8f <fileread+0x5f>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
80100fb7:	c7 04 24 62 6e 10 80 	movl   $0x80106e62,(%esp)
80100fbe:	e8 9d f3 ff ff       	call   80100360 <panic>
80100fc3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100fc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100fd0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100fd0:	55                   	push   %ebp
80100fd1:	89 e5                	mov    %esp,%ebp
80100fd3:	57                   	push   %edi
80100fd4:	56                   	push   %esi
80100fd5:	53                   	push   %ebx
80100fd6:	83 ec 2c             	sub    $0x2c,%esp
80100fd9:	8b 45 0c             	mov    0xc(%ebp),%eax
80100fdc:	8b 7d 08             	mov    0x8(%ebp),%edi
80100fdf:	89 45 dc             	mov    %eax,-0x24(%ebp)
80100fe2:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
80100fe5:	80 7f 09 00          	cmpb   $0x0,0x9(%edi)

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100fe9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int r;

  if(f->writable == 0)
80100fec:	0f 84 ae 00 00 00    	je     801010a0 <filewrite+0xd0>
    return -1;
  if(f->type == FD_PIPE)
80100ff2:	8b 07                	mov    (%edi),%eax
80100ff4:	83 f8 01             	cmp    $0x1,%eax
80100ff7:	0f 84 c2 00 00 00    	je     801010bf <filewrite+0xef>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100ffd:	83 f8 02             	cmp    $0x2,%eax
80101000:	0f 85 d7 00 00 00    	jne    801010dd <filewrite+0x10d>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101006:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101009:	31 db                	xor    %ebx,%ebx
8010100b:	85 c0                	test   %eax,%eax
8010100d:	7f 31                	jg     80101040 <filewrite+0x70>
8010100f:	e9 9c 00 00 00       	jmp    801010b0 <filewrite+0xe0>
80101014:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
      iunlock(f->ip);
80101018:	8b 4f 10             	mov    0x10(%edi),%ecx
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
8010101b:	01 47 14             	add    %eax,0x14(%edi)
8010101e:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101021:	89 0c 24             	mov    %ecx,(%esp)
80101024:	e8 57 07 00 00       	call   80101780 <iunlock>
      end_op();
80101029:	e8 c2 1b 00 00       	call   80102bf0 <end_op>
8010102e:	8b 45 e0             	mov    -0x20(%ebp),%eax

      if(r < 0)
        break;
      if(r != n1)
80101031:	39 f0                	cmp    %esi,%eax
80101033:	0f 85 98 00 00 00    	jne    801010d1 <filewrite+0x101>
        panic("short filewrite");
      i += r;
80101039:	01 c3                	add    %eax,%ebx
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
8010103b:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
8010103e:	7e 70                	jle    801010b0 <filewrite+0xe0>
      int n1 = n - i;
80101040:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101043:	b8 00 1a 00 00       	mov    $0x1a00,%eax
80101048:	29 de                	sub    %ebx,%esi
8010104a:	81 fe 00 1a 00 00    	cmp    $0x1a00,%esi
80101050:	0f 4f f0             	cmovg  %eax,%esi
      if(n1 > max)
        n1 = max;

      begin_op();
80101053:	e8 28 1b 00 00       	call   80102b80 <begin_op>
      ilock(f->ip);
80101058:	8b 47 10             	mov    0x10(%edi),%eax
8010105b:	89 04 24             	mov    %eax,(%esp)
8010105e:	e8 4d 06 00 00       	call   801016b0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101063:	89 74 24 0c          	mov    %esi,0xc(%esp)
80101067:	8b 47 14             	mov    0x14(%edi),%eax
8010106a:	89 44 24 08          	mov    %eax,0x8(%esp)
8010106e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101071:	01 d8                	add    %ebx,%eax
80101073:	89 44 24 04          	mov    %eax,0x4(%esp)
80101077:	8b 47 10             	mov    0x10(%edi),%eax
8010107a:	89 04 24             	mov    %eax,(%esp)
8010107d:	e8 be 09 00 00       	call   80101a40 <writei>
80101082:	85 c0                	test   %eax,%eax
80101084:	7f 92                	jg     80101018 <filewrite+0x48>
        f->off += r;
      iunlock(f->ip);
80101086:	8b 4f 10             	mov    0x10(%edi),%ecx
80101089:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010108c:	89 0c 24             	mov    %ecx,(%esp)
8010108f:	e8 ec 06 00 00       	call   80101780 <iunlock>
      end_op();
80101094:	e8 57 1b 00 00       	call   80102bf0 <end_op>

      if(r < 0)
80101099:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010109c:	85 c0                	test   %eax,%eax
8010109e:	74 91                	je     80101031 <filewrite+0x61>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010a0:	83 c4 2c             	add    $0x2c,%esp
filewrite(struct file *f, char *addr, int n)
{
  int r;

  if(f->writable == 0)
    return -1;
801010a3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010a8:	5b                   	pop    %ebx
801010a9:	5e                   	pop    %esi
801010aa:	5f                   	pop    %edi
801010ab:	5d                   	pop    %ebp
801010ac:	c3                   	ret    
801010ad:	8d 76 00             	lea    0x0(%esi),%esi
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
801010b0:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
801010b3:	89 d8                	mov    %ebx,%eax
801010b5:	75 e9                	jne    801010a0 <filewrite+0xd0>
  }
  panic("filewrite");
}
801010b7:	83 c4 2c             	add    $0x2c,%esp
801010ba:	5b                   	pop    %ebx
801010bb:	5e                   	pop    %esi
801010bc:	5f                   	pop    %edi
801010bd:	5d                   	pop    %ebp
801010be:	c3                   	ret    
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
801010bf:	8b 47 0c             	mov    0xc(%edi),%eax
801010c2:	89 45 08             	mov    %eax,0x8(%ebp)
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010c5:	83 c4 2c             	add    $0x2c,%esp
801010c8:	5b                   	pop    %ebx
801010c9:	5e                   	pop    %esi
801010ca:	5f                   	pop    %edi
801010cb:	5d                   	pop    %ebp
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
801010cc:	e9 5f 23 00 00       	jmp    80103430 <pipewrite>
      end_op();

      if(r < 0)
        break;
      if(r != n1)
        panic("short filewrite");
801010d1:	c7 04 24 6b 6e 10 80 	movl   $0x80106e6b,(%esp)
801010d8:	e8 83 f2 ff ff       	call   80100360 <panic>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
801010dd:	c7 04 24 71 6e 10 80 	movl   $0x80106e71,(%esp)
801010e4:	e8 77 f2 ff ff       	call   80100360 <panic>
801010e9:	66 90                	xchg   %ax,%ax
801010eb:	66 90                	xchg   %ax,%ax
801010ed:	66 90                	xchg   %ax,%ax
801010ef:	90                   	nop

801010f0 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801010f0:	55                   	push   %ebp
801010f1:	89 e5                	mov    %esp,%ebp
801010f3:	57                   	push   %edi
801010f4:	56                   	push   %esi
801010f5:	53                   	push   %ebx
801010f6:	83 ec 2c             	sub    $0x2c,%esp
801010f9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
801010fc:	a1 e0 09 11 80       	mov    0x801109e0,%eax
80101101:	85 c0                	test   %eax,%eax
80101103:	0f 84 8c 00 00 00    	je     80101195 <balloc+0xa5>
80101109:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101110:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101113:	89 f0                	mov    %esi,%eax
80101115:	c1 f8 0c             	sar    $0xc,%eax
80101118:	03 05 f8 09 11 80    	add    0x801109f8,%eax
8010111e:	89 44 24 04          	mov    %eax,0x4(%esp)
80101122:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101125:	89 04 24             	mov    %eax,(%esp)
80101128:	e8 a3 ef ff ff       	call   801000d0 <bread>
8010112d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101130:	a1 e0 09 11 80       	mov    0x801109e0,%eax
80101135:	89 45 e0             	mov    %eax,-0x20(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101138:	31 c0                	xor    %eax,%eax
8010113a:	eb 33                	jmp    8010116f <balloc+0x7f>
8010113c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101140:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101143:	89 c2                	mov    %eax,%edx

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
80101145:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101147:	c1 fa 03             	sar    $0x3,%edx

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
8010114a:	83 e1 07             	and    $0x7,%ecx
8010114d:	bf 01 00 00 00       	mov    $0x1,%edi
80101152:	d3 e7                	shl    %cl,%edi
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101154:	0f b6 5c 13 5c       	movzbl 0x5c(%ebx,%edx,1),%ebx

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
80101159:	89 f9                	mov    %edi,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010115b:	0f b6 fb             	movzbl %bl,%edi
8010115e:	85 cf                	test   %ecx,%edi
80101160:	74 46                	je     801011a8 <balloc+0xb8>
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101162:	83 c0 01             	add    $0x1,%eax
80101165:	83 c6 01             	add    $0x1,%esi
80101168:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010116d:	74 05                	je     80101174 <balloc+0x84>
8010116f:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80101172:	72 cc                	jb     80101140 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101174:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101177:	89 04 24             	mov    %eax,(%esp)
8010117a:	e8 61 f0 ff ff       	call   801001e0 <brelse>
{
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
8010117f:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101186:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101189:	3b 05 e0 09 11 80    	cmp    0x801109e0,%eax
8010118f:	0f 82 7b ff ff ff    	jb     80101110 <balloc+0x20>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
80101195:	c7 04 24 7b 6e 10 80 	movl   $0x80106e7b,(%esp)
8010119c:	e8 bf f1 ff ff       	call   80100360 <panic>
801011a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
        bp->data[bi/8] |= m;  // Mark block in use.
801011a8:	09 d9                	or     %ebx,%ecx
801011aa:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801011ad:	88 4c 13 5c          	mov    %cl,0x5c(%ebx,%edx,1)
        log_write(bp);
801011b1:	89 1c 24             	mov    %ebx,(%esp)
801011b4:	e8 67 1b 00 00       	call   80102d20 <log_write>
        brelse(bp);
801011b9:	89 1c 24             	mov    %ebx,(%esp)
801011bc:	e8 1f f0 ff ff       	call   801001e0 <brelse>
static void
bzero(int dev, int bno)
{
  struct buf *bp;

  bp = bread(dev, bno);
801011c1:	8b 45 d8             	mov    -0x28(%ebp),%eax
801011c4:	89 74 24 04          	mov    %esi,0x4(%esp)
801011c8:	89 04 24             	mov    %eax,(%esp)
801011cb:	e8 00 ef ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
801011d0:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
801011d7:	00 
801011d8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801011df:	00 
static void
bzero(int dev, int bno)
{
  struct buf *bp;

  bp = bread(dev, bno);
801011e0:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801011e2:	8d 40 5c             	lea    0x5c(%eax),%eax
801011e5:	89 04 24             	mov    %eax,(%esp)
801011e8:	e8 b3 31 00 00       	call   801043a0 <memset>
  log_write(bp);
801011ed:	89 1c 24             	mov    %ebx,(%esp)
801011f0:	e8 2b 1b 00 00       	call   80102d20 <log_write>
  brelse(bp);
801011f5:	89 1c 24             	mov    %ebx,(%esp)
801011f8:	e8 e3 ef ff ff       	call   801001e0 <brelse>
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
}
801011fd:	83 c4 2c             	add    $0x2c,%esp
80101200:	89 f0                	mov    %esi,%eax
80101202:	5b                   	pop    %ebx
80101203:	5e                   	pop    %esi
80101204:	5f                   	pop    %edi
80101205:	5d                   	pop    %ebp
80101206:	c3                   	ret    
80101207:	89 f6                	mov    %esi,%esi
80101209:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101210 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101210:	55                   	push   %ebp
80101211:	89 e5                	mov    %esp,%ebp
80101213:	57                   	push   %edi
80101214:	89 c7                	mov    %eax,%edi
80101216:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101217:	31 f6                	xor    %esi,%esi
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101219:	53                   	push   %ebx

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010121a:	bb 34 0a 11 80       	mov    $0x80110a34,%ebx
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
8010121f:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
80101222:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101229:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  struct inode *ip, *empty;

  acquire(&icache.lock);
8010122c:	e8 ef 2f 00 00       	call   80104220 <acquire>

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101231:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101234:	eb 14                	jmp    8010124a <iget+0x3a>
80101236:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101238:	85 f6                	test   %esi,%esi
8010123a:	74 3c                	je     80101278 <iget+0x68>

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010123c:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101242:	81 fb 54 26 11 80    	cmp    $0x80112654,%ebx
80101248:	74 46                	je     80101290 <iget+0x80>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010124a:	8b 4b 08             	mov    0x8(%ebx),%ecx
8010124d:	85 c9                	test   %ecx,%ecx
8010124f:	7e e7                	jle    80101238 <iget+0x28>
80101251:	39 3b                	cmp    %edi,(%ebx)
80101253:	75 e3                	jne    80101238 <iget+0x28>
80101255:	39 53 04             	cmp    %edx,0x4(%ebx)
80101258:	75 de                	jne    80101238 <iget+0x28>
      ip->ref++;
8010125a:	83 c1 01             	add    $0x1,%ecx
      release(&icache.lock);
      return ip;
8010125d:	89 de                	mov    %ebx,%esi
  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
8010125f:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
80101266:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
80101269:	e8 e2 30 00 00       	call   80104350 <release>
  ip->ref = 1;
  ip->flags = 0;
  release(&icache.lock);

  return ip;
}
8010126e:	83 c4 1c             	add    $0x1c,%esp
80101271:	89 f0                	mov    %esi,%eax
80101273:	5b                   	pop    %ebx
80101274:	5e                   	pop    %esi
80101275:	5f                   	pop    %edi
80101276:	5d                   	pop    %ebp
80101277:	c3                   	ret    
80101278:	85 c9                	test   %ecx,%ecx
8010127a:	0f 44 f3             	cmove  %ebx,%esi

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010127d:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101283:	81 fb 54 26 11 80    	cmp    $0x80112654,%ebx
80101289:	75 bf                	jne    8010124a <iget+0x3a>
8010128b:	90                   	nop
8010128c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101290:	85 f6                	test   %esi,%esi
80101292:	74 29                	je     801012bd <iget+0xad>
    panic("iget: no inodes");

  ip = empty;
  ip->dev = dev;
80101294:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101296:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
80101299:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->flags = 0;
801012a0:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801012a7:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
801012ae:	e8 9d 30 00 00       	call   80104350 <release>

  return ip;
}
801012b3:	83 c4 1c             	add    $0x1c,%esp
801012b6:	89 f0                	mov    %esi,%eax
801012b8:	5b                   	pop    %ebx
801012b9:	5e                   	pop    %esi
801012ba:	5f                   	pop    %edi
801012bb:	5d                   	pop    %ebp
801012bc:	c3                   	ret    
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
    panic("iget: no inodes");
801012bd:	c7 04 24 91 6e 10 80 	movl   $0x80106e91,(%esp)
801012c4:	e8 97 f0 ff ff       	call   80100360 <panic>
801012c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801012d0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801012d0:	55                   	push   %ebp
801012d1:	89 e5                	mov    %esp,%ebp
801012d3:	57                   	push   %edi
801012d4:	56                   	push   %esi
801012d5:	53                   	push   %ebx
801012d6:	89 c3                	mov    %eax,%ebx
801012d8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801012db:	83 fa 0b             	cmp    $0xb,%edx
801012de:	77 18                	ja     801012f8 <bmap+0x28>
801012e0:	8d 34 90             	lea    (%eax,%edx,4),%esi
    if((addr = ip->addrs[bn]) == 0)
801012e3:	8b 46 5c             	mov    0x5c(%esi),%eax
801012e6:	85 c0                	test   %eax,%eax
801012e8:	74 66                	je     80101350 <bmap+0x80>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
801012ea:	83 c4 1c             	add    $0x1c,%esp
801012ed:	5b                   	pop    %ebx
801012ee:	5e                   	pop    %esi
801012ef:	5f                   	pop    %edi
801012f0:	5d                   	pop    %ebp
801012f1:	c3                   	ret    
801012f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
801012f8:	8d 72 f4             	lea    -0xc(%edx),%esi

  if(bn < NINDIRECT){
801012fb:	83 fe 7f             	cmp    $0x7f,%esi
801012fe:	77 77                	ja     80101377 <bmap+0xa7>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101300:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101306:	85 c0                	test   %eax,%eax
80101308:	74 5e                	je     80101368 <bmap+0x98>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010130a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010130e:	8b 03                	mov    (%ebx),%eax
80101310:	89 04 24             	mov    %eax,(%esp)
80101313:	e8 b8 ed ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101318:	8d 54 b0 5c          	lea    0x5c(%eax,%esi,4),%edx

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010131c:	89 c7                	mov    %eax,%edi
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
8010131e:	8b 32                	mov    (%edx),%esi
80101320:	85 f6                	test   %esi,%esi
80101322:	75 19                	jne    8010133d <bmap+0x6d>
      a[bn] = addr = balloc(ip->dev);
80101324:	8b 03                	mov    (%ebx),%eax
80101326:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101329:	e8 c2 fd ff ff       	call   801010f0 <balloc>
8010132e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101331:	89 02                	mov    %eax,(%edx)
80101333:	89 c6                	mov    %eax,%esi
      log_write(bp);
80101335:	89 3c 24             	mov    %edi,(%esp)
80101338:	e8 e3 19 00 00       	call   80102d20 <log_write>
    }
    brelse(bp);
8010133d:	89 3c 24             	mov    %edi,(%esp)
80101340:	e8 9b ee ff ff       	call   801001e0 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
80101345:	83 c4 1c             	add    $0x1c,%esp
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101348:	89 f0                	mov    %esi,%eax
    return addr;
  }

  panic("bmap: out of range");
}
8010134a:	5b                   	pop    %ebx
8010134b:	5e                   	pop    %esi
8010134c:	5f                   	pop    %edi
8010134d:	5d                   	pop    %ebp
8010134e:	c3                   	ret    
8010134f:	90                   	nop
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
80101350:	8b 03                	mov    (%ebx),%eax
80101352:	e8 99 fd ff ff       	call   801010f0 <balloc>
80101357:	89 46 5c             	mov    %eax,0x5c(%esi)
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010135a:	83 c4 1c             	add    $0x1c,%esp
8010135d:	5b                   	pop    %ebx
8010135e:	5e                   	pop    %esi
8010135f:	5f                   	pop    %edi
80101360:	5d                   	pop    %ebp
80101361:	c3                   	ret    
80101362:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  bn -= NDIRECT;

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101368:	8b 03                	mov    (%ebx),%eax
8010136a:	e8 81 fd ff ff       	call   801010f0 <balloc>
8010136f:	89 83 8c 00 00 00    	mov    %eax,0x8c(%ebx)
80101375:	eb 93                	jmp    8010130a <bmap+0x3a>
    }
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
80101377:	c7 04 24 a1 6e 10 80 	movl   $0x80106ea1,(%esp)
8010137e:	e8 dd ef ff ff       	call   80100360 <panic>
80101383:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101389:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101390 <readsb>:
struct superblock sb; 

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
80101390:	55                   	push   %ebp
80101391:	89 e5                	mov    %esp,%ebp
80101393:	56                   	push   %esi
80101394:	53                   	push   %ebx
80101395:	83 ec 10             	sub    $0x10,%esp
  struct buf *bp;

  bp = bread(dev, 1);
80101398:	8b 45 08             	mov    0x8(%ebp),%eax
8010139b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801013a2:	00 
struct superblock sb; 

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
801013a3:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct buf *bp;

  bp = bread(dev, 1);
801013a6:	89 04 24             	mov    %eax,(%esp)
801013a9:	e8 22 ed ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
801013ae:	89 34 24             	mov    %esi,(%esp)
801013b1:	c7 44 24 08 1c 00 00 	movl   $0x1c,0x8(%esp)
801013b8:	00 
void
readsb(int dev, struct superblock *sb)
{
  struct buf *bp;

  bp = bread(dev, 1);
801013b9:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801013bb:	8d 40 5c             	lea    0x5c(%eax),%eax
801013be:	89 44 24 04          	mov    %eax,0x4(%esp)
801013c2:	e8 79 30 00 00       	call   80104440 <memmove>
  brelse(bp);
801013c7:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801013ca:	83 c4 10             	add    $0x10,%esp
801013cd:	5b                   	pop    %ebx
801013ce:	5e                   	pop    %esi
801013cf:	5d                   	pop    %ebp
{
  struct buf *bp;

  bp = bread(dev, 1);
  memmove(sb, bp->data, sizeof(*sb));
  brelse(bp);
801013d0:	e9 0b ee ff ff       	jmp    801001e0 <brelse>
801013d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801013d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801013e0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801013e0:	55                   	push   %ebp
801013e1:	89 e5                	mov    %esp,%ebp
801013e3:	57                   	push   %edi
801013e4:	89 d7                	mov    %edx,%edi
801013e6:	56                   	push   %esi
801013e7:	53                   	push   %ebx
801013e8:	89 c3                	mov    %eax,%ebx
801013ea:	83 ec 1c             	sub    $0x1c,%esp
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
801013ed:	89 04 24             	mov    %eax,(%esp)
801013f0:	c7 44 24 04 e0 09 11 	movl   $0x801109e0,0x4(%esp)
801013f7:	80 
801013f8:	e8 93 ff ff ff       	call   80101390 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
801013fd:	89 fa                	mov    %edi,%edx
801013ff:	c1 ea 0c             	shr    $0xc,%edx
80101402:	03 15 f8 09 11 80    	add    0x801109f8,%edx
80101408:	89 1c 24             	mov    %ebx,(%esp)
  bi = b % BPB;
  m = 1 << (bi % 8);
8010140b:	bb 01 00 00 00       	mov    $0x1,%ebx
{
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
80101410:	89 54 24 04          	mov    %edx,0x4(%esp)
80101414:	e8 b7 ec ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
80101419:	89 f9                	mov    %edi,%ecx
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
8010141b:	81 e7 ff 0f 00 00    	and    $0xfff,%edi
80101421:	89 fa                	mov    %edi,%edx
  m = 1 << (bi % 8);
80101423:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
80101426:	c1 fa 03             	sar    $0x3,%edx
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
80101429:	d3 e3                	shl    %cl,%ebx
{
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
8010142b:	89 c6                	mov    %eax,%esi
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
8010142d:	0f b6 44 10 5c       	movzbl 0x5c(%eax,%edx,1),%eax
80101432:	0f b6 c8             	movzbl %al,%ecx
80101435:	85 d9                	test   %ebx,%ecx
80101437:	74 20                	je     80101459 <bfree+0x79>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
80101439:	f7 d3                	not    %ebx
8010143b:	21 c3                	and    %eax,%ebx
8010143d:	88 5c 16 5c          	mov    %bl,0x5c(%esi,%edx,1)
  log_write(bp);
80101441:	89 34 24             	mov    %esi,(%esp)
80101444:	e8 d7 18 00 00       	call   80102d20 <log_write>
  brelse(bp);
80101449:	89 34 24             	mov    %esi,(%esp)
8010144c:	e8 8f ed ff ff       	call   801001e0 <brelse>
}
80101451:	83 c4 1c             	add    $0x1c,%esp
80101454:	5b                   	pop    %ebx
80101455:	5e                   	pop    %esi
80101456:	5f                   	pop    %edi
80101457:	5d                   	pop    %ebp
80101458:	c3                   	ret    
  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
    panic("freeing free block");
80101459:	c7 04 24 b4 6e 10 80 	movl   $0x80106eb4,(%esp)
80101460:	e8 fb ee ff ff       	call   80100360 <panic>
80101465:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101469:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101470 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
80101470:	55                   	push   %ebp
80101471:	89 e5                	mov    %esp,%ebp
80101473:	53                   	push   %ebx
80101474:	bb 40 0a 11 80       	mov    $0x80110a40,%ebx
80101479:	83 ec 24             	sub    $0x24,%esp
  int i = 0;
  
  initlock(&icache.lock, "icache");
8010147c:	c7 44 24 04 c7 6e 10 	movl   $0x80106ec7,0x4(%esp)
80101483:	80 
80101484:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
8010148b:	e8 10 2d 00 00       	call   801041a0 <initlock>
  for(i = 0; i < NINODE; i++) {
    initsleeplock(&icache.inode[i].lock, "inode");
80101490:	89 1c 24             	mov    %ebx,(%esp)
80101493:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101499:	c7 44 24 04 ce 6e 10 	movl   $0x80106ece,0x4(%esp)
801014a0:	80 
801014a1:	e8 ea 2b 00 00       	call   80104090 <initsleeplock>
iinit(int dev)
{
  int i = 0;
  
  initlock(&icache.lock, "icache");
  for(i = 0; i < NINODE; i++) {
801014a6:	81 fb 60 26 11 80    	cmp    $0x80112660,%ebx
801014ac:	75 e2                	jne    80101490 <iinit+0x20>
    initsleeplock(&icache.inode[i].lock, "inode");
  }
  
  readsb(dev, &sb);
801014ae:	8b 45 08             	mov    0x8(%ebp),%eax
801014b1:	c7 44 24 04 e0 09 11 	movl   $0x801109e0,0x4(%esp)
801014b8:	80 
801014b9:	89 04 24             	mov    %eax,(%esp)
801014bc:	e8 cf fe ff ff       	call   80101390 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801014c1:	a1 f8 09 11 80       	mov    0x801109f8,%eax
801014c6:	c7 04 24 24 6f 10 80 	movl   $0x80106f24,(%esp)
801014cd:	89 44 24 1c          	mov    %eax,0x1c(%esp)
801014d1:	a1 f4 09 11 80       	mov    0x801109f4,%eax
801014d6:	89 44 24 18          	mov    %eax,0x18(%esp)
801014da:	a1 f0 09 11 80       	mov    0x801109f0,%eax
801014df:	89 44 24 14          	mov    %eax,0x14(%esp)
801014e3:	a1 ec 09 11 80       	mov    0x801109ec,%eax
801014e8:	89 44 24 10          	mov    %eax,0x10(%esp)
801014ec:	a1 e8 09 11 80       	mov    0x801109e8,%eax
801014f1:	89 44 24 0c          	mov    %eax,0xc(%esp)
801014f5:	a1 e4 09 11 80       	mov    0x801109e4,%eax
801014fa:	89 44 24 08          	mov    %eax,0x8(%esp)
801014fe:	a1 e0 09 11 80       	mov    0x801109e0,%eax
80101503:	89 44 24 04          	mov    %eax,0x4(%esp)
80101507:	e8 44 f1 ff ff       	call   80100650 <cprintf>
 inodestart %d bmap start %d\n", sb.size, sb.nblocks,
          sb.ninodes, sb.nlog, sb.logstart, sb.inodestart,
          sb.bmapstart);
}
8010150c:	83 c4 24             	add    $0x24,%esp
8010150f:	5b                   	pop    %ebx
80101510:	5d                   	pop    %ebp
80101511:	c3                   	ret    
80101512:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101519:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101520 <ialloc>:
//PAGEBREAK!
// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
80101520:	55                   	push   %ebp
80101521:	89 e5                	mov    %esp,%ebp
80101523:	57                   	push   %edi
80101524:	56                   	push   %esi
80101525:	53                   	push   %ebx
80101526:	83 ec 2c             	sub    $0x2c,%esp
80101529:	8b 45 0c             	mov    0xc(%ebp),%eax
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
8010152c:	83 3d e8 09 11 80 01 	cmpl   $0x1,0x801109e8
//PAGEBREAK!
// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
80101533:	8b 7d 08             	mov    0x8(%ebp),%edi
80101536:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101539:	0f 86 a2 00 00 00    	jbe    801015e1 <ialloc+0xc1>
8010153f:	be 01 00 00 00       	mov    $0x1,%esi
80101544:	bb 01 00 00 00       	mov    $0x1,%ebx
80101549:	eb 1a                	jmp    80101565 <ialloc+0x45>
8010154b:	90                   	nop
8010154c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
80101550:	89 14 24             	mov    %edx,(%esp)
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101553:	83 c3 01             	add    $0x1,%ebx
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
80101556:	e8 85 ec ff ff       	call   801001e0 <brelse>
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
8010155b:	89 de                	mov    %ebx,%esi
8010155d:	3b 1d e8 09 11 80    	cmp    0x801109e8,%ebx
80101563:	73 7c                	jae    801015e1 <ialloc+0xc1>
    bp = bread(dev, IBLOCK(inum, sb));
80101565:	89 f0                	mov    %esi,%eax
80101567:	c1 e8 03             	shr    $0x3,%eax
8010156a:	03 05 f4 09 11 80    	add    0x801109f4,%eax
80101570:	89 3c 24             	mov    %edi,(%esp)
80101573:	89 44 24 04          	mov    %eax,0x4(%esp)
80101577:	e8 54 eb ff ff       	call   801000d0 <bread>
8010157c:	89 c2                	mov    %eax,%edx
    dip = (struct dinode*)bp->data + inum%IPB;
8010157e:	89 f0                	mov    %esi,%eax
80101580:	83 e0 07             	and    $0x7,%eax
80101583:	c1 e0 06             	shl    $0x6,%eax
80101586:	8d 4c 02 5c          	lea    0x5c(%edx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010158a:	66 83 39 00          	cmpw   $0x0,(%ecx)
8010158e:	75 c0                	jne    80101550 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101590:	89 0c 24             	mov    %ecx,(%esp)
80101593:	c7 44 24 08 40 00 00 	movl   $0x40,0x8(%esp)
8010159a:	00 
8010159b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801015a2:	00 
801015a3:	89 55 dc             	mov    %edx,-0x24(%ebp)
801015a6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801015a9:	e8 f2 2d 00 00       	call   801043a0 <memset>
      dip->type = type;
801015ae:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
      log_write(bp);   // mark it allocated on the disk
801015b2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  for(inum = 1; inum < sb.ninodes; inum++){
    bp = bread(dev, IBLOCK(inum, sb));
    dip = (struct dinode*)bp->data + inum%IPB;
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
801015b5:	8b 4d e0             	mov    -0x20(%ebp),%ecx
      log_write(bp);   // mark it allocated on the disk
801015b8:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
    bp = bread(dev, IBLOCK(inum, sb));
    dip = (struct dinode*)bp->data + inum%IPB;
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
801015bb:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801015be:	89 14 24             	mov    %edx,(%esp)
801015c1:	e8 5a 17 00 00       	call   80102d20 <log_write>
      brelse(bp);
801015c6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801015c9:	89 14 24             	mov    %edx,(%esp)
801015cc:	e8 0f ec ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
801015d1:	83 c4 2c             	add    $0x2c,%esp
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
801015d4:	89 f2                	mov    %esi,%edx
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
801015d6:	5b                   	pop    %ebx
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
801015d7:	89 f8                	mov    %edi,%eax
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
801015d9:	5e                   	pop    %esi
801015da:	5f                   	pop    %edi
801015db:	5d                   	pop    %ebp
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
801015dc:	e9 2f fc ff ff       	jmp    80101210 <iget>
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
801015e1:	c7 04 24 d4 6e 10 80 	movl   $0x80106ed4,(%esp)
801015e8:	e8 73 ed ff ff       	call   80100360 <panic>
801015ed:	8d 76 00             	lea    0x0(%esi),%esi

801015f0 <iupdate>:
}

// Copy a modified in-memory inode to disk.
void
iupdate(struct inode *ip)
{
801015f0:	55                   	push   %ebp
801015f1:	89 e5                	mov    %esp,%ebp
801015f3:	56                   	push   %esi
801015f4:	53                   	push   %ebx
801015f5:	83 ec 10             	sub    $0x10,%esp
801015f8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015fb:	8b 43 04             	mov    0x4(%ebx),%eax
  dip->type = ip->type;
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015fe:	83 c3 5c             	add    $0x5c,%ebx
iupdate(struct inode *ip)
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101601:	c1 e8 03             	shr    $0x3,%eax
80101604:	03 05 f4 09 11 80    	add    0x801109f4,%eax
8010160a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010160e:	8b 43 a4             	mov    -0x5c(%ebx),%eax
80101611:	89 04 24             	mov    %eax,(%esp)
80101614:	e8 b7 ea ff ff       	call   801000d0 <bread>
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101619:	8b 53 a8             	mov    -0x58(%ebx),%edx
8010161c:	83 e2 07             	and    $0x7,%edx
8010161f:	c1 e2 06             	shl    $0x6,%edx
80101622:	8d 54 10 5c          	lea    0x5c(%eax,%edx,1),%edx
iupdate(struct inode *ip)
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101626:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
  dip->type = ip->type;
80101628:	0f b7 43 f4          	movzwl -0xc(%ebx),%eax
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010162c:	83 c2 0c             	add    $0xc,%edx
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
  dip = (struct dinode*)bp->data + ip->inum%IPB;
  dip->type = ip->type;
8010162f:	66 89 42 f4          	mov    %ax,-0xc(%edx)
  dip->major = ip->major;
80101633:	0f b7 43 f6          	movzwl -0xa(%ebx),%eax
80101637:	66 89 42 f6          	mov    %ax,-0xa(%edx)
  dip->minor = ip->minor;
8010163b:	0f b7 43 f8          	movzwl -0x8(%ebx),%eax
8010163f:	66 89 42 f8          	mov    %ax,-0x8(%edx)
  dip->nlink = ip->nlink;
80101643:	0f b7 43 fa          	movzwl -0x6(%ebx),%eax
80101647:	66 89 42 fa          	mov    %ax,-0x6(%edx)
  dip->size = ip->size;
8010164b:	8b 43 fc             	mov    -0x4(%ebx),%eax
8010164e:	89 42 fc             	mov    %eax,-0x4(%edx)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101651:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101655:	89 14 24             	mov    %edx,(%esp)
80101658:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
8010165f:	00 
80101660:	e8 db 2d 00 00       	call   80104440 <memmove>
  log_write(bp);
80101665:	89 34 24             	mov    %esi,(%esp)
80101668:	e8 b3 16 00 00       	call   80102d20 <log_write>
  brelse(bp);
8010166d:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101670:	83 c4 10             	add    $0x10,%esp
80101673:	5b                   	pop    %ebx
80101674:	5e                   	pop    %esi
80101675:	5d                   	pop    %ebp
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
  log_write(bp);
  brelse(bp);
80101676:	e9 65 eb ff ff       	jmp    801001e0 <brelse>
8010167b:	90                   	nop
8010167c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101680 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
80101680:	55                   	push   %ebp
80101681:	89 e5                	mov    %esp,%ebp
80101683:	53                   	push   %ebx
80101684:	83 ec 14             	sub    $0x14,%esp
80101687:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010168a:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
80101691:	e8 8a 2b 00 00       	call   80104220 <acquire>
  ip->ref++;
80101696:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010169a:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
801016a1:	e8 aa 2c 00 00       	call   80104350 <release>
  return ip;
}
801016a6:	83 c4 14             	add    $0x14,%esp
801016a9:	89 d8                	mov    %ebx,%eax
801016ab:	5b                   	pop    %ebx
801016ac:	5d                   	pop    %ebp
801016ad:	c3                   	ret    
801016ae:	66 90                	xchg   %ax,%ax

801016b0 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
801016b0:	55                   	push   %ebp
801016b1:	89 e5                	mov    %esp,%ebp
801016b3:	56                   	push   %esi
801016b4:	53                   	push   %ebx
801016b5:	83 ec 10             	sub    $0x10,%esp
801016b8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
801016bb:	85 db                	test   %ebx,%ebx
801016bd:	0f 84 b0 00 00 00    	je     80101773 <ilock+0xc3>
801016c3:	8b 43 08             	mov    0x8(%ebx),%eax
801016c6:	85 c0                	test   %eax,%eax
801016c8:	0f 8e a5 00 00 00    	jle    80101773 <ilock+0xc3>
    panic("ilock");

  acquiresleep(&ip->lock);
801016ce:	8d 43 0c             	lea    0xc(%ebx),%eax
801016d1:	89 04 24             	mov    %eax,(%esp)
801016d4:	e8 f7 29 00 00       	call   801040d0 <acquiresleep>

  if(!(ip->flags & I_VALID)){
801016d9:	f6 43 4c 02          	testb  $0x2,0x4c(%ebx)
801016dd:	74 09                	je     801016e8 <ilock+0x38>
    brelse(bp);
    ip->flags |= I_VALID;
    if(ip->type == 0)
      panic("ilock: no type");
  }
}
801016df:	83 c4 10             	add    $0x10,%esp
801016e2:	5b                   	pop    %ebx
801016e3:	5e                   	pop    %esi
801016e4:	5d                   	pop    %ebp
801016e5:	c3                   	ret    
801016e6:	66 90                	xchg   %ax,%ax
    panic("ilock");

  acquiresleep(&ip->lock);

  if(!(ip->flags & I_VALID)){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016e8:	8b 43 04             	mov    0x4(%ebx),%eax
801016eb:	c1 e8 03             	shr    $0x3,%eax
801016ee:	03 05 f4 09 11 80    	add    0x801109f4,%eax
801016f4:	89 44 24 04          	mov    %eax,0x4(%esp)
801016f8:	8b 03                	mov    (%ebx),%eax
801016fa:	89 04 24             	mov    %eax,(%esp)
801016fd:	e8 ce e9 ff ff       	call   801000d0 <bread>
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101702:	8b 53 04             	mov    0x4(%ebx),%edx
80101705:	83 e2 07             	and    $0x7,%edx
80101708:	c1 e2 06             	shl    $0x6,%edx
8010170b:	8d 54 10 5c          	lea    0x5c(%eax,%edx,1),%edx
    panic("ilock");

  acquiresleep(&ip->lock);

  if(!(ip->flags & I_VALID)){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010170f:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    ip->type = dip->type;
80101711:	0f b7 02             	movzwl (%edx),%eax
    ip->major = dip->major;
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101714:	83 c2 0c             	add    $0xc,%edx
  acquiresleep(&ip->lock);

  if(!(ip->flags & I_VALID)){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    ip->type = dip->type;
80101717:	66 89 43 50          	mov    %ax,0x50(%ebx)
    ip->major = dip->major;
8010171b:	0f b7 42 f6          	movzwl -0xa(%edx),%eax
8010171f:	66 89 43 52          	mov    %ax,0x52(%ebx)
    ip->minor = dip->minor;
80101723:	0f b7 42 f8          	movzwl -0x8(%edx),%eax
80101727:	66 89 43 54          	mov    %ax,0x54(%ebx)
    ip->nlink = dip->nlink;
8010172b:	0f b7 42 fa          	movzwl -0x6(%edx),%eax
8010172f:	66 89 43 56          	mov    %ax,0x56(%ebx)
    ip->size = dip->size;
80101733:	8b 42 fc             	mov    -0x4(%edx),%eax
80101736:	89 43 58             	mov    %eax,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101739:	8d 43 5c             	lea    0x5c(%ebx),%eax
8010173c:	89 54 24 04          	mov    %edx,0x4(%esp)
80101740:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
80101747:	00 
80101748:	89 04 24             	mov    %eax,(%esp)
8010174b:	e8 f0 2c 00 00       	call   80104440 <memmove>
    brelse(bp);
80101750:	89 34 24             	mov    %esi,(%esp)
80101753:	e8 88 ea ff ff       	call   801001e0 <brelse>
    ip->flags |= I_VALID;
80101758:	83 4b 4c 02          	orl    $0x2,0x4c(%ebx)
    if(ip->type == 0)
8010175c:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
80101761:	0f 85 78 ff ff ff    	jne    801016df <ilock+0x2f>
      panic("ilock: no type");
80101767:	c7 04 24 ec 6e 10 80 	movl   $0x80106eec,(%esp)
8010176e:	e8 ed eb ff ff       	call   80100360 <panic>
{
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
    panic("ilock");
80101773:	c7 04 24 e6 6e 10 80 	movl   $0x80106ee6,(%esp)
8010177a:	e8 e1 eb ff ff       	call   80100360 <panic>
8010177f:	90                   	nop

80101780 <iunlock>:
}

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101780:	55                   	push   %ebp
80101781:	89 e5                	mov    %esp,%ebp
80101783:	56                   	push   %esi
80101784:	53                   	push   %ebx
80101785:	83 ec 10             	sub    $0x10,%esp
80101788:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
8010178b:	85 db                	test   %ebx,%ebx
8010178d:	74 24                	je     801017b3 <iunlock+0x33>
8010178f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101792:	89 34 24             	mov    %esi,(%esp)
80101795:	e8 d6 29 00 00       	call   80104170 <holdingsleep>
8010179a:	85 c0                	test   %eax,%eax
8010179c:	74 15                	je     801017b3 <iunlock+0x33>
8010179e:	8b 43 08             	mov    0x8(%ebx),%eax
801017a1:	85 c0                	test   %eax,%eax
801017a3:	7e 0e                	jle    801017b3 <iunlock+0x33>
    panic("iunlock");

  releasesleep(&ip->lock);
801017a5:	89 75 08             	mov    %esi,0x8(%ebp)
}
801017a8:	83 c4 10             	add    $0x10,%esp
801017ab:	5b                   	pop    %ebx
801017ac:	5e                   	pop    %esi
801017ad:	5d                   	pop    %ebp
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");

  releasesleep(&ip->lock);
801017ae:	e9 7d 29 00 00       	jmp    80104130 <releasesleep>
// Unlock the given inode.
void
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");
801017b3:	c7 04 24 fb 6e 10 80 	movl   $0x80106efb,(%esp)
801017ba:	e8 a1 eb ff ff       	call   80100360 <panic>
801017bf:	90                   	nop

801017c0 <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
801017c0:	55                   	push   %ebp
801017c1:	89 e5                	mov    %esp,%ebp
801017c3:	57                   	push   %edi
801017c4:	56                   	push   %esi
801017c5:	53                   	push   %ebx
801017c6:	83 ec 1c             	sub    $0x1c,%esp
801017c9:	8b 75 08             	mov    0x8(%ebp),%esi
  acquire(&icache.lock);
801017cc:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
801017d3:	e8 48 2a 00 00       	call   80104220 <acquire>
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
801017d8:	8b 46 08             	mov    0x8(%esi),%eax
801017db:	83 f8 01             	cmp    $0x1,%eax
801017de:	74 20                	je     80101800 <iput+0x40>
    ip->type = 0;
    iupdate(ip);
    acquire(&icache.lock);
    ip->flags = 0;
  }
  ip->ref--;
801017e0:	83 e8 01             	sub    $0x1,%eax
801017e3:	89 46 08             	mov    %eax,0x8(%esi)
  release(&icache.lock);
801017e6:	c7 45 08 00 0a 11 80 	movl   $0x80110a00,0x8(%ebp)
}
801017ed:	83 c4 1c             	add    $0x1c,%esp
801017f0:	5b                   	pop    %ebx
801017f1:	5e                   	pop    %esi
801017f2:	5f                   	pop    %edi
801017f3:	5d                   	pop    %ebp
    iupdate(ip);
    acquire(&icache.lock);
    ip->flags = 0;
  }
  ip->ref--;
  release(&icache.lock);
801017f4:	e9 57 2b 00 00       	jmp    80104350 <release>
801017f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
// case it has to free the inode.
void
iput(struct inode *ip)
{
  acquire(&icache.lock);
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
80101800:	f6 46 4c 02          	testb  $0x2,0x4c(%esi)
80101804:	74 da                	je     801017e0 <iput+0x20>
80101806:	66 83 7e 56 00       	cmpw   $0x0,0x56(%esi)
8010180b:	75 d3                	jne    801017e0 <iput+0x20>
    // inode has no links and no other references: truncate and free.
    release(&icache.lock);
8010180d:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
80101814:	89 f3                	mov    %esi,%ebx
80101816:	e8 35 2b 00 00       	call   80104350 <release>
8010181b:	8d 7e 30             	lea    0x30(%esi),%edi
8010181e:	eb 07                	jmp    80101827 <iput+0x67>
80101820:	83 c3 04             	add    $0x4,%ebx
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101823:	39 fb                	cmp    %edi,%ebx
80101825:	74 19                	je     80101840 <iput+0x80>
    if(ip->addrs[i]){
80101827:	8b 53 5c             	mov    0x5c(%ebx),%edx
8010182a:	85 d2                	test   %edx,%edx
8010182c:	74 f2                	je     80101820 <iput+0x60>
      bfree(ip->dev, ip->addrs[i]);
8010182e:	8b 06                	mov    (%esi),%eax
80101830:	e8 ab fb ff ff       	call   801013e0 <bfree>
      ip->addrs[i] = 0;
80101835:	c7 43 5c 00 00 00 00 	movl   $0x0,0x5c(%ebx)
8010183c:	eb e2                	jmp    80101820 <iput+0x60>
8010183e:	66 90                	xchg   %ax,%ax
    }
  }

  if(ip->addrs[NDIRECT]){
80101840:	8b 86 8c 00 00 00    	mov    0x8c(%esi),%eax
80101846:	85 c0                	test   %eax,%eax
80101848:	75 3e                	jne    80101888 <iput+0xc8>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
8010184a:	c7 46 58 00 00 00 00 	movl   $0x0,0x58(%esi)
  iupdate(ip);
80101851:	89 34 24             	mov    %esi,(%esp)
80101854:	e8 97 fd ff ff       	call   801015f0 <iupdate>
  acquire(&icache.lock);
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
    // inode has no links and no other references: truncate and free.
    release(&icache.lock);
    itrunc(ip);
    ip->type = 0;
80101859:	31 c0                	xor    %eax,%eax
8010185b:	66 89 46 50          	mov    %ax,0x50(%esi)
    iupdate(ip);
8010185f:	89 34 24             	mov    %esi,(%esp)
80101862:	e8 89 fd ff ff       	call   801015f0 <iupdate>
    acquire(&icache.lock);
80101867:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
8010186e:	e8 ad 29 00 00       	call   80104220 <acquire>
80101873:	8b 46 08             	mov    0x8(%esi),%eax
    ip->flags = 0;
80101876:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
8010187d:	e9 5e ff ff ff       	jmp    801017e0 <iput+0x20>
80101882:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101888:	89 44 24 04          	mov    %eax,0x4(%esp)
8010188c:	8b 06                	mov    (%esi),%eax
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
8010188e:	31 db                	xor    %ebx,%ebx
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101890:	89 04 24             	mov    %eax,(%esp)
80101893:	e8 38 e8 ff ff       	call   801000d0 <bread>
80101898:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
8010189b:	8d 78 5c             	lea    0x5c(%eax),%edi
    for(j = 0; j < NINDIRECT; j++){
8010189e:	31 c0                	xor    %eax,%eax
801018a0:	eb 13                	jmp    801018b5 <iput+0xf5>
801018a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801018a8:	83 c3 01             	add    $0x1,%ebx
801018ab:	81 fb 80 00 00 00    	cmp    $0x80,%ebx
801018b1:	89 d8                	mov    %ebx,%eax
801018b3:	74 10                	je     801018c5 <iput+0x105>
      if(a[j])
801018b5:	8b 14 87             	mov    (%edi,%eax,4),%edx
801018b8:	85 d2                	test   %edx,%edx
801018ba:	74 ec                	je     801018a8 <iput+0xe8>
        bfree(ip->dev, a[j]);
801018bc:	8b 06                	mov    (%esi),%eax
801018be:	e8 1d fb ff ff       	call   801013e0 <bfree>
801018c3:	eb e3                	jmp    801018a8 <iput+0xe8>
    }
    brelse(bp);
801018c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801018c8:	89 04 24             	mov    %eax,(%esp)
801018cb:	e8 10 e9 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801018d0:	8b 96 8c 00 00 00    	mov    0x8c(%esi),%edx
801018d6:	8b 06                	mov    (%esi),%eax
801018d8:	e8 03 fb ff ff       	call   801013e0 <bfree>
    ip->addrs[NDIRECT] = 0;
801018dd:	c7 86 8c 00 00 00 00 	movl   $0x0,0x8c(%esi)
801018e4:	00 00 00 
801018e7:	e9 5e ff ff ff       	jmp    8010184a <iput+0x8a>
801018ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801018f0 <iunlockput>:
}

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
801018f0:	55                   	push   %ebp
801018f1:	89 e5                	mov    %esp,%ebp
801018f3:	53                   	push   %ebx
801018f4:	83 ec 14             	sub    $0x14,%esp
801018f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
801018fa:	89 1c 24             	mov    %ebx,(%esp)
801018fd:	e8 7e fe ff ff       	call   80101780 <iunlock>
  iput(ip);
80101902:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80101905:	83 c4 14             	add    $0x14,%esp
80101908:	5b                   	pop    %ebx
80101909:	5d                   	pop    %ebp
// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
  iput(ip);
8010190a:	e9 b1 fe ff ff       	jmp    801017c0 <iput>
8010190f:	90                   	nop

80101910 <stati>:
}

// Copy stat information from inode.
void
stati(struct inode *ip, struct stat *st)
{
80101910:	55                   	push   %ebp
80101911:	89 e5                	mov    %esp,%ebp
80101913:	8b 55 08             	mov    0x8(%ebp),%edx
80101916:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101919:	8b 0a                	mov    (%edx),%ecx
8010191b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
8010191e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101921:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101924:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101928:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
8010192b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
8010192f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101933:	8b 52 58             	mov    0x58(%edx),%edx
80101936:	89 50 10             	mov    %edx,0x10(%eax)
}
80101939:	5d                   	pop    %ebp
8010193a:	c3                   	ret    
8010193b:	90                   	nop
8010193c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101940 <readi>:

//PAGEBREAK!
// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101940:	55                   	push   %ebp
80101941:	89 e5                	mov    %esp,%ebp
80101943:	57                   	push   %edi
80101944:	56                   	push   %esi
80101945:	53                   	push   %ebx
80101946:	83 ec 2c             	sub    $0x2c,%esp
80101949:	8b 45 0c             	mov    0xc(%ebp),%eax
8010194c:	8b 7d 08             	mov    0x8(%ebp),%edi
8010194f:	8b 75 10             	mov    0x10(%ebp),%esi
80101952:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101955:	8b 45 14             	mov    0x14(%ebp),%eax
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101958:	66 83 7f 50 03       	cmpw   $0x3,0x50(%edi)

//PAGEBREAK!
// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
8010195d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101960:	0f 84 aa 00 00 00    	je     80101a10 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101966:	8b 47 58             	mov    0x58(%edi),%eax
80101969:	39 f0                	cmp    %esi,%eax
8010196b:	0f 82 c7 00 00 00    	jb     80101a38 <readi+0xf8>
80101971:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101974:	89 da                	mov    %ebx,%edx
80101976:	01 f2                	add    %esi,%edx
80101978:	0f 82 ba 00 00 00    	jb     80101a38 <readi+0xf8>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
8010197e:	89 c1                	mov    %eax,%ecx
80101980:	29 f1                	sub    %esi,%ecx
80101982:	39 d0                	cmp    %edx,%eax
80101984:	0f 43 cb             	cmovae %ebx,%ecx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101987:	31 c0                	xor    %eax,%eax
80101989:	85 c9                	test   %ecx,%ecx
  }

  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
8010198b:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
8010198e:	74 70                	je     80101a00 <readi+0xc0>
80101990:	89 7d d8             	mov    %edi,-0x28(%ebp)
80101993:	89 c7                	mov    %eax,%edi
80101995:	8d 76 00             	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101998:	8b 5d d8             	mov    -0x28(%ebp),%ebx
8010199b:	89 f2                	mov    %esi,%edx
8010199d:	c1 ea 09             	shr    $0x9,%edx
801019a0:	89 d8                	mov    %ebx,%eax
801019a2:	e8 29 f9 ff ff       	call   801012d0 <bmap>
801019a7:	89 44 24 04          	mov    %eax,0x4(%esp)
801019ab:	8b 03                	mov    (%ebx),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
801019ad:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019b2:	89 04 24             	mov    %eax,(%esp)
801019b5:	e8 16 e7 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
801019ba:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801019bd:	29 f9                	sub    %edi,%ecx
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019bf:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
801019c1:	89 f0                	mov    %esi,%eax
801019c3:	25 ff 01 00 00       	and    $0x1ff,%eax
801019c8:	29 c3                	sub    %eax,%ebx
    for (int j = 0; j < min(m, 10); j++) {
      cprintf("%x ", bp->data[off%BSIZE+j]);
    }
    cprintf("\n");
    */
    memmove(dst, bp->data + off%BSIZE, m);
801019ca:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
801019ce:	39 cb                	cmp    %ecx,%ebx
    for (int j = 0; j < min(m, 10); j++) {
      cprintf("%x ", bp->data[off%BSIZE+j]);
    }
    cprintf("\n");
    */
    memmove(dst, bp->data + off%BSIZE, m);
801019d0:	89 44 24 04          	mov    %eax,0x4(%esp)
801019d4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
801019d7:	0f 47 d9             	cmova  %ecx,%ebx
    for (int j = 0; j < min(m, 10); j++) {
      cprintf("%x ", bp->data[off%BSIZE+j]);
    }
    cprintf("\n");
    */
    memmove(dst, bp->data + off%BSIZE, m);
801019da:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019de:	01 df                	add    %ebx,%edi
801019e0:	01 de                	add    %ebx,%esi
    for (int j = 0; j < min(m, 10); j++) {
      cprintf("%x ", bp->data[off%BSIZE+j]);
    }
    cprintf("\n");
    */
    memmove(dst, bp->data + off%BSIZE, m);
801019e2:	89 55 dc             	mov    %edx,-0x24(%ebp)
801019e5:	89 04 24             	mov    %eax,(%esp)
801019e8:	e8 53 2a 00 00       	call   80104440 <memmove>
    brelse(bp);
801019ed:	8b 55 dc             	mov    -0x24(%ebp),%edx
801019f0:	89 14 24             	mov    %edx,(%esp)
801019f3:	e8 e8 e7 ff ff       	call   801001e0 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019f8:	01 5d e0             	add    %ebx,-0x20(%ebp)
801019fb:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801019fe:	77 98                	ja     80101998 <readi+0x58>
    cprintf("\n");
    */
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
80101a00:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101a03:	83 c4 2c             	add    $0x2c,%esp
80101a06:	5b                   	pop    %ebx
80101a07:	5e                   	pop    %esi
80101a08:	5f                   	pop    %edi
80101a09:	5d                   	pop    %ebp
80101a0a:	c3                   	ret    
80101a0b:	90                   	nop
80101a0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101a10:	0f bf 47 52          	movswl 0x52(%edi),%eax
80101a14:	66 83 f8 09          	cmp    $0x9,%ax
80101a18:	77 1e                	ja     80101a38 <readi+0xf8>
80101a1a:	8b 04 c5 80 09 11 80 	mov    -0x7feef680(,%eax,8),%eax
80101a21:	85 c0                	test   %eax,%eax
80101a23:	74 13                	je     80101a38 <readi+0xf8>
      return -1;
    return devsw[ip->major].read(ip, dst, n);
80101a25:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101a28:	89 75 10             	mov    %esi,0x10(%ebp)
    */
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
}
80101a2b:	83 c4 2c             	add    $0x2c,%esp
80101a2e:	5b                   	pop    %ebx
80101a2f:	5e                   	pop    %esi
80101a30:	5f                   	pop    %edi
80101a31:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
80101a32:	ff e0                	jmp    *%eax
80101a34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
80101a38:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a3d:	eb c4                	jmp    80101a03 <readi+0xc3>
80101a3f:	90                   	nop

80101a40 <writei>:

// PAGEBREAK!
// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101a40:	55                   	push   %ebp
80101a41:	89 e5                	mov    %esp,%ebp
80101a43:	57                   	push   %edi
80101a44:	56                   	push   %esi
80101a45:	53                   	push   %ebx
80101a46:	83 ec 2c             	sub    $0x2c,%esp
80101a49:	8b 45 08             	mov    0x8(%ebp),%eax
80101a4c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101a4f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a52:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)

// PAGEBREAK!
// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101a57:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101a5a:	8b 75 10             	mov    0x10(%ebp),%esi
80101a5d:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a60:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a63:	0f 84 b7 00 00 00    	je     80101b20 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101a69:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a6c:	39 70 58             	cmp    %esi,0x58(%eax)
80101a6f:	0f 82 e3 00 00 00    	jb     80101b58 <writei+0x118>
80101a75:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101a78:	89 c8                	mov    %ecx,%eax
80101a7a:	01 f0                	add    %esi,%eax
80101a7c:	0f 82 d6 00 00 00    	jb     80101b58 <writei+0x118>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101a82:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101a87:	0f 87 cb 00 00 00    	ja     80101b58 <writei+0x118>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101a8d:	85 c9                	test   %ecx,%ecx
80101a8f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101a96:	74 77                	je     80101b0f <writei+0xcf>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a98:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101a9b:	89 f2                	mov    %esi,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101a9d:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101aa2:	c1 ea 09             	shr    $0x9,%edx
80101aa5:	89 f8                	mov    %edi,%eax
80101aa7:	e8 24 f8 ff ff       	call   801012d0 <bmap>
80101aac:	89 44 24 04          	mov    %eax,0x4(%esp)
80101ab0:	8b 07                	mov    (%edi),%eax
80101ab2:	89 04 24             	mov    %eax,(%esp)
80101ab5:	e8 16 e6 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101aba:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101abd:	2b 4d e4             	sub    -0x1c(%ebp),%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101ac0:	8b 55 dc             	mov    -0x24(%ebp),%edx
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ac3:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101ac5:	89 f0                	mov    %esi,%eax
80101ac7:	25 ff 01 00 00       	and    $0x1ff,%eax
80101acc:	29 c3                	sub    %eax,%ebx
80101ace:	39 cb                	cmp    %ecx,%ebx
80101ad0:	0f 47 d9             	cmova  %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101ad3:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101ad7:	01 de                	add    %ebx,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(bp->data + off%BSIZE, src, m);
80101ad9:	89 54 24 04          	mov    %edx,0x4(%esp)
80101add:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80101ae1:	89 04 24             	mov    %eax,(%esp)
80101ae4:	e8 57 29 00 00       	call   80104440 <memmove>
    log_write(bp);
80101ae9:	89 3c 24             	mov    %edi,(%esp)
80101aec:	e8 2f 12 00 00       	call   80102d20 <log_write>
    brelse(bp);
80101af1:	89 3c 24             	mov    %edi,(%esp)
80101af4:	e8 e7 e6 ff ff       	call   801001e0 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101af9:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101afc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101aff:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101b02:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101b05:	77 91                	ja     80101a98 <writei+0x58>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
80101b07:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b0a:	39 70 58             	cmp    %esi,0x58(%eax)
80101b0d:	72 39                	jb     80101b48 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101b0f:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101b12:	83 c4 2c             	add    $0x2c,%esp
80101b15:	5b                   	pop    %ebx
80101b16:	5e                   	pop    %esi
80101b17:	5f                   	pop    %edi
80101b18:	5d                   	pop    %ebp
80101b19:	c3                   	ret    
80101b1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101b20:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b24:	66 83 f8 09          	cmp    $0x9,%ax
80101b28:	77 2e                	ja     80101b58 <writei+0x118>
80101b2a:	8b 04 c5 84 09 11 80 	mov    -0x7feef67c(,%eax,8),%eax
80101b31:	85 c0                	test   %eax,%eax
80101b33:	74 23                	je     80101b58 <writei+0x118>
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101b35:	89 4d 10             	mov    %ecx,0x10(%ebp)
  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
}
80101b38:	83 c4 2c             	add    $0x2c,%esp
80101b3b:	5b                   	pop    %ebx
80101b3c:	5e                   	pop    %esi
80101b3d:	5f                   	pop    %edi
80101b3e:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101b3f:	ff e0                	jmp    *%eax
80101b41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
    ip->size = off;
80101b48:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b4b:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101b4e:	89 04 24             	mov    %eax,(%esp)
80101b51:	e8 9a fa ff ff       	call   801015f0 <iupdate>
80101b56:	eb b7                	jmp    80101b0f <writei+0xcf>
  }
  return n;
}
80101b58:	83 c4 2c             	add    $0x2c,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
80101b5b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
}
80101b60:	5b                   	pop    %ebx
80101b61:	5e                   	pop    %esi
80101b62:	5f                   	pop    %edi
80101b63:	5d                   	pop    %ebp
80101b64:	c3                   	ret    
80101b65:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101b69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101b70 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101b70:	55                   	push   %ebp
80101b71:	89 e5                	mov    %esp,%ebp
80101b73:	83 ec 18             	sub    $0x18,%esp
  return strncmp(s, t, DIRSIZ);
80101b76:	8b 45 0c             	mov    0xc(%ebp),%eax
80101b79:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101b80:	00 
80101b81:	89 44 24 04          	mov    %eax,0x4(%esp)
80101b85:	8b 45 08             	mov    0x8(%ebp),%eax
80101b88:	89 04 24             	mov    %eax,(%esp)
80101b8b:	e8 30 29 00 00       	call   801044c0 <strncmp>
}
80101b90:	c9                   	leave  
80101b91:	c3                   	ret    
80101b92:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101ba0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101ba0:	55                   	push   %ebp
80101ba1:	89 e5                	mov    %esp,%ebp
80101ba3:	57                   	push   %edi
80101ba4:	56                   	push   %esi
80101ba5:	53                   	push   %ebx
80101ba6:	83 ec 2c             	sub    $0x2c,%esp
80101ba9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101bac:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101bb1:	0f 85 97 00 00 00    	jne    80101c4e <dirlookup+0xae>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101bb7:	8b 53 58             	mov    0x58(%ebx),%edx
80101bba:	31 ff                	xor    %edi,%edi
80101bbc:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101bbf:	85 d2                	test   %edx,%edx
80101bc1:	75 0d                	jne    80101bd0 <dirlookup+0x30>
80101bc3:	eb 73                	jmp    80101c38 <dirlookup+0x98>
80101bc5:	8d 76 00             	lea    0x0(%esi),%esi
80101bc8:	83 c7 10             	add    $0x10,%edi
80101bcb:	39 7b 58             	cmp    %edi,0x58(%ebx)
80101bce:	76 68                	jbe    80101c38 <dirlookup+0x98>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101bd0:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101bd7:	00 
80101bd8:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101bdc:	89 74 24 04          	mov    %esi,0x4(%esp)
80101be0:	89 1c 24             	mov    %ebx,(%esp)
80101be3:	e8 58 fd ff ff       	call   80101940 <readi>
80101be8:	83 f8 10             	cmp    $0x10,%eax
80101beb:	75 55                	jne    80101c42 <dirlookup+0xa2>
      panic("dirlink read");
    if(de.inum == 0)
80101bed:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101bf2:	74 d4                	je     80101bc8 <dirlookup+0x28>
// Directories

int
namecmp(const char *s, const char *t)
{
  return strncmp(s, t, DIRSIZ);
80101bf4:	8d 45 da             	lea    -0x26(%ebp),%eax
80101bf7:	89 44 24 04          	mov    %eax,0x4(%esp)
80101bfb:	8b 45 0c             	mov    0xc(%ebp),%eax
80101bfe:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101c05:	00 
80101c06:	89 04 24             	mov    %eax,(%esp)
80101c09:	e8 b2 28 00 00       	call   801044c0 <strncmp>
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
80101c0e:	85 c0                	test   %eax,%eax
80101c10:	75 b6                	jne    80101bc8 <dirlookup+0x28>
      // entry matches path element
      if(poff)
80101c12:	8b 45 10             	mov    0x10(%ebp),%eax
80101c15:	85 c0                	test   %eax,%eax
80101c17:	74 05                	je     80101c1e <dirlookup+0x7e>
        *poff = off;
80101c19:	8b 45 10             	mov    0x10(%ebp),%eax
80101c1c:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101c1e:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101c22:	8b 03                	mov    (%ebx),%eax
80101c24:	e8 e7 f5 ff ff       	call   80101210 <iget>
    }
  }

  return 0;
}
80101c29:	83 c4 2c             	add    $0x2c,%esp
80101c2c:	5b                   	pop    %ebx
80101c2d:	5e                   	pop    %esi
80101c2e:	5f                   	pop    %edi
80101c2f:	5d                   	pop    %ebp
80101c30:	c3                   	ret    
80101c31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c38:	83 c4 2c             	add    $0x2c,%esp
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
80101c3b:	31 c0                	xor    %eax,%eax
}
80101c3d:	5b                   	pop    %ebx
80101c3e:	5e                   	pop    %esi
80101c3f:	5f                   	pop    %edi
80101c40:	5d                   	pop    %ebp
80101c41:	c3                   	ret    
  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
80101c42:	c7 04 24 15 6f 10 80 	movl   $0x80106f15,(%esp)
80101c49:	e8 12 e7 ff ff       	call   80100360 <panic>
{
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");
80101c4e:	c7 04 24 03 6f 10 80 	movl   $0x80106f03,(%esp)
80101c55:	e8 06 e7 ff ff       	call   80100360 <panic>
80101c5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101c60 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101c60:	55                   	push   %ebp
80101c61:	89 e5                	mov    %esp,%ebp
80101c63:	57                   	push   %edi
80101c64:	89 cf                	mov    %ecx,%edi
80101c66:	56                   	push   %esi
80101c67:	53                   	push   %ebx
80101c68:	89 c3                	mov    %eax,%ebx
80101c6a:	83 ec 2c             	sub    $0x2c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101c6d:	80 38 2f             	cmpb   $0x2f,(%eax)
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101c70:	89 55 e0             	mov    %edx,-0x20(%ebp)
  struct inode *ip, *next;

  if(*path == '/')
80101c73:	0f 84 51 01 00 00    	je     80101dca <namex+0x16a>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);
80101c79:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80101c7f:	8b 70 68             	mov    0x68(%eax),%esi
// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
  acquire(&icache.lock);
80101c82:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
80101c89:	e8 92 25 00 00       	call   80104220 <acquire>
  ip->ref++;
80101c8e:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101c92:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
80101c99:	e8 b2 26 00 00       	call   80104350 <release>
80101c9e:	eb 03                	jmp    80101ca3 <namex+0x43>
{
  char *s;
  int len;

  while(*path == '/')
    path++;
80101ca0:	83 c3 01             	add    $0x1,%ebx
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
80101ca3:	0f b6 03             	movzbl (%ebx),%eax
80101ca6:	3c 2f                	cmp    $0x2f,%al
80101ca8:	74 f6                	je     80101ca0 <namex+0x40>
    path++;
  if(*path == 0)
80101caa:	84 c0                	test   %al,%al
80101cac:	0f 84 ed 00 00 00    	je     80101d9f <namex+0x13f>
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101cb2:	0f b6 03             	movzbl (%ebx),%eax
80101cb5:	89 da                	mov    %ebx,%edx
80101cb7:	84 c0                	test   %al,%al
80101cb9:	0f 84 b1 00 00 00    	je     80101d70 <namex+0x110>
80101cbf:	3c 2f                	cmp    $0x2f,%al
80101cc1:	75 0f                	jne    80101cd2 <namex+0x72>
80101cc3:	e9 a8 00 00 00       	jmp    80101d70 <namex+0x110>
80101cc8:	3c 2f                	cmp    $0x2f,%al
80101cca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101cd0:	74 0a                	je     80101cdc <namex+0x7c>
    path++;
80101cd2:	83 c2 01             	add    $0x1,%edx
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101cd5:	0f b6 02             	movzbl (%edx),%eax
80101cd8:	84 c0                	test   %al,%al
80101cda:	75 ec                	jne    80101cc8 <namex+0x68>
80101cdc:	89 d1                	mov    %edx,%ecx
80101cde:	29 d9                	sub    %ebx,%ecx
    path++;
  len = path - s;
  if(len >= DIRSIZ)
80101ce0:	83 f9 0d             	cmp    $0xd,%ecx
80101ce3:	0f 8e 8f 00 00 00    	jle    80101d78 <namex+0x118>
    memmove(name, s, DIRSIZ);
80101ce9:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101ced:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101cf4:	00 
80101cf5:	89 3c 24             	mov    %edi,(%esp)
80101cf8:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101cfb:	e8 40 27 00 00       	call   80104440 <memmove>
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
80101d00:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101d03:	89 d3                	mov    %edx,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101d05:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101d08:	75 0e                	jne    80101d18 <namex+0xb8>
80101d0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    path++;
80101d10:	83 c3 01             	add    $0x1,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101d13:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101d16:	74 f8                	je     80101d10 <namex+0xb0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101d18:	89 34 24             	mov    %esi,(%esp)
80101d1b:	e8 90 f9 ff ff       	call   801016b0 <ilock>
    if(ip->type != T_DIR){
80101d20:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101d25:	0f 85 85 00 00 00    	jne    80101db0 <namex+0x150>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101d2b:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101d2e:	85 d2                	test   %edx,%edx
80101d30:	74 09                	je     80101d3b <namex+0xdb>
80101d32:	80 3b 00             	cmpb   $0x0,(%ebx)
80101d35:	0f 84 a5 00 00 00    	je     80101de0 <namex+0x180>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101d3b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80101d42:	00 
80101d43:	89 7c 24 04          	mov    %edi,0x4(%esp)
80101d47:	89 34 24             	mov    %esi,(%esp)
80101d4a:	e8 51 fe ff ff       	call   80101ba0 <dirlookup>
80101d4f:	85 c0                	test   %eax,%eax
80101d51:	74 5d                	je     80101db0 <namex+0x150>

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80101d53:	89 34 24             	mov    %esi,(%esp)
80101d56:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101d59:	e8 22 fa ff ff       	call   80101780 <iunlock>
  iput(ip);
80101d5e:	89 34 24             	mov    %esi,(%esp)
80101d61:	e8 5a fa ff ff       	call   801017c0 <iput>
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
    }
    iunlockput(ip);
    ip = next;
80101d66:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101d69:	89 c6                	mov    %eax,%esi
80101d6b:	e9 33 ff ff ff       	jmp    80101ca3 <namex+0x43>
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101d70:	31 c9                	xor    %ecx,%ecx
80101d72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
80101d78:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80101d7c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101d80:	89 3c 24             	mov    %edi,(%esp)
80101d83:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101d86:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101d89:	e8 b2 26 00 00       	call   80104440 <memmove>
    name[len] = 0;
80101d8e:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101d91:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101d94:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101d98:	89 d3                	mov    %edx,%ebx
80101d9a:	e9 66 ff ff ff       	jmp    80101d05 <namex+0xa5>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101d9f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101da2:	85 c0                	test   %eax,%eax
80101da4:	75 4c                	jne    80101df2 <namex+0x192>
80101da6:	89 f0                	mov    %esi,%eax
    iput(ip);
    return 0;
  }
  return ip;
}
80101da8:	83 c4 2c             	add    $0x2c,%esp
80101dab:	5b                   	pop    %ebx
80101dac:	5e                   	pop    %esi
80101dad:	5f                   	pop    %edi
80101dae:	5d                   	pop    %ebp
80101daf:	c3                   	ret    

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80101db0:	89 34 24             	mov    %esi,(%esp)
80101db3:	e8 c8 f9 ff ff       	call   80101780 <iunlock>
  iput(ip);
80101db8:	89 34 24             	mov    %esi,(%esp)
80101dbb:	e8 00 fa ff ff       	call   801017c0 <iput>
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101dc0:	83 c4 2c             	add    $0x2c,%esp
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
80101dc3:	31 c0                	xor    %eax,%eax
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101dc5:	5b                   	pop    %ebx
80101dc6:	5e                   	pop    %esi
80101dc7:	5f                   	pop    %edi
80101dc8:	5d                   	pop    %ebp
80101dc9:	c3                   	ret    
namex(char *path, int nameiparent, char *name)
{
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
80101dca:	ba 01 00 00 00       	mov    $0x1,%edx
80101dcf:	b8 01 00 00 00       	mov    $0x1,%eax
80101dd4:	e8 37 f4 ff ff       	call   80101210 <iget>
80101dd9:	89 c6                	mov    %eax,%esi
80101ddb:	e9 c3 fe ff ff       	jmp    80101ca3 <namex+0x43>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
80101de0:	89 34 24             	mov    %esi,(%esp)
80101de3:	e8 98 f9 ff ff       	call   80101780 <iunlock>
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101de8:	83 c4 2c             	add    $0x2c,%esp
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
      return ip;
80101deb:	89 f0                	mov    %esi,%eax
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101ded:	5b                   	pop    %ebx
80101dee:	5e                   	pop    %esi
80101def:	5f                   	pop    %edi
80101df0:	5d                   	pop    %ebp
80101df1:	c3                   	ret    
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
    iput(ip);
80101df2:	89 34 24             	mov    %esi,(%esp)
80101df5:	e8 c6 f9 ff ff       	call   801017c0 <iput>
    return 0;
80101dfa:	31 c0                	xor    %eax,%eax
80101dfc:	eb aa                	jmp    80101da8 <namex+0x148>
80101dfe:	66 90                	xchg   %ax,%ax

80101e00 <dirlink>:
}

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
80101e00:	55                   	push   %ebp
80101e01:	89 e5                	mov    %esp,%ebp
80101e03:	57                   	push   %edi
80101e04:	56                   	push   %esi
80101e05:	53                   	push   %ebx
80101e06:	83 ec 2c             	sub    $0x2c,%esp
80101e09:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
80101e0c:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e0f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80101e16:	00 
80101e17:	89 1c 24             	mov    %ebx,(%esp)
80101e1a:	89 44 24 04          	mov    %eax,0x4(%esp)
80101e1e:	e8 7d fd ff ff       	call   80101ba0 <dirlookup>
80101e23:	85 c0                	test   %eax,%eax
80101e25:	0f 85 8b 00 00 00    	jne    80101eb6 <dirlink+0xb6>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80101e2b:	8b 43 58             	mov    0x58(%ebx),%eax
80101e2e:	31 ff                	xor    %edi,%edi
80101e30:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e33:	85 c0                	test   %eax,%eax
80101e35:	75 13                	jne    80101e4a <dirlink+0x4a>
80101e37:	eb 35                	jmp    80101e6e <dirlink+0x6e>
80101e39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e40:	8d 57 10             	lea    0x10(%edi),%edx
80101e43:	39 53 58             	cmp    %edx,0x58(%ebx)
80101e46:	89 d7                	mov    %edx,%edi
80101e48:	76 24                	jbe    80101e6e <dirlink+0x6e>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e4a:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101e51:	00 
80101e52:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101e56:	89 74 24 04          	mov    %esi,0x4(%esp)
80101e5a:	89 1c 24             	mov    %ebx,(%esp)
80101e5d:	e8 de fa ff ff       	call   80101940 <readi>
80101e62:	83 f8 10             	cmp    $0x10,%eax
80101e65:	75 5e                	jne    80101ec5 <dirlink+0xc5>
      panic("dirlink read");
    if(de.inum == 0)
80101e67:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101e6c:	75 d2                	jne    80101e40 <dirlink+0x40>
      break;
  }

  strncpy(de.name, name, DIRSIZ);
80101e6e:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e71:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101e78:	00 
80101e79:	89 44 24 04          	mov    %eax,0x4(%esp)
80101e7d:	8d 45 da             	lea    -0x26(%ebp),%eax
80101e80:	89 04 24             	mov    %eax,(%esp)
80101e83:	e8 a8 26 00 00       	call   80104530 <strncpy>
  de.inum = inum;
80101e88:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e8b:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101e92:	00 
80101e93:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101e97:	89 74 24 04          	mov    %esi,0x4(%esp)
80101e9b:	89 1c 24             	mov    %ebx,(%esp)
    if(de.inum == 0)
      break;
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
80101e9e:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ea2:	e8 99 fb ff ff       	call   80101a40 <writei>
80101ea7:	83 f8 10             	cmp    $0x10,%eax
80101eaa:	75 25                	jne    80101ed1 <dirlink+0xd1>
    panic("dirlink");

  return 0;
80101eac:	31 c0                	xor    %eax,%eax
}
80101eae:	83 c4 2c             	add    $0x2c,%esp
80101eb1:	5b                   	pop    %ebx
80101eb2:	5e                   	pop    %esi
80101eb3:	5f                   	pop    %edi
80101eb4:	5d                   	pop    %ebp
80101eb5:	c3                   	ret    
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
    iput(ip);
80101eb6:	89 04 24             	mov    %eax,(%esp)
80101eb9:	e8 02 f9 ff ff       	call   801017c0 <iput>
    return -1;
80101ebe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101ec3:	eb e9                	jmp    80101eae <dirlink+0xae>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
80101ec5:	c7 04 24 15 6f 10 80 	movl   $0x80106f15,(%esp)
80101ecc:	e8 8f e4 ff ff       	call   80100360 <panic>
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("dirlink");
80101ed1:	c7 04 24 e2 74 10 80 	movl   $0x801074e2,(%esp)
80101ed8:	e8 83 e4 ff ff       	call   80100360 <panic>
80101edd:	8d 76 00             	lea    0x0(%esi),%esi

80101ee0 <namei>:
  return ip;
}

struct inode*
namei(char *path)
{
80101ee0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101ee1:	31 d2                	xor    %edx,%edx
  return ip;
}

struct inode*
namei(char *path)
{
80101ee3:	89 e5                	mov    %esp,%ebp
80101ee5:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101ee8:	8b 45 08             	mov    0x8(%ebp),%eax
80101eeb:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101eee:	e8 6d fd ff ff       	call   80101c60 <namex>
}
80101ef3:	c9                   	leave  
80101ef4:	c3                   	ret    
80101ef5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101ef9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f00 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101f00:	55                   	push   %ebp
  return namex(path, 1, name);
80101f01:	ba 01 00 00 00       	mov    $0x1,%edx
  return namex(path, 0, name);
}

struct inode*
nameiparent(char *path, char *name)
{
80101f06:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101f08:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101f0b:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101f0e:	5d                   	pop    %ebp
}

struct inode*
nameiparent(char *path, char *name)
{
  return namex(path, 1, name);
80101f0f:	e9 4c fd ff ff       	jmp    80101c60 <namex>
80101f14:	66 90                	xchg   %ax,%ax
80101f16:	66 90                	xchg   %ax,%ax
80101f18:	66 90                	xchg   %ax,%ax
80101f1a:	66 90                	xchg   %ax,%ax
80101f1c:	66 90                	xchg   %ax,%ax
80101f1e:	66 90                	xchg   %ax,%ax

80101f20 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101f20:	55                   	push   %ebp
80101f21:	89 e5                	mov    %esp,%ebp
80101f23:	56                   	push   %esi
80101f24:	89 c6                	mov    %eax,%esi
80101f26:	53                   	push   %ebx
80101f27:	83 ec 10             	sub    $0x10,%esp
  if(b == 0)
80101f2a:	85 c0                	test   %eax,%eax
80101f2c:	0f 84 99 00 00 00    	je     80101fcb <idestart+0xab>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101f32:	8b 48 08             	mov    0x8(%eax),%ecx
80101f35:	81 f9 e7 03 00 00    	cmp    $0x3e7,%ecx
80101f3b:	0f 87 7e 00 00 00    	ja     80101fbf <idestart+0x9f>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101f41:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101f46:	66 90                	xchg   %ax,%ax
80101f48:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101f49:	83 e0 c0             	and    $0xffffffc0,%eax
80101f4c:	3c 40                	cmp    $0x40,%al
80101f4e:	75 f8                	jne    80101f48 <idestart+0x28>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101f50:	31 db                	xor    %ebx,%ebx
80101f52:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101f57:	89 d8                	mov    %ebx,%eax
80101f59:	ee                   	out    %al,(%dx)
80101f5a:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101f5f:	b8 01 00 00 00       	mov    $0x1,%eax
80101f64:	ee                   	out    %al,(%dx)
80101f65:	0f b6 c1             	movzbl %cl,%eax
80101f68:	b2 f3                	mov    $0xf3,%dl
80101f6a:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80101f6b:	89 c8                	mov    %ecx,%eax
80101f6d:	b2 f4                	mov    $0xf4,%dl
80101f6f:	c1 f8 08             	sar    $0x8,%eax
80101f72:	ee                   	out    %al,(%dx)
80101f73:	b2 f5                	mov    $0xf5,%dl
80101f75:	89 d8                	mov    %ebx,%eax
80101f77:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80101f78:	0f b6 46 04          	movzbl 0x4(%esi),%eax
80101f7c:	b2 f6                	mov    $0xf6,%dl
80101f7e:	83 e0 01             	and    $0x1,%eax
80101f81:	c1 e0 04             	shl    $0x4,%eax
80101f84:	83 c8 e0             	or     $0xffffffe0,%eax
80101f87:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
80101f88:	f6 06 04             	testb  $0x4,(%esi)
80101f8b:	75 13                	jne    80101fa0 <idestart+0x80>
80101f8d:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101f92:	b8 20 00 00 00       	mov    $0x20,%eax
80101f97:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101f98:	83 c4 10             	add    $0x10,%esp
80101f9b:	5b                   	pop    %ebx
80101f9c:	5e                   	pop    %esi
80101f9d:	5d                   	pop    %ebp
80101f9e:	c3                   	ret    
80101f9f:	90                   	nop
80101fa0:	b2 f7                	mov    $0xf7,%dl
80101fa2:	b8 30 00 00 00       	mov    $0x30,%eax
80101fa7:	ee                   	out    %al,(%dx)
}

static inline void
outsl(int port, const void *addr, int cnt)
{
  asm volatile("cld; rep outsl" :
80101fa8:	b9 80 00 00 00       	mov    $0x80,%ecx
  outb(0x1f4, (sector >> 8) & 0xff);
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
80101fad:	83 c6 5c             	add    $0x5c,%esi
80101fb0:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101fb5:	fc                   	cld    
80101fb6:	f3 6f                	rep outsl %ds:(%esi),(%dx)
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101fb8:	83 c4 10             	add    $0x10,%esp
80101fbb:	5b                   	pop    %ebx
80101fbc:	5e                   	pop    %esi
80101fbd:	5d                   	pop    %ebp
80101fbe:	c3                   	ret    
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
  if(b->blockno >= FSSIZE)
    panic("incorrect blockno");
80101fbf:	c7 04 24 80 6f 10 80 	movl   $0x80106f80,(%esp)
80101fc6:	e8 95 e3 ff ff       	call   80100360 <panic>
// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
80101fcb:	c7 04 24 77 6f 10 80 	movl   $0x80106f77,(%esp)
80101fd2:	e8 89 e3 ff ff       	call   80100360 <panic>
80101fd7:	89 f6                	mov    %esi,%esi
80101fd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101fe0 <ideinit>:
  return 0;
}

void
ideinit(void)
{
80101fe0:	55                   	push   %ebp
80101fe1:	89 e5                	mov    %esp,%ebp
80101fe3:	83 ec 18             	sub    $0x18,%esp
  int i;

  initlock(&idelock, "ide");
80101fe6:	c7 44 24 04 92 6f 10 	movl   $0x80106f92,0x4(%esp)
80101fed:	80 
80101fee:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
80101ff5:	e8 a6 21 00 00       	call   801041a0 <initlock>
  picenable(IRQ_IDE);
80101ffa:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
80102001:	e8 ea 11 00 00       	call   801031f0 <picenable>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102006:	a1 80 2d 11 80       	mov    0x80112d80,%eax
8010200b:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
80102012:	83 e8 01             	sub    $0x1,%eax
80102015:	89 44 24 04          	mov    %eax,0x4(%esp)
80102019:	e8 82 02 00 00       	call   801022a0 <ioapicenable>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010201e:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102023:	90                   	nop
80102024:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102028:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102029:	83 e0 c0             	and    $0xffffffc0,%eax
8010202c:	3c 40                	cmp    $0x40,%al
8010202e:	75 f8                	jne    80102028 <ideinit+0x48>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102030:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102035:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010203a:	ee                   	out    %al,(%dx)
8010203b:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102040:	b2 f7                	mov    $0xf7,%dl
80102042:	eb 09                	jmp    8010204d <ideinit+0x6d>
80102044:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);

  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
80102048:	83 e9 01             	sub    $0x1,%ecx
8010204b:	74 0f                	je     8010205c <ideinit+0x7c>
8010204d:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
8010204e:	84 c0                	test   %al,%al
80102050:	74 f6                	je     80102048 <ideinit+0x68>
      havedisk1 = 1;
80102052:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
80102059:	00 00 00 
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010205c:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102061:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102066:	ee                   	out    %al,(%dx)
    }
  }

  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
}
80102067:	c9                   	leave  
80102068:	c3                   	ret    
80102069:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102070 <ideintr>:
}

// Interrupt handler.
void
ideintr(void)
{
80102070:	55                   	push   %ebp
80102071:	89 e5                	mov    %esp,%ebp
80102073:	57                   	push   %edi
80102074:	56                   	push   %esi
80102075:	53                   	push   %ebx
80102076:	83 ec 1c             	sub    $0x1c,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102079:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
80102080:	e8 9b 21 00 00       	call   80104220 <acquire>
  if((b = idequeue) == 0){
80102085:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
8010208b:	85 db                	test   %ebx,%ebx
8010208d:	74 30                	je     801020bf <ideintr+0x4f>
    release(&idelock);
    // cprintf("spurious IDE interrupt\n");
    return;
  }
  idequeue = b->qnext;
8010208f:	8b 43 58             	mov    0x58(%ebx),%eax
80102092:	a3 64 a5 10 80       	mov    %eax,0x8010a564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102097:	8b 33                	mov    (%ebx),%esi
80102099:	f7 c6 04 00 00 00    	test   $0x4,%esi
8010209f:	74 37                	je     801020d8 <ideintr+0x68>
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
801020a1:	83 e6 fb             	and    $0xfffffffb,%esi
801020a4:	83 ce 02             	or     $0x2,%esi
801020a7:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
801020a9:	89 1c 24             	mov    %ebx,(%esp)
801020ac:	e8 ff 1d 00 00       	call   80103eb0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801020b1:	a1 64 a5 10 80       	mov    0x8010a564,%eax
801020b6:	85 c0                	test   %eax,%eax
801020b8:	74 05                	je     801020bf <ideintr+0x4f>
    idestart(idequeue);
801020ba:	e8 61 fe ff ff       	call   80101f20 <idestart>
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
  if((b = idequeue) == 0){
    release(&idelock);
801020bf:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
801020c6:	e8 85 22 00 00       	call   80104350 <release>
  // Start disk on next buf in queue.
  if(idequeue != 0)
    idestart(idequeue);

  release(&idelock);
}
801020cb:	83 c4 1c             	add    $0x1c,%esp
801020ce:	5b                   	pop    %ebx
801020cf:	5e                   	pop    %esi
801020d0:	5f                   	pop    %edi
801020d1:	5d                   	pop    %ebp
801020d2:	c3                   	ret    
801020d3:	90                   	nop
801020d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020d8:	ba f7 01 00 00       	mov    $0x1f7,%edx
801020dd:	8d 76 00             	lea    0x0(%esi),%esi
801020e0:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801020e1:	89 c1                	mov    %eax,%ecx
801020e3:	83 e1 c0             	and    $0xffffffc0,%ecx
801020e6:	80 f9 40             	cmp    $0x40,%cl
801020e9:	75 f5                	jne    801020e0 <ideintr+0x70>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801020eb:	a8 21                	test   $0x21,%al
801020ed:	75 b2                	jne    801020a1 <ideintr+0x31>
  }
  idequeue = b->qnext;

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
    insl(0x1f0, b->data, BSIZE/4);
801020ef:	8d 7b 5c             	lea    0x5c(%ebx),%edi
}

static inline void
insl(int port, void *addr, int cnt)
{
  asm volatile("cld; rep insl" :
801020f2:	b9 80 00 00 00       	mov    $0x80,%ecx
801020f7:	ba f0 01 00 00       	mov    $0x1f0,%edx
801020fc:	fc                   	cld    
801020fd:	f3 6d                	rep insl (%dx),%es:(%edi)
801020ff:	8b 33                	mov    (%ebx),%esi
80102101:	eb 9e                	jmp    801020a1 <ideintr+0x31>
80102103:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102109:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102110 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102110:	55                   	push   %ebp
80102111:	89 e5                	mov    %esp,%ebp
80102113:	53                   	push   %ebx
80102114:	83 ec 14             	sub    $0x14,%esp
80102117:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010211a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010211d:	89 04 24             	mov    %eax,(%esp)
80102120:	e8 4b 20 00 00       	call   80104170 <holdingsleep>
80102125:	85 c0                	test   %eax,%eax
80102127:	0f 84 9e 00 00 00    	je     801021cb <iderw+0xbb>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010212d:	8b 03                	mov    (%ebx),%eax
8010212f:	83 e0 06             	and    $0x6,%eax
80102132:	83 f8 02             	cmp    $0x2,%eax
80102135:	0f 84 a8 00 00 00    	je     801021e3 <iderw+0xd3>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010213b:	8b 53 04             	mov    0x4(%ebx),%edx
8010213e:	85 d2                	test   %edx,%edx
80102140:	74 0d                	je     8010214f <iderw+0x3f>
80102142:	a1 60 a5 10 80       	mov    0x8010a560,%eax
80102147:	85 c0                	test   %eax,%eax
80102149:	0f 84 88 00 00 00    	je     801021d7 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
8010214f:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
80102156:	e8 c5 20 00 00       	call   80104220 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010215b:	a1 64 a5 10 80       	mov    0x8010a564,%eax
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
80102160:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102167:	85 c0                	test   %eax,%eax
80102169:	75 07                	jne    80102172 <iderw+0x62>
8010216b:	eb 4e                	jmp    801021bb <iderw+0xab>
8010216d:	8d 76 00             	lea    0x0(%esi),%esi
80102170:	89 d0                	mov    %edx,%eax
80102172:	8b 50 58             	mov    0x58(%eax),%edx
80102175:	85 d2                	test   %edx,%edx
80102177:	75 f7                	jne    80102170 <iderw+0x60>
80102179:	83 c0 58             	add    $0x58,%eax
    ;
  *pp = b;
8010217c:	89 18                	mov    %ebx,(%eax)

  // Start disk if necessary.
  if(idequeue == b)
8010217e:	39 1d 64 a5 10 80    	cmp    %ebx,0x8010a564
80102184:	74 3c                	je     801021c2 <iderw+0xb2>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102186:	8b 03                	mov    (%ebx),%eax
80102188:	83 e0 06             	and    $0x6,%eax
8010218b:	83 f8 02             	cmp    $0x2,%eax
8010218e:	74 1a                	je     801021aa <iderw+0x9a>
    sleep(b, &idelock);
80102190:	c7 44 24 04 80 a5 10 	movl   $0x8010a580,0x4(%esp)
80102197:	80 
80102198:	89 1c 24             	mov    %ebx,(%esp)
8010219b:	e8 60 1b 00 00       	call   80103d00 <sleep>
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801021a0:	8b 13                	mov    (%ebx),%edx
801021a2:	83 e2 06             	and    $0x6,%edx
801021a5:	83 fa 02             	cmp    $0x2,%edx
801021a8:	75 e6                	jne    80102190 <iderw+0x80>
    sleep(b, &idelock);
  }

  release(&idelock);
801021aa:	c7 45 08 80 a5 10 80 	movl   $0x8010a580,0x8(%ebp)
}
801021b1:	83 c4 14             	add    $0x14,%esp
801021b4:	5b                   	pop    %ebx
801021b5:	5d                   	pop    %ebp
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
    sleep(b, &idelock);
  }

  release(&idelock);
801021b6:	e9 95 21 00 00       	jmp    80104350 <release>

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801021bb:	b8 64 a5 10 80       	mov    $0x8010a564,%eax
801021c0:	eb ba                	jmp    8010217c <iderw+0x6c>
    ;
  *pp = b;

  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
801021c2:	89 d8                	mov    %ebx,%eax
801021c4:	e8 57 fd ff ff       	call   80101f20 <idestart>
801021c9:	eb bb                	jmp    80102186 <iderw+0x76>
iderw(struct buf *b)
{
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
801021cb:	c7 04 24 96 6f 10 80 	movl   $0x80106f96,(%esp)
801021d2:	e8 89 e1 ff ff       	call   80100360 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
    panic("iderw: ide disk 1 not present");
801021d7:	c7 04 24 c1 6f 10 80 	movl   $0x80106fc1,(%esp)
801021de:	e8 7d e1 ff ff       	call   80100360 <panic>
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
801021e3:	c7 04 24 ac 6f 10 80 	movl   $0x80106fac,(%esp)
801021ea:	e8 71 e1 ff ff       	call   80100360 <panic>
801021ef:	90                   	nop

801021f0 <ioapicinit>:
void
ioapicinit(void)
{
  int i, id, maxintr;

  if(!ismp)
801021f0:	a1 84 27 11 80       	mov    0x80112784,%eax
801021f5:	85 c0                	test   %eax,%eax
801021f7:	0f 84 9b 00 00 00    	je     80102298 <ioapicinit+0xa8>
  ioapic->data = data;
}

void
ioapicinit(void)
{
801021fd:	55                   	push   %ebp
801021fe:	89 e5                	mov    %esp,%ebp
80102200:	56                   	push   %esi
80102201:	53                   	push   %ebx
80102202:	83 ec 10             	sub    $0x10,%esp
  int i, id, maxintr;

  if(!ismp)
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102205:	c7 05 54 26 11 80 00 	movl   $0xfec00000,0x80112654
8010220c:	00 c0 fe 
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
8010220f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102216:	00 00 00 
  return ioapic->data;
80102219:	8b 15 54 26 11 80    	mov    0x80112654,%edx
8010221f:	8b 42 10             	mov    0x10(%edx),%eax
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
80102222:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80102228:	8b 1d 54 26 11 80    	mov    0x80112654,%ebx
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010222e:	0f b6 15 80 27 11 80 	movzbl 0x80112780,%edx

  if(!ismp)
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102235:	c1 e8 10             	shr    $0x10,%eax
80102238:	0f b6 f0             	movzbl %al,%esi

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
  return ioapic->data;
8010223b:	8b 43 10             	mov    0x10(%ebx),%eax
  if(!ismp)
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
8010223e:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102241:	39 c2                	cmp    %eax,%edx
80102243:	74 12                	je     80102257 <ioapicinit+0x67>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102245:	c7 04 24 e0 6f 10 80 	movl   $0x80106fe0,(%esp)
8010224c:	e8 ff e3 ff ff       	call   80100650 <cprintf>
80102251:	8b 1d 54 26 11 80    	mov    0x80112654,%ebx
80102257:	ba 10 00 00 00       	mov    $0x10,%edx
8010225c:	31 c0                	xor    %eax,%eax
8010225e:	eb 02                	jmp    80102262 <ioapicinit+0x72>
80102260:	89 cb                	mov    %ecx,%ebx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102262:	89 13                	mov    %edx,(%ebx)
  ioapic->data = data;
80102264:	8b 1d 54 26 11 80    	mov    0x80112654,%ebx
8010226a:	8d 48 20             	lea    0x20(%eax),%ecx
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
8010226d:	81 c9 00 00 01 00    	or     $0x10000,%ecx
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102273:	83 c0 01             	add    $0x1,%eax

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
80102276:	89 4b 10             	mov    %ecx,0x10(%ebx)
80102279:	8d 4a 01             	lea    0x1(%edx),%ecx
8010227c:	83 c2 02             	add    $0x2,%edx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
8010227f:	89 0b                	mov    %ecx,(%ebx)
  ioapic->data = data;
80102281:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102287:	39 c6                	cmp    %eax,%esi

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
80102289:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102290:	7d ce                	jge    80102260 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80102292:	83 c4 10             	add    $0x10,%esp
80102295:	5b                   	pop    %ebx
80102296:	5e                   	pop    %esi
80102297:	5d                   	pop    %ebp
80102298:	f3 c3                	repz ret 
8010229a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801022a0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
  if(!ismp)
801022a0:	8b 15 84 27 11 80    	mov    0x80112784,%edx
  }
}

void
ioapicenable(int irq, int cpunum)
{
801022a6:	55                   	push   %ebp
801022a7:	89 e5                	mov    %esp,%ebp
801022a9:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!ismp)
801022ac:	85 d2                	test   %edx,%edx
801022ae:	74 29                	je     801022d9 <ioapicenable+0x39>
    return;

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801022b0:	8d 48 20             	lea    0x20(%eax),%ecx
801022b3:	8d 54 00 10          	lea    0x10(%eax,%eax,1),%edx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801022b7:	a1 54 26 11 80       	mov    0x80112654,%eax
801022bc:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
801022be:	a1 54 26 11 80       	mov    0x80112654,%eax

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022c3:	83 c2 01             	add    $0x1,%edx

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
801022c6:	89 48 10             	mov    %ecx,0x10(%eax)

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022c9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801022cc:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
801022ce:	a1 54 26 11 80       	mov    0x80112654,%eax

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022d3:	c1 e1 18             	shl    $0x18,%ecx

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
801022d6:	89 48 10             	mov    %ecx,0x10(%eax)
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
}
801022d9:	5d                   	pop    %ebp
801022da:	c3                   	ret    
801022db:	66 90                	xchg   %ax,%ax
801022dd:	66 90                	xchg   %ax,%ax
801022df:	90                   	nop

801022e0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801022e0:	55                   	push   %ebp
801022e1:	89 e5                	mov    %esp,%ebp
801022e3:	53                   	push   %ebx
801022e4:	83 ec 14             	sub    $0x14,%esp
801022e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801022ea:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801022f0:	75 7c                	jne    8010236e <kfree+0x8e>
801022f2:	81 fb 28 6c 11 80    	cmp    $0x80116c28,%ebx
801022f8:	72 74                	jb     8010236e <kfree+0x8e>
801022fa:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102300:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102305:	77 67                	ja     8010236e <kfree+0x8e>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102307:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010230e:	00 
8010230f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102316:	00 
80102317:	89 1c 24             	mov    %ebx,(%esp)
8010231a:	e8 81 20 00 00       	call   801043a0 <memset>

  if(kmem.use_lock)
8010231f:	8b 15 94 26 11 80    	mov    0x80112694,%edx
80102325:	85 d2                	test   %edx,%edx
80102327:	75 37                	jne    80102360 <kfree+0x80>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102329:	a1 98 26 11 80       	mov    0x80112698,%eax
8010232e:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
80102330:	a1 94 26 11 80       	mov    0x80112694,%eax

  if(kmem.use_lock)
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
80102335:	89 1d 98 26 11 80    	mov    %ebx,0x80112698
  if(kmem.use_lock)
8010233b:	85 c0                	test   %eax,%eax
8010233d:	75 09                	jne    80102348 <kfree+0x68>
    release(&kmem.lock);
}
8010233f:	83 c4 14             	add    $0x14,%esp
80102342:	5b                   	pop    %ebx
80102343:	5d                   	pop    %ebp
80102344:	c3                   	ret    
80102345:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
80102348:	c7 45 08 60 26 11 80 	movl   $0x80112660,0x8(%ebp)
}
8010234f:	83 c4 14             	add    $0x14,%esp
80102352:	5b                   	pop    %ebx
80102353:	5d                   	pop    %ebp
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
80102354:	e9 f7 1f 00 00       	jmp    80104350 <release>
80102359:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);

  if(kmem.use_lock)
    acquire(&kmem.lock);
80102360:	c7 04 24 60 26 11 80 	movl   $0x80112660,(%esp)
80102367:	e8 b4 1e 00 00       	call   80104220 <acquire>
8010236c:	eb bb                	jmp    80102329 <kfree+0x49>
kfree(char *v)
{
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
    panic("kfree");
8010236e:	c7 04 24 12 70 10 80 	movl   $0x80107012,(%esp)
80102375:	e8 e6 df ff ff       	call   80100360 <panic>
8010237a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102380 <freerange>:
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
80102380:	55                   	push   %ebp
80102381:	89 e5                	mov    %esp,%ebp
80102383:	56                   	push   %esi
80102384:	53                   	push   %ebx
80102385:	83 ec 10             	sub    $0x10,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102388:	8b 45 08             	mov    0x8(%ebp),%eax
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
8010238b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010238e:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
80102394:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010239a:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
801023a0:	39 de                	cmp    %ebx,%esi
801023a2:	73 08                	jae    801023ac <freerange+0x2c>
801023a4:	eb 18                	jmp    801023be <freerange+0x3e>
801023a6:	66 90                	xchg   %ax,%ax
801023a8:	89 da                	mov    %ebx,%edx
801023aa:	89 c3                	mov    %eax,%ebx
    kfree(p);
801023ac:	89 14 24             	mov    %edx,(%esp)
801023af:	e8 2c ff ff ff       	call   801022e0 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023b4:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
801023ba:	39 f0                	cmp    %esi,%eax
801023bc:	76 ea                	jbe    801023a8 <freerange+0x28>
    kfree(p);
}
801023be:	83 c4 10             	add    $0x10,%esp
801023c1:	5b                   	pop    %ebx
801023c2:	5e                   	pop    %esi
801023c3:	5d                   	pop    %ebp
801023c4:	c3                   	ret    
801023c5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801023c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801023d0 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
801023d0:	55                   	push   %ebp
801023d1:	89 e5                	mov    %esp,%ebp
801023d3:	56                   	push   %esi
801023d4:	53                   	push   %ebx
801023d5:	83 ec 10             	sub    $0x10,%esp
801023d8:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801023db:	c7 44 24 04 18 70 10 	movl   $0x80107018,0x4(%esp)
801023e2:	80 
801023e3:	c7 04 24 60 26 11 80 	movl   $0x80112660,(%esp)
801023ea:	e8 b1 1d 00 00       	call   801041a0 <initlock>

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801023ef:	8b 45 08             	mov    0x8(%ebp),%eax
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
801023f2:	c7 05 94 26 11 80 00 	movl   $0x0,0x80112694
801023f9:	00 00 00 

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801023fc:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
80102402:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102408:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
8010240e:	39 de                	cmp    %ebx,%esi
80102410:	73 0a                	jae    8010241c <kinit1+0x4c>
80102412:	eb 1a                	jmp    8010242e <kinit1+0x5e>
80102414:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102418:	89 da                	mov    %ebx,%edx
8010241a:	89 c3                	mov    %eax,%ebx
    kfree(p);
8010241c:	89 14 24             	mov    %edx,(%esp)
8010241f:	e8 bc fe ff ff       	call   801022e0 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102424:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
8010242a:	39 c6                	cmp    %eax,%esi
8010242c:	73 ea                	jae    80102418 <kinit1+0x48>
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
  freerange(vstart, vend);
}
8010242e:	83 c4 10             	add    $0x10,%esp
80102431:	5b                   	pop    %ebx
80102432:	5e                   	pop    %esi
80102433:	5d                   	pop    %ebp
80102434:	c3                   	ret    
80102435:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102439:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102440 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102440:	55                   	push   %ebp
80102441:	89 e5                	mov    %esp,%ebp
80102443:	56                   	push   %esi
80102444:	53                   	push   %ebx
80102445:	83 ec 10             	sub    $0x10,%esp

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102448:	8b 45 08             	mov    0x8(%ebp),%eax
  freerange(vstart, vend);
}

void
kinit2(void *vstart, void *vend)
{
8010244b:	8b 75 0c             	mov    0xc(%ebp),%esi

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010244e:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
80102454:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010245a:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
80102460:	39 de                	cmp    %ebx,%esi
80102462:	73 08                	jae    8010246c <kinit2+0x2c>
80102464:	eb 18                	jmp    8010247e <kinit2+0x3e>
80102466:	66 90                	xchg   %ax,%ax
80102468:	89 da                	mov    %ebx,%edx
8010246a:	89 c3                	mov    %eax,%ebx
    kfree(p);
8010246c:	89 14 24             	mov    %edx,(%esp)
8010246f:	e8 6c fe ff ff       	call   801022e0 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102474:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
8010247a:	39 c6                	cmp    %eax,%esi
8010247c:	73 ea                	jae    80102468 <kinit2+0x28>

void
kinit2(void *vstart, void *vend)
{
  freerange(vstart, vend);
  kmem.use_lock = 1;
8010247e:	c7 05 94 26 11 80 01 	movl   $0x1,0x80112694
80102485:	00 00 00 
}
80102488:	83 c4 10             	add    $0x10,%esp
8010248b:	5b                   	pop    %ebx
8010248c:	5e                   	pop    %esi
8010248d:	5d                   	pop    %ebp
8010248e:	c3                   	ret    
8010248f:	90                   	nop

80102490 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102490:	55                   	push   %ebp
80102491:	89 e5                	mov    %esp,%ebp
80102493:	53                   	push   %ebx
80102494:	83 ec 14             	sub    $0x14,%esp
  struct run *r;

  if(kmem.use_lock)
80102497:	a1 94 26 11 80       	mov    0x80112694,%eax
8010249c:	85 c0                	test   %eax,%eax
8010249e:	75 30                	jne    801024d0 <kalloc+0x40>
    acquire(&kmem.lock);
  r = kmem.freelist;
801024a0:	8b 1d 98 26 11 80    	mov    0x80112698,%ebx
  if(r)
801024a6:	85 db                	test   %ebx,%ebx
801024a8:	74 08                	je     801024b2 <kalloc+0x22>
    kmem.freelist = r->next;
801024aa:	8b 13                	mov    (%ebx),%edx
801024ac:	89 15 98 26 11 80    	mov    %edx,0x80112698
  if(kmem.use_lock)
801024b2:	85 c0                	test   %eax,%eax
801024b4:	74 0c                	je     801024c2 <kalloc+0x32>
    release(&kmem.lock);
801024b6:	c7 04 24 60 26 11 80 	movl   $0x80112660,(%esp)
801024bd:	e8 8e 1e 00 00       	call   80104350 <release>
  return (char*)r;
}
801024c2:	83 c4 14             	add    $0x14,%esp
801024c5:	89 d8                	mov    %ebx,%eax
801024c7:	5b                   	pop    %ebx
801024c8:	5d                   	pop    %ebp
801024c9:	c3                   	ret    
801024ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
    acquire(&kmem.lock);
801024d0:	c7 04 24 60 26 11 80 	movl   $0x80112660,(%esp)
801024d7:	e8 44 1d 00 00       	call   80104220 <acquire>
801024dc:	a1 94 26 11 80       	mov    0x80112694,%eax
801024e1:	eb bd                	jmp    801024a0 <kalloc+0x10>
801024e3:	66 90                	xchg   %ax,%ax
801024e5:	66 90                	xchg   %ax,%ax
801024e7:	66 90                	xchg   %ax,%ax
801024e9:	66 90                	xchg   %ax,%ax
801024eb:	66 90                	xchg   %ax,%ax
801024ed:	66 90                	xchg   %ax,%ax
801024ef:	90                   	nop

801024f0 <kbdgetc>:
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801024f0:	ba 64 00 00 00       	mov    $0x64,%edx
801024f5:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801024f6:	a8 01                	test   $0x1,%al
801024f8:	0f 84 ba 00 00 00    	je     801025b8 <kbdgetc+0xc8>
801024fe:	b2 60                	mov    $0x60,%dl
80102500:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102501:	0f b6 c8             	movzbl %al,%ecx

  if(data == 0xE0){
80102504:	81 f9 e0 00 00 00    	cmp    $0xe0,%ecx
8010250a:	0f 84 88 00 00 00    	je     80102598 <kbdgetc+0xa8>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102510:	84 c0                	test   %al,%al
80102512:	79 2c                	jns    80102540 <kbdgetc+0x50>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102514:	8b 15 b4 a5 10 80    	mov    0x8010a5b4,%edx
8010251a:	f6 c2 40             	test   $0x40,%dl
8010251d:	75 05                	jne    80102524 <kbdgetc+0x34>
8010251f:	89 c1                	mov    %eax,%ecx
80102521:	83 e1 7f             	and    $0x7f,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80102524:	0f b6 81 40 71 10 80 	movzbl -0x7fef8ec0(%ecx),%eax
8010252b:	83 c8 40             	or     $0x40,%eax
8010252e:	0f b6 c0             	movzbl %al,%eax
80102531:	f7 d0                	not    %eax
80102533:	21 d0                	and    %edx,%eax
80102535:	a3 b4 a5 10 80       	mov    %eax,0x8010a5b4
    return 0;
8010253a:	31 c0                	xor    %eax,%eax
8010253c:	c3                   	ret    
8010253d:	8d 76 00             	lea    0x0(%esi),%esi
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102540:	55                   	push   %ebp
80102541:	89 e5                	mov    %esp,%ebp
80102543:	53                   	push   %ebx
80102544:	8b 1d b4 a5 10 80    	mov    0x8010a5b4,%ebx
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
8010254a:	f6 c3 40             	test   $0x40,%bl
8010254d:	74 09                	je     80102558 <kbdgetc+0x68>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
8010254f:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102552:	83 e3 bf             	and    $0xffffffbf,%ebx
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102555:	0f b6 c8             	movzbl %al,%ecx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
80102558:	0f b6 91 40 71 10 80 	movzbl -0x7fef8ec0(%ecx),%edx
  shift ^= togglecode[data];
8010255f:	0f b6 81 40 70 10 80 	movzbl -0x7fef8fc0(%ecx),%eax
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
80102566:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
80102568:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010256a:	89 d0                	mov    %edx,%eax
8010256c:	83 e0 03             	and    $0x3,%eax
8010256f:	8b 04 85 20 70 10 80 	mov    -0x7fef8fe0(,%eax,4),%eax
    data |= 0x80;
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
80102576:	89 15 b4 a5 10 80    	mov    %edx,0x8010a5b4
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
8010257c:	83 e2 08             	and    $0x8,%edx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
8010257f:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
80102583:	74 0b                	je     80102590 <kbdgetc+0xa0>
    if('a' <= c && c <= 'z')
80102585:	8d 50 9f             	lea    -0x61(%eax),%edx
80102588:	83 fa 19             	cmp    $0x19,%edx
8010258b:	77 1b                	ja     801025a8 <kbdgetc+0xb8>
      c += 'A' - 'a';
8010258d:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102590:	5b                   	pop    %ebx
80102591:	5d                   	pop    %ebp
80102592:	c3                   	ret    
80102593:	90                   	nop
80102594:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if((st & KBS_DIB) == 0)
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80102598:	83 0d b4 a5 10 80 40 	orl    $0x40,0x8010a5b4
    return 0;
8010259f:	31 c0                	xor    %eax,%eax
801025a1:	c3                   	ret    
801025a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
801025a8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801025ab:	8d 50 20             	lea    0x20(%eax),%edx
801025ae:	83 f9 19             	cmp    $0x19,%ecx
801025b1:	0f 46 c2             	cmovbe %edx,%eax
  }
  return c;
801025b4:	eb da                	jmp    80102590 <kbdgetc+0xa0>
801025b6:	66 90                	xchg   %ax,%ax
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
    return -1;
801025b8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801025bd:	c3                   	ret    
801025be:	66 90                	xchg   %ax,%ax

801025c0 <kbdintr>:
  return c;
}

void
kbdintr(void)
{
801025c0:	55                   	push   %ebp
801025c1:	89 e5                	mov    %esp,%ebp
801025c3:	83 ec 18             	sub    $0x18,%esp
  consoleintr(kbdgetc);
801025c6:	c7 04 24 f0 24 10 80 	movl   $0x801024f0,(%esp)
801025cd:	e8 de e1 ff ff       	call   801007b0 <consoleintr>
}
801025d2:	c9                   	leave  
801025d3:	c3                   	ret    
801025d4:	66 90                	xchg   %ax,%ax
801025d6:	66 90                	xchg   %ax,%ax
801025d8:	66 90                	xchg   %ax,%ax
801025da:	66 90                	xchg   %ax,%ax
801025dc:	66 90                	xchg   %ax,%ax
801025de:	66 90                	xchg   %ax,%ax

801025e0 <fill_rtcdate>:

  return inb(CMOS_RETURN);
}

static void fill_rtcdate(struct rtcdate *r)
{
801025e0:	55                   	push   %ebp
801025e1:	89 c1                	mov    %eax,%ecx
801025e3:	89 e5                	mov    %esp,%ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801025e5:	ba 70 00 00 00       	mov    $0x70,%edx
801025ea:	53                   	push   %ebx
801025eb:	31 c0                	xor    %eax,%eax
801025ed:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801025ee:	bb 71 00 00 00       	mov    $0x71,%ebx
801025f3:	89 da                	mov    %ebx,%edx
801025f5:	ec                   	in     (%dx),%al
static uint cmos_read(uint reg)
{
  outb(CMOS_PORT,  reg);
  microdelay(200);

  return inb(CMOS_RETURN);
801025f6:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801025f9:	b2 70                	mov    $0x70,%dl
801025fb:	89 01                	mov    %eax,(%ecx)
801025fd:	b8 02 00 00 00       	mov    $0x2,%eax
80102602:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102603:	89 da                	mov    %ebx,%edx
80102605:	ec                   	in     (%dx),%al
80102606:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102609:	b2 70                	mov    $0x70,%dl
8010260b:	89 41 04             	mov    %eax,0x4(%ecx)
8010260e:	b8 04 00 00 00       	mov    $0x4,%eax
80102613:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102614:	89 da                	mov    %ebx,%edx
80102616:	ec                   	in     (%dx),%al
80102617:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010261a:	b2 70                	mov    $0x70,%dl
8010261c:	89 41 08             	mov    %eax,0x8(%ecx)
8010261f:	b8 07 00 00 00       	mov    $0x7,%eax
80102624:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102625:	89 da                	mov    %ebx,%edx
80102627:	ec                   	in     (%dx),%al
80102628:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010262b:	b2 70                	mov    $0x70,%dl
8010262d:	89 41 0c             	mov    %eax,0xc(%ecx)
80102630:	b8 08 00 00 00       	mov    $0x8,%eax
80102635:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102636:	89 da                	mov    %ebx,%edx
80102638:	ec                   	in     (%dx),%al
80102639:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010263c:	b2 70                	mov    $0x70,%dl
8010263e:	89 41 10             	mov    %eax,0x10(%ecx)
80102641:	b8 09 00 00 00       	mov    $0x9,%eax
80102646:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102647:	89 da                	mov    %ebx,%edx
80102649:	ec                   	in     (%dx),%al
8010264a:	0f b6 d8             	movzbl %al,%ebx
8010264d:	89 59 14             	mov    %ebx,0x14(%ecx)
  r->minute = cmos_read(MINS);
  r->hour   = cmos_read(HOURS);
  r->day    = cmos_read(DAY);
  r->month  = cmos_read(MONTH);
  r->year   = cmos_read(YEAR);
}
80102650:	5b                   	pop    %ebx
80102651:	5d                   	pop    %ebp
80102652:	c3                   	ret    
80102653:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102659:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102660 <lapicinit>:
//PAGEBREAK!

void
lapicinit(void)
{
  if(!lapic)
80102660:	a1 9c 26 11 80       	mov    0x8011269c,%eax
}
//PAGEBREAK!

void
lapicinit(void)
{
80102665:	55                   	push   %ebp
80102666:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102668:	85 c0                	test   %eax,%eax
8010266a:	0f 84 c0 00 00 00    	je     80102730 <lapicinit+0xd0>
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102670:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102677:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010267a:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010267d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102684:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102687:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010268a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102691:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102694:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102697:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010269e:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
801026a1:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026a4:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
801026ab:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801026ae:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026b1:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
801026b8:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801026bb:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801026be:	8b 50 30             	mov    0x30(%eax),%edx
801026c1:	c1 ea 10             	shr    $0x10,%edx
801026c4:	80 fa 03             	cmp    $0x3,%dl
801026c7:	77 6f                	ja     80102738 <lapicinit+0xd8>
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026c9:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
801026d0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026d3:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026d6:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801026dd:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026e0:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026e3:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801026ea:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026ed:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026f0:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801026f7:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026fa:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026fd:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102704:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102707:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010270a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102711:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102714:	8b 50 20             	mov    0x20(%eax),%edx
80102717:	90                   	nop
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102718:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
8010271e:	80 e6 10             	and    $0x10,%dh
80102721:	75 f5                	jne    80102718 <lapicinit+0xb8>
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102723:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
8010272a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010272d:	8b 40 20             	mov    0x20(%eax),%eax
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102730:	5d                   	pop    %ebp
80102731:	c3                   	ret    
80102732:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102738:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
8010273f:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102742:	8b 50 20             	mov    0x20(%eax),%edx
80102745:	eb 82                	jmp    801026c9 <lapicinit+0x69>
80102747:	89 f6                	mov    %esi,%esi
80102749:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102750 <cpunum>:
  lapicw(TPR, 0);
}

int
cpunum(void)
{
80102750:	55                   	push   %ebp
80102751:	89 e5                	mov    %esp,%ebp
80102753:	56                   	push   %esi
80102754:	53                   	push   %ebx
80102755:	83 ec 10             	sub    $0x10,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80102758:	9c                   	pushf  
80102759:	58                   	pop    %eax
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
8010275a:	f6 c4 02             	test   $0x2,%ah
8010275d:	74 12                	je     80102771 <cpunum+0x21>
    static int n;
    if(n++ == 0)
8010275f:	a1 b8 a5 10 80       	mov    0x8010a5b8,%eax
80102764:	8d 50 01             	lea    0x1(%eax),%edx
80102767:	85 c0                	test   %eax,%eax
80102769:	89 15 b8 a5 10 80    	mov    %edx,0x8010a5b8
8010276f:	74 4a                	je     801027bb <cpunum+0x6b>
      cprintf("cpu called from %x with interrupts enabled\n",
        __builtin_return_address(0));
  }

  if (!lapic)
80102771:	a1 9c 26 11 80       	mov    0x8011269c,%eax
80102776:	85 c0                	test   %eax,%eax
80102778:	74 5d                	je     801027d7 <cpunum+0x87>
    return 0;

  apicid = lapic[ID] >> 24;
8010277a:	8b 58 20             	mov    0x20(%eax),%ebx
  for (i = 0; i < ncpu; ++i) {
8010277d:	8b 35 80 2d 11 80    	mov    0x80112d80,%esi
  }

  if (!lapic)
    return 0;

  apicid = lapic[ID] >> 24;
80102783:	c1 eb 18             	shr    $0x18,%ebx
  for (i = 0; i < ncpu; ++i) {
80102786:	85 f6                	test   %esi,%esi
80102788:	7e 56                	jle    801027e0 <cpunum+0x90>
    if (cpus[i].apicid == apicid)
8010278a:	0f b6 05 a0 27 11 80 	movzbl 0x801127a0,%eax
80102791:	39 d8                	cmp    %ebx,%eax
80102793:	74 42                	je     801027d7 <cpunum+0x87>
80102795:	ba 5c 28 11 80       	mov    $0x8011285c,%edx

  if (!lapic)
    return 0;

  apicid = lapic[ID] >> 24;
  for (i = 0; i < ncpu; ++i) {
8010279a:	31 c0                	xor    %eax,%eax
8010279c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801027a0:	83 c0 01             	add    $0x1,%eax
801027a3:	39 f0                	cmp    %esi,%eax
801027a5:	74 39                	je     801027e0 <cpunum+0x90>
    if (cpus[i].apicid == apicid)
801027a7:	0f b6 0a             	movzbl (%edx),%ecx
801027aa:	81 c2 bc 00 00 00    	add    $0xbc,%edx
801027b0:	39 d9                	cmp    %ebx,%ecx
801027b2:	75 ec                	jne    801027a0 <cpunum+0x50>
      return i;
  }
  panic("unknown apicid\n");
}
801027b4:	83 c4 10             	add    $0x10,%esp
801027b7:	5b                   	pop    %ebx
801027b8:	5e                   	pop    %esi
801027b9:	5d                   	pop    %ebp
801027ba:	c3                   	ret    
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
    static int n;
    if(n++ == 0)
      cprintf("cpu called from %x with interrupts enabled\n",
801027bb:	8b 45 04             	mov    0x4(%ebp),%eax
801027be:	c7 04 24 40 72 10 80 	movl   $0x80107240,(%esp)
801027c5:	89 44 24 04          	mov    %eax,0x4(%esp)
801027c9:	e8 82 de ff ff       	call   80100650 <cprintf>
        __builtin_return_address(0));
  }

  if (!lapic)
801027ce:	a1 9c 26 11 80       	mov    0x8011269c,%eax
801027d3:	85 c0                	test   %eax,%eax
801027d5:	75 a3                	jne    8010277a <cpunum+0x2a>
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return i;
  }
  panic("unknown apicid\n");
}
801027d7:	83 c4 10             	add    $0x10,%esp
      cprintf("cpu called from %x with interrupts enabled\n",
        __builtin_return_address(0));
  }

  if (!lapic)
    return 0;
801027da:	31 c0                	xor    %eax,%eax
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return i;
  }
  panic("unknown apicid\n");
}
801027dc:	5b                   	pop    %ebx
801027dd:	5e                   	pop    %esi
801027de:	5d                   	pop    %ebp
801027df:	c3                   	ret    
  apicid = lapic[ID] >> 24;
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return i;
  }
  panic("unknown apicid\n");
801027e0:	c7 04 24 6c 72 10 80 	movl   $0x8010726c,(%esp)
801027e7:	e8 74 db ff ff       	call   80100360 <panic>
801027ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801027f0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
801027f0:	a1 9c 26 11 80       	mov    0x8011269c,%eax
}

// Acknowledge interrupt.
void
lapiceoi(void)
{
801027f5:	55                   	push   %ebp
801027f6:	89 e5                	mov    %esp,%ebp
  if(lapic)
801027f8:	85 c0                	test   %eax,%eax
801027fa:	74 0d                	je     80102809 <lapiceoi+0x19>
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027fc:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102803:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102806:	8b 40 20             	mov    0x20(%eax),%eax
void
lapiceoi(void)
{
  if(lapic)
    lapicw(EOI, 0);
}
80102809:	5d                   	pop    %ebp
8010280a:	c3                   	ret    
8010280b:	90                   	nop
8010280c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102810 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102810:	55                   	push   %ebp
80102811:	89 e5                	mov    %esp,%ebp
}
80102813:	5d                   	pop    %ebp
80102814:	c3                   	ret    
80102815:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102819:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102820 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102820:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102821:	ba 70 00 00 00       	mov    $0x70,%edx
80102826:	89 e5                	mov    %esp,%ebp
80102828:	b8 0f 00 00 00       	mov    $0xf,%eax
8010282d:	53                   	push   %ebx
8010282e:	8b 4d 08             	mov    0x8(%ebp),%ecx
80102831:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80102834:	ee                   	out    %al,(%dx)
80102835:	b8 0a 00 00 00       	mov    $0xa,%eax
8010283a:	b2 71                	mov    $0x71,%dl
8010283c:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
8010283d:	31 c0                	xor    %eax,%eax
8010283f:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102845:	89 d8                	mov    %ebx,%eax
80102847:	c1 e8 04             	shr    $0x4,%eax
8010284a:	66 a3 69 04 00 80    	mov    %ax,0x80000469
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102850:	a1 9c 26 11 80       	mov    0x8011269c,%eax
  wrv[0] = 0;
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102855:	c1 e1 18             	shl    $0x18,%ecx
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102858:	c1 eb 0c             	shr    $0xc,%ebx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010285b:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102861:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102864:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
8010286b:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010286e:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102871:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102878:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010287b:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010287e:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102884:	8b 50 20             	mov    0x20(%eax),%edx
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102887:	89 da                	mov    %ebx,%edx
80102889:	80 ce 06             	or     $0x6,%dh
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010288c:	89 90 00 03 00 00    	mov    %edx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102892:	8b 58 20             	mov    0x20(%eax),%ebx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102895:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010289b:	8b 48 20             	mov    0x20(%eax),%ecx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010289e:	89 90 00 03 00 00    	mov    %edx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801028a4:	8b 40 20             	mov    0x20(%eax),%eax
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
801028a7:	5b                   	pop    %ebx
801028a8:	5d                   	pop    %ebp
801028a9:	c3                   	ret    
801028aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801028b0 <cmostime>:
  r->year   = cmos_read(YEAR);
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
801028b0:	55                   	push   %ebp
801028b1:	ba 70 00 00 00       	mov    $0x70,%edx
801028b6:	89 e5                	mov    %esp,%ebp
801028b8:	b8 0b 00 00 00       	mov    $0xb,%eax
801028bd:	57                   	push   %edi
801028be:	56                   	push   %esi
801028bf:	53                   	push   %ebx
801028c0:	83 ec 4c             	sub    $0x4c,%esp
801028c3:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028c4:	b2 71                	mov    $0x71,%dl
801028c6:	ec                   	in     (%dx),%al
801028c7:	88 45 b7             	mov    %al,-0x49(%ebp)
801028ca:	8d 5d b8             	lea    -0x48(%ebp),%ebx
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
801028cd:	80 65 b7 04          	andb   $0x4,-0x49(%ebp)
801028d1:	8d 7d d0             	lea    -0x30(%ebp),%edi
801028d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028d8:	be 70 00 00 00       	mov    $0x70,%esi

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
801028dd:	89 d8                	mov    %ebx,%eax
801028df:	e8 fc fc ff ff       	call   801025e0 <fill_rtcdate>
801028e4:	b8 0a 00 00 00       	mov    $0xa,%eax
801028e9:	89 f2                	mov    %esi,%edx
801028eb:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028ec:	ba 71 00 00 00       	mov    $0x71,%edx
801028f1:	ec                   	in     (%dx),%al
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
801028f2:	84 c0                	test   %al,%al
801028f4:	78 e7                	js     801028dd <cmostime+0x2d>
        continue;
    fill_rtcdate(&t2);
801028f6:	89 f8                	mov    %edi,%eax
801028f8:	e8 e3 fc ff ff       	call   801025e0 <fill_rtcdate>
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
801028fd:	c7 44 24 08 18 00 00 	movl   $0x18,0x8(%esp)
80102904:	00 
80102905:	89 7c 24 04          	mov    %edi,0x4(%esp)
80102909:	89 1c 24             	mov    %ebx,(%esp)
8010290c:	e8 df 1a 00 00       	call   801043f0 <memcmp>
80102911:	85 c0                	test   %eax,%eax
80102913:	75 c3                	jne    801028d8 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102915:	80 7d b7 00          	cmpb   $0x0,-0x49(%ebp)
80102919:	75 78                	jne    80102993 <cmostime+0xe3>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
8010291b:	8b 45 b8             	mov    -0x48(%ebp),%eax
8010291e:	89 c2                	mov    %eax,%edx
80102920:	83 e0 0f             	and    $0xf,%eax
80102923:	c1 ea 04             	shr    $0x4,%edx
80102926:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102929:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010292c:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
8010292f:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102932:	89 c2                	mov    %eax,%edx
80102934:	83 e0 0f             	and    $0xf,%eax
80102937:	c1 ea 04             	shr    $0x4,%edx
8010293a:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010293d:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102940:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102943:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102946:	89 c2                	mov    %eax,%edx
80102948:	83 e0 0f             	and    $0xf,%eax
8010294b:	c1 ea 04             	shr    $0x4,%edx
8010294e:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102951:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102954:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102957:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010295a:	89 c2                	mov    %eax,%edx
8010295c:	83 e0 0f             	and    $0xf,%eax
8010295f:	c1 ea 04             	shr    $0x4,%edx
80102962:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102965:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102968:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
8010296b:	8b 45 c8             	mov    -0x38(%ebp),%eax
8010296e:	89 c2                	mov    %eax,%edx
80102970:	83 e0 0f             	and    $0xf,%eax
80102973:	c1 ea 04             	shr    $0x4,%edx
80102976:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102979:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010297c:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
8010297f:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102982:	89 c2                	mov    %eax,%edx
80102984:	83 e0 0f             	and    $0xf,%eax
80102987:	c1 ea 04             	shr    $0x4,%edx
8010298a:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010298d:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102990:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102993:	8b 4d 08             	mov    0x8(%ebp),%ecx
80102996:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102999:	89 01                	mov    %eax,(%ecx)
8010299b:	8b 45 bc             	mov    -0x44(%ebp),%eax
8010299e:	89 41 04             	mov    %eax,0x4(%ecx)
801029a1:	8b 45 c0             	mov    -0x40(%ebp),%eax
801029a4:	89 41 08             	mov    %eax,0x8(%ecx)
801029a7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801029aa:	89 41 0c             	mov    %eax,0xc(%ecx)
801029ad:	8b 45 c8             	mov    -0x38(%ebp),%eax
801029b0:	89 41 10             	mov    %eax,0x10(%ecx)
801029b3:	8b 45 cc             	mov    -0x34(%ebp),%eax
801029b6:	89 41 14             	mov    %eax,0x14(%ecx)
  r->year += 2000;
801029b9:	81 41 14 d0 07 00 00 	addl   $0x7d0,0x14(%ecx)
}
801029c0:	83 c4 4c             	add    $0x4c,%esp
801029c3:	5b                   	pop    %ebx
801029c4:	5e                   	pop    %esi
801029c5:	5f                   	pop    %edi
801029c6:	5d                   	pop    %ebp
801029c7:	c3                   	ret    
801029c8:	66 90                	xchg   %ax,%ax
801029ca:	66 90                	xchg   %ax,%ax
801029cc:	66 90                	xchg   %ax,%ax
801029ce:	66 90                	xchg   %ax,%ax

801029d0 <install_trans>:
}

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
801029d0:	55                   	push   %ebp
801029d1:	89 e5                	mov    %esp,%ebp
801029d3:	57                   	push   %edi
801029d4:	56                   	push   %esi
801029d5:	53                   	push   %ebx
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801029d6:	31 db                	xor    %ebx,%ebx
}

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
801029d8:	83 ec 1c             	sub    $0x1c,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801029db:	a1 e8 26 11 80       	mov    0x801126e8,%eax
801029e0:	85 c0                	test   %eax,%eax
801029e2:	7e 78                	jle    80102a5c <install_trans+0x8c>
801029e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
801029e8:	a1 d4 26 11 80       	mov    0x801126d4,%eax
801029ed:	01 d8                	add    %ebx,%eax
801029ef:	83 c0 01             	add    $0x1,%eax
801029f2:	89 44 24 04          	mov    %eax,0x4(%esp)
801029f6:	a1 e4 26 11 80       	mov    0x801126e4,%eax
801029fb:	89 04 24             	mov    %eax,(%esp)
801029fe:	e8 cd d6 ff ff       	call   801000d0 <bread>
80102a03:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102a05:	8b 04 9d ec 26 11 80 	mov    -0x7feed914(,%ebx,4),%eax
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102a0c:	83 c3 01             	add    $0x1,%ebx
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102a0f:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a13:	a1 e4 26 11 80       	mov    0x801126e4,%eax
80102a18:	89 04 24             	mov    %eax,(%esp)
80102a1b:	e8 b0 d6 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102a20:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80102a27:	00 
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102a28:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102a2a:	8d 47 5c             	lea    0x5c(%edi),%eax
80102a2d:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a31:	8d 46 5c             	lea    0x5c(%esi),%eax
80102a34:	89 04 24             	mov    %eax,(%esp)
80102a37:	e8 04 1a 00 00       	call   80104440 <memmove>
    bwrite(dbuf);  // write dst to disk
80102a3c:	89 34 24             	mov    %esi,(%esp)
80102a3f:	e8 5c d7 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102a44:	89 3c 24             	mov    %edi,(%esp)
80102a47:	e8 94 d7 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102a4c:	89 34 24             	mov    %esi,(%esp)
80102a4f:	e8 8c d7 ff ff       	call   801001e0 <brelse>
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102a54:	39 1d e8 26 11 80    	cmp    %ebx,0x801126e8
80102a5a:	7f 8c                	jg     801029e8 <install_trans+0x18>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf);
    brelse(dbuf);
  }
}
80102a5c:	83 c4 1c             	add    $0x1c,%esp
80102a5f:	5b                   	pop    %ebx
80102a60:	5e                   	pop    %esi
80102a61:	5f                   	pop    %edi
80102a62:	5d                   	pop    %ebp
80102a63:	c3                   	ret    
80102a64:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102a6a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80102a70 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102a70:	55                   	push   %ebp
80102a71:	89 e5                	mov    %esp,%ebp
80102a73:	57                   	push   %edi
80102a74:	56                   	push   %esi
80102a75:	53                   	push   %ebx
80102a76:	83 ec 1c             	sub    $0x1c,%esp
  struct buf *buf = bread(log.dev, log.start);
80102a79:	a1 d4 26 11 80       	mov    0x801126d4,%eax
80102a7e:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a82:	a1 e4 26 11 80       	mov    0x801126e4,%eax
80102a87:	89 04 24             	mov    %eax,(%esp)
80102a8a:	e8 41 d6 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102a8f:	8b 1d e8 26 11 80    	mov    0x801126e8,%ebx
  for (i = 0; i < log.lh.n; i++) {
80102a95:	31 d2                	xor    %edx,%edx
80102a97:	85 db                	test   %ebx,%ebx
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102a99:	89 c7                	mov    %eax,%edi
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102a9b:	89 58 5c             	mov    %ebx,0x5c(%eax)
80102a9e:	8d 70 5c             	lea    0x5c(%eax),%esi
  for (i = 0; i < log.lh.n; i++) {
80102aa1:	7e 17                	jle    80102aba <write_head+0x4a>
80102aa3:	90                   	nop
80102aa4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80102aa8:	8b 0c 95 ec 26 11 80 	mov    -0x7feed914(,%edx,4),%ecx
80102aaf:	89 4c 96 04          	mov    %ecx,0x4(%esi,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102ab3:	83 c2 01             	add    $0x1,%edx
80102ab6:	39 da                	cmp    %ebx,%edx
80102ab8:	75 ee                	jne    80102aa8 <write_head+0x38>
    hb->block[i] = log.lh.block[i];
  }
  bwrite(buf);
80102aba:	89 3c 24             	mov    %edi,(%esp)
80102abd:	e8 de d6 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102ac2:	89 3c 24             	mov    %edi,(%esp)
80102ac5:	e8 16 d7 ff ff       	call   801001e0 <brelse>
}
80102aca:	83 c4 1c             	add    $0x1c,%esp
80102acd:	5b                   	pop    %ebx
80102ace:	5e                   	pop    %esi
80102acf:	5f                   	pop    %edi
80102ad0:	5d                   	pop    %ebp
80102ad1:	c3                   	ret    
80102ad2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102ad9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102ae0 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
80102ae0:	55                   	push   %ebp
80102ae1:	89 e5                	mov    %esp,%ebp
80102ae3:	56                   	push   %esi
80102ae4:	53                   	push   %ebx
80102ae5:	83 ec 30             	sub    $0x30,%esp
80102ae8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
80102aeb:	c7 44 24 04 7c 72 10 	movl   $0x8010727c,0x4(%esp)
80102af2:	80 
80102af3:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102afa:	e8 a1 16 00 00       	call   801041a0 <initlock>
  readsb(dev, &sb);
80102aff:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102b02:	89 44 24 04          	mov    %eax,0x4(%esp)
80102b06:	89 1c 24             	mov    %ebx,(%esp)
80102b09:	e8 82 e8 ff ff       	call   80101390 <readsb>
  log.start = sb.logstart;
80102b0e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  log.size = sb.nlog;
80102b11:	8b 55 e8             	mov    -0x18(%ebp),%edx

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102b14:	89 1c 24             	mov    %ebx,(%esp)
  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
80102b17:	89 1d e4 26 11 80    	mov    %ebx,0x801126e4

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102b1d:	89 44 24 04          	mov    %eax,0x4(%esp)

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
80102b21:	89 15 d8 26 11 80    	mov    %edx,0x801126d8
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
80102b27:	a3 d4 26 11 80       	mov    %eax,0x801126d4

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102b2c:	e8 9f d5 ff ff       	call   801000d0 <bread>
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
80102b31:	31 d2                	xor    %edx,%edx
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102b33:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102b36:	8d 70 5c             	lea    0x5c(%eax),%esi
  for (i = 0; i < log.lh.n; i++) {
80102b39:	85 db                	test   %ebx,%ebx
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102b3b:	89 1d e8 26 11 80    	mov    %ebx,0x801126e8
  for (i = 0; i < log.lh.n; i++) {
80102b41:	7e 17                	jle    80102b5a <initlog+0x7a>
80102b43:	90                   	nop
80102b44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    log.lh.block[i] = lh->block[i];
80102b48:	8b 4c 96 04          	mov    0x4(%esi,%edx,4),%ecx
80102b4c:	89 0c 95 ec 26 11 80 	mov    %ecx,-0x7feed914(,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
80102b53:	83 c2 01             	add    $0x1,%edx
80102b56:	39 da                	cmp    %ebx,%edx
80102b58:	75 ee                	jne    80102b48 <initlog+0x68>
    log.lh.block[i] = lh->block[i];
  }
  brelse(buf);
80102b5a:	89 04 24             	mov    %eax,(%esp)
80102b5d:	e8 7e d6 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102b62:	e8 69 fe ff ff       	call   801029d0 <install_trans>
  log.lh.n = 0;
80102b67:	c7 05 e8 26 11 80 00 	movl   $0x0,0x801126e8
80102b6e:	00 00 00 
  write_head(); // clear the log
80102b71:	e8 fa fe ff ff       	call   80102a70 <write_head>
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
  recover_from_log();
}
80102b76:	83 c4 30             	add    $0x30,%esp
80102b79:	5b                   	pop    %ebx
80102b7a:	5e                   	pop    %esi
80102b7b:	5d                   	pop    %ebp
80102b7c:	c3                   	ret    
80102b7d:	8d 76 00             	lea    0x0(%esi),%esi

80102b80 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102b80:	55                   	push   %ebp
80102b81:	89 e5                	mov    %esp,%ebp
80102b83:	83 ec 18             	sub    $0x18,%esp
  acquire(&log.lock);
80102b86:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102b8d:	e8 8e 16 00 00       	call   80104220 <acquire>
80102b92:	eb 18                	jmp    80102bac <begin_op+0x2c>
80102b94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102b98:	c7 44 24 04 a0 26 11 	movl   $0x801126a0,0x4(%esp)
80102b9f:	80 
80102ba0:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102ba7:	e8 54 11 00 00       	call   80103d00 <sleep>
void
begin_op(void)
{
  acquire(&log.lock);
  while(1){
    if(log.committing){
80102bac:	a1 e0 26 11 80       	mov    0x801126e0,%eax
80102bb1:	85 c0                	test   %eax,%eax
80102bb3:	75 e3                	jne    80102b98 <begin_op+0x18>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102bb5:	a1 dc 26 11 80       	mov    0x801126dc,%eax
80102bba:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
80102bc0:	83 c0 01             	add    $0x1,%eax
80102bc3:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102bc6:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102bc9:	83 fa 1e             	cmp    $0x1e,%edx
80102bcc:	7f ca                	jg     80102b98 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102bce:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
80102bd5:	a3 dc 26 11 80       	mov    %eax,0x801126dc
      release(&log.lock);
80102bda:	e8 71 17 00 00       	call   80104350 <release>
      break;
    }
  }
}
80102bdf:	c9                   	leave  
80102be0:	c3                   	ret    
80102be1:	eb 0d                	jmp    80102bf0 <end_op>
80102be3:	90                   	nop
80102be4:	90                   	nop
80102be5:	90                   	nop
80102be6:	90                   	nop
80102be7:	90                   	nop
80102be8:	90                   	nop
80102be9:	90                   	nop
80102bea:	90                   	nop
80102beb:	90                   	nop
80102bec:	90                   	nop
80102bed:	90                   	nop
80102bee:	90                   	nop
80102bef:	90                   	nop

80102bf0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102bf0:	55                   	push   %ebp
80102bf1:	89 e5                	mov    %esp,%ebp
80102bf3:	57                   	push   %edi
80102bf4:	56                   	push   %esi
80102bf5:	53                   	push   %ebx
80102bf6:	83 ec 1c             	sub    $0x1c,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102bf9:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102c00:	e8 1b 16 00 00       	call   80104220 <acquire>
  log.outstanding -= 1;
80102c05:	a1 dc 26 11 80       	mov    0x801126dc,%eax
  if(log.committing)
80102c0a:	8b 15 e0 26 11 80    	mov    0x801126e0,%edx
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80102c10:	83 e8 01             	sub    $0x1,%eax
  if(log.committing)
80102c13:	85 d2                	test   %edx,%edx
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80102c15:	a3 dc 26 11 80       	mov    %eax,0x801126dc
  if(log.committing)
80102c1a:	0f 85 f3 00 00 00    	jne    80102d13 <end_op+0x123>
    panic("log.committing");
  if(log.outstanding == 0){
80102c20:	85 c0                	test   %eax,%eax
80102c22:	0f 85 cb 00 00 00    	jne    80102cf3 <end_op+0x103>
    log.committing = 1;
  } else {
    // begin_op() may be waiting for log space.
    wakeup(&log);
  }
  release(&log.lock);
80102c28:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
}

static void
commit()
{
  if (log.lh.n > 0) {
80102c2f:	31 db                	xor    %ebx,%ebx
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
  if(log.outstanding == 0){
    do_commit = 1;
    log.committing = 1;
80102c31:	c7 05 e0 26 11 80 01 	movl   $0x1,0x801126e0
80102c38:	00 00 00 
  } else {
    // begin_op() may be waiting for log space.
    wakeup(&log);
  }
  release(&log.lock);
80102c3b:	e8 10 17 00 00       	call   80104350 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102c40:	a1 e8 26 11 80       	mov    0x801126e8,%eax
80102c45:	85 c0                	test   %eax,%eax
80102c47:	0f 8e 90 00 00 00    	jle    80102cdd <end_op+0xed>
80102c4d:	8d 76 00             	lea    0x0(%esi),%esi
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102c50:	a1 d4 26 11 80       	mov    0x801126d4,%eax
80102c55:	01 d8                	add    %ebx,%eax
80102c57:	83 c0 01             	add    $0x1,%eax
80102c5a:	89 44 24 04          	mov    %eax,0x4(%esp)
80102c5e:	a1 e4 26 11 80       	mov    0x801126e4,%eax
80102c63:	89 04 24             	mov    %eax,(%esp)
80102c66:	e8 65 d4 ff ff       	call   801000d0 <bread>
80102c6b:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c6d:	8b 04 9d ec 26 11 80 	mov    -0x7feed914(,%ebx,4),%eax
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102c74:	83 c3 01             	add    $0x1,%ebx
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c77:	89 44 24 04          	mov    %eax,0x4(%esp)
80102c7b:	a1 e4 26 11 80       	mov    0x801126e4,%eax
80102c80:	89 04 24             	mov    %eax,(%esp)
80102c83:	e8 48 d4 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102c88:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80102c8f:	00 
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c90:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102c92:	8d 40 5c             	lea    0x5c(%eax),%eax
80102c95:	89 44 24 04          	mov    %eax,0x4(%esp)
80102c99:	8d 46 5c             	lea    0x5c(%esi),%eax
80102c9c:	89 04 24             	mov    %eax,(%esp)
80102c9f:	e8 9c 17 00 00       	call   80104440 <memmove>
    bwrite(to);  // write the log
80102ca4:	89 34 24             	mov    %esi,(%esp)
80102ca7:	e8 f4 d4 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102cac:	89 3c 24             	mov    %edi,(%esp)
80102caf:	e8 2c d5 ff ff       	call   801001e0 <brelse>
    brelse(to);
80102cb4:	89 34 24             	mov    %esi,(%esp)
80102cb7:	e8 24 d5 ff ff       	call   801001e0 <brelse>
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102cbc:	3b 1d e8 26 11 80    	cmp    0x801126e8,%ebx
80102cc2:	7c 8c                	jl     80102c50 <end_op+0x60>
static void
commit()
{
  if (log.lh.n > 0) {
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102cc4:	e8 a7 fd ff ff       	call   80102a70 <write_head>
    install_trans(); // Now install writes to home locations
80102cc9:	e8 02 fd ff ff       	call   801029d0 <install_trans>
    log.lh.n = 0;
80102cce:	c7 05 e8 26 11 80 00 	movl   $0x0,0x801126e8
80102cd5:	00 00 00 
    write_head();    // Erase the transaction from the log
80102cd8:	e8 93 fd ff ff       	call   80102a70 <write_head>

  if(do_commit){
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
    acquire(&log.lock);
80102cdd:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102ce4:	e8 37 15 00 00       	call   80104220 <acquire>
    log.committing = 0;
80102ce9:	c7 05 e0 26 11 80 00 	movl   $0x0,0x801126e0
80102cf0:	00 00 00 
    wakeup(&log);
80102cf3:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102cfa:	e8 b1 11 00 00       	call   80103eb0 <wakeup>
    release(&log.lock);
80102cff:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102d06:	e8 45 16 00 00       	call   80104350 <release>
  }
}
80102d0b:	83 c4 1c             	add    $0x1c,%esp
80102d0e:	5b                   	pop    %ebx
80102d0f:	5e                   	pop    %esi
80102d10:	5f                   	pop    %edi
80102d11:	5d                   	pop    %ebp
80102d12:	c3                   	ret    
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
80102d13:	c7 04 24 80 72 10 80 	movl   $0x80107280,(%esp)
80102d1a:	e8 41 d6 ff ff       	call   80100360 <panic>
80102d1f:	90                   	nop

80102d20 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102d20:	55                   	push   %ebp
80102d21:	89 e5                	mov    %esp,%ebp
80102d23:	53                   	push   %ebx
80102d24:	83 ec 14             	sub    $0x14,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102d27:	a1 e8 26 11 80       	mov    0x801126e8,%eax
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102d2c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102d2f:	83 f8 1d             	cmp    $0x1d,%eax
80102d32:	0f 8f 98 00 00 00    	jg     80102dd0 <log_write+0xb0>
80102d38:	8b 0d d8 26 11 80    	mov    0x801126d8,%ecx
80102d3e:	8d 51 ff             	lea    -0x1(%ecx),%edx
80102d41:	39 d0                	cmp    %edx,%eax
80102d43:	0f 8d 87 00 00 00    	jge    80102dd0 <log_write+0xb0>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102d49:	a1 dc 26 11 80       	mov    0x801126dc,%eax
80102d4e:	85 c0                	test   %eax,%eax
80102d50:	0f 8e 86 00 00 00    	jle    80102ddc <log_write+0xbc>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102d56:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102d5d:	e8 be 14 00 00       	call   80104220 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102d62:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
80102d68:	83 fa 00             	cmp    $0x0,%edx
80102d6b:	7e 54                	jle    80102dc1 <log_write+0xa1>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102d6d:	8b 4b 08             	mov    0x8(%ebx),%ecx
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80102d70:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102d72:	39 0d ec 26 11 80    	cmp    %ecx,0x801126ec
80102d78:	75 0f                	jne    80102d89 <log_write+0x69>
80102d7a:	eb 3c                	jmp    80102db8 <log_write+0x98>
80102d7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102d80:	39 0c 85 ec 26 11 80 	cmp    %ecx,-0x7feed914(,%eax,4)
80102d87:	74 2f                	je     80102db8 <log_write+0x98>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80102d89:	83 c0 01             	add    $0x1,%eax
80102d8c:	39 d0                	cmp    %edx,%eax
80102d8e:	75 f0                	jne    80102d80 <log_write+0x60>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80102d90:	89 0c 95 ec 26 11 80 	mov    %ecx,-0x7feed914(,%edx,4)
  if (i == log.lh.n)
    log.lh.n++;
80102d97:	83 c2 01             	add    $0x1,%edx
80102d9a:	89 15 e8 26 11 80    	mov    %edx,0x801126e8
  b->flags |= B_DIRTY; // prevent eviction
80102da0:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102da3:	c7 45 08 a0 26 11 80 	movl   $0x801126a0,0x8(%ebp)
}
80102daa:	83 c4 14             	add    $0x14,%esp
80102dad:	5b                   	pop    %ebx
80102dae:	5d                   	pop    %ebp
  }
  log.lh.block[i] = b->blockno;
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
  release(&log.lock);
80102daf:	e9 9c 15 00 00       	jmp    80104350 <release>
80102db4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80102db8:	89 0c 85 ec 26 11 80 	mov    %ecx,-0x7feed914(,%eax,4)
80102dbf:	eb df                	jmp    80102da0 <log_write+0x80>
80102dc1:	8b 43 08             	mov    0x8(%ebx),%eax
80102dc4:	a3 ec 26 11 80       	mov    %eax,0x801126ec
  if (i == log.lh.n)
80102dc9:	75 d5                	jne    80102da0 <log_write+0x80>
80102dcb:	eb ca                	jmp    80102d97 <log_write+0x77>
80102dcd:	8d 76 00             	lea    0x0(%esi),%esi
log_write(struct buf *b)
{
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    panic("too big a transaction");
80102dd0:	c7 04 24 8f 72 10 80 	movl   $0x8010728f,(%esp)
80102dd7:	e8 84 d5 ff ff       	call   80100360 <panic>
  if (log.outstanding < 1)
    panic("log_write outside of trans");
80102ddc:	c7 04 24 a5 72 10 80 	movl   $0x801072a5,(%esp)
80102de3:	e8 78 d5 ff ff       	call   80100360 <panic>
80102de8:	66 90                	xchg   %ax,%ax
80102dea:	66 90                	xchg   %ax,%ax
80102dec:	66 90                	xchg   %ax,%ax
80102dee:	66 90                	xchg   %ax,%ax

80102df0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102df0:	55                   	push   %ebp
80102df1:	89 e5                	mov    %esp,%ebp
80102df3:	83 ec 18             	sub    $0x18,%esp
  cprintf("cpu%d: starting\n", cpunum());
80102df6:	e8 55 f9 ff ff       	call   80102750 <cpunum>
80102dfb:	c7 04 24 c0 72 10 80 	movl   $0x801072c0,(%esp)
80102e02:	89 44 24 04          	mov    %eax,0x4(%esp)
80102e06:	e8 45 d8 ff ff       	call   80100650 <cprintf>
  idtinit();       // load idt register
80102e0b:	e8 10 28 00 00       	call   80105620 <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
80102e10:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102e17:	b8 01 00 00 00       	mov    $0x1,%eax
80102e1c:	f0 87 82 a8 00 00 00 	lock xchg %eax,0xa8(%edx)
  scheduler();     // start running processes
80102e23:	e8 18 0c 00 00       	call   80103a40 <scheduler>
80102e28:	90                   	nop
80102e29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102e30 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
80102e30:	55                   	push   %ebp
80102e31:	89 e5                	mov    %esp,%ebp
80102e33:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102e36:	e8 d5 39 00 00       	call   80106810 <switchkvm>
  seginit();
80102e3b:	e8 f0 37 00 00       	call   80106630 <seginit>
  lapicinit();
80102e40:	e8 1b f8 ff ff       	call   80102660 <lapicinit>
  mpmain();
80102e45:	e8 a6 ff ff ff       	call   80102df0 <mpmain>
80102e4a:	66 90                	xchg   %ax,%ax
80102e4c:	66 90                	xchg   %ax,%ax
80102e4e:	66 90                	xchg   %ax,%ax

80102e50 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80102e50:	55                   	push   %ebp
80102e51:	89 e5                	mov    %esp,%ebp
80102e53:	53                   	push   %ebx
80102e54:	83 e4 f0             	and    $0xfffffff0,%esp
80102e57:	83 ec 10             	sub    $0x10,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102e5a:	c7 44 24 04 00 00 40 	movl   $0x80400000,0x4(%esp)
80102e61:	80 
80102e62:	c7 04 24 28 6c 11 80 	movl   $0x80116c28,(%esp)
80102e69:	e8 62 f5 ff ff       	call   801023d0 <kinit1>
  kvmalloc();      // kernel page table
80102e6e:	e8 7d 39 00 00       	call   801067f0 <kvmalloc>
  mpinit();        // detect other processors
80102e73:	e8 a8 01 00 00       	call   80103020 <mpinit>
  lapicinit();     // interrupt controller
80102e78:	e8 e3 f7 ff ff       	call   80102660 <lapicinit>
80102e7d:	8d 76 00             	lea    0x0(%esi),%esi
  seginit();       // segment descriptors
80102e80:	e8 ab 37 00 00       	call   80106630 <seginit>
  cprintf("\ncpu%d: starting xv6\n\n", cpunum());
80102e85:	e8 c6 f8 ff ff       	call   80102750 <cpunum>
80102e8a:	c7 04 24 d1 72 10 80 	movl   $0x801072d1,(%esp)
80102e91:	89 44 24 04          	mov    %eax,0x4(%esp)
80102e95:	e8 b6 d7 ff ff       	call   80100650 <cprintf>
  picinit();       // another interrupt controller
80102e9a:	e8 81 03 00 00       	call   80103220 <picinit>
  ioapicinit();    // another interrupt controller
80102e9f:	e8 4c f3 ff ff       	call   801021f0 <ioapicinit>
  consoleinit();   // console hardware
80102ea4:	e8 a7 da ff ff       	call   80100950 <consoleinit>
  uartinit();      // serial port
80102ea9:	e8 92 2a 00 00       	call   80105940 <uartinit>
80102eae:	66 90                	xchg   %ax,%ax
  pinit();         // process table
80102eb0:	e8 bb 08 00 00       	call   80103770 <pinit>
  tvinit();        // trap vectors
80102eb5:	e8 c6 26 00 00       	call   80105580 <tvinit>
  binit();         // buffer cache
80102eba:	e8 81 d1 ff ff       	call   80100040 <binit>
80102ebf:	90                   	nop
  fileinit();      // file table
80102ec0:	e8 7b de ff ff       	call   80100d40 <fileinit>
  ideinit();       // disk
80102ec5:	e8 16 f1 ff ff       	call   80101fe0 <ideinit>
  if(!ismp)
80102eca:	a1 84 27 11 80       	mov    0x80112784,%eax
80102ecf:	85 c0                	test   %eax,%eax
80102ed1:	0f 84 ca 00 00 00    	je     80102fa1 <main+0x151>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102ed7:	c7 44 24 08 8a 00 00 	movl   $0x8a,0x8(%esp)
80102ede:	00 

  for(c = cpus; c < cpus+ncpu; c++){
80102edf:	bb a0 27 11 80       	mov    $0x801127a0,%ebx

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102ee4:	c7 44 24 04 8c a4 10 	movl   $0x8010a48c,0x4(%esp)
80102eeb:	80 
80102eec:	c7 04 24 00 70 00 80 	movl   $0x80007000,(%esp)
80102ef3:	e8 48 15 00 00       	call   80104440 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80102ef8:	69 05 80 2d 11 80 bc 	imul   $0xbc,0x80112d80,%eax
80102eff:	00 00 00 
80102f02:	05 a0 27 11 80       	add    $0x801127a0,%eax
80102f07:	39 d8                	cmp    %ebx,%eax
80102f09:	76 78                	jbe    80102f83 <main+0x133>
80102f0b:	90                   	nop
80102f0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(c == cpus+cpunum())  // We've started already.
80102f10:	e8 3b f8 ff ff       	call   80102750 <cpunum>
80102f15:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80102f1b:	05 a0 27 11 80       	add    $0x801127a0,%eax
80102f20:	39 c3                	cmp    %eax,%ebx
80102f22:	74 46                	je     80102f6a <main+0x11a>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102f24:	e8 67 f5 ff ff       	call   80102490 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void**)(code-8) = mpenter;
80102f29:	c7 05 f8 6f 00 80 30 	movl   $0x80102e30,0x80006ff8
80102f30:	2e 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102f33:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
80102f3a:	90 10 00 

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
    *(void**)(code-4) = stack + KSTACKSIZE;
80102f3d:	05 00 10 00 00       	add    $0x1000,%eax
80102f42:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    *(void**)(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80102f47:	0f b6 03             	movzbl (%ebx),%eax
80102f4a:	c7 44 24 04 00 70 00 	movl   $0x7000,0x4(%esp)
80102f51:	00 
80102f52:	89 04 24             	mov    %eax,(%esp)
80102f55:	e8 c6 f8 ff ff       	call   80102820 <lapicstartap>
80102f5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102f60:	8b 83 a8 00 00 00    	mov    0xa8(%ebx),%eax
80102f66:	85 c0                	test   %eax,%eax
80102f68:	74 f6                	je     80102f60 <main+0x110>
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80102f6a:	69 05 80 2d 11 80 bc 	imul   $0xbc,0x80112d80,%eax
80102f71:	00 00 00 
80102f74:	81 c3 bc 00 00 00    	add    $0xbc,%ebx
80102f7a:	05 a0 27 11 80       	add    $0x801127a0,%eax
80102f7f:	39 c3                	cmp    %eax,%ebx
80102f81:	72 8d                	jb     80102f10 <main+0xc0>
  fileinit();      // file table
  ideinit();       // disk
  if(!ismp)
    timerinit();   // uniprocessor timer
  startothers();   // start other processors
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102f83:	c7 44 24 04 00 00 00 	movl   $0x8e000000,0x4(%esp)
80102f8a:	8e 
80102f8b:	c7 04 24 00 00 40 80 	movl   $0x80400000,(%esp)
80102f92:	e8 a9 f4 ff ff       	call   80102440 <kinit2>
  userinit();      // first user process
80102f97:	e8 f4 07 00 00       	call   80103790 <userinit>
  mpmain();        // finish this processor's setup
80102f9c:	e8 4f fe ff ff       	call   80102df0 <mpmain>
  tvinit();        // trap vectors
  binit();         // buffer cache
  fileinit();      // file table
  ideinit();       // disk
  if(!ismp)
    timerinit();   // uniprocessor timer
80102fa1:	e8 7a 25 00 00       	call   80105520 <timerinit>
80102fa6:	e9 2c ff ff ff       	jmp    80102ed7 <main+0x87>
80102fab:	66 90                	xchg   %ax,%ax
80102fad:	66 90                	xchg   %ax,%ax
80102faf:	90                   	nop

80102fb0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102fb0:	55                   	push   %ebp
80102fb1:	89 e5                	mov    %esp,%ebp
80102fb3:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80102fb4:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102fba:	53                   	push   %ebx
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
80102fbb:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102fbe:	83 ec 10             	sub    $0x10,%esp
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80102fc1:	39 de                	cmp    %ebx,%esi
80102fc3:	73 3c                	jae    80103001 <mpsearch1+0x51>
80102fc5:	8d 76 00             	lea    0x0(%esi),%esi
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102fc8:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80102fcf:	00 
80102fd0:	c7 44 24 04 e8 72 10 	movl   $0x801072e8,0x4(%esp)
80102fd7:	80 
80102fd8:	89 34 24             	mov    %esi,(%esp)
80102fdb:	e8 10 14 00 00       	call   801043f0 <memcmp>
80102fe0:	85 c0                	test   %eax,%eax
80102fe2:	75 16                	jne    80102ffa <mpsearch1+0x4a>
80102fe4:	31 c9                	xor    %ecx,%ecx
80102fe6:	31 d2                	xor    %edx,%edx
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
    sum += addr[i];
80102fe8:	0f b6 04 16          	movzbl (%esi,%edx,1),%eax
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80102fec:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80102fef:	01 c1                	add    %eax,%ecx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80102ff1:	83 fa 10             	cmp    $0x10,%edx
80102ff4:	75 f2                	jne    80102fe8 <mpsearch1+0x38>
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102ff6:	84 c9                	test   %cl,%cl
80102ff8:	74 10                	je     8010300a <mpsearch1+0x5a>
{
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80102ffa:	83 c6 10             	add    $0x10,%esi
80102ffd:	39 f3                	cmp    %esi,%ebx
80102fff:	77 c7                	ja     80102fc8 <mpsearch1+0x18>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
}
80103001:	83 c4 10             	add    $0x10,%esp
  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80103004:	31 c0                	xor    %eax,%eax
}
80103006:	5b                   	pop    %ebx
80103007:	5e                   	pop    %esi
80103008:	5d                   	pop    %ebp
80103009:	c3                   	ret    
8010300a:	83 c4 10             	add    $0x10,%esp
8010300d:	89 f0                	mov    %esi,%eax
8010300f:	5b                   	pop    %ebx
80103010:	5e                   	pop    %esi
80103011:	5d                   	pop    %ebp
80103012:	c3                   	ret    
80103013:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103019:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103020 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103020:	55                   	push   %ebp
80103021:	89 e5                	mov    %esp,%ebp
80103023:	57                   	push   %edi
80103024:	56                   	push   %esi
80103025:	53                   	push   %ebx
80103026:	83 ec 1c             	sub    $0x1c,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103029:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103030:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103037:	c1 e0 08             	shl    $0x8,%eax
8010303a:	09 d0                	or     %edx,%eax
8010303c:	c1 e0 04             	shl    $0x4,%eax
8010303f:	85 c0                	test   %eax,%eax
80103041:	75 1b                	jne    8010305e <mpinit+0x3e>
    if((mp = mpsearch1(p, 1024)))
      return mp;
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103043:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010304a:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103051:	c1 e0 08             	shl    $0x8,%eax
80103054:	09 d0                	or     %edx,%eax
80103056:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103059:	2d 00 04 00 00       	sub    $0x400,%eax
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
    if((mp = mpsearch1(p, 1024)))
8010305e:	ba 00 04 00 00       	mov    $0x400,%edx
80103063:	e8 48 ff ff ff       	call   80102fb0 <mpsearch1>
80103068:	85 c0                	test   %eax,%eax
8010306a:	89 c7                	mov    %eax,%edi
8010306c:	0f 84 4e 01 00 00    	je     801031c0 <mpinit+0x1a0>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103072:	8b 77 04             	mov    0x4(%edi),%esi
80103075:	85 f6                	test   %esi,%esi
80103077:	0f 84 ce 00 00 00    	je     8010314b <mpinit+0x12b>
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010307d:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103083:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
8010308a:	00 
8010308b:	c7 44 24 04 ed 72 10 	movl   $0x801072ed,0x4(%esp)
80103092:	80 
80103093:	89 04 24             	mov    %eax,(%esp)
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103096:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103099:	e8 52 13 00 00       	call   801043f0 <memcmp>
8010309e:	85 c0                	test   %eax,%eax
801030a0:	0f 85 a5 00 00 00    	jne    8010314b <mpinit+0x12b>
    return 0;
  if(conf->version != 1 && conf->version != 4)
801030a6:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
801030ad:	3c 04                	cmp    $0x4,%al
801030af:	0f 85 29 01 00 00    	jne    801031de <mpinit+0x1be>
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
801030b5:	0f b7 86 04 00 00 80 	movzwl -0x7ffffffc(%esi),%eax
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
801030bc:	85 c0                	test   %eax,%eax
801030be:	74 1d                	je     801030dd <mpinit+0xbd>
static uchar
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
801030c0:	31 c9                	xor    %ecx,%ecx
  for(i=0; i<len; i++)
801030c2:	31 d2                	xor    %edx,%edx
801030c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
801030c8:	0f b6 9c 16 00 00 00 	movzbl -0x80000000(%esi,%edx,1),%ebx
801030cf:	80 
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
801030d0:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801030d3:	01 d9                	add    %ebx,%ecx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
801030d5:	39 d0                	cmp    %edx,%eax
801030d7:	7f ef                	jg     801030c8 <mpinit+0xa8>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
  if(memcmp(conf, "PCMP", 4) != 0)
    return 0;
  if(conf->version != 1 && conf->version != 4)
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
801030d9:	84 c9                	test   %cl,%cl
801030db:	75 6e                	jne    8010314b <mpinit+0x12b>
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
801030dd:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801030e0:	85 db                	test   %ebx,%ebx
801030e2:	74 67                	je     8010314b <mpinit+0x12b>
    return;
  ismp = 1;
801030e4:	c7 05 84 27 11 80 01 	movl   $0x1,0x80112784
801030eb:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
801030ee:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
801030f4:	a3 9c 26 11 80       	mov    %eax,0x8011269c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801030f9:	0f b7 8e 04 00 00 80 	movzwl -0x7ffffffc(%esi),%ecx
80103100:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
80103106:	01 d9                	add    %ebx,%ecx
80103108:	39 c8                	cmp    %ecx,%eax
8010310a:	0f 83 90 00 00 00    	jae    801031a0 <mpinit+0x180>
    switch(*p){
80103110:	80 38 04             	cmpb   $0x4,(%eax)
80103113:	77 7b                	ja     80103190 <mpinit+0x170>
80103115:	0f b6 10             	movzbl (%eax),%edx
80103118:	ff 24 95 f4 72 10 80 	jmp    *-0x7fef8d0c(,%edx,4)
8010311f:	90                   	nop
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103120:	83 c0 08             	add    $0x8,%eax

  if((conf = mpconfig(&mp)) == 0)
    return;
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103123:	39 c1                	cmp    %eax,%ecx
80103125:	77 e9                	ja     80103110 <mpinit+0xf0>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp){
80103127:	a1 84 27 11 80       	mov    0x80112784,%eax
8010312c:	85 c0                	test   %eax,%eax
8010312e:	75 70                	jne    801031a0 <mpinit+0x180>
    // Didn't like what we found; fall back to no MP.
    ncpu = 1;
80103130:	c7 05 80 2d 11 80 01 	movl   $0x1,0x80112d80
80103137:	00 00 00 
    lapic = 0;
8010313a:	c7 05 9c 26 11 80 00 	movl   $0x0,0x8011269c
80103141:	00 00 00 
    ioapicid = 0;
80103144:	c6 05 80 27 11 80 00 	movb   $0x0,0x80112780
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
8010314b:	83 c4 1c             	add    $0x1c,%esp
8010314e:	5b                   	pop    %ebx
8010314f:	5e                   	pop    %esi
80103150:	5f                   	pop    %edi
80103151:	5d                   	pop    %ebp
80103152:	c3                   	ret    
80103153:	90                   	nop
80103154:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
80103158:	8b 15 80 2d 11 80    	mov    0x80112d80,%edx
8010315e:	83 fa 07             	cmp    $0x7,%edx
80103161:	7f 17                	jg     8010317a <mpinit+0x15a>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103163:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
80103167:	69 d2 bc 00 00 00    	imul   $0xbc,%edx,%edx
        ncpu++;
8010316d:	83 05 80 2d 11 80 01 	addl   $0x1,0x80112d80
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103174:	88 9a a0 27 11 80    	mov    %bl,-0x7feed860(%edx)
        ncpu++;
      }
      p += sizeof(struct mpproc);
8010317a:	83 c0 14             	add    $0x14,%eax
      continue;
8010317d:	eb a4                	jmp    80103123 <mpinit+0x103>
8010317f:	90                   	nop
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
80103180:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
80103184:	83 c0 08             	add    $0x8,%eax
      }
      p += sizeof(struct mpproc);
      continue;
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
80103187:	88 15 80 27 11 80    	mov    %dl,0x80112780
      p += sizeof(struct mpioapic);
      continue;
8010318d:	eb 94                	jmp    80103123 <mpinit+0x103>
8010318f:	90                   	nop
    case MPIOINTR:
    case MPLINTR:
      p += 8;
      continue;
    default:
      ismp = 0;
80103190:	c7 05 84 27 11 80 00 	movl   $0x0,0x80112784
80103197:	00 00 00 
      break;
8010319a:	eb 87                	jmp    80103123 <mpinit+0x103>
8010319c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    lapic = 0;
    ioapicid = 0;
    return;
  }

  if(mp->imcrp){
801031a0:	80 7f 0c 00          	cmpb   $0x0,0xc(%edi)
801031a4:	74 a5                	je     8010314b <mpinit+0x12b>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801031a6:	ba 22 00 00 00       	mov    $0x22,%edx
801031ab:	b8 70 00 00 00       	mov    $0x70,%eax
801031b0:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801031b1:	b2 23                	mov    $0x23,%dl
801031b3:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801031b4:	83 c8 01             	or     $0x1,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801031b7:	ee                   	out    %al,(%dx)
  }
}
801031b8:	83 c4 1c             	add    $0x1c,%esp
801031bb:	5b                   	pop    %ebx
801031bc:	5e                   	pop    %esi
801031bd:	5f                   	pop    %edi
801031be:	5d                   	pop    %ebp
801031bf:	c3                   	ret    
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
801031c0:	ba 00 00 01 00       	mov    $0x10000,%edx
801031c5:	b8 00 00 0f 00       	mov    $0xf0000,%eax
801031ca:	e8 e1 fd ff ff       	call   80102fb0 <mpsearch1>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801031cf:	85 c0                	test   %eax,%eax
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
801031d1:	89 c7                	mov    %eax,%edi
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801031d3:	0f 85 99 fe ff ff    	jne    80103072 <mpinit+0x52>
801031d9:	e9 6d ff ff ff       	jmp    8010314b <mpinit+0x12b>
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
  if(memcmp(conf, "PCMP", 4) != 0)
    return 0;
  if(conf->version != 1 && conf->version != 4)
801031de:	3c 01                	cmp    $0x1,%al
801031e0:	0f 84 cf fe ff ff    	je     801030b5 <mpinit+0x95>
801031e6:	e9 60 ff ff ff       	jmp    8010314b <mpinit+0x12b>
801031eb:	66 90                	xchg   %ax,%ax
801031ed:	66 90                	xchg   %ax,%ax
801031ef:	90                   	nop

801031f0 <picenable>:
  outb(IO_PIC2+1, mask >> 8);
}

void
picenable(int irq)
{
801031f0:	55                   	push   %ebp
  picsetmask(irqmask & ~(1<<irq));
801031f1:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
  outb(IO_PIC2+1, mask >> 8);
}

void
picenable(int irq)
{
801031f6:	89 e5                	mov    %esp,%ebp
801031f8:	ba 21 00 00 00       	mov    $0x21,%edx
  picsetmask(irqmask & ~(1<<irq));
801031fd:	8b 4d 08             	mov    0x8(%ebp),%ecx
80103200:	d3 c0                	rol    %cl,%eax
80103202:	66 23 05 00 a0 10 80 	and    0x8010a000,%ax
static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);

static void
picsetmask(ushort mask)
{
  irqmask = mask;
80103209:	66 a3 00 a0 10 80    	mov    %ax,0x8010a000
8010320f:	ee                   	out    %al,(%dx)
  outb(IO_PIC1+1, mask);
  outb(IO_PIC2+1, mask >> 8);
80103210:	66 c1 e8 08          	shr    $0x8,%ax
80103214:	b2 a1                	mov    $0xa1,%dl
80103216:	ee                   	out    %al,(%dx)

void
picenable(int irq)
{
  picsetmask(irqmask & ~(1<<irq));
}
80103217:	5d                   	pop    %ebp
80103218:	c3                   	ret    
80103219:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103220 <picinit>:

// Initialize the 8259A interrupt controllers.
void
picinit(void)
{
80103220:	55                   	push   %ebp
80103221:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103226:	89 e5                	mov    %esp,%ebp
80103228:	57                   	push   %edi
80103229:	56                   	push   %esi
8010322a:	53                   	push   %ebx
8010322b:	bb 21 00 00 00       	mov    $0x21,%ebx
80103230:	89 da                	mov    %ebx,%edx
80103232:	ee                   	out    %al,(%dx)
80103233:	b9 a1 00 00 00       	mov    $0xa1,%ecx
80103238:	89 ca                	mov    %ecx,%edx
8010323a:	ee                   	out    %al,(%dx)
8010323b:	bf 11 00 00 00       	mov    $0x11,%edi
80103240:	be 20 00 00 00       	mov    $0x20,%esi
80103245:	89 f8                	mov    %edi,%eax
80103247:	89 f2                	mov    %esi,%edx
80103249:	ee                   	out    %al,(%dx)
8010324a:	b8 20 00 00 00       	mov    $0x20,%eax
8010324f:	89 da                	mov    %ebx,%edx
80103251:	ee                   	out    %al,(%dx)
80103252:	b8 04 00 00 00       	mov    $0x4,%eax
80103257:	ee                   	out    %al,(%dx)
80103258:	b8 03 00 00 00       	mov    $0x3,%eax
8010325d:	ee                   	out    %al,(%dx)
8010325e:	b3 a0                	mov    $0xa0,%bl
80103260:	89 f8                	mov    %edi,%eax
80103262:	89 da                	mov    %ebx,%edx
80103264:	ee                   	out    %al,(%dx)
80103265:	b8 28 00 00 00       	mov    $0x28,%eax
8010326a:	89 ca                	mov    %ecx,%edx
8010326c:	ee                   	out    %al,(%dx)
8010326d:	b8 02 00 00 00       	mov    $0x2,%eax
80103272:	ee                   	out    %al,(%dx)
80103273:	b8 03 00 00 00       	mov    $0x3,%eax
80103278:	ee                   	out    %al,(%dx)
80103279:	bf 68 00 00 00       	mov    $0x68,%edi
8010327e:	89 f2                	mov    %esi,%edx
80103280:	89 f8                	mov    %edi,%eax
80103282:	ee                   	out    %al,(%dx)
80103283:	b9 0a 00 00 00       	mov    $0xa,%ecx
80103288:	89 c8                	mov    %ecx,%eax
8010328a:	ee                   	out    %al,(%dx)
8010328b:	89 f8                	mov    %edi,%eax
8010328d:	89 da                	mov    %ebx,%edx
8010328f:	ee                   	out    %al,(%dx)
80103290:	89 c8                	mov    %ecx,%eax
80103292:	ee                   	out    %al,(%dx)
  outb(IO_PIC1, 0x0a);             // read IRR by default

  outb(IO_PIC2, 0x68);             // OCW3
  outb(IO_PIC2, 0x0a);             // OCW3

  if(irqmask != 0xFFFF)
80103293:	0f b7 05 00 a0 10 80 	movzwl 0x8010a000,%eax
8010329a:	66 83 f8 ff          	cmp    $0xffff,%ax
8010329e:	74 0a                	je     801032aa <picinit+0x8a>
801032a0:	b2 21                	mov    $0x21,%dl
801032a2:	ee                   	out    %al,(%dx)
static void
picsetmask(ushort mask)
{
  irqmask = mask;
  outb(IO_PIC1+1, mask);
  outb(IO_PIC2+1, mask >> 8);
801032a3:	66 c1 e8 08          	shr    $0x8,%ax
801032a7:	b2 a1                	mov    $0xa1,%dl
801032a9:	ee                   	out    %al,(%dx)
  outb(IO_PIC2, 0x68);             // OCW3
  outb(IO_PIC2, 0x0a);             // OCW3

  if(irqmask != 0xFFFF)
    picsetmask(irqmask);
}
801032aa:	5b                   	pop    %ebx
801032ab:	5e                   	pop    %esi
801032ac:	5f                   	pop    %edi
801032ad:	5d                   	pop    %ebp
801032ae:	c3                   	ret    
801032af:	90                   	nop

801032b0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
801032b0:	55                   	push   %ebp
801032b1:	89 e5                	mov    %esp,%ebp
801032b3:	57                   	push   %edi
801032b4:	56                   	push   %esi
801032b5:	53                   	push   %ebx
801032b6:	83 ec 1c             	sub    $0x1c,%esp
801032b9:	8b 75 08             	mov    0x8(%ebp),%esi
801032bc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
801032bf:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
801032c5:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
801032cb:	e8 90 da ff ff       	call   80100d60 <filealloc>
801032d0:	85 c0                	test   %eax,%eax
801032d2:	89 06                	mov    %eax,(%esi)
801032d4:	0f 84 a4 00 00 00    	je     8010337e <pipealloc+0xce>
801032da:	e8 81 da ff ff       	call   80100d60 <filealloc>
801032df:	85 c0                	test   %eax,%eax
801032e1:	89 03                	mov    %eax,(%ebx)
801032e3:	0f 84 87 00 00 00    	je     80103370 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801032e9:	e8 a2 f1 ff ff       	call   80102490 <kalloc>
801032ee:	85 c0                	test   %eax,%eax
801032f0:	89 c7                	mov    %eax,%edi
801032f2:	74 7c                	je     80103370 <pipealloc+0xc0>
    goto bad;
  p->readopen = 1;
801032f4:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801032fb:	00 00 00 
  p->writeopen = 1;
801032fe:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103305:	00 00 00 
  p->nwrite = 0;
80103308:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010330f:	00 00 00 
  p->nread = 0;
80103312:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103319:	00 00 00 
  initlock(&p->lock, "pipe");
8010331c:	89 04 24             	mov    %eax,(%esp)
8010331f:	c7 44 24 04 08 73 10 	movl   $0x80107308,0x4(%esp)
80103326:	80 
80103327:	e8 74 0e 00 00       	call   801041a0 <initlock>
  (*f0)->type = FD_PIPE;
8010332c:	8b 06                	mov    (%esi),%eax
8010332e:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103334:	8b 06                	mov    (%esi),%eax
80103336:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010333a:	8b 06                	mov    (%esi),%eax
8010333c:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103340:	8b 06                	mov    (%esi),%eax
80103342:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103345:	8b 03                	mov    (%ebx),%eax
80103347:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
8010334d:	8b 03                	mov    (%ebx),%eax
8010334f:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103353:	8b 03                	mov    (%ebx),%eax
80103355:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103359:	8b 03                	mov    (%ebx),%eax
  return 0;
8010335b:	31 db                	xor    %ebx,%ebx
  (*f0)->writable = 0;
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
8010335d:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103360:	83 c4 1c             	add    $0x1c,%esp
80103363:	89 d8                	mov    %ebx,%eax
80103365:	5b                   	pop    %ebx
80103366:	5e                   	pop    %esi
80103367:	5f                   	pop    %edi
80103368:	5d                   	pop    %ebp
80103369:	c3                   	ret    
8010336a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
80103370:	8b 06                	mov    (%esi),%eax
80103372:	85 c0                	test   %eax,%eax
80103374:	74 08                	je     8010337e <pipealloc+0xce>
    fileclose(*f0);
80103376:	89 04 24             	mov    %eax,(%esp)
80103379:	e8 a2 da ff ff       	call   80100e20 <fileclose>
  if(*f1)
8010337e:	8b 03                	mov    (%ebx),%eax
    fileclose(*f1);
  return -1;
80103380:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
    fileclose(*f0);
  if(*f1)
80103385:	85 c0                	test   %eax,%eax
80103387:	74 d7                	je     80103360 <pipealloc+0xb0>
    fileclose(*f1);
80103389:	89 04 24             	mov    %eax,(%esp)
8010338c:	e8 8f da ff ff       	call   80100e20 <fileclose>
  return -1;
}
80103391:	83 c4 1c             	add    $0x1c,%esp
80103394:	89 d8                	mov    %ebx,%eax
80103396:	5b                   	pop    %ebx
80103397:	5e                   	pop    %esi
80103398:	5f                   	pop    %edi
80103399:	5d                   	pop    %ebp
8010339a:	c3                   	ret    
8010339b:	90                   	nop
8010339c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801033a0 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
801033a0:	55                   	push   %ebp
801033a1:	89 e5                	mov    %esp,%ebp
801033a3:	56                   	push   %esi
801033a4:	53                   	push   %ebx
801033a5:	83 ec 10             	sub    $0x10,%esp
801033a8:	8b 5d 08             	mov    0x8(%ebp),%ebx
801033ab:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
801033ae:	89 1c 24             	mov    %ebx,(%esp)
801033b1:	e8 6a 0e 00 00       	call   80104220 <acquire>
  if(writable){
801033b6:	85 f6                	test   %esi,%esi
801033b8:	74 3e                	je     801033f8 <pipeclose+0x58>
    p->writeopen = 0;
    wakeup(&p->nread);
801033ba:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
void
pipeclose(struct pipe *p, int writable)
{
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
801033c0:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
801033c7:	00 00 00 
    wakeup(&p->nread);
801033ca:	89 04 24             	mov    %eax,(%esp)
801033cd:	e8 de 0a 00 00       	call   80103eb0 <wakeup>
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
801033d2:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801033d8:	85 d2                	test   %edx,%edx
801033da:	75 0a                	jne    801033e6 <pipeclose+0x46>
801033dc:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801033e2:	85 c0                	test   %eax,%eax
801033e4:	74 32                	je     80103418 <pipeclose+0x78>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801033e6:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801033e9:	83 c4 10             	add    $0x10,%esp
801033ec:	5b                   	pop    %ebx
801033ed:	5e                   	pop    %esi
801033ee:	5d                   	pop    %ebp
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801033ef:	e9 5c 0f 00 00       	jmp    80104350 <release>
801033f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
801033f8:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
801033fe:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103405:	00 00 00 
    wakeup(&p->nwrite);
80103408:	89 04 24             	mov    %eax,(%esp)
8010340b:	e8 a0 0a 00 00       	call   80103eb0 <wakeup>
80103410:	eb c0                	jmp    801033d2 <pipeclose+0x32>
80103412:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
80103418:	89 1c 24             	mov    %ebx,(%esp)
8010341b:	e8 30 0f 00 00       	call   80104350 <release>
    kfree((char*)p);
80103420:	89 5d 08             	mov    %ebx,0x8(%ebp)
  } else
    release(&p->lock);
}
80103423:	83 c4 10             	add    $0x10,%esp
80103426:	5b                   	pop    %ebx
80103427:	5e                   	pop    %esi
80103428:	5d                   	pop    %ebp
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
80103429:	e9 b2 ee ff ff       	jmp    801022e0 <kfree>
8010342e:	66 90                	xchg   %ax,%ax

80103430 <pipewrite>:
}

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103430:	55                   	push   %ebp
80103431:	89 e5                	mov    %esp,%ebp
80103433:	57                   	push   %edi
80103434:	56                   	push   %esi
80103435:	53                   	push   %ebx
80103436:	83 ec 1c             	sub    $0x1c,%esp
80103439:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i;

  acquire(&p->lock);
8010343c:	89 3c 24             	mov    %edi,(%esp)
8010343f:	e8 dc 0d 00 00       	call   80104220 <acquire>
  for(i = 0; i < n; i++){
80103444:	8b 45 10             	mov    0x10(%ebp),%eax
80103447:	85 c0                	test   %eax,%eax
80103449:	0f 8e c2 00 00 00    	jle    80103511 <pipewrite+0xe1>
8010344f:	8b 45 0c             	mov    0xc(%ebp),%eax
80103452:	8d b7 34 02 00 00    	lea    0x234(%edi),%esi
80103458:	8b 8f 38 02 00 00    	mov    0x238(%edi),%ecx
8010345e:	8d 9f 38 02 00 00    	lea    0x238(%edi),%ebx
80103464:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103467:	03 45 10             	add    0x10(%ebp),%eax
8010346a:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010346d:	8b 87 34 02 00 00    	mov    0x234(%edi),%eax
80103473:	8d 90 00 02 00 00    	lea    0x200(%eax),%edx
80103479:	39 d1                	cmp    %edx,%ecx
8010347b:	0f 85 c4 00 00 00    	jne    80103545 <pipewrite+0x115>
      if(p->readopen == 0 || proc->killed){
80103481:	8b 97 3c 02 00 00    	mov    0x23c(%edi),%edx
80103487:	85 d2                	test   %edx,%edx
80103489:	0f 84 a1 00 00 00    	je     80103530 <pipewrite+0x100>
8010348f:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80103496:	8b 42 24             	mov    0x24(%edx),%eax
80103499:	85 c0                	test   %eax,%eax
8010349b:	74 22                	je     801034bf <pipewrite+0x8f>
8010349d:	e9 8e 00 00 00       	jmp    80103530 <pipewrite+0x100>
801034a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801034a8:	8b 87 3c 02 00 00    	mov    0x23c(%edi),%eax
801034ae:	85 c0                	test   %eax,%eax
801034b0:	74 7e                	je     80103530 <pipewrite+0x100>
801034b2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801034b8:	8b 48 24             	mov    0x24(%eax),%ecx
801034bb:	85 c9                	test   %ecx,%ecx
801034bd:	75 71                	jne    80103530 <pipewrite+0x100>
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801034bf:	89 34 24             	mov    %esi,(%esp)
801034c2:	e8 e9 09 00 00       	call   80103eb0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801034c7:	89 7c 24 04          	mov    %edi,0x4(%esp)
801034cb:	89 1c 24             	mov    %ebx,(%esp)
801034ce:	e8 2d 08 00 00       	call   80103d00 <sleep>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801034d3:	8b 87 34 02 00 00    	mov    0x234(%edi),%eax
801034d9:	8b 97 38 02 00 00    	mov    0x238(%edi),%edx
801034df:	05 00 02 00 00       	add    $0x200,%eax
801034e4:	39 c2                	cmp    %eax,%edx
801034e6:	74 c0                	je     801034a8 <pipewrite+0x78>
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801034e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801034eb:	8d 4a 01             	lea    0x1(%edx),%ecx
801034ee:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801034f4:	89 8f 38 02 00 00    	mov    %ecx,0x238(%edi)
801034fa:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
801034fe:	0f b6 00             	movzbl (%eax),%eax
80103501:	88 44 17 34          	mov    %al,0x34(%edi,%edx,1)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
80103505:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103508:	3b 45 e0             	cmp    -0x20(%ebp),%eax
8010350b:	0f 85 5c ff ff ff    	jne    8010346d <pipewrite+0x3d>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103511:	8d 97 34 02 00 00    	lea    0x234(%edi),%edx
80103517:	89 14 24             	mov    %edx,(%esp)
8010351a:	e8 91 09 00 00       	call   80103eb0 <wakeup>
  release(&p->lock);
8010351f:	89 3c 24             	mov    %edi,(%esp)
80103522:	e8 29 0e 00 00       	call   80104350 <release>
  return n;
80103527:	8b 45 10             	mov    0x10(%ebp),%eax
8010352a:	eb 11                	jmp    8010353d <pipewrite+0x10d>
8010352c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || proc->killed){
        release(&p->lock);
80103530:	89 3c 24             	mov    %edi,(%esp)
80103533:	e8 18 0e 00 00       	call   80104350 <release>
        return -1;
80103538:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
8010353d:	83 c4 1c             	add    $0x1c,%esp
80103540:	5b                   	pop    %ebx
80103541:	5e                   	pop    %esi
80103542:	5f                   	pop    %edi
80103543:	5d                   	pop    %ebp
80103544:	c3                   	ret    
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103545:	89 ca                	mov    %ecx,%edx
80103547:	eb 9f                	jmp    801034e8 <pipewrite+0xb8>
80103549:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103550 <piperead>:
  return n;
}

int
piperead(struct pipe *p, char *addr, int n)
{
80103550:	55                   	push   %ebp
80103551:	89 e5                	mov    %esp,%ebp
80103553:	57                   	push   %edi
80103554:	56                   	push   %esi
80103555:	53                   	push   %ebx
80103556:	83 ec 1c             	sub    $0x1c,%esp
80103559:	8b 75 08             	mov    0x8(%ebp),%esi
8010355c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010355f:	89 34 24             	mov    %esi,(%esp)
80103562:	e8 b9 0c 00 00       	call   80104220 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103567:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
8010356d:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103573:	75 5b                	jne    801035d0 <piperead+0x80>
80103575:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
8010357b:	85 db                	test   %ebx,%ebx
8010357d:	74 51                	je     801035d0 <piperead+0x80>
8010357f:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103585:	eb 25                	jmp    801035ac <piperead+0x5c>
80103587:	90                   	nop
    if(proc->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103588:	89 74 24 04          	mov    %esi,0x4(%esp)
8010358c:	89 1c 24             	mov    %ebx,(%esp)
8010358f:	e8 6c 07 00 00       	call   80103d00 <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103594:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
8010359a:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
801035a0:	75 2e                	jne    801035d0 <piperead+0x80>
801035a2:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
801035a8:	85 d2                	test   %edx,%edx
801035aa:	74 24                	je     801035d0 <piperead+0x80>
    if(proc->killed){
801035ac:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801035b2:	8b 48 24             	mov    0x24(%eax),%ecx
801035b5:	85 c9                	test   %ecx,%ecx
801035b7:	74 cf                	je     80103588 <piperead+0x38>
      release(&p->lock);
801035b9:	89 34 24             	mov    %esi,(%esp)
801035bc:	e8 8f 0d 00 00       	call   80104350 <release>
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
801035c1:	83 c4 1c             	add    $0x1c,%esp

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
    if(proc->killed){
      release(&p->lock);
      return -1;
801035c4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
801035c9:	5b                   	pop    %ebx
801035ca:	5e                   	pop    %esi
801035cb:	5f                   	pop    %edi
801035cc:	5d                   	pop    %ebp
801035cd:	c3                   	ret    
801035ce:	66 90                	xchg   %ax,%ax
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801035d0:	8b 55 10             	mov    0x10(%ebp),%edx
    if(p->nread == p->nwrite)
801035d3:	31 db                	xor    %ebx,%ebx
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801035d5:	85 d2                	test   %edx,%edx
801035d7:	7f 2b                	jg     80103604 <piperead+0xb4>
801035d9:	eb 31                	jmp    8010360c <piperead+0xbc>
801035db:	90                   	nop
801035dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
801035e0:	8d 48 01             	lea    0x1(%eax),%ecx
801035e3:	25 ff 01 00 00       	and    $0x1ff,%eax
801035e8:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
801035ee:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
801035f3:	88 04 1f             	mov    %al,(%edi,%ebx,1)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801035f6:	83 c3 01             	add    $0x1,%ebx
801035f9:	3b 5d 10             	cmp    0x10(%ebp),%ebx
801035fc:	74 0e                	je     8010360c <piperead+0xbc>
    if(p->nread == p->nwrite)
801035fe:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103604:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010360a:	75 d4                	jne    801035e0 <piperead+0x90>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010360c:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103612:	89 04 24             	mov    %eax,(%esp)
80103615:	e8 96 08 00 00       	call   80103eb0 <wakeup>
  release(&p->lock);
8010361a:	89 34 24             	mov    %esi,(%esp)
8010361d:	e8 2e 0d 00 00       	call   80104350 <release>
  return i;
}
80103622:	83 c4 1c             	add    $0x1c,%esp
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
80103625:	89 d8                	mov    %ebx,%eax
}
80103627:	5b                   	pop    %ebx
80103628:	5e                   	pop    %esi
80103629:	5f                   	pop    %edi
8010362a:	5d                   	pop    %ebp
8010362b:	c3                   	ret    
8010362c:	66 90                	xchg   %ax,%ax
8010362e:	66 90                	xchg   %ax,%ax

80103630 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103630:	55                   	push   %ebp
80103631:	89 e5                	mov    %esp,%ebp
80103633:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103634:	bb d4 2d 11 80       	mov    $0x80112dd4,%ebx
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103639:	83 ec 14             	sub    $0x14,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
8010363c:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103643:	e8 d8 0b 00 00       	call   80104220 <acquire>
80103648:	eb 18                	jmp    80103662 <allocproc+0x32>
8010364a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103650:	81 c3 d8 00 00 00    	add    $0xd8,%ebx
80103656:	81 fb d4 63 11 80    	cmp    $0x801163d4,%ebx
8010365c:	0f 84 96 00 00 00    	je     801036f8 <allocproc+0xc8>
    if(p->state == UNUSED)
80103662:	8b 43 0c             	mov    0xc(%ebx),%eax
80103665:	85 c0                	test   %eax,%eax
80103667:	75 e7                	jne    80103650 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103669:	a1 08 a0 10 80       	mov    0x8010a008,%eax

  release(&ptable.lock);
8010366e:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
80103675:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
8010367c:	8d 50 01             	lea    0x1(%eax),%edx
8010367f:	89 15 08 a0 10 80    	mov    %edx,0x8010a008
80103685:	89 43 10             	mov    %eax,0x10(%ebx)

  release(&ptable.lock);
80103688:	e8 c3 0c 00 00       	call   80104350 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
8010368d:	e8 fe ed ff ff       	call   80102490 <kalloc>
80103692:	85 c0                	test   %eax,%eax
80103694:	89 43 08             	mov    %eax,0x8(%ebx)
80103697:	74 73                	je     8010370c <allocproc+0xdc>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103699:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
8010369f:	05 9c 0f 00 00       	add    $0xf9c,%eax
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801036a4:	89 53 18             	mov    %edx,0x18(%ebx)
  p->tf = (struct trapframe*)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;
801036a7:	c7 40 14 6d 55 10 80 	movl   $0x8010556d,0x14(%eax)

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
801036ae:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
801036b5:	00 
801036b6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801036bd:	00 
801036be:	89 04 24             	mov    %eax,(%esp)
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
801036c1:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
801036c4:	e8 d7 0c 00 00       	call   801043a0 <memset>
  p->context->eip = (uint)forkret;
801036c9:	8b 43 1c             	mov    0x1c(%ebx),%eax
801036cc:	c7 40 10 20 37 10 80 	movl   $0x80103720,0x10(%eax)

  memset(p->callcount, 0, NUM_CALLS + 1);
801036d3:	8d 43 7c             	lea    0x7c(%ebx),%eax
801036d6:	c7 44 24 08 17 00 00 	movl   $0x17,0x8(%esp)
801036dd:	00 
801036de:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801036e5:	00 
801036e6:	89 04 24             	mov    %eax,(%esp)
801036e9:	e8 b2 0c 00 00       	call   801043a0 <memset>

  return p;
801036ee:	89 d8                	mov    %ebx,%eax
}
801036f0:	83 c4 14             	add    $0x14,%esp
801036f3:	5b                   	pop    %ebx
801036f4:	5d                   	pop    %ebp
801036f5:	c3                   	ret    
801036f6:	66 90                	xchg   %ax,%ax

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
801036f8:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
801036ff:	e8 4c 0c 00 00       	call   80104350 <release>
  p->context->eip = (uint)forkret;

  memset(p->callcount, 0, NUM_CALLS + 1);

  return p;
}
80103704:	83 c4 14             	add    $0x14,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
  return 0;
80103707:	31 c0                	xor    %eax,%eax
  p->context->eip = (uint)forkret;

  memset(p->callcount, 0, NUM_CALLS + 1);

  return p;
}
80103709:	5b                   	pop    %ebx
8010370a:	5d                   	pop    %ebp
8010370b:	c3                   	ret    

  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
8010370c:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103713:	eb db                	jmp    801036f0 <allocproc+0xc0>
80103715:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103719:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103720 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103720:	55                   	push   %ebp
80103721:	89 e5                	mov    %esp,%ebp
80103723:	83 ec 18             	sub    $0x18,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103726:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
8010372d:	e8 1e 0c 00 00       	call   80104350 <release>

  if (first) {
80103732:	a1 04 a0 10 80       	mov    0x8010a004,%eax
80103737:	85 c0                	test   %eax,%eax
80103739:	75 05                	jne    80103740 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
8010373b:	c9                   	leave  
8010373c:	c3                   	ret    
8010373d:	8d 76 00             	lea    0x0(%esi),%esi
  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
80103740:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)

  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
80103747:	c7 05 04 a0 10 80 00 	movl   $0x0,0x8010a004
8010374e:	00 00 00 
    iinit(ROOTDEV);
80103751:	e8 1a dd ff ff       	call   80101470 <iinit>
    initlog(ROOTDEV);
80103756:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010375d:	e8 7e f3 ff ff       	call   80102ae0 <initlog>
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103762:	c9                   	leave  
80103763:	c3                   	ret    
80103764:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010376a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103770 <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
80103770:	55                   	push   %ebp
80103771:	89 e5                	mov    %esp,%ebp
80103773:	83 ec 18             	sub    $0x18,%esp
  initlock(&ptable.lock, "ptable");
80103776:	c7 44 24 04 0d 73 10 	movl   $0x8010730d,0x4(%esp)
8010377d:	80 
8010377e:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103785:	e8 16 0a 00 00       	call   801041a0 <initlock>
}
8010378a:	c9                   	leave  
8010378b:	c3                   	ret    
8010378c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103790 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
80103790:	55                   	push   %ebp
80103791:	89 e5                	mov    %esp,%ebp
80103793:	53                   	push   %ebx
80103794:	83 ec 14             	sub    $0x14,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
80103797:	e8 94 fe ff ff       	call   80103630 <allocproc>
8010379c:	89 c3                	mov    %eax,%ebx
  
  initproc = p;
8010379e:	a3 bc a5 10 80       	mov    %eax,0x8010a5bc
  if((p->pgdir = setupkvm()) == 0)
801037a3:	e8 c8 2f 00 00       	call   80106770 <setupkvm>
801037a8:	85 c0                	test   %eax,%eax
801037aa:	89 43 04             	mov    %eax,0x4(%ebx)
801037ad:	0f 84 d4 00 00 00    	je     80103887 <userinit+0xf7>
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801037b3:	89 04 24             	mov    %eax,(%esp)
801037b6:	c7 44 24 08 2c 00 00 	movl   $0x2c,0x8(%esp)
801037bd:	00 
801037be:	c7 44 24 04 60 a4 10 	movl   $0x8010a460,0x4(%esp)
801037c5:	80 
801037c6:	e8 35 31 00 00       	call   80106900 <inituvm>
  p->sz = PGSIZE;
801037cb:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
801037d1:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
801037d8:	00 
801037d9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801037e0:	00 
801037e1:	8b 43 18             	mov    0x18(%ebx),%eax
801037e4:	89 04 24             	mov    %eax,(%esp)
801037e7:	e8 b4 0b 00 00       	call   801043a0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801037ec:	8b 43 18             	mov    0x18(%ebx),%eax
801037ef:	ba 23 00 00 00       	mov    $0x23,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801037f4:	b9 2b 00 00 00       	mov    $0x2b,%ecx
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801037f9:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801037fd:	8b 43 18             	mov    0x18(%ebx),%eax
80103800:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103804:	8b 43 18             	mov    0x18(%ebx),%eax
80103807:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
8010380b:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
8010380f:	8b 43 18             	mov    0x18(%ebx),%eax
80103812:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103816:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
8010381a:	8b 43 18             	mov    0x18(%ebx),%eax
8010381d:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103824:	8b 43 18             	mov    0x18(%ebx),%eax
80103827:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
8010382e:	8b 43 18             	mov    0x18(%ebx),%eax
80103831:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
80103838:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010383b:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80103842:	00 
80103843:	c7 44 24 04 2d 73 10 	movl   $0x8010732d,0x4(%esp)
8010384a:	80 
8010384b:	89 04 24             	mov    %eax,(%esp)
8010384e:	e8 2d 0d 00 00       	call   80104580 <safestrcpy>
  p->cwd = namei("/");
80103853:	c7 04 24 36 73 10 80 	movl   $0x80107336,(%esp)
8010385a:	e8 81 e6 ff ff       	call   80101ee0 <namei>
8010385f:	89 43 68             	mov    %eax,0x68(%ebx)

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);
80103862:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103869:	e8 b2 09 00 00       	call   80104220 <acquire>

  p->state = RUNNABLE;
8010386e:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)

  release(&ptable.lock);
80103875:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
8010387c:	e8 cf 0a 00 00       	call   80104350 <release>
}
80103881:	83 c4 14             	add    $0x14,%esp
80103884:	5b                   	pop    %ebx
80103885:	5d                   	pop    %ebp
80103886:	c3                   	ret    

  p = allocproc();
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
80103887:	c7 04 24 14 73 10 80 	movl   $0x80107314,(%esp)
8010388e:	e8 cd ca ff ff       	call   80100360 <panic>
80103893:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103899:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801038a0 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
801038a0:	55                   	push   %ebp
801038a1:	89 e5                	mov    %esp,%ebp
801038a3:	83 ec 18             	sub    $0x18,%esp
  uint sz;

  sz = proc->sz;
801038a6:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
801038ad:	8b 4d 08             	mov    0x8(%ebp),%ecx
  uint sz;

  sz = proc->sz;
801038b0:	8b 02                	mov    (%edx),%eax
  if(n > 0){
801038b2:	83 f9 00             	cmp    $0x0,%ecx
801038b5:	7e 39                	jle    801038f0 <growproc+0x50>
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
801038b7:	01 c1                	add    %eax,%ecx
801038b9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
801038bd:	89 44 24 04          	mov    %eax,0x4(%esp)
801038c1:	8b 42 04             	mov    0x4(%edx),%eax
801038c4:	89 04 24             	mov    %eax,(%esp)
801038c7:	e8 74 31 00 00       	call   80106a40 <allocuvm>
801038cc:	85 c0                	test   %eax,%eax
801038ce:	74 40                	je     80103910 <growproc+0x70>
801038d0:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  proc->sz = sz;
801038d7:	89 02                	mov    %eax,(%edx)
  switchuvm(proc);
801038d9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801038df:	89 04 24             	mov    %eax,(%esp)
801038e2:	e8 49 2f 00 00       	call   80106830 <switchuvm>
  return 0;
801038e7:	31 c0                	xor    %eax,%eax
}
801038e9:	c9                   	leave  
801038ea:	c3                   	ret    
801038eb:	90                   	nop
801038ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  sz = proc->sz;
  if(n > 0){
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
801038f0:	74 e5                	je     801038d7 <growproc+0x37>
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
801038f2:	01 c1                	add    %eax,%ecx
801038f4:	89 4c 24 08          	mov    %ecx,0x8(%esp)
801038f8:	89 44 24 04          	mov    %eax,0x4(%esp)
801038fc:	8b 42 04             	mov    0x4(%edx),%eax
801038ff:	89 04 24             	mov    %eax,(%esp)
80103902:	e8 29 32 00 00       	call   80106b30 <deallocuvm>
80103907:	85 c0                	test   %eax,%eax
80103909:	75 c5                	jne    801038d0 <growproc+0x30>
8010390b:	90                   	nop
8010390c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint sz;

  sz = proc->sz;
  if(n > 0){
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
      return -1;
80103910:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return -1;
  }
  proc->sz = sz;
  switchuvm(proc);
  return 0;
}
80103915:	c9                   	leave  
80103916:	c3                   	ret    
80103917:	89 f6                	mov    %esi,%esi
80103919:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103920 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
80103920:	55                   	push   %ebp
80103921:	89 e5                	mov    %esp,%ebp
80103923:	57                   	push   %edi
80103924:	56                   	push   %esi
80103925:	53                   	push   %ebx
80103926:	83 ec 1c             	sub    $0x1c,%esp
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0){
80103929:	e8 02 fd ff ff       	call   80103630 <allocproc>
8010392e:	85 c0                	test   %eax,%eax
80103930:	89 c3                	mov    %eax,%ebx
80103932:	0f 84 d5 00 00 00    	je     80103a0d <fork+0xed>
    return -1;
  }

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
80103938:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010393e:	8b 10                	mov    (%eax),%edx
80103940:	89 54 24 04          	mov    %edx,0x4(%esp)
80103944:	8b 40 04             	mov    0x4(%eax),%eax
80103947:	89 04 24             	mov    %eax,(%esp)
8010394a:	e8 b1 32 00 00       	call   80106c00 <copyuvm>
8010394f:	85 c0                	test   %eax,%eax
80103951:	89 43 04             	mov    %eax,0x4(%ebx)
80103954:	0f 84 ba 00 00 00    	je     80103a14 <fork+0xf4>
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = proc->sz;
8010395a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  np->parent = proc;
  *np->tf = *proc->tf;
80103960:	b9 13 00 00 00       	mov    $0x13,%ecx
80103965:	8b 7b 18             	mov    0x18(%ebx),%edi
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = proc->sz;
80103968:	8b 00                	mov    (%eax),%eax
8010396a:	89 03                	mov    %eax,(%ebx)
  np->parent = proc;
8010396c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103972:	89 43 14             	mov    %eax,0x14(%ebx)
  *np->tf = *proc->tf;
80103975:	8b 70 18             	mov    0x18(%eax),%esi
80103978:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
8010397a:	31 f6                	xor    %esi,%esi
  np->sz = proc->sz;
  np->parent = proc;
  *np->tf = *proc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
8010397c:	8b 43 18             	mov    0x18(%ebx),%eax
8010397f:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80103986:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
8010398d:	8d 76 00             	lea    0x0(%esi),%esi

  for(i = 0; i < NOFILE; i++)
    if(proc->ofile[i])
80103990:	8b 44 b2 28          	mov    0x28(%edx,%esi,4),%eax
80103994:	85 c0                	test   %eax,%eax
80103996:	74 13                	je     801039ab <fork+0x8b>
      np->ofile[i] = filedup(proc->ofile[i]);
80103998:	89 04 24             	mov    %eax,(%esp)
8010399b:	e8 30 d4 ff ff       	call   80100dd0 <filedup>
801039a0:	89 44 b3 28          	mov    %eax,0x28(%ebx,%esi,4)
801039a4:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
  *np->tf = *proc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
801039ab:	83 c6 01             	add    $0x1,%esi
801039ae:	83 fe 10             	cmp    $0x10,%esi
801039b1:	75 dd                	jne    80103990 <fork+0x70>
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);
801039b3:	8b 42 68             	mov    0x68(%edx),%eax
801039b6:	89 04 24             	mov    %eax,(%esp)
801039b9:	e8 c2 dc ff ff       	call   80101680 <idup>
801039be:	89 43 68             	mov    %eax,0x68(%ebx)

  safestrcpy(np->name, proc->name, sizeof(proc->name));
801039c1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801039c7:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
801039ce:	00 
801039cf:	83 c0 6c             	add    $0x6c,%eax
801039d2:	89 44 24 04          	mov    %eax,0x4(%esp)
801039d6:	8d 43 6c             	lea    0x6c(%ebx),%eax
801039d9:	89 04 24             	mov    %eax,(%esp)
801039dc:	e8 9f 0b 00 00       	call   80104580 <safestrcpy>

  pid = np->pid;
801039e1:	8b 73 10             	mov    0x10(%ebx),%esi

  acquire(&ptable.lock);
801039e4:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
801039eb:	e8 30 08 00 00       	call   80104220 <acquire>

  np->state = RUNNABLE;
801039f0:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)

  release(&ptable.lock);
801039f7:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
801039fe:	e8 4d 09 00 00       	call   80104350 <release>

  return pid;
80103a03:	89 f0                	mov    %esi,%eax
}
80103a05:	83 c4 1c             	add    $0x1c,%esp
80103a08:	5b                   	pop    %ebx
80103a09:	5e                   	pop    %esi
80103a0a:	5f                   	pop    %edi
80103a0b:	5d                   	pop    %ebp
80103a0c:	c3                   	ret    
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0){
    return -1;
80103a0d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103a12:	eb f1                	jmp    80103a05 <fork+0xe5>
  }

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
    kfree(np->kstack);
80103a14:	8b 43 08             	mov    0x8(%ebx),%eax
80103a17:	89 04 24             	mov    %eax,(%esp)
80103a1a:	e8 c1 e8 ff ff       	call   801022e0 <kfree>
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
80103a1f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
    kfree(np->kstack);
    np->kstack = 0;
80103a24:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    np->state = UNUSED;
80103a2b:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103a32:	eb d1                	jmp    80103a05 <fork+0xe5>
80103a34:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103a3a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103a40 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
80103a40:	55                   	push   %ebp
80103a41:	89 e5                	mov    %esp,%ebp
80103a43:	53                   	push   %ebx
80103a44:	83 ec 14             	sub    $0x14,%esp
80103a47:	90                   	nop
}

static inline void
sti(void)
{
  asm volatile("sti");
80103a48:	fb                   	sti    
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80103a49:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a50:	bb d4 2d 11 80       	mov    $0x80112dd4,%ebx
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80103a55:	e8 c6 07 00 00       	call   80104220 <acquire>
80103a5a:	eb 12                	jmp    80103a6e <scheduler+0x2e>
80103a5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a60:	81 c3 d8 00 00 00    	add    $0xd8,%ebx
80103a66:	81 fb d4 63 11 80    	cmp    $0x801163d4,%ebx
80103a6c:	74 5a                	je     80103ac8 <scheduler+0x88>
      if(p->state != RUNNABLE)
80103a6e:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103a72:	75 ec                	jne    80103a60 <scheduler+0x20>

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      proc = p;
      switchuvm(p);
80103a74:	89 1c 24             	mov    %ebx,(%esp)
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      proc = p;
80103a77:	65 89 1d 04 00 00 00 	mov    %ebx,%gs:0x4
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a7e:	81 c3 d8 00 00 00    	add    $0xd8,%ebx

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      proc = p;
      switchuvm(p);
80103a84:	e8 a7 2d 00 00       	call   80106830 <switchuvm>
      p->state = RUNNING;
      swtch(&cpu->scheduler, p->context);
80103a89:	8b 83 44 ff ff ff    	mov    -0xbc(%ebx),%eax
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      proc = p;
      switchuvm(p);
      p->state = RUNNING;
80103a8f:	c7 83 34 ff ff ff 04 	movl   $0x4,-0xcc(%ebx)
80103a96:	00 00 00 
      swtch(&cpu->scheduler, p->context);
80103a99:	89 44 24 04          	mov    %eax,0x4(%esp)
80103a9d:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103aa3:	83 c0 04             	add    $0x4,%eax
80103aa6:	89 04 24             	mov    %eax,(%esp)
80103aa9:	e8 2d 0b 00 00       	call   801045db <swtch>
      switchkvm();
80103aae:	e8 5d 2d 00 00       	call   80106810 <switchkvm>
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ab3:	81 fb d4 63 11 80    	cmp    $0x801163d4,%ebx
      swtch(&cpu->scheduler, p->context);
      switchkvm();

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
80103ab9:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80103ac0:	00 00 00 00 
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ac4:	75 a8                	jne    80103a6e <scheduler+0x2e>
80103ac6:	66 90                	xchg   %ax,%ax

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
    }
    release(&ptable.lock);
80103ac8:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103acf:	e8 7c 08 00 00       	call   80104350 <release>

  }
80103ad4:	e9 6f ff ff ff       	jmp    80103a48 <scheduler+0x8>
80103ad9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103ae0 <sched>:
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
80103ae0:	55                   	push   %ebp
80103ae1:	89 e5                	mov    %esp,%ebp
80103ae3:	53                   	push   %ebx
80103ae4:	83 ec 14             	sub    $0x14,%esp
  int intena;

  if(!holding(&ptable.lock))
80103ae7:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103aee:	e8 bd 07 00 00       	call   801042b0 <holding>
80103af3:	85 c0                	test   %eax,%eax
80103af5:	74 4d                	je     80103b44 <sched+0x64>
    panic("sched ptable.lock");
  if(cpu->ncli != 1)
80103af7:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103afd:	83 b8 ac 00 00 00 01 	cmpl   $0x1,0xac(%eax)
80103b04:	75 62                	jne    80103b68 <sched+0x88>
    panic("sched locks");
  if(proc->state == RUNNING)
80103b06:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80103b0d:	83 7a 0c 04          	cmpl   $0x4,0xc(%edx)
80103b11:	74 49                	je     80103b5c <sched+0x7c>

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103b13:	9c                   	pushf  
80103b14:	59                   	pop    %ecx
    panic("sched running");
  if(readeflags()&FL_IF)
80103b15:	80 e5 02             	and    $0x2,%ch
80103b18:	75 36                	jne    80103b50 <sched+0x70>
    panic("sched interruptible");
  intena = cpu->intena;
80103b1a:	8b 98 b0 00 00 00    	mov    0xb0(%eax),%ebx
  swtch(&proc->context, cpu->scheduler);
80103b20:	83 c2 1c             	add    $0x1c,%edx
80103b23:	8b 40 04             	mov    0x4(%eax),%eax
80103b26:	89 14 24             	mov    %edx,(%esp)
80103b29:	89 44 24 04          	mov    %eax,0x4(%esp)
80103b2d:	e8 a9 0a 00 00       	call   801045db <swtch>
  cpu->intena = intena;
80103b32:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103b38:	89 98 b0 00 00 00    	mov    %ebx,0xb0(%eax)
}
80103b3e:	83 c4 14             	add    $0x14,%esp
80103b41:	5b                   	pop    %ebx
80103b42:	5d                   	pop    %ebp
80103b43:	c3                   	ret    
sched(void)
{
  int intena;

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
80103b44:	c7 04 24 38 73 10 80 	movl   $0x80107338,(%esp)
80103b4b:	e8 10 c8 ff ff       	call   80100360 <panic>
  if(cpu->ncli != 1)
    panic("sched locks");
  if(proc->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
80103b50:	c7 04 24 64 73 10 80 	movl   $0x80107364,(%esp)
80103b57:	e8 04 c8 ff ff       	call   80100360 <panic>
  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(cpu->ncli != 1)
    panic("sched locks");
  if(proc->state == RUNNING)
    panic("sched running");
80103b5c:	c7 04 24 56 73 10 80 	movl   $0x80107356,(%esp)
80103b63:	e8 f8 c7 ff ff       	call   80100360 <panic>
  int intena;

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(cpu->ncli != 1)
    panic("sched locks");
80103b68:	c7 04 24 4a 73 10 80 	movl   $0x8010734a,(%esp)
80103b6f:	e8 ec c7 ff ff       	call   80100360 <panic>
80103b74:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103b7a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103b80 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80103b80:	55                   	push   %ebp
80103b81:	89 e5                	mov    %esp,%ebp
80103b83:	56                   	push   %esi
80103b84:	53                   	push   %ebx
  struct proc *p;
  int fd;

  if(proc == initproc)
80103b85:	31 db                	xor    %ebx,%ebx
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80103b87:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;
  int fd;

  if(proc == initproc)
80103b8a:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80103b91:	3b 15 bc a5 10 80    	cmp    0x8010a5bc,%edx
80103b97:	0f 84 0b 01 00 00    	je     80103ca8 <exit+0x128>
80103b9d:	8d 76 00             	lea    0x0(%esi),%esi
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd]){
80103ba0:	8d 73 08             	lea    0x8(%ebx),%esi
80103ba3:	8b 44 b2 08          	mov    0x8(%edx,%esi,4),%eax
80103ba7:	85 c0                	test   %eax,%eax
80103ba9:	74 17                	je     80103bc2 <exit+0x42>
      fileclose(proc->ofile[fd]);
80103bab:	89 04 24             	mov    %eax,(%esp)
80103bae:	e8 6d d2 ff ff       	call   80100e20 <fileclose>
      proc->ofile[fd] = 0;
80103bb3:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80103bba:	c7 44 b2 08 00 00 00 	movl   $0x0,0x8(%edx,%esi,4)
80103bc1:	00 

  if(proc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80103bc2:	83 c3 01             	add    $0x1,%ebx
80103bc5:	83 fb 10             	cmp    $0x10,%ebx
80103bc8:	75 d6                	jne    80103ba0 <exit+0x20>
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  begin_op();
80103bca:	e8 b1 ef ff ff       	call   80102b80 <begin_op>
  iput(proc->cwd);
80103bcf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103bd5:	8b 40 68             	mov    0x68(%eax),%eax
80103bd8:	89 04 24             	mov    %eax,(%esp)
80103bdb:	e8 e0 db ff ff       	call   801017c0 <iput>
  end_op();
80103be0:	e8 0b f0 ff ff       	call   80102bf0 <end_op>
  proc->cwd = 0;
80103be5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103beb:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
80103bf2:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103bf9:	e8 22 06 00 00       	call   80104220 <acquire>

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
80103bfe:	65 8b 0d 04 00 00 00 	mov    %gs:0x4,%ecx
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103c05:	b8 d4 2d 11 80       	mov    $0x80112dd4,%eax
  proc->cwd = 0;

  acquire(&ptable.lock);

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
80103c0a:	8b 51 14             	mov    0x14(%ecx),%edx
80103c0d:	eb 0d                	jmp    80103c1c <exit+0x9c>
80103c0f:	90                   	nop
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103c10:	05 d8 00 00 00       	add    $0xd8,%eax
80103c15:	3d d4 63 11 80       	cmp    $0x801163d4,%eax
80103c1a:	74 1e                	je     80103c3a <exit+0xba>
    if(p->state == SLEEPING && p->chan == chan)
80103c1c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103c20:	75 ee                	jne    80103c10 <exit+0x90>
80103c22:	3b 50 20             	cmp    0x20(%eax),%edx
80103c25:	75 e9                	jne    80103c10 <exit+0x90>
      p->state = RUNNABLE;
80103c27:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103c2e:	05 d8 00 00 00       	add    $0xd8,%eax
80103c33:	3d d4 63 11 80       	cmp    $0x801163d4,%eax
80103c38:	75 e2                	jne    80103c1c <exit+0x9c>
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == proc){
      p->parent = initproc;
80103c3a:	8b 1d bc a5 10 80    	mov    0x8010a5bc,%ebx
80103c40:	ba d4 2d 11 80       	mov    $0x80112dd4,%edx
80103c45:	eb 0f                	jmp    80103c56 <exit+0xd6>
80103c47:	90                   	nop

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103c48:	81 c2 d8 00 00 00    	add    $0xd8,%edx
80103c4e:	81 fa d4 63 11 80    	cmp    $0x801163d4,%edx
80103c54:	74 3a                	je     80103c90 <exit+0x110>
    if(p->parent == proc){
80103c56:	3b 4a 14             	cmp    0x14(%edx),%ecx
80103c59:	75 ed                	jne    80103c48 <exit+0xc8>
      p->parent = initproc;
      if(p->state == ZOMBIE)
80103c5b:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == proc){
      p->parent = initproc;
80103c5f:	89 5a 14             	mov    %ebx,0x14(%edx)
      if(p->state == ZOMBIE)
80103c62:	75 e4                	jne    80103c48 <exit+0xc8>
80103c64:	b8 d4 2d 11 80       	mov    $0x80112dd4,%eax
80103c69:	eb 11                	jmp    80103c7c <exit+0xfc>
80103c6b:	90                   	nop
80103c6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103c70:	05 d8 00 00 00       	add    $0xd8,%eax
80103c75:	3d d4 63 11 80       	cmp    $0x801163d4,%eax
80103c7a:	74 cc                	je     80103c48 <exit+0xc8>
    if(p->state == SLEEPING && p->chan == chan)
80103c7c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103c80:	75 ee                	jne    80103c70 <exit+0xf0>
80103c82:	3b 58 20             	cmp    0x20(%eax),%ebx
80103c85:	75 e9                	jne    80103c70 <exit+0xf0>
      p->state = RUNNABLE;
80103c87:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103c8e:	eb e0                	jmp    80103c70 <exit+0xf0>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  proc->state = ZOMBIE;
80103c90:	c7 41 0c 05 00 00 00 	movl   $0x5,0xc(%ecx)
  sched();
80103c97:	e8 44 fe ff ff       	call   80103ae0 <sched>
  panic("zombie exit");
80103c9c:	c7 04 24 85 73 10 80 	movl   $0x80107385,(%esp)
80103ca3:	e8 b8 c6 ff ff       	call   80100360 <panic>
{
  struct proc *p;
  int fd;

  if(proc == initproc)
    panic("init exiting");
80103ca8:	c7 04 24 78 73 10 80 	movl   $0x80107378,(%esp)
80103caf:	e8 ac c6 ff ff       	call   80100360 <panic>
80103cb4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103cba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103cc0 <yield>:
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
80103cc0:	55                   	push   %ebp
80103cc1:	89 e5                	mov    %esp,%ebp
80103cc3:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103cc6:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103ccd:	e8 4e 05 00 00       	call   80104220 <acquire>
  proc->state = RUNNABLE;
80103cd2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103cd8:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
80103cdf:	e8 fc fd ff ff       	call   80103ae0 <sched>
  release(&ptable.lock);
80103ce4:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103ceb:	e8 60 06 00 00       	call   80104350 <release>
}
80103cf0:	c9                   	leave  
80103cf1:	c3                   	ret    
80103cf2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103cf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103d00 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80103d00:	55                   	push   %ebp
80103d01:	89 e5                	mov    %esp,%ebp
80103d03:	56                   	push   %esi
80103d04:	53                   	push   %ebx
80103d05:	83 ec 10             	sub    $0x10,%esp
  if(proc == 0)
80103d08:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80103d0e:	8b 75 08             	mov    0x8(%ebp),%esi
80103d11:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  if(proc == 0)
80103d14:	85 c0                	test   %eax,%eax
80103d16:	0f 84 8b 00 00 00    	je     80103da7 <sleep+0xa7>
    panic("sleep");

  if(lk == 0)
80103d1c:	85 db                	test   %ebx,%ebx
80103d1e:	74 7b                	je     80103d9b <sleep+0x9b>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103d20:	81 fb a0 2d 11 80    	cmp    $0x80112da0,%ebx
80103d26:	74 50                	je     80103d78 <sleep+0x78>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103d28:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103d2f:	e8 ec 04 00 00       	call   80104220 <acquire>
    release(lk);
80103d34:	89 1c 24             	mov    %ebx,(%esp)
80103d37:	e8 14 06 00 00       	call   80104350 <release>
  }

  // Go to sleep.
  proc->chan = chan;
80103d3c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103d42:	89 70 20             	mov    %esi,0x20(%eax)
  proc->state = SLEEPING;
80103d45:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
80103d4c:	e8 8f fd ff ff       	call   80103ae0 <sched>

  // Tidy up.
  proc->chan = 0;
80103d51:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103d57:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
80103d5e:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103d65:	e8 e6 05 00 00       	call   80104350 <release>
    acquire(lk);
80103d6a:	89 5d 08             	mov    %ebx,0x8(%ebp)
  }
}
80103d6d:	83 c4 10             	add    $0x10,%esp
80103d70:	5b                   	pop    %ebx
80103d71:	5e                   	pop    %esi
80103d72:	5d                   	pop    %ebp
  proc->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
80103d73:	e9 a8 04 00 00       	jmp    80104220 <acquire>
    acquire(&ptable.lock);  //DOC: sleeplock1
    release(lk);
  }

  // Go to sleep.
  proc->chan = chan;
80103d78:	89 70 20             	mov    %esi,0x20(%eax)
  proc->state = SLEEPING;
80103d7b:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
80103d82:	e8 59 fd ff ff       	call   80103ae0 <sched>

  // Tidy up.
  proc->chan = 0;
80103d87:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103d8d:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)
  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}
80103d94:	83 c4 10             	add    $0x10,%esp
80103d97:	5b                   	pop    %ebx
80103d98:	5e                   	pop    %esi
80103d99:	5d                   	pop    %ebp
80103d9a:	c3                   	ret    
{
  if(proc == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");
80103d9b:	c7 04 24 97 73 10 80 	movl   $0x80107397,(%esp)
80103da2:	e8 b9 c5 ff ff       	call   80100360 <panic>
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
  if(proc == 0)
    panic("sleep");
80103da7:	c7 04 24 91 73 10 80 	movl   $0x80107391,(%esp)
80103dae:	e8 ad c5 ff ff       	call   80100360 <panic>
80103db3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103db9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103dc0 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
80103dc0:	55                   	push   %ebp
80103dc1:	89 e5                	mov    %esp,%ebp
80103dc3:	56                   	push   %esi
80103dc4:	53                   	push   %ebx
80103dc5:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
80103dc8:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103dcf:	e8 4c 04 00 00       	call   80104220 <acquire>
80103dd4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
80103dda:	31 d2                	xor    %edx,%edx
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ddc:	bb d4 2d 11 80       	mov    $0x80112dd4,%ebx
80103de1:	eb 13                	jmp    80103df6 <wait+0x36>
80103de3:	90                   	nop
80103de4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103de8:	81 c3 d8 00 00 00    	add    $0xd8,%ebx
80103dee:	81 fb d4 63 11 80    	cmp    $0x801163d4,%ebx
80103df4:	74 22                	je     80103e18 <wait+0x58>
      if(p->parent != proc)
80103df6:	39 43 14             	cmp    %eax,0x14(%ebx)
80103df9:	75 ed                	jne    80103de8 <wait+0x28>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
80103dfb:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103dff:	74 34                	je     80103e35 <wait+0x75>

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e01:	81 c3 d8 00 00 00    	add    $0xd8,%ebx
      if(p->parent != proc)
        continue;
      havekids = 1;
80103e07:	ba 01 00 00 00       	mov    $0x1,%edx

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e0c:	81 fb d4 63 11 80    	cmp    $0x801163d4,%ebx
80103e12:	75 e2                	jne    80103df6 <wait+0x36>
80103e14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
80103e18:	85 d2                	test   %edx,%edx
80103e1a:	74 6e                	je     80103e8a <wait+0xca>
80103e1c:	8b 50 24             	mov    0x24(%eax),%edx
80103e1f:	85 d2                	test   %edx,%edx
80103e21:	75 67                	jne    80103e8a <wait+0xca>
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
80103e23:	c7 44 24 04 a0 2d 11 	movl   $0x80112da0,0x4(%esp)
80103e2a:	80 
80103e2b:	89 04 24             	mov    %eax,(%esp)
80103e2e:	e8 cd fe ff ff       	call   80103d00 <sleep>
  }
80103e33:	eb 9f                	jmp    80103dd4 <wait+0x14>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
80103e35:	8b 43 08             	mov    0x8(%ebx),%eax
      if(p->parent != proc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
80103e38:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80103e3b:	89 04 24             	mov    %eax,(%esp)
80103e3e:	e8 9d e4 ff ff       	call   801022e0 <kfree>
        p->kstack = 0;
        freevm(p->pgdir);
80103e43:	8b 43 04             	mov    0x4(%ebx),%eax
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
80103e46:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80103e4d:	89 04 24             	mov    %eax,(%esp)
80103e50:	e8 fb 2c 00 00       	call   80106b50 <freevm>
        p->pid = 0;
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
        release(&ptable.lock);
80103e55:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
        freevm(p->pgdir);
        p->pid = 0;
80103e5c:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80103e63:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80103e6a:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80103e6e:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80103e75:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80103e7c:	e8 cf 04 00 00       	call   80104350 <release>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103e81:	83 c4 10             	add    $0x10,%esp
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
        release(&ptable.lock);
        return pid;
80103e84:	89 f0                	mov    %esi,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103e86:	5b                   	pop    %ebx
80103e87:	5e                   	pop    %esi
80103e88:	5d                   	pop    %ebp
80103e89:	c3                   	ret    
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
      release(&ptable.lock);
80103e8a:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103e91:	e8 ba 04 00 00       	call   80104350 <release>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103e96:	83 c4 10             	add    $0x10,%esp
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
      release(&ptable.lock);
      return -1;
80103e99:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103e9e:	5b                   	pop    %ebx
80103e9f:	5e                   	pop    %esi
80103ea0:	5d                   	pop    %ebp
80103ea1:	c3                   	ret    
80103ea2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103ea9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103eb0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80103eb0:	55                   	push   %ebp
80103eb1:	89 e5                	mov    %esp,%ebp
80103eb3:	53                   	push   %ebx
80103eb4:	83 ec 14             	sub    $0x14,%esp
80103eb7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80103eba:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103ec1:	e8 5a 03 00 00       	call   80104220 <acquire>
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ec6:	b8 d4 2d 11 80       	mov    $0x80112dd4,%eax
80103ecb:	eb 0f                	jmp    80103edc <wakeup+0x2c>
80103ecd:	8d 76 00             	lea    0x0(%esi),%esi
80103ed0:	05 d8 00 00 00       	add    $0xd8,%eax
80103ed5:	3d d4 63 11 80       	cmp    $0x801163d4,%eax
80103eda:	74 24                	je     80103f00 <wakeup+0x50>
    if(p->state == SLEEPING && p->chan == chan)
80103edc:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103ee0:	75 ee                	jne    80103ed0 <wakeup+0x20>
80103ee2:	3b 58 20             	cmp    0x20(%eax),%ebx
80103ee5:	75 e9                	jne    80103ed0 <wakeup+0x20>
      p->state = RUNNABLE;
80103ee7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103eee:	05 d8 00 00 00       	add    $0xd8,%eax
80103ef3:	3d d4 63 11 80       	cmp    $0x801163d4,%eax
80103ef8:	75 e2                	jne    80103edc <wakeup+0x2c>
80103efa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
80103f00:	c7 45 08 a0 2d 11 80 	movl   $0x80112da0,0x8(%ebp)
}
80103f07:	83 c4 14             	add    $0x14,%esp
80103f0a:	5b                   	pop    %ebx
80103f0b:	5d                   	pop    %ebp
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
80103f0c:	e9 3f 04 00 00       	jmp    80104350 <release>
80103f11:	eb 0d                	jmp    80103f20 <kill>
80103f13:	90                   	nop
80103f14:	90                   	nop
80103f15:	90                   	nop
80103f16:	90                   	nop
80103f17:	90                   	nop
80103f18:	90                   	nop
80103f19:	90                   	nop
80103f1a:	90                   	nop
80103f1b:	90                   	nop
80103f1c:	90                   	nop
80103f1d:	90                   	nop
80103f1e:	90                   	nop
80103f1f:	90                   	nop

80103f20 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80103f20:	55                   	push   %ebp
80103f21:	89 e5                	mov    %esp,%ebp
80103f23:	53                   	push   %ebx
80103f24:	83 ec 14             	sub    $0x14,%esp
80103f27:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
80103f2a:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103f31:	e8 ea 02 00 00       	call   80104220 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f36:	b8 d4 2d 11 80       	mov    $0x80112dd4,%eax
80103f3b:	eb 0f                	jmp    80103f4c <kill+0x2c>
80103f3d:	8d 76 00             	lea    0x0(%esi),%esi
80103f40:	05 d8 00 00 00       	add    $0xd8,%eax
80103f45:	3d d4 63 11 80       	cmp    $0x801163d4,%eax
80103f4a:	74 3c                	je     80103f88 <kill+0x68>
    if(p->pid == pid){
80103f4c:	39 58 10             	cmp    %ebx,0x10(%eax)
80103f4f:	75 ef                	jne    80103f40 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80103f51:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
80103f55:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80103f5c:	74 1a                	je     80103f78 <kill+0x58>
        p->state = RUNNABLE;
      release(&ptable.lock);
80103f5e:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103f65:	e8 e6 03 00 00       	call   80104350 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80103f6a:	83 c4 14             	add    $0x14,%esp
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
80103f6d:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
80103f6f:	5b                   	pop    %ebx
80103f70:	5d                   	pop    %ebp
80103f71:	c3                   	ret    
80103f72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
80103f78:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103f7f:	eb dd                	jmp    80103f5e <kill+0x3e>
80103f81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
80103f88:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103f8f:	e8 bc 03 00 00       	call   80104350 <release>
  return -1;
}
80103f94:	83 c4 14             	add    $0x14,%esp
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
80103f97:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103f9c:	5b                   	pop    %ebx
80103f9d:	5d                   	pop    %ebp
80103f9e:	c3                   	ret    
80103f9f:	90                   	nop

80103fa0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80103fa0:	55                   	push   %ebp
80103fa1:	89 e5                	mov    %esp,%ebp
80103fa3:	57                   	push   %edi
80103fa4:	56                   	push   %esi
80103fa5:	53                   	push   %ebx
80103fa6:	bb 40 2e 11 80       	mov    $0x80112e40,%ebx
80103fab:	83 ec 4c             	sub    $0x4c,%esp
80103fae:	8d 75 e8             	lea    -0x18(%ebp),%esi
80103fb1:	eb 23                	jmp    80103fd6 <procdump+0x36>
80103fb3:	90                   	nop
80103fb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80103fb8:	c7 04 24 e6 72 10 80 	movl   $0x801072e6,(%esp)
80103fbf:	e8 8c c6 ff ff       	call   80100650 <cprintf>
80103fc4:	81 c3 d8 00 00 00    	add    $0xd8,%ebx
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103fca:	81 fb 40 64 11 80    	cmp    $0x80116440,%ebx
80103fd0:	0f 84 8a 00 00 00    	je     80104060 <procdump+0xc0>
    if(p->state == UNUSED)
80103fd6:	8b 43 a0             	mov    -0x60(%ebx),%eax
80103fd9:	85 c0                	test   %eax,%eax
80103fdb:	74 e7                	je     80103fc4 <procdump+0x24>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80103fdd:	83 f8 05             	cmp    $0x5,%eax
      state = states[p->state];
    else
      state = "???";
80103fe0:	ba a8 73 10 80       	mov    $0x801073a8,%edx
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80103fe5:	77 11                	ja     80103ff8 <procdump+0x58>
80103fe7:	8b 14 85 e0 73 10 80 	mov    -0x7fef8c20(,%eax,4),%edx
      state = states[p->state];
    else
      state = "???";
80103fee:	b8 a8 73 10 80       	mov    $0x801073a8,%eax
80103ff3:	85 d2                	test   %edx,%edx
80103ff5:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80103ff8:	8b 43 a4             	mov    -0x5c(%ebx),%eax
80103ffb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
80103fff:	89 54 24 08          	mov    %edx,0x8(%esp)
80104003:	c7 04 24 ac 73 10 80 	movl   $0x801073ac,(%esp)
8010400a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010400e:	e8 3d c6 ff ff       	call   80100650 <cprintf>
    if(p->state == SLEEPING){
80104013:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80104017:	75 9f                	jne    80103fb8 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104019:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010401c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104020:	8b 43 b0             	mov    -0x50(%ebx),%eax
80104023:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104026:	8b 40 0c             	mov    0xc(%eax),%eax
80104029:	83 c0 08             	add    $0x8,%eax
8010402c:	89 04 24             	mov    %eax,(%esp)
8010402f:	e8 8c 01 00 00       	call   801041c0 <getcallerpcs>
80104034:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      for(i=0; i<10 && pc[i] != 0; i++)
80104038:	8b 17                	mov    (%edi),%edx
8010403a:	85 d2                	test   %edx,%edx
8010403c:	0f 84 76 ff ff ff    	je     80103fb8 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104042:	89 54 24 04          	mov    %edx,0x4(%esp)
80104046:	83 c7 04             	add    $0x4,%edi
80104049:	c7 04 24 09 6e 10 80 	movl   $0x80106e09,(%esp)
80104050:	e8 fb c5 ff ff       	call   80100650 <cprintf>
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
80104055:	39 f7                	cmp    %esi,%edi
80104057:	75 df                	jne    80104038 <procdump+0x98>
80104059:	e9 5a ff ff ff       	jmp    80103fb8 <procdump+0x18>
8010405e:	66 90                	xchg   %ax,%ax
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
80104060:	83 c4 4c             	add    $0x4c,%esp
80104063:	5b                   	pop    %ebx
80104064:	5e                   	pop    %esi
80104065:	5f                   	pop    %edi
80104066:	5d                   	pop    %ebp
80104067:	c3                   	ret    
80104068:	90                   	nop
80104069:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104070 <callcount>:

int callcount(int num) {
80104070:	55                   	push   %ebp
  if(num > -1 && num < NUM_CALLS + 1)
    return proc->callcount[num];
  return 0;
80104071:	31 c0                	xor    %eax,%eax
    }
    cprintf("\n");
  }
}

int callcount(int num) {
80104073:	89 e5                	mov    %esp,%ebp
80104075:	8b 55 08             	mov    0x8(%ebp),%edx
  if(num > -1 && num < NUM_CALLS + 1)
80104078:	83 fa 16             	cmp    $0x16,%edx
8010407b:	77 0a                	ja     80104087 <callcount+0x17>
    return proc->callcount[num];
8010407d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104083:	8b 44 90 7c          	mov    0x7c(%eax,%edx,4),%eax
  return 0;
}
80104087:	5d                   	pop    %ebp
80104088:	c3                   	ret    
80104089:	66 90                	xchg   %ax,%ax
8010408b:	66 90                	xchg   %ax,%ax
8010408d:	66 90                	xchg   %ax,%ax
8010408f:	90                   	nop

80104090 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104090:	55                   	push   %ebp
80104091:	89 e5                	mov    %esp,%ebp
80104093:	53                   	push   %ebx
80104094:	83 ec 14             	sub    $0x14,%esp
80104097:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010409a:	c7 44 24 04 f8 73 10 	movl   $0x801073f8,0x4(%esp)
801040a1:	80 
801040a2:	8d 43 04             	lea    0x4(%ebx),%eax
801040a5:	89 04 24             	mov    %eax,(%esp)
801040a8:	e8 f3 00 00 00       	call   801041a0 <initlock>
  lk->name = name;
801040ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
801040b0:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801040b6:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)

void
initsleeplock(struct sleeplock *lk, char *name)
{
  initlock(&lk->lk, "sleep lock");
  lk->name = name;
801040bd:	89 43 38             	mov    %eax,0x38(%ebx)
  lk->locked = 0;
  lk->pid = 0;
}
801040c0:	83 c4 14             	add    $0x14,%esp
801040c3:	5b                   	pop    %ebx
801040c4:	5d                   	pop    %ebp
801040c5:	c3                   	ret    
801040c6:	8d 76 00             	lea    0x0(%esi),%esi
801040c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801040d0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
801040d0:	55                   	push   %ebp
801040d1:	89 e5                	mov    %esp,%ebp
801040d3:	56                   	push   %esi
801040d4:	53                   	push   %ebx
801040d5:	83 ec 10             	sub    $0x10,%esp
801040d8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801040db:	8d 73 04             	lea    0x4(%ebx),%esi
801040de:	89 34 24             	mov    %esi,(%esp)
801040e1:	e8 3a 01 00 00       	call   80104220 <acquire>
  while (lk->locked) {
801040e6:	8b 13                	mov    (%ebx),%edx
801040e8:	85 d2                	test   %edx,%edx
801040ea:	74 16                	je     80104102 <acquiresleep+0x32>
801040ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sleep(lk, &lk->lk);
801040f0:	89 74 24 04          	mov    %esi,0x4(%esp)
801040f4:	89 1c 24             	mov    %ebx,(%esp)
801040f7:	e8 04 fc ff ff       	call   80103d00 <sleep>

void
acquiresleep(struct sleeplock *lk)
{
  acquire(&lk->lk);
  while (lk->locked) {
801040fc:	8b 03                	mov    (%ebx),%eax
801040fe:	85 c0                	test   %eax,%eax
80104100:	75 ee                	jne    801040f0 <acquiresleep+0x20>
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
80104102:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = proc->pid;
80104108:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010410e:	8b 40 10             	mov    0x10(%eax),%eax
80104111:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104114:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104117:	83 c4 10             	add    $0x10,%esp
8010411a:	5b                   	pop    %ebx
8010411b:	5e                   	pop    %esi
8010411c:	5d                   	pop    %ebp
  while (lk->locked) {
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
  lk->pid = proc->pid;
  release(&lk->lk);
8010411d:	e9 2e 02 00 00       	jmp    80104350 <release>
80104122:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104129:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104130 <releasesleep>:
}

void
releasesleep(struct sleeplock *lk)
{
80104130:	55                   	push   %ebp
80104131:	89 e5                	mov    %esp,%ebp
80104133:	56                   	push   %esi
80104134:	53                   	push   %ebx
80104135:	83 ec 10             	sub    $0x10,%esp
80104138:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
8010413b:	8d 73 04             	lea    0x4(%ebx),%esi
8010413e:	89 34 24             	mov    %esi,(%esp)
80104141:	e8 da 00 00 00       	call   80104220 <acquire>
  lk->locked = 0;
80104146:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010414c:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104153:	89 1c 24             	mov    %ebx,(%esp)
80104156:	e8 55 fd ff ff       	call   80103eb0 <wakeup>
  release(&lk->lk);
8010415b:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010415e:	83 c4 10             	add    $0x10,%esp
80104161:	5b                   	pop    %ebx
80104162:	5e                   	pop    %esi
80104163:	5d                   	pop    %ebp
{
  acquire(&lk->lk);
  lk->locked = 0;
  lk->pid = 0;
  wakeup(lk);
  release(&lk->lk);
80104164:	e9 e7 01 00 00       	jmp    80104350 <release>
80104169:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104170 <holdingsleep>:
}

int
holdingsleep(struct sleeplock *lk)
{
80104170:	55                   	push   %ebp
80104171:	89 e5                	mov    %esp,%ebp
80104173:	56                   	push   %esi
80104174:	53                   	push   %ebx
80104175:	83 ec 10             	sub    $0x10,%esp
80104178:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
8010417b:	8d 73 04             	lea    0x4(%ebx),%esi
8010417e:	89 34 24             	mov    %esi,(%esp)
80104181:	e8 9a 00 00 00       	call   80104220 <acquire>
  r = lk->locked;
80104186:	8b 1b                	mov    (%ebx),%ebx
  release(&lk->lk);
80104188:	89 34 24             	mov    %esi,(%esp)
8010418b:	e8 c0 01 00 00       	call   80104350 <release>
  return r;
}
80104190:	83 c4 10             	add    $0x10,%esp
80104193:	89 d8                	mov    %ebx,%eax
80104195:	5b                   	pop    %ebx
80104196:	5e                   	pop    %esi
80104197:	5d                   	pop    %ebp
80104198:	c3                   	ret    
80104199:	66 90                	xchg   %ax,%ax
8010419b:	66 90                	xchg   %ax,%ax
8010419d:	66 90                	xchg   %ax,%ax
8010419f:	90                   	nop

801041a0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801041a0:	55                   	push   %ebp
801041a1:	89 e5                	mov    %esp,%ebp
801041a3:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
801041a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
801041a9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
  lk->name = name;
801041af:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
  lk->cpu = 0;
801041b2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801041b9:	5d                   	pop    %ebp
801041ba:	c3                   	ret    
801041bb:	90                   	nop
801041bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801041c0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801041c0:	55                   	push   %ebp
801041c1:	89 e5                	mov    %esp,%ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
801041c3:	8b 45 08             	mov    0x8(%ebp),%eax
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801041c6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801041c9:	53                   	push   %ebx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
801041ca:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
801041cd:	31 c0                	xor    %eax,%eax
801041cf:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801041d0:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
801041d6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801041dc:	77 1a                	ja     801041f8 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
801041de:	8b 5a 04             	mov    0x4(%edx),%ebx
801041e1:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801041e4:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
801041e7:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801041e9:	83 f8 0a             	cmp    $0xa,%eax
801041ec:	75 e2                	jne    801041d0 <getcallerpcs+0x10>
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
801041ee:	5b                   	pop    %ebx
801041ef:	5d                   	pop    %ebp
801041f0:	c3                   	ret    
801041f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
801041f8:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801041ff:	83 c0 01             	add    $0x1,%eax
80104202:	83 f8 0a             	cmp    $0xa,%eax
80104205:	74 e7                	je     801041ee <getcallerpcs+0x2e>
    pcs[i] = 0;
80104207:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
8010420e:	83 c0 01             	add    $0x1,%eax
80104211:	83 f8 0a             	cmp    $0xa,%eax
80104214:	75 e2                	jne    801041f8 <getcallerpcs+0x38>
80104216:	eb d6                	jmp    801041ee <getcallerpcs+0x2e>
80104218:	90                   	nop
80104219:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104220 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80104220:	55                   	push   %ebp
80104221:	89 e5                	mov    %esp,%ebp
80104223:	83 ec 18             	sub    $0x18,%esp
80104226:	9c                   	pushf  
80104227:	59                   	pop    %ecx
}

static inline void
cli(void)
{
  asm volatile("cli");
80104228:	fa                   	cli    
{
  int eflags;

  eflags = readeflags();
  cli();
  if(cpu->ncli == 0)
80104229:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010422f:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80104235:	85 d2                	test   %edx,%edx
80104237:	75 0c                	jne    80104245 <acquire+0x25>
    cpu->intena = eflags & FL_IF;
80104239:	81 e1 00 02 00 00    	and    $0x200,%ecx
8010423f:	89 88 b0 00 00 00    	mov    %ecx,0xb0(%eax)
  cpu->ncli += 1;
80104245:	83 c2 01             	add    $0x1,%edx
80104248:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
8010424e:	8b 55 08             	mov    0x8(%ebp),%edx

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == cpu;
80104251:	8b 0a                	mov    (%edx),%ecx
80104253:	85 c9                	test   %ecx,%ecx
80104255:	74 05                	je     8010425c <acquire+0x3c>
80104257:	3b 42 08             	cmp    0x8(%edx),%eax
8010425a:	74 3e                	je     8010429a <acquire+0x7a>
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010425c:	b9 01 00 00 00       	mov    $0x1,%ecx
80104261:	eb 08                	jmp    8010426b <acquire+0x4b>
80104263:	90                   	nop
80104264:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104268:	8b 55 08             	mov    0x8(%ebp),%edx
8010426b:	89 c8                	mov    %ecx,%eax
8010426d:	f0 87 02             	lock xchg %eax,(%edx)
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
    panic("acquire");

  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
80104270:	85 c0                	test   %eax,%eax
80104272:	75 f4                	jne    80104268 <acquire+0x48>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
80104274:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
80104279:	8b 45 08             	mov    0x8(%ebp),%eax
8010427c:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
  getcallerpcs(&lk, lk->pcs);
80104283:	83 c0 0c             	add    $0xc,%eax
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
80104286:	89 50 fc             	mov    %edx,-0x4(%eax)
  getcallerpcs(&lk, lk->pcs);
80104289:	89 44 24 04          	mov    %eax,0x4(%esp)
8010428d:	8d 45 08             	lea    0x8(%ebp),%eax
80104290:	89 04 24             	mov    %eax,(%esp)
80104293:	e8 28 ff ff ff       	call   801041c0 <getcallerpcs>
}
80104298:	c9                   	leave  
80104299:	c3                   	ret    
void
acquire(struct spinlock *lk)
{
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
    panic("acquire");
8010429a:	c7 04 24 03 74 10 80 	movl   $0x80107403,(%esp)
801042a1:	e8 ba c0 ff ff       	call   80100360 <panic>
801042a6:	8d 76 00             	lea    0x0(%esi),%esi
801042a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801042b0 <holding>:
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
801042b0:	55                   	push   %ebp
  return lock->locked && lock->cpu == cpu;
801042b1:	31 c0                	xor    %eax,%eax
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
801042b3:	89 e5                	mov    %esp,%ebp
801042b5:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == cpu;
801042b8:	8b 0a                	mov    (%edx),%ecx
801042ba:	85 c9                	test   %ecx,%ecx
801042bc:	74 0f                	je     801042cd <holding+0x1d>
801042be:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801042c4:	39 42 08             	cmp    %eax,0x8(%edx)
801042c7:	0f 94 c0             	sete   %al
801042ca:	0f b6 c0             	movzbl %al,%eax
}
801042cd:	5d                   	pop    %ebp
801042ce:	c3                   	ret    
801042cf:	90                   	nop

801042d0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801042d0:	55                   	push   %ebp
801042d1:	89 e5                	mov    %esp,%ebp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801042d3:	9c                   	pushf  
801042d4:	59                   	pop    %ecx
}

static inline void
cli(void)
{
  asm volatile("cli");
801042d5:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(cpu->ncli == 0)
801042d6:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801042dc:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
801042e2:	85 d2                	test   %edx,%edx
801042e4:	75 0c                	jne    801042f2 <pushcli+0x22>
    cpu->intena = eflags & FL_IF;
801042e6:	81 e1 00 02 00 00    	and    $0x200,%ecx
801042ec:	89 88 b0 00 00 00    	mov    %ecx,0xb0(%eax)
  cpu->ncli += 1;
801042f2:	83 c2 01             	add    $0x1,%edx
801042f5:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
}
801042fb:	5d                   	pop    %ebp
801042fc:	c3                   	ret    
801042fd:	8d 76 00             	lea    0x0(%esi),%esi

80104300 <popcli>:

void
popcli(void)
{
80104300:	55                   	push   %ebp
80104301:	89 e5                	mov    %esp,%ebp
80104303:	83 ec 18             	sub    $0x18,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104306:	9c                   	pushf  
80104307:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104308:	f6 c4 02             	test   $0x2,%ah
8010430b:	75 34                	jne    80104341 <popcli+0x41>
    panic("popcli - interruptible");
  if(--cpu->ncli < 0)
8010430d:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104313:	8b 88 ac 00 00 00    	mov    0xac(%eax),%ecx
80104319:	8d 51 ff             	lea    -0x1(%ecx),%edx
8010431c:	85 d2                	test   %edx,%edx
8010431e:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
80104324:	78 0f                	js     80104335 <popcli+0x35>
    panic("popcli");
  if(cpu->ncli == 0 && cpu->intena)
80104326:	75 0b                	jne    80104333 <popcli+0x33>
80104328:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
8010432e:	85 c0                	test   %eax,%eax
80104330:	74 01                	je     80104333 <popcli+0x33>
}

static inline void
sti(void)
{
  asm volatile("sti");
80104332:	fb                   	sti    
    sti();
}
80104333:	c9                   	leave  
80104334:	c3                   	ret    
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--cpu->ncli < 0)
    panic("popcli");
80104335:	c7 04 24 22 74 10 80 	movl   $0x80107422,(%esp)
8010433c:	e8 1f c0 ff ff       	call   80100360 <panic>

void
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
80104341:	c7 04 24 0b 74 10 80 	movl   $0x8010740b,(%esp)
80104348:	e8 13 c0 ff ff       	call   80100360 <panic>
8010434d:	8d 76 00             	lea    0x0(%esi),%esi

80104350 <release>:
}

// Release the lock.
void
release(struct spinlock *lk)
{
80104350:	55                   	push   %ebp
80104351:	89 e5                	mov    %esp,%ebp
80104353:	83 ec 18             	sub    $0x18,%esp
80104356:	8b 45 08             	mov    0x8(%ebp),%eax

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == cpu;
80104359:	8b 10                	mov    (%eax),%edx
8010435b:	85 d2                	test   %edx,%edx
8010435d:	74 0c                	je     8010436b <release+0x1b>
8010435f:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104366:	39 50 08             	cmp    %edx,0x8(%eax)
80104369:	74 0d                	je     80104378 <release+0x28>
// Release the lock.
void
release(struct spinlock *lk)
{
  if(!holding(lk))
    panic("release");
8010436b:	c7 04 24 29 74 10 80 	movl   $0x80107429,(%esp)
80104372:	e8 e9 bf ff ff       	call   80100360 <panic>
80104377:	90                   	nop

  lk->pcs[0] = 0;
80104378:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
8010437f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that all the stores in the critical
  // section are visible to other cores before the lock is released.
  // Both the C compiler and the hardware may re-order loads and
  // stores; __sync_synchronize() tells them both not to.
  __sync_synchronize();
80104386:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010438b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  popcli();
}
80104391:	c9                   	leave  
  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );

  popcli();
80104392:	e9 69 ff ff ff       	jmp    80104300 <popcli>
80104397:	66 90                	xchg   %ax,%ax
80104399:	66 90                	xchg   %ax,%ax
8010439b:	66 90                	xchg   %ax,%ax
8010439d:	66 90                	xchg   %ax,%ax
8010439f:	90                   	nop

801043a0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801043a0:	55                   	push   %ebp
801043a1:	89 e5                	mov    %esp,%ebp
801043a3:	8b 55 08             	mov    0x8(%ebp),%edx
801043a6:	57                   	push   %edi
801043a7:	8b 4d 10             	mov    0x10(%ebp),%ecx
801043aa:	53                   	push   %ebx
  if ((int)dst%4 == 0 && n%4 == 0){
801043ab:	f6 c2 03             	test   $0x3,%dl
801043ae:	75 05                	jne    801043b5 <memset+0x15>
801043b0:	f6 c1 03             	test   $0x3,%cl
801043b3:	74 13                	je     801043c8 <memset+0x28>
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
801043b5:	89 d7                	mov    %edx,%edi
801043b7:	8b 45 0c             	mov    0xc(%ebp),%eax
801043ba:	fc                   	cld    
801043bb:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
801043bd:	5b                   	pop    %ebx
801043be:	89 d0                	mov    %edx,%eax
801043c0:	5f                   	pop    %edi
801043c1:	5d                   	pop    %ebp
801043c2:	c3                   	ret    
801043c3:	90                   	nop
801043c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

void*
memset(void *dst, int c, uint n)
{
  if ((int)dst%4 == 0 && n%4 == 0){
    c &= 0xFF;
801043c8:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801043cc:	c1 e9 02             	shr    $0x2,%ecx
801043cf:	89 f8                	mov    %edi,%eax
801043d1:	89 fb                	mov    %edi,%ebx
801043d3:	c1 e0 18             	shl    $0x18,%eax
801043d6:	c1 e3 10             	shl    $0x10,%ebx
801043d9:	09 d8                	or     %ebx,%eax
801043db:	09 f8                	or     %edi,%eax
801043dd:	c1 e7 08             	shl    $0x8,%edi
801043e0:	09 f8                	or     %edi,%eax
}

static inline void
stosl(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosl" :
801043e2:	89 d7                	mov    %edx,%edi
801043e4:	fc                   	cld    
801043e5:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
801043e7:	5b                   	pop    %ebx
801043e8:	89 d0                	mov    %edx,%eax
801043ea:	5f                   	pop    %edi
801043eb:	5d                   	pop    %ebp
801043ec:	c3                   	ret    
801043ed:	8d 76 00             	lea    0x0(%esi),%esi

801043f0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801043f0:	55                   	push   %ebp
801043f1:	89 e5                	mov    %esp,%ebp
801043f3:	8b 45 10             	mov    0x10(%ebp),%eax
801043f6:	57                   	push   %edi
801043f7:	56                   	push   %esi
801043f8:	8b 75 0c             	mov    0xc(%ebp),%esi
801043fb:	53                   	push   %ebx
801043fc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801043ff:	85 c0                	test   %eax,%eax
80104401:	8d 78 ff             	lea    -0x1(%eax),%edi
80104404:	74 26                	je     8010442c <memcmp+0x3c>
    if(*s1 != *s2)
80104406:	0f b6 03             	movzbl (%ebx),%eax
80104409:	31 d2                	xor    %edx,%edx
8010440b:	0f b6 0e             	movzbl (%esi),%ecx
8010440e:	38 c8                	cmp    %cl,%al
80104410:	74 16                	je     80104428 <memcmp+0x38>
80104412:	eb 24                	jmp    80104438 <memcmp+0x48>
80104414:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104418:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
8010441d:	83 c2 01             	add    $0x1,%edx
80104420:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104424:	38 c8                	cmp    %cl,%al
80104426:	75 10                	jne    80104438 <memcmp+0x48>
{
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104428:	39 fa                	cmp    %edi,%edx
8010442a:	75 ec                	jne    80104418 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
8010442c:	5b                   	pop    %ebx
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
8010442d:	31 c0                	xor    %eax,%eax
}
8010442f:	5e                   	pop    %esi
80104430:	5f                   	pop    %edi
80104431:	5d                   	pop    %ebp
80104432:	c3                   	ret    
80104433:	90                   	nop
80104434:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104438:	5b                   	pop    %ebx

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
80104439:	29 c8                	sub    %ecx,%eax
    s1++, s2++;
  }

  return 0;
}
8010443b:	5e                   	pop    %esi
8010443c:	5f                   	pop    %edi
8010443d:	5d                   	pop    %ebp
8010443e:	c3                   	ret    
8010443f:	90                   	nop

80104440 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104440:	55                   	push   %ebp
80104441:	89 e5                	mov    %esp,%ebp
80104443:	57                   	push   %edi
80104444:	8b 45 08             	mov    0x8(%ebp),%eax
80104447:	56                   	push   %esi
80104448:	8b 75 0c             	mov    0xc(%ebp),%esi
8010444b:	53                   	push   %ebx
8010444c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010444f:	39 c6                	cmp    %eax,%esi
80104451:	73 35                	jae    80104488 <memmove+0x48>
80104453:	8d 0c 1e             	lea    (%esi,%ebx,1),%ecx
80104456:	39 c8                	cmp    %ecx,%eax
80104458:	73 2e                	jae    80104488 <memmove+0x48>
    s += n;
    d += n;
    while(n-- > 0)
8010445a:	85 db                	test   %ebx,%ebx

  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
8010445c:	8d 3c 18             	lea    (%eax,%ebx,1),%edi
    while(n-- > 0)
8010445f:	8d 53 ff             	lea    -0x1(%ebx),%edx
80104462:	74 1b                	je     8010447f <memmove+0x3f>
80104464:	f7 db                	neg    %ebx
80104466:	8d 34 19             	lea    (%ecx,%ebx,1),%esi
80104469:	01 fb                	add    %edi,%ebx
8010446b:	90                   	nop
8010446c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *--d = *--s;
80104470:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104474:	88 0c 13             	mov    %cl,(%ebx,%edx,1)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
80104477:	83 ea 01             	sub    $0x1,%edx
8010447a:	83 fa ff             	cmp    $0xffffffff,%edx
8010447d:	75 f1                	jne    80104470 <memmove+0x30>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010447f:	5b                   	pop    %ebx
80104480:	5e                   	pop    %esi
80104481:	5f                   	pop    %edi
80104482:	5d                   	pop    %ebp
80104483:	c3                   	ret    
80104484:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80104488:	31 d2                	xor    %edx,%edx
8010448a:	85 db                	test   %ebx,%ebx
8010448c:	74 f1                	je     8010447f <memmove+0x3f>
8010448e:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80104490:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104494:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104497:	83 c2 01             	add    $0x1,%edx
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
8010449a:	39 da                	cmp    %ebx,%edx
8010449c:	75 f2                	jne    80104490 <memmove+0x50>
      *d++ = *s++;

  return dst;
}
8010449e:	5b                   	pop    %ebx
8010449f:	5e                   	pop    %esi
801044a0:	5f                   	pop    %edi
801044a1:	5d                   	pop    %ebp
801044a2:	c3                   	ret    
801044a3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801044a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801044b0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
801044b0:	55                   	push   %ebp
801044b1:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
801044b3:	5d                   	pop    %ebp

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
801044b4:	e9 87 ff ff ff       	jmp    80104440 <memmove>
801044b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801044c0 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
801044c0:	55                   	push   %ebp
801044c1:	89 e5                	mov    %esp,%ebp
801044c3:	56                   	push   %esi
801044c4:	8b 75 10             	mov    0x10(%ebp),%esi
801044c7:	53                   	push   %ebx
801044c8:	8b 4d 08             	mov    0x8(%ebp),%ecx
801044cb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while(n > 0 && *p && *p == *q)
801044ce:	85 f6                	test   %esi,%esi
801044d0:	74 30                	je     80104502 <strncmp+0x42>
801044d2:	0f b6 01             	movzbl (%ecx),%eax
801044d5:	84 c0                	test   %al,%al
801044d7:	74 2f                	je     80104508 <strncmp+0x48>
801044d9:	0f b6 13             	movzbl (%ebx),%edx
801044dc:	38 d0                	cmp    %dl,%al
801044de:	75 46                	jne    80104526 <strncmp+0x66>
801044e0:	8d 51 01             	lea    0x1(%ecx),%edx
801044e3:	01 ce                	add    %ecx,%esi
801044e5:	eb 14                	jmp    801044fb <strncmp+0x3b>
801044e7:	90                   	nop
801044e8:	0f b6 02             	movzbl (%edx),%eax
801044eb:	84 c0                	test   %al,%al
801044ed:	74 31                	je     80104520 <strncmp+0x60>
801044ef:	0f b6 19             	movzbl (%ecx),%ebx
801044f2:	83 c2 01             	add    $0x1,%edx
801044f5:	38 d8                	cmp    %bl,%al
801044f7:	75 17                	jne    80104510 <strncmp+0x50>
    n--, p++, q++;
801044f9:	89 cb                	mov    %ecx,%ebx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
801044fb:	39 f2                	cmp    %esi,%edx
    n--, p++, q++;
801044fd:	8d 4b 01             	lea    0x1(%ebx),%ecx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80104500:	75 e6                	jne    801044e8 <strncmp+0x28>
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80104502:	5b                   	pop    %ebx
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
80104503:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}
80104505:	5e                   	pop    %esi
80104506:	5d                   	pop    %ebp
80104507:	c3                   	ret    
80104508:	0f b6 1b             	movzbl (%ebx),%ebx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
8010450b:	31 c0                	xor    %eax,%eax
8010450d:	8d 76 00             	lea    0x0(%esi),%esi
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104510:	0f b6 d3             	movzbl %bl,%edx
80104513:	29 d0                	sub    %edx,%eax
}
80104515:	5b                   	pop    %ebx
80104516:	5e                   	pop    %esi
80104517:	5d                   	pop    %ebp
80104518:	c3                   	ret    
80104519:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104520:	0f b6 5b 01          	movzbl 0x1(%ebx),%ebx
80104524:	eb ea                	jmp    80104510 <strncmp+0x50>
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80104526:	89 d3                	mov    %edx,%ebx
80104528:	eb e6                	jmp    80104510 <strncmp+0x50>
8010452a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104530 <strncpy>:
  return (uchar)*p - (uchar)*q;
}

char*
strncpy(char *s, const char *t, int n)
{
80104530:	55                   	push   %ebp
80104531:	89 e5                	mov    %esp,%ebp
80104533:	8b 45 08             	mov    0x8(%ebp),%eax
80104536:	56                   	push   %esi
80104537:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010453a:	53                   	push   %ebx
8010453b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010453e:	89 c2                	mov    %eax,%edx
80104540:	eb 19                	jmp    8010455b <strncpy+0x2b>
80104542:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104548:	83 c3 01             	add    $0x1,%ebx
8010454b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
8010454f:	83 c2 01             	add    $0x1,%edx
80104552:	84 c9                	test   %cl,%cl
80104554:	88 4a ff             	mov    %cl,-0x1(%edx)
80104557:	74 09                	je     80104562 <strncpy+0x32>
80104559:	89 f1                	mov    %esi,%ecx
8010455b:	85 c9                	test   %ecx,%ecx
8010455d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104560:	7f e6                	jg     80104548 <strncpy+0x18>
    ;
  while(n-- > 0)
80104562:	31 c9                	xor    %ecx,%ecx
80104564:	85 f6                	test   %esi,%esi
80104566:	7e 0f                	jle    80104577 <strncpy+0x47>
    *s++ = 0;
80104568:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
8010456c:	89 f3                	mov    %esi,%ebx
8010456e:	83 c1 01             	add    $0x1,%ecx
80104571:	29 cb                	sub    %ecx,%ebx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
80104573:	85 db                	test   %ebx,%ebx
80104575:	7f f1                	jg     80104568 <strncpy+0x38>
    *s++ = 0;
  return os;
}
80104577:	5b                   	pop    %ebx
80104578:	5e                   	pop    %esi
80104579:	5d                   	pop    %ebp
8010457a:	c3                   	ret    
8010457b:	90                   	nop
8010457c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104580 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104580:	55                   	push   %ebp
80104581:	89 e5                	mov    %esp,%ebp
80104583:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104586:	56                   	push   %esi
80104587:	8b 45 08             	mov    0x8(%ebp),%eax
8010458a:	53                   	push   %ebx
8010458b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
8010458e:	85 c9                	test   %ecx,%ecx
80104590:	7e 26                	jle    801045b8 <safestrcpy+0x38>
80104592:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104596:	89 c1                	mov    %eax,%ecx
80104598:	eb 17                	jmp    801045b1 <safestrcpy+0x31>
8010459a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
801045a0:	83 c2 01             	add    $0x1,%edx
801045a3:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
801045a7:	83 c1 01             	add    $0x1,%ecx
801045aa:	84 db                	test   %bl,%bl
801045ac:	88 59 ff             	mov    %bl,-0x1(%ecx)
801045af:	74 04                	je     801045b5 <safestrcpy+0x35>
801045b1:	39 f2                	cmp    %esi,%edx
801045b3:	75 eb                	jne    801045a0 <safestrcpy+0x20>
    ;
  *s = 0;
801045b5:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
801045b8:	5b                   	pop    %ebx
801045b9:	5e                   	pop    %esi
801045ba:	5d                   	pop    %ebp
801045bb:	c3                   	ret    
801045bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801045c0 <strlen>:

int
strlen(const char *s)
{
801045c0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
801045c1:	31 c0                	xor    %eax,%eax
  return os;
}

int
strlen(const char *s)
{
801045c3:	89 e5                	mov    %esp,%ebp
801045c5:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
801045c8:	80 3a 00             	cmpb   $0x0,(%edx)
801045cb:	74 0c                	je     801045d9 <strlen+0x19>
801045cd:	8d 76 00             	lea    0x0(%esi),%esi
801045d0:	83 c0 01             	add    $0x1,%eax
801045d3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
801045d7:	75 f7                	jne    801045d0 <strlen+0x10>
    ;
  return n;
}
801045d9:	5d                   	pop    %ebp
801045da:	c3                   	ret    

801045db <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
801045db:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801045df:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
801045e3:	55                   	push   %ebp
  pushl %ebx
801045e4:	53                   	push   %ebx
  pushl %esi
801045e5:	56                   	push   %esi
  pushl %edi
801045e6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801045e7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801045e9:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
801045eb:	5f                   	pop    %edi
  popl %esi
801045ec:	5e                   	pop    %esi
  popl %ebx
801045ed:	5b                   	pop    %ebx
  popl %ebp
801045ee:	5d                   	pop    %ebp
  ret
801045ef:	c3                   	ret    

801045f0 <fetchint>:

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
801045f0:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801045f7:	55                   	push   %ebp
801045f8:	89 e5                	mov    %esp,%ebp
801045fa:	8b 45 08             	mov    0x8(%ebp),%eax
  if(addr >= proc->sz || addr+4 > proc->sz)
801045fd:	8b 12                	mov    (%edx),%edx
801045ff:	39 c2                	cmp    %eax,%edx
80104601:	76 15                	jbe    80104618 <fetchint+0x28>
80104603:	8d 48 04             	lea    0x4(%eax),%ecx
80104606:	39 ca                	cmp    %ecx,%edx
80104608:	72 0e                	jb     80104618 <fetchint+0x28>
    return -1;
  *ip = *(int*)(addr);
8010460a:	8b 10                	mov    (%eax),%edx
8010460c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010460f:	89 10                	mov    %edx,(%eax)
  return 0;
80104611:	31 c0                	xor    %eax,%eax
}
80104613:	5d                   	pop    %ebp
80104614:	c3                   	ret    
80104615:	8d 76 00             	lea    0x0(%esi),%esi
// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
    return -1;
80104618:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  *ip = *(int*)(addr);
  return 0;
}
8010461d:	5d                   	pop    %ebp
8010461e:	c3                   	ret    
8010461f:	90                   	nop

80104620 <fetchstr>:
int
fetchstr(uint addr, char **pp)
{
  char *s, *ep;

  if(addr >= proc->sz)
80104620:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104626:	55                   	push   %ebp
80104627:	89 e5                	mov    %esp,%ebp
80104629:	8b 4d 08             	mov    0x8(%ebp),%ecx
  char *s, *ep;

  if(addr >= proc->sz)
8010462c:	39 08                	cmp    %ecx,(%eax)
8010462e:	76 2c                	jbe    8010465c <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80104630:	8b 55 0c             	mov    0xc(%ebp),%edx
80104633:	89 c8                	mov    %ecx,%eax
80104635:	89 0a                	mov    %ecx,(%edx)
  ep = (char*)proc->sz;
80104637:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
8010463e:	8b 12                	mov    (%edx),%edx
  for(s = *pp; s < ep; s++)
80104640:	39 d1                	cmp    %edx,%ecx
80104642:	73 18                	jae    8010465c <fetchstr+0x3c>
    if(*s == 0)
80104644:	80 39 00             	cmpb   $0x0,(%ecx)
80104647:	75 0c                	jne    80104655 <fetchstr+0x35>
80104649:	eb 1d                	jmp    80104668 <fetchstr+0x48>
8010464b:	90                   	nop
8010464c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104650:	80 38 00             	cmpb   $0x0,(%eax)
80104653:	74 13                	je     80104668 <fetchstr+0x48>

  if(addr >= proc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
80104655:	83 c0 01             	add    $0x1,%eax
80104658:	39 c2                	cmp    %eax,%edx
8010465a:	77 f4                	ja     80104650 <fetchstr+0x30>
fetchstr(uint addr, char **pp)
{
  char *s, *ep;

  if(addr >= proc->sz)
    return -1;
8010465c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
    if(*s == 0)
      return s - *pp;
  return -1;
}
80104661:	5d                   	pop    %ebp
80104662:	c3                   	ret    
80104663:	90                   	nop
80104664:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
    if(*s == 0)
      return s - *pp;
80104668:	29 c8                	sub    %ecx,%eax
  return -1;
}
8010466a:	5d                   	pop    %ebp
8010466b:	c3                   	ret    
8010466c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104670 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80104670:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
}

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104677:	55                   	push   %ebp
80104678:	89 e5                	mov    %esp,%ebp
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
8010467a:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010467d:	8b 42 18             	mov    0x18(%edx),%eax

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
80104680:	8b 12                	mov    (%edx),%edx

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80104682:	8b 40 44             	mov    0x44(%eax),%eax
80104685:	8d 04 88             	lea    (%eax,%ecx,4),%eax
80104688:	8d 48 04             	lea    0x4(%eax),%ecx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
8010468b:	39 d1                	cmp    %edx,%ecx
8010468d:	73 19                	jae    801046a8 <argint+0x38>
8010468f:	8d 48 08             	lea    0x8(%eax),%ecx
80104692:	39 ca                	cmp    %ecx,%edx
80104694:	72 12                	jb     801046a8 <argint+0x38>
    return -1;
  *ip = *(int*)(addr);
80104696:	8b 50 04             	mov    0x4(%eax),%edx
80104699:	8b 45 0c             	mov    0xc(%ebp),%eax
8010469c:	89 10                	mov    %edx,(%eax)
  return 0;
8010469e:	31 c0                	xor    %eax,%eax
// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
}
801046a0:	5d                   	pop    %ebp
801046a1:	c3                   	ret    
801046a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
    return -1;
801046a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
}
801046ad:	5d                   	pop    %ebp
801046ae:	c3                   	ret    
801046af:	90                   	nop

801046b0 <argptr>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
801046b0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801046b6:	55                   	push   %ebp
801046b7:	89 e5                	mov    %esp,%ebp
801046b9:	53                   	push   %ebx

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
801046ba:	8b 4d 08             	mov    0x8(%ebp),%ecx
801046bd:	8b 50 18             	mov    0x18(%eax),%edx
801046c0:	8b 52 44             	mov    0x44(%edx),%edx
801046c3:	8d 0c 8a             	lea    (%edx,%ecx,4),%ecx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
801046c6:	8b 10                	mov    (%eax),%edx
argptr(int n, char **pp, int size)
{
  int i;

  if(argint(n, &i) < 0)
    return -1;
801046c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
801046cd:	8d 59 04             	lea    0x4(%ecx),%ebx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
801046d0:	39 d3                	cmp    %edx,%ebx
801046d2:	73 25                	jae    801046f9 <argptr+0x49>
801046d4:	8d 59 08             	lea    0x8(%ecx),%ebx
801046d7:	39 da                	cmp    %ebx,%edx
801046d9:	72 1e                	jb     801046f9 <argptr+0x49>
{
  int i;

  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= proc->sz || (uint)i+size > proc->sz)
801046db:	8b 5d 10             	mov    0x10(%ebp),%ebx
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
    return -1;
  *ip = *(int*)(addr);
801046de:	8b 49 04             	mov    0x4(%ecx),%ecx
{
  int i;

  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= proc->sz || (uint)i+size > proc->sz)
801046e1:	85 db                	test   %ebx,%ebx
801046e3:	78 14                	js     801046f9 <argptr+0x49>
801046e5:	39 d1                	cmp    %edx,%ecx
801046e7:	73 10                	jae    801046f9 <argptr+0x49>
801046e9:	8b 5d 10             	mov    0x10(%ebp),%ebx
801046ec:	01 cb                	add    %ecx,%ebx
801046ee:	39 d3                	cmp    %edx,%ebx
801046f0:	77 07                	ja     801046f9 <argptr+0x49>
    return -1;
  *pp = (char*)i;
801046f2:	8b 45 0c             	mov    0xc(%ebp),%eax
801046f5:	89 08                	mov    %ecx,(%eax)
  return 0;
801046f7:	31 c0                	xor    %eax,%eax
}
801046f9:	5b                   	pop    %ebx
801046fa:	5d                   	pop    %ebp
801046fb:	c3                   	ret    
801046fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104700 <argstr>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80104700:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104706:	55                   	push   %ebp
80104707:	89 e5                	mov    %esp,%ebp

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80104709:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010470c:	8b 50 18             	mov    0x18(%eax),%edx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
8010470f:	8b 00                	mov    (%eax),%eax

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80104711:	8b 52 44             	mov    0x44(%edx),%edx
80104714:	8d 14 8a             	lea    (%edx,%ecx,4),%edx
80104717:	8d 4a 04             	lea    0x4(%edx),%ecx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
8010471a:	39 c1                	cmp    %eax,%ecx
8010471c:	73 07                	jae    80104725 <argstr+0x25>
8010471e:	8d 4a 08             	lea    0x8(%edx),%ecx
80104721:	39 c8                	cmp    %ecx,%eax
80104723:	73 0b                	jae    80104730 <argstr+0x30>
int
argstr(int n, char **pp)
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
80104725:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchstr(addr, pp);
}
8010472a:	5d                   	pop    %ebp
8010472b:	c3                   	ret    
8010472c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
    return -1;
  *ip = *(int*)(addr);
80104730:	8b 4a 04             	mov    0x4(%edx),%ecx
int
fetchstr(uint addr, char **pp)
{
  char *s, *ep;

  if(addr >= proc->sz)
80104733:	39 c1                	cmp    %eax,%ecx
80104735:	73 ee                	jae    80104725 <argstr+0x25>
    return -1;
  *pp = (char*)addr;
80104737:	8b 55 0c             	mov    0xc(%ebp),%edx
8010473a:	89 c8                	mov    %ecx,%eax
8010473c:	89 0a                	mov    %ecx,(%edx)
  ep = (char*)proc->sz;
8010473e:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104745:	8b 12                	mov    (%edx),%edx
  for(s = *pp; s < ep; s++)
80104747:	39 d1                	cmp    %edx,%ecx
80104749:	73 da                	jae    80104725 <argstr+0x25>
    if(*s == 0)
8010474b:	80 39 00             	cmpb   $0x0,(%ecx)
8010474e:	75 12                	jne    80104762 <argstr+0x62>
80104750:	eb 1e                	jmp    80104770 <argstr+0x70>
80104752:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104758:	80 38 00             	cmpb   $0x0,(%eax)
8010475b:	90                   	nop
8010475c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104760:	74 0e                	je     80104770 <argstr+0x70>

  if(addr >= proc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
80104762:	83 c0 01             	add    $0x1,%eax
80104765:	39 c2                	cmp    %eax,%edx
80104767:	77 ef                	ja     80104758 <argstr+0x58>
80104769:	eb ba                	jmp    80104725 <argstr+0x25>
8010476b:	90                   	nop
8010476c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(*s == 0)
      return s - *pp;
80104770:	29 c8                	sub    %ecx,%eax
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
80104772:	5d                   	pop    %ebp
80104773:	c3                   	ret    
80104774:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010477a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104780 <syscall>:
  return (num > 0 && num < NELEM(syscalls) && syscalls[num]);
}

void
syscall(void)
{
80104780:	55                   	push   %ebp
80104781:	89 e5                	mov    %esp,%ebp
80104783:	53                   	push   %ebx
80104784:	83 ec 14             	sub    $0x14,%esp
  int num;
  num = proc->tf->eax;
80104787:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010478d:	8b 58 18             	mov    0x18(%eax),%ebx
80104790:	8b 53 1c             	mov    0x1c(%ebx),%edx
[SYS_close]   sys_close,
[SYS_callcount] sys_callcount,
};

static int valid_syscall(int num) {
  return (num > 0 && num < NELEM(syscalls) && syscalls[num]);
80104793:	8d 4a ff             	lea    -0x1(%edx),%ecx
80104796:	83 f9 15             	cmp    $0x15,%ecx
80104799:	77 25                	ja     801047c0 <syscall+0x40>
8010479b:	8b 0c 95 60 74 10 80 	mov    -0x7fef8ba0(,%edx,4),%ecx
801047a2:	85 c9                	test   %ecx,%ecx
801047a4:	74 1a                	je     801047c0 <syscall+0x40>
syscall(void)
{
  int num;
  num = proc->tf->eax;
  if (valid_syscall(num)) {
    proc->callcount[num] += 1;
801047a6:	83 44 90 7c 01       	addl   $0x1,0x7c(%eax,%edx,4)
    proc->callcount[0] += 1;
801047ab:	83 40 7c 01          	addl   $0x1,0x7c(%eax)
    proc->tf->eax = syscalls[num]();
801047af:	ff d1                	call   *%ecx
801047b1:	89 43 1c             	mov    %eax,0x1c(%ebx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
  }
}
801047b4:	83 c4 14             	add    $0x14,%esp
801047b7:	5b                   	pop    %ebx
801047b8:	5d                   	pop    %ebp
801047b9:	c3                   	ret    
801047ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if (valid_syscall(num)) {
    proc->callcount[num] += 1;
    proc->callcount[0] += 1;
    proc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
801047c0:	89 54 24 0c          	mov    %edx,0xc(%esp)
            proc->pid, proc->name, num);
801047c4:	8d 50 6c             	lea    0x6c(%eax),%edx
801047c7:	89 54 24 08          	mov    %edx,0x8(%esp)
  if (valid_syscall(num)) {
    proc->callcount[num] += 1;
    proc->callcount[0] += 1;
    proc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
801047cb:	8b 40 10             	mov    0x10(%eax),%eax
801047ce:	c7 04 24 31 74 10 80 	movl   $0x80107431,(%esp)
801047d5:	89 44 24 04          	mov    %eax,0x4(%esp)
801047d9:	e8 72 be ff ff       	call   80100650 <cprintf>
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
801047de:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047e4:	8b 40 18             	mov    0x18(%eax),%eax
801047e7:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
801047ee:	83 c4 14             	add    $0x14,%esp
801047f1:	5b                   	pop    %ebx
801047f2:	5d                   	pop    %ebp
801047f3:	c3                   	ret    
801047f4:	66 90                	xchg   %ax,%ax
801047f6:	66 90                	xchg   %ax,%ax
801047f8:	66 90                	xchg   %ax,%ax
801047fa:	66 90                	xchg   %ax,%ax
801047fc:	66 90                	xchg   %ax,%ax
801047fe:	66 90                	xchg   %ax,%ax

80104800 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104800:	55                   	push   %ebp
80104801:	89 e5                	mov    %esp,%ebp
80104803:	57                   	push   %edi
80104804:	56                   	push   %esi
80104805:	53                   	push   %ebx
80104806:	83 ec 4c             	sub    $0x4c,%esp
80104809:	89 4d c0             	mov    %ecx,-0x40(%ebp)
8010480c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
8010480f:	8d 5d da             	lea    -0x26(%ebp),%ebx
80104812:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104816:	89 04 24             	mov    %eax,(%esp)
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104819:	89 55 c4             	mov    %edx,-0x3c(%ebp)
8010481c:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
8010481f:	e8 dc d6 ff ff       	call   80101f00 <nameiparent>
80104824:	85 c0                	test   %eax,%eax
80104826:	89 c7                	mov    %eax,%edi
80104828:	0f 84 da 00 00 00    	je     80104908 <create+0x108>
    return 0;
  ilock(dp);
8010482e:	89 04 24             	mov    %eax,(%esp)
80104831:	e8 7a ce ff ff       	call   801016b0 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80104836:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104839:	89 44 24 08          	mov    %eax,0x8(%esp)
8010483d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104841:	89 3c 24             	mov    %edi,(%esp)
80104844:	e8 57 d3 ff ff       	call   80101ba0 <dirlookup>
80104849:	85 c0                	test   %eax,%eax
8010484b:	89 c6                	mov    %eax,%esi
8010484d:	74 41                	je     80104890 <create+0x90>
    iunlockput(dp);
8010484f:	89 3c 24             	mov    %edi,(%esp)
80104852:	e8 99 d0 ff ff       	call   801018f0 <iunlockput>
    ilock(ip);
80104857:	89 34 24             	mov    %esi,(%esp)
8010485a:	e8 51 ce ff ff       	call   801016b0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
8010485f:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
80104864:	75 12                	jne    80104878 <create+0x78>
80104866:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
8010486b:	89 f0                	mov    %esi,%eax
8010486d:	75 09                	jne    80104878 <create+0x78>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
8010486f:	83 c4 4c             	add    $0x4c,%esp
80104872:	5b                   	pop    %ebx
80104873:	5e                   	pop    %esi
80104874:	5f                   	pop    %edi
80104875:	5d                   	pop    %ebp
80104876:	c3                   	ret    
80104877:	90                   	nop
  if((ip = dirlookup(dp, name, &off)) != 0){
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
80104878:	89 34 24             	mov    %esi,(%esp)
8010487b:	e8 70 d0 ff ff       	call   801018f0 <iunlockput>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104880:	83 c4 4c             	add    $0x4c,%esp
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
    return 0;
80104883:	31 c0                	xor    %eax,%eax
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104885:	5b                   	pop    %ebx
80104886:	5e                   	pop    %esi
80104887:	5f                   	pop    %edi
80104888:	5d                   	pop    %ebp
80104889:	c3                   	ret    
8010488a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      return ip;
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80104890:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
80104894:	89 44 24 04          	mov    %eax,0x4(%esp)
80104898:	8b 07                	mov    (%edi),%eax
8010489a:	89 04 24             	mov    %eax,(%esp)
8010489d:	e8 7e cc ff ff       	call   80101520 <ialloc>
801048a2:	85 c0                	test   %eax,%eax
801048a4:	89 c6                	mov    %eax,%esi
801048a6:	0f 84 bf 00 00 00    	je     8010496b <create+0x16b>
    panic("create: ialloc");

  ilock(ip);
801048ac:	89 04 24             	mov    %eax,(%esp)
801048af:	e8 fc cd ff ff       	call   801016b0 <ilock>
  ip->major = major;
801048b4:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
801048b8:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
801048bc:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
801048c0:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
801048c4:	b8 01 00 00 00       	mov    $0x1,%eax
801048c9:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
801048cd:	89 34 24             	mov    %esi,(%esp)
801048d0:	e8 1b cd ff ff       	call   801015f0 <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
801048d5:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
801048da:	74 34                	je     80104910 <create+0x110>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }

  if(dirlink(dp, name, ip->inum) < 0)
801048dc:	8b 46 04             	mov    0x4(%esi),%eax
801048df:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801048e3:	89 3c 24             	mov    %edi,(%esp)
801048e6:	89 44 24 08          	mov    %eax,0x8(%esp)
801048ea:	e8 11 d5 ff ff       	call   80101e00 <dirlink>
801048ef:	85 c0                	test   %eax,%eax
801048f1:	78 6c                	js     8010495f <create+0x15f>
    panic("create: dirlink");

  iunlockput(dp);
801048f3:	89 3c 24             	mov    %edi,(%esp)
801048f6:	e8 f5 cf ff ff       	call   801018f0 <iunlockput>

  return ip;
}
801048fb:	83 c4 4c             	add    $0x4c,%esp
  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
801048fe:	89 f0                	mov    %esi,%eax
}
80104900:	5b                   	pop    %ebx
80104901:	5e                   	pop    %esi
80104902:	5f                   	pop    %edi
80104903:	5d                   	pop    %ebp
80104904:	c3                   	ret    
80104905:	8d 76 00             	lea    0x0(%esi),%esi
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    return 0;
80104908:	31 c0                	xor    %eax,%eax
8010490a:	e9 60 ff ff ff       	jmp    8010486f <create+0x6f>
8010490f:	90                   	nop
  ip->minor = minor;
  ip->nlink = 1;
  iupdate(ip);

  if(type == T_DIR){  // Create . and .. entries.
    dp->nlink++;  // for ".."
80104910:	66 83 47 56 01       	addw   $0x1,0x56(%edi)
    iupdate(dp);
80104915:	89 3c 24             	mov    %edi,(%esp)
80104918:	e8 d3 cc ff ff       	call   801015f0 <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010491d:	8b 46 04             	mov    0x4(%esi),%eax
80104920:	c7 44 24 04 d8 74 10 	movl   $0x801074d8,0x4(%esp)
80104927:	80 
80104928:	89 34 24             	mov    %esi,(%esp)
8010492b:	89 44 24 08          	mov    %eax,0x8(%esp)
8010492f:	e8 cc d4 ff ff       	call   80101e00 <dirlink>
80104934:	85 c0                	test   %eax,%eax
80104936:	78 1b                	js     80104953 <create+0x153>
80104938:	8b 47 04             	mov    0x4(%edi),%eax
8010493b:	c7 44 24 04 d7 74 10 	movl   $0x801074d7,0x4(%esp)
80104942:	80 
80104943:	89 34 24             	mov    %esi,(%esp)
80104946:	89 44 24 08          	mov    %eax,0x8(%esp)
8010494a:	e8 b1 d4 ff ff       	call   80101e00 <dirlink>
8010494f:	85 c0                	test   %eax,%eax
80104951:	79 89                	jns    801048dc <create+0xdc>
      panic("create dots");
80104953:	c7 04 24 cb 74 10 80 	movl   $0x801074cb,(%esp)
8010495a:	e8 01 ba ff ff       	call   80100360 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");
8010495f:	c7 04 24 da 74 10 80 	movl   $0x801074da,(%esp)
80104966:	e8 f5 b9 ff ff       	call   80100360 <panic>
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
    panic("create: ialloc");
8010496b:	c7 04 24 bc 74 10 80 	movl   $0x801074bc,(%esp)
80104972:	e8 e9 b9 ff ff       	call   80100360 <panic>
80104977:	89 f6                	mov    %esi,%esi
80104979:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104980 <argfd.constprop.0>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
80104980:	55                   	push   %ebp
80104981:	89 e5                	mov    %esp,%ebp
80104983:	56                   	push   %esi
80104984:	89 c6                	mov    %eax,%esi
80104986:	53                   	push   %ebx
80104987:	89 d3                	mov    %edx,%ebx
80104989:	83 ec 20             	sub    $0x20,%esp
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
8010498c:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010498f:	89 44 24 04          	mov    %eax,0x4(%esp)
80104993:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010499a:	e8 d1 fc ff ff       	call   80104670 <argint>
8010499f:	85 c0                	test   %eax,%eax
801049a1:	78 35                	js     801049d8 <argfd.constprop.0+0x58>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
801049a3:	8b 4d f4             	mov    -0xc(%ebp),%ecx
801049a6:	83 f9 0f             	cmp    $0xf,%ecx
801049a9:	77 2d                	ja     801049d8 <argfd.constprop.0+0x58>
801049ab:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049b1:	8b 44 88 28          	mov    0x28(%eax,%ecx,4),%eax
801049b5:	85 c0                	test   %eax,%eax
801049b7:	74 1f                	je     801049d8 <argfd.constprop.0+0x58>
    return -1;
  if(pfd)
801049b9:	85 f6                	test   %esi,%esi
801049bb:	74 02                	je     801049bf <argfd.constprop.0+0x3f>
    *pfd = fd;
801049bd:	89 0e                	mov    %ecx,(%esi)
  if(pf)
801049bf:	85 db                	test   %ebx,%ebx
801049c1:	74 0d                	je     801049d0 <argfd.constprop.0+0x50>
    *pf = f;
801049c3:	89 03                	mov    %eax,(%ebx)
  return 0;
801049c5:	31 c0                	xor    %eax,%eax
}
801049c7:	83 c4 20             	add    $0x20,%esp
801049ca:	5b                   	pop    %ebx
801049cb:	5e                   	pop    %esi
801049cc:	5d                   	pop    %ebp
801049cd:	c3                   	ret    
801049ce:	66 90                	xchg   %ax,%ax
    return -1;
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  return 0;
801049d0:	31 c0                	xor    %eax,%eax
801049d2:	eb f3                	jmp    801049c7 <argfd.constprop.0+0x47>
801049d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    return -1;
801049d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801049dd:	eb e8                	jmp    801049c7 <argfd.constprop.0+0x47>
801049df:	90                   	nop

801049e0 <sys_dup>:
  return -1;
}

int
sys_dup(void)
{
801049e0:	55                   	push   %ebp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
801049e1:	31 c0                	xor    %eax,%eax
  return -1;
}

int
sys_dup(void)
{
801049e3:	89 e5                	mov    %esp,%ebp
801049e5:	53                   	push   %ebx
801049e6:	83 ec 24             	sub    $0x24,%esp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
801049e9:	8d 55 f4             	lea    -0xc(%ebp),%edx
801049ec:	e8 8f ff ff ff       	call   80104980 <argfd.constprop.0>
801049f1:	85 c0                	test   %eax,%eax
801049f3:	78 1b                	js     80104a10 <sys_dup+0x30>
    return -1;
  if((fd=fdalloc(f)) < 0)
801049f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
801049f8:	31 db                	xor    %ebx,%ebx
801049fa:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
    if(proc->ofile[fd] == 0){
80104a00:	8b 4c 98 28          	mov    0x28(%eax,%ebx,4),%ecx
80104a04:	85 c9                	test   %ecx,%ecx
80104a06:	74 18                	je     80104a20 <sys_dup+0x40>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80104a08:	83 c3 01             	add    $0x1,%ebx
80104a0b:	83 fb 10             	cmp    $0x10,%ebx
80104a0e:	75 f0                	jne    80104a00 <sys_dup+0x20>
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
}
80104a10:	83 c4 24             	add    $0x24,%esp
{
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
    return -1;
80104a13:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
}
80104a18:	5b                   	pop    %ebx
80104a19:	5d                   	pop    %ebp
80104a1a:	c3                   	ret    
80104a1b:	90                   	nop
80104a1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
80104a20:	89 54 98 28          	mov    %edx,0x28(%eax,%ebx,4)

  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
80104a24:	89 14 24             	mov    %edx,(%esp)
80104a27:	e8 a4 c3 ff ff       	call   80100dd0 <filedup>
  return fd;
}
80104a2c:	83 c4 24             	add    $0x24,%esp
  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
80104a2f:	89 d8                	mov    %ebx,%eax
}
80104a31:	5b                   	pop    %ebx
80104a32:	5d                   	pop    %ebp
80104a33:	c3                   	ret    
80104a34:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104a3a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104a40 <sys_read>:

int
sys_read(void)
{
80104a40:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104a41:	31 c0                	xor    %eax,%eax
  return fd;
}

int
sys_read(void)
{
80104a43:	89 e5                	mov    %esp,%ebp
80104a45:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104a48:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104a4b:	e8 30 ff ff ff       	call   80104980 <argfd.constprop.0>
80104a50:	85 c0                	test   %eax,%eax
80104a52:	78 54                	js     80104aa8 <sys_read+0x68>
80104a54:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104a57:	89 44 24 04          	mov    %eax,0x4(%esp)
80104a5b:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80104a62:	e8 09 fc ff ff       	call   80104670 <argint>
80104a67:	85 c0                	test   %eax,%eax
80104a69:	78 3d                	js     80104aa8 <sys_read+0x68>
80104a6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104a6e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104a75:	89 44 24 08          	mov    %eax,0x8(%esp)
80104a79:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104a7c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104a80:	e8 2b fc ff ff       	call   801046b0 <argptr>
80104a85:	85 c0                	test   %eax,%eax
80104a87:	78 1f                	js     80104aa8 <sys_read+0x68>
    return -1;
  return fileread(f, p, n);
80104a89:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104a8c:	89 44 24 08          	mov    %eax,0x8(%esp)
80104a90:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a93:	89 44 24 04          	mov    %eax,0x4(%esp)
80104a97:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104a9a:	89 04 24             	mov    %eax,(%esp)
80104a9d:	e8 8e c4 ff ff       	call   80100f30 <fileread>
}
80104aa2:	c9                   	leave  
80104aa3:	c3                   	ret    
80104aa4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
80104aa8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fileread(f, p, n);
}
80104aad:	c9                   	leave  
80104aae:	c3                   	ret    
80104aaf:	90                   	nop

80104ab0 <sys_write>:

int
sys_write(void)
{
80104ab0:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104ab1:	31 c0                	xor    %eax,%eax
  return fileread(f, p, n);
}

int
sys_write(void)
{
80104ab3:	89 e5                	mov    %esp,%ebp
80104ab5:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104ab8:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104abb:	e8 c0 fe ff ff       	call   80104980 <argfd.constprop.0>
80104ac0:	85 c0                	test   %eax,%eax
80104ac2:	78 54                	js     80104b18 <sys_write+0x68>
80104ac4:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104ac7:	89 44 24 04          	mov    %eax,0x4(%esp)
80104acb:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80104ad2:	e8 99 fb ff ff       	call   80104670 <argint>
80104ad7:	85 c0                	test   %eax,%eax
80104ad9:	78 3d                	js     80104b18 <sys_write+0x68>
80104adb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104ade:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104ae5:	89 44 24 08          	mov    %eax,0x8(%esp)
80104ae9:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104aec:	89 44 24 04          	mov    %eax,0x4(%esp)
80104af0:	e8 bb fb ff ff       	call   801046b0 <argptr>
80104af5:	85 c0                	test   %eax,%eax
80104af7:	78 1f                	js     80104b18 <sys_write+0x68>
    return -1;
  return filewrite(f, p, n);
80104af9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104afc:	89 44 24 08          	mov    %eax,0x8(%esp)
80104b00:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b03:	89 44 24 04          	mov    %eax,0x4(%esp)
80104b07:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104b0a:	89 04 24             	mov    %eax,(%esp)
80104b0d:	e8 be c4 ff ff       	call   80100fd0 <filewrite>
}
80104b12:	c9                   	leave  
80104b13:	c3                   	ret    
80104b14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
80104b18:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filewrite(f, p, n);
}
80104b1d:	c9                   	leave  
80104b1e:	c3                   	ret    
80104b1f:	90                   	nop

80104b20 <sys_close>:

int
sys_close(void)
{
80104b20:	55                   	push   %ebp
80104b21:	89 e5                	mov    %esp,%ebp
80104b23:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
80104b26:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104b29:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104b2c:	e8 4f fe ff ff       	call   80104980 <argfd.constprop.0>
80104b31:	85 c0                	test   %eax,%eax
80104b33:	78 23                	js     80104b58 <sys_close+0x38>
    return -1;
  proc->ofile[fd] = 0;
80104b35:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104b38:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b3e:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80104b45:	00 
  fileclose(f);
80104b46:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b49:	89 04 24             	mov    %eax,(%esp)
80104b4c:	e8 cf c2 ff ff       	call   80100e20 <fileclose>
  return 0;
80104b51:	31 c0                	xor    %eax,%eax
}
80104b53:	c9                   	leave  
80104b54:	c3                   	ret    
80104b55:	8d 76 00             	lea    0x0(%esi),%esi
{
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    return -1;
80104b58:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  proc->ofile[fd] = 0;
  fileclose(f);
  return 0;
}
80104b5d:	c9                   	leave  
80104b5e:	c3                   	ret    
80104b5f:	90                   	nop

80104b60 <sys_fstat>:

int
sys_fstat(void)
{
80104b60:	55                   	push   %ebp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104b61:	31 c0                	xor    %eax,%eax
  return 0;
}

int
sys_fstat(void)
{
80104b63:	89 e5                	mov    %esp,%ebp
80104b65:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104b68:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104b6b:	e8 10 fe ff ff       	call   80104980 <argfd.constprop.0>
80104b70:	85 c0                	test   %eax,%eax
80104b72:	78 34                	js     80104ba8 <sys_fstat+0x48>
80104b74:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104b77:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
80104b7e:	00 
80104b7f:	89 44 24 04          	mov    %eax,0x4(%esp)
80104b83:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104b8a:	e8 21 fb ff ff       	call   801046b0 <argptr>
80104b8f:	85 c0                	test   %eax,%eax
80104b91:	78 15                	js     80104ba8 <sys_fstat+0x48>
    return -1;
  return filestat(f, st);
80104b93:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b96:	89 44 24 04          	mov    %eax,0x4(%esp)
80104b9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104b9d:	89 04 24             	mov    %eax,(%esp)
80104ba0:	e8 3b c3 ff ff       	call   80100ee0 <filestat>
}
80104ba5:	c9                   	leave  
80104ba6:	c3                   	ret    
80104ba7:	90                   	nop
{
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
    return -1;
80104ba8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filestat(f, st);
}
80104bad:	c9                   	leave  
80104bae:	c3                   	ret    
80104baf:	90                   	nop

80104bb0 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80104bb0:	55                   	push   %ebp
80104bb1:	89 e5                	mov    %esp,%ebp
80104bb3:	57                   	push   %edi
80104bb4:	56                   	push   %esi
80104bb5:	53                   	push   %ebx
80104bb6:	83 ec 3c             	sub    $0x3c,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104bb9:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104bbc:	89 44 24 04          	mov    %eax,0x4(%esp)
80104bc0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104bc7:	e8 34 fb ff ff       	call   80104700 <argstr>
80104bcc:	85 c0                	test   %eax,%eax
80104bce:	0f 88 e6 00 00 00    	js     80104cba <sys_link+0x10a>
80104bd4:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104bd7:	89 44 24 04          	mov    %eax,0x4(%esp)
80104bdb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104be2:	e8 19 fb ff ff       	call   80104700 <argstr>
80104be7:	85 c0                	test   %eax,%eax
80104be9:	0f 88 cb 00 00 00    	js     80104cba <sys_link+0x10a>
    return -1;

  begin_op();
80104bef:	e8 8c df ff ff       	call   80102b80 <begin_op>
  if((ip = namei(old)) == 0){
80104bf4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80104bf7:	89 04 24             	mov    %eax,(%esp)
80104bfa:	e8 e1 d2 ff ff       	call   80101ee0 <namei>
80104bff:	85 c0                	test   %eax,%eax
80104c01:	89 c3                	mov    %eax,%ebx
80104c03:	0f 84 ac 00 00 00    	je     80104cb5 <sys_link+0x105>
    end_op();
    return -1;
  }

  ilock(ip);
80104c09:	89 04 24             	mov    %eax,(%esp)
80104c0c:	e8 9f ca ff ff       	call   801016b0 <ilock>
  if(ip->type == T_DIR){
80104c11:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104c16:	0f 84 91 00 00 00    	je     80104cad <sys_link+0xfd>
    iunlockput(ip);
    end_op();
    return -1;
  }

  ip->nlink++;
80104c1c:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
80104c21:	8d 7d da             	lea    -0x26(%ebp),%edi
    end_op();
    return -1;
  }

  ip->nlink++;
  iupdate(ip);
80104c24:	89 1c 24             	mov    %ebx,(%esp)
80104c27:	e8 c4 c9 ff ff       	call   801015f0 <iupdate>
  iunlock(ip);
80104c2c:	89 1c 24             	mov    %ebx,(%esp)
80104c2f:	e8 4c cb ff ff       	call   80101780 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
80104c34:	8b 45 d0             	mov    -0x30(%ebp),%eax
80104c37:	89 7c 24 04          	mov    %edi,0x4(%esp)
80104c3b:	89 04 24             	mov    %eax,(%esp)
80104c3e:	e8 bd d2 ff ff       	call   80101f00 <nameiparent>
80104c43:	85 c0                	test   %eax,%eax
80104c45:	89 c6                	mov    %eax,%esi
80104c47:	74 4f                	je     80104c98 <sys_link+0xe8>
    goto bad;
  ilock(dp);
80104c49:	89 04 24             	mov    %eax,(%esp)
80104c4c:	e8 5f ca ff ff       	call   801016b0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80104c51:	8b 03                	mov    (%ebx),%eax
80104c53:	39 06                	cmp    %eax,(%esi)
80104c55:	75 39                	jne    80104c90 <sys_link+0xe0>
80104c57:	8b 43 04             	mov    0x4(%ebx),%eax
80104c5a:	89 7c 24 04          	mov    %edi,0x4(%esp)
80104c5e:	89 34 24             	mov    %esi,(%esp)
80104c61:	89 44 24 08          	mov    %eax,0x8(%esp)
80104c65:	e8 96 d1 ff ff       	call   80101e00 <dirlink>
80104c6a:	85 c0                	test   %eax,%eax
80104c6c:	78 22                	js     80104c90 <sys_link+0xe0>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
80104c6e:	89 34 24             	mov    %esi,(%esp)
80104c71:	e8 7a cc ff ff       	call   801018f0 <iunlockput>
  iput(ip);
80104c76:	89 1c 24             	mov    %ebx,(%esp)
80104c79:	e8 42 cb ff ff       	call   801017c0 <iput>

  end_op();
80104c7e:	e8 6d df ff ff       	call   80102bf0 <end_op>
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
80104c83:	83 c4 3c             	add    $0x3c,%esp
  iunlockput(dp);
  iput(ip);

  end_op();

  return 0;
80104c86:	31 c0                	xor    %eax,%eax
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
80104c88:	5b                   	pop    %ebx
80104c89:	5e                   	pop    %esi
80104c8a:	5f                   	pop    %edi
80104c8b:	5d                   	pop    %ebp
80104c8c:	c3                   	ret    
80104c8d:	8d 76 00             	lea    0x0(%esi),%esi

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
  ilock(dp);
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    iunlockput(dp);
80104c90:	89 34 24             	mov    %esi,(%esp)
80104c93:	e8 58 cc ff ff       	call   801018f0 <iunlockput>
  end_op();

  return 0;

bad:
  ilock(ip);
80104c98:	89 1c 24             	mov    %ebx,(%esp)
80104c9b:	e8 10 ca ff ff       	call   801016b0 <ilock>
  ip->nlink--;
80104ca0:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104ca5:	89 1c 24             	mov    %ebx,(%esp)
80104ca8:	e8 43 c9 ff ff       	call   801015f0 <iupdate>
  iunlockput(ip);
80104cad:	89 1c 24             	mov    %ebx,(%esp)
80104cb0:	e8 3b cc ff ff       	call   801018f0 <iunlockput>
  end_op();
80104cb5:	e8 36 df ff ff       	call   80102bf0 <end_op>
  return -1;
}
80104cba:	83 c4 3c             	add    $0x3c,%esp
  ilock(ip);
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
80104cbd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104cc2:	5b                   	pop    %ebx
80104cc3:	5e                   	pop    %esi
80104cc4:	5f                   	pop    %edi
80104cc5:	5d                   	pop    %ebp
80104cc6:	c3                   	ret    
80104cc7:	89 f6                	mov    %esi,%esi
80104cc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104cd0 <sys_unlink>:
}

//PAGEBREAK!
int
sys_unlink(void)
{
80104cd0:	55                   	push   %ebp
80104cd1:	89 e5                	mov    %esp,%ebp
80104cd3:	57                   	push   %edi
80104cd4:	56                   	push   %esi
80104cd5:	53                   	push   %ebx
80104cd6:	83 ec 5c             	sub    $0x5c,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80104cd9:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104cdc:	89 44 24 04          	mov    %eax,0x4(%esp)
80104ce0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104ce7:	e8 14 fa ff ff       	call   80104700 <argstr>
80104cec:	85 c0                	test   %eax,%eax
80104cee:	0f 88 76 01 00 00    	js     80104e6a <sys_unlink+0x19a>
    return -1;

  begin_op();
80104cf4:	e8 87 de ff ff       	call   80102b80 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80104cf9:	8b 45 c0             	mov    -0x40(%ebp),%eax
80104cfc:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80104cff:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104d03:	89 04 24             	mov    %eax,(%esp)
80104d06:	e8 f5 d1 ff ff       	call   80101f00 <nameiparent>
80104d0b:	85 c0                	test   %eax,%eax
80104d0d:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80104d10:	0f 84 4f 01 00 00    	je     80104e65 <sys_unlink+0x195>
    end_op();
    return -1;
  }

  ilock(dp);
80104d16:	8b 75 b4             	mov    -0x4c(%ebp),%esi
80104d19:	89 34 24             	mov    %esi,(%esp)
80104d1c:	e8 8f c9 ff ff       	call   801016b0 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80104d21:	c7 44 24 04 d8 74 10 	movl   $0x801074d8,0x4(%esp)
80104d28:	80 
80104d29:	89 1c 24             	mov    %ebx,(%esp)
80104d2c:	e8 3f ce ff ff       	call   80101b70 <namecmp>
80104d31:	85 c0                	test   %eax,%eax
80104d33:	0f 84 21 01 00 00    	je     80104e5a <sys_unlink+0x18a>
80104d39:	c7 44 24 04 d7 74 10 	movl   $0x801074d7,0x4(%esp)
80104d40:	80 
80104d41:	89 1c 24             	mov    %ebx,(%esp)
80104d44:	e8 27 ce ff ff       	call   80101b70 <namecmp>
80104d49:	85 c0                	test   %eax,%eax
80104d4b:	0f 84 09 01 00 00    	je     80104e5a <sys_unlink+0x18a>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80104d51:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80104d54:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104d58:	89 44 24 08          	mov    %eax,0x8(%esp)
80104d5c:	89 34 24             	mov    %esi,(%esp)
80104d5f:	e8 3c ce ff ff       	call   80101ba0 <dirlookup>
80104d64:	85 c0                	test   %eax,%eax
80104d66:	89 c3                	mov    %eax,%ebx
80104d68:	0f 84 ec 00 00 00    	je     80104e5a <sys_unlink+0x18a>
    goto bad;
  ilock(ip);
80104d6e:	89 04 24             	mov    %eax,(%esp)
80104d71:	e8 3a c9 ff ff       	call   801016b0 <ilock>

  if(ip->nlink < 1)
80104d76:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80104d7b:	0f 8e 24 01 00 00    	jle    80104ea5 <sys_unlink+0x1d5>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
80104d81:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104d86:	8d 75 d8             	lea    -0x28(%ebp),%esi
80104d89:	74 7d                	je     80104e08 <sys_unlink+0x138>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
80104d8b:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80104d92:	00 
80104d93:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80104d9a:	00 
80104d9b:	89 34 24             	mov    %esi,(%esp)
80104d9e:	e8 fd f5 ff ff       	call   801043a0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104da3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80104da6:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80104dad:	00 
80104dae:	89 74 24 04          	mov    %esi,0x4(%esp)
80104db2:	89 44 24 08          	mov    %eax,0x8(%esp)
80104db6:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104db9:	89 04 24             	mov    %eax,(%esp)
80104dbc:	e8 7f cc ff ff       	call   80101a40 <writei>
80104dc1:	83 f8 10             	cmp    $0x10,%eax
80104dc4:	0f 85 cf 00 00 00    	jne    80104e99 <sys_unlink+0x1c9>
    panic("unlink: writei");
  if(ip->type == T_DIR){
80104dca:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104dcf:	0f 84 a3 00 00 00    	je     80104e78 <sys_unlink+0x1a8>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
80104dd5:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104dd8:	89 04 24             	mov    %eax,(%esp)
80104ddb:	e8 10 cb ff ff       	call   801018f0 <iunlockput>

  ip->nlink--;
80104de0:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104de5:	89 1c 24             	mov    %ebx,(%esp)
80104de8:	e8 03 c8 ff ff       	call   801015f0 <iupdate>
  iunlockput(ip);
80104ded:	89 1c 24             	mov    %ebx,(%esp)
80104df0:	e8 fb ca ff ff       	call   801018f0 <iunlockput>

  end_op();
80104df5:	e8 f6 dd ff ff       	call   80102bf0 <end_op>

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
80104dfa:	83 c4 5c             	add    $0x5c,%esp
  iupdate(ip);
  iunlockput(ip);

  end_op();

  return 0;
80104dfd:	31 c0                	xor    %eax,%eax

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
80104dff:	5b                   	pop    %ebx
80104e00:	5e                   	pop    %esi
80104e01:	5f                   	pop    %edi
80104e02:	5d                   	pop    %ebp
80104e03:	c3                   	ret    
80104e04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80104e08:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80104e0c:	0f 86 79 ff ff ff    	jbe    80104d8b <sys_unlink+0xbb>
80104e12:	bf 20 00 00 00       	mov    $0x20,%edi
80104e17:	eb 15                	jmp    80104e2e <sys_unlink+0x15e>
80104e19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e20:	8d 57 10             	lea    0x10(%edi),%edx
80104e23:	3b 53 58             	cmp    0x58(%ebx),%edx
80104e26:	0f 83 5f ff ff ff    	jae    80104d8b <sys_unlink+0xbb>
80104e2c:	89 d7                	mov    %edx,%edi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104e2e:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80104e35:	00 
80104e36:	89 7c 24 08          	mov    %edi,0x8(%esp)
80104e3a:	89 74 24 04          	mov    %esi,0x4(%esp)
80104e3e:	89 1c 24             	mov    %ebx,(%esp)
80104e41:	e8 fa ca ff ff       	call   80101940 <readi>
80104e46:	83 f8 10             	cmp    $0x10,%eax
80104e49:	75 42                	jne    80104e8d <sys_unlink+0x1bd>
      panic("isdirempty: readi");
    if(de.inum != 0)
80104e4b:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80104e50:	74 ce                	je     80104e20 <sys_unlink+0x150>
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
    iunlockput(ip);
80104e52:	89 1c 24             	mov    %ebx,(%esp)
80104e55:	e8 96 ca ff ff       	call   801018f0 <iunlockput>
  end_op();

  return 0;

bad:
  iunlockput(dp);
80104e5a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104e5d:	89 04 24             	mov    %eax,(%esp)
80104e60:	e8 8b ca ff ff       	call   801018f0 <iunlockput>
  end_op();
80104e65:	e8 86 dd ff ff       	call   80102bf0 <end_op>
  return -1;
}
80104e6a:	83 c4 5c             	add    $0x5c,%esp
  return 0;

bad:
  iunlockput(dp);
  end_op();
  return -1;
80104e6d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e72:	5b                   	pop    %ebx
80104e73:	5e                   	pop    %esi
80104e74:	5f                   	pop    %edi
80104e75:	5d                   	pop    %ebp
80104e76:	c3                   	ret    
80104e77:	90                   	nop

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
80104e78:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104e7b:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
80104e80:	89 04 24             	mov    %eax,(%esp)
80104e83:	e8 68 c7 ff ff       	call   801015f0 <iupdate>
80104e88:	e9 48 ff ff ff       	jmp    80104dd5 <sys_unlink+0x105>
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
80104e8d:	c7 04 24 fc 74 10 80 	movl   $0x801074fc,(%esp)
80104e94:	e8 c7 b4 ff ff       	call   80100360 <panic>
    goto bad;
  }

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
80104e99:	c7 04 24 0e 75 10 80 	movl   $0x8010750e,(%esp)
80104ea0:	e8 bb b4 ff ff       	call   80100360 <panic>
  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
80104ea5:	c7 04 24 ea 74 10 80 	movl   $0x801074ea,(%esp)
80104eac:	e8 af b4 ff ff       	call   80100360 <panic>
80104eb1:	eb 0d                	jmp    80104ec0 <sys_open>
80104eb3:	90                   	nop
80104eb4:	90                   	nop
80104eb5:	90                   	nop
80104eb6:	90                   	nop
80104eb7:	90                   	nop
80104eb8:	90                   	nop
80104eb9:	90                   	nop
80104eba:	90                   	nop
80104ebb:	90                   	nop
80104ebc:	90                   	nop
80104ebd:	90                   	nop
80104ebe:	90                   	nop
80104ebf:	90                   	nop

80104ec0 <sys_open>:
  return ip;
}

int
sys_open(void)
{
80104ec0:	55                   	push   %ebp
80104ec1:	89 e5                	mov    %esp,%ebp
80104ec3:	57                   	push   %edi
80104ec4:	56                   	push   %esi
80104ec5:	53                   	push   %ebx
80104ec6:	83 ec 2c             	sub    $0x2c,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80104ec9:	8d 45 e0             	lea    -0x20(%ebp),%eax
80104ecc:	89 44 24 04          	mov    %eax,0x4(%esp)
80104ed0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104ed7:	e8 24 f8 ff ff       	call   80104700 <argstr>
80104edc:	85 c0                	test   %eax,%eax
80104ede:	0f 88 81 00 00 00    	js     80104f65 <sys_open+0xa5>
80104ee4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80104ee7:	89 44 24 04          	mov    %eax,0x4(%esp)
80104eeb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104ef2:	e8 79 f7 ff ff       	call   80104670 <argint>
80104ef7:	85 c0                	test   %eax,%eax
80104ef9:	78 6a                	js     80104f65 <sys_open+0xa5>
    return -1;

  begin_op();
80104efb:	e8 80 dc ff ff       	call   80102b80 <begin_op>

  if(omode & O_CREATE){
80104f00:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80104f04:	75 72                	jne    80104f78 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80104f06:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104f09:	89 04 24             	mov    %eax,(%esp)
80104f0c:	e8 cf cf ff ff       	call   80101ee0 <namei>
80104f11:	85 c0                	test   %eax,%eax
80104f13:	89 c7                	mov    %eax,%edi
80104f15:	74 49                	je     80104f60 <sys_open+0xa0>
      end_op();
      return -1;
    }
    ilock(ip);
80104f17:	89 04 24             	mov    %eax,(%esp)
80104f1a:	e8 91 c7 ff ff       	call   801016b0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80104f1f:	66 83 7f 50 01       	cmpw   $0x1,0x50(%edi)
80104f24:	0f 84 ae 00 00 00    	je     80104fd8 <sys_open+0x118>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80104f2a:	e8 31 be ff ff       	call   80100d60 <filealloc>
80104f2f:	85 c0                	test   %eax,%eax
80104f31:	89 c6                	mov    %eax,%esi
80104f33:	74 23                	je     80104f58 <sys_open+0x98>
80104f35:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104f3c:	31 db                	xor    %ebx,%ebx
80104f3e:	66 90                	xchg   %ax,%ax
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
80104f40:	8b 44 9a 28          	mov    0x28(%edx,%ebx,4),%eax
80104f44:	85 c0                	test   %eax,%eax
80104f46:	74 50                	je     80104f98 <sys_open+0xd8>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80104f48:	83 c3 01             	add    $0x1,%ebx
80104f4b:	83 fb 10             	cmp    $0x10,%ebx
80104f4e:	75 f0                	jne    80104f40 <sys_open+0x80>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
80104f50:	89 34 24             	mov    %esi,(%esp)
80104f53:	e8 c8 be ff ff       	call   80100e20 <fileclose>
    iunlockput(ip);
80104f58:	89 3c 24             	mov    %edi,(%esp)
80104f5b:	e8 90 c9 ff ff       	call   801018f0 <iunlockput>
    end_op();
80104f60:	e8 8b dc ff ff       	call   80102bf0 <end_op>
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
80104f65:	83 c4 2c             	add    $0x2c,%esp
  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
80104f68:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
80104f6d:	5b                   	pop    %ebx
80104f6e:	5e                   	pop    %esi
80104f6f:	5f                   	pop    %edi
80104f70:	5d                   	pop    %ebp
80104f71:	c3                   	ret    
80104f72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
80104f78:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104f7b:	31 c9                	xor    %ecx,%ecx
80104f7d:	ba 02 00 00 00       	mov    $0x2,%edx
80104f82:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104f89:	e8 72 f8 ff ff       	call   80104800 <create>
    if(ip == 0){
80104f8e:	85 c0                	test   %eax,%eax
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
80104f90:	89 c7                	mov    %eax,%edi
    if(ip == 0){
80104f92:	75 96                	jne    80104f2a <sys_open+0x6a>
80104f94:	eb ca                	jmp    80104f60 <sys_open+0xa0>
80104f96:	66 90                	xchg   %ax,%ax
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
80104f98:	89 74 9a 28          	mov    %esi,0x28(%edx,%ebx,4)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80104f9c:	89 3c 24             	mov    %edi,(%esp)
80104f9f:	e8 dc c7 ff ff       	call   80101780 <iunlock>
  end_op();
80104fa4:	e8 47 dc ff ff       	call   80102bf0 <end_op>

  f->type = FD_INODE;
80104fa9:	c7 06 02 00 00 00    	movl   $0x2,(%esi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80104faf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  }
  iunlock(ip);
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
80104fb2:	89 7e 10             	mov    %edi,0x10(%esi)
  f->off = 0;
80104fb5:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)
  f->readable = !(omode & O_WRONLY);
80104fbc:	89 d0                	mov    %edx,%eax
80104fbe:	83 e0 01             	and    $0x1,%eax
80104fc1:	83 f0 01             	xor    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80104fc4:	83 e2 03             	and    $0x3,%edx
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80104fc7:	88 46 08             	mov    %al,0x8(%esi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
80104fca:	89 d8                	mov    %ebx,%eax

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80104fcc:	0f 95 46 09          	setne  0x9(%esi)
  return fd;
}
80104fd0:	83 c4 2c             	add    $0x2c,%esp
80104fd3:	5b                   	pop    %ebx
80104fd4:	5e                   	pop    %esi
80104fd5:	5f                   	pop    %edi
80104fd6:	5d                   	pop    %ebp
80104fd7:	c3                   	ret    
    if((ip = namei(path)) == 0){
      end_op();
      return -1;
    }
    ilock(ip);
    if(ip->type == T_DIR && omode != O_RDONLY){
80104fd8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104fdb:	85 d2                	test   %edx,%edx
80104fdd:	0f 84 47 ff ff ff    	je     80104f2a <sys_open+0x6a>
80104fe3:	e9 70 ff ff ff       	jmp    80104f58 <sys_open+0x98>
80104fe8:	90                   	nop
80104fe9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104ff0 <sys_mkdir>:
  return fd;
}

int
sys_mkdir(void)
{
80104ff0:	55                   	push   %ebp
80104ff1:	89 e5                	mov    %esp,%ebp
80104ff3:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  begin_op();
80104ff6:	e8 85 db ff ff       	call   80102b80 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80104ffb:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104ffe:	89 44 24 04          	mov    %eax,0x4(%esp)
80105002:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105009:	e8 f2 f6 ff ff       	call   80104700 <argstr>
8010500e:	85 c0                	test   %eax,%eax
80105010:	78 2e                	js     80105040 <sys_mkdir+0x50>
80105012:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105015:	31 c9                	xor    %ecx,%ecx
80105017:	ba 01 00 00 00       	mov    $0x1,%edx
8010501c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105023:	e8 d8 f7 ff ff       	call   80104800 <create>
80105028:	85 c0                	test   %eax,%eax
8010502a:	74 14                	je     80105040 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010502c:	89 04 24             	mov    %eax,(%esp)
8010502f:	e8 bc c8 ff ff       	call   801018f0 <iunlockput>
  end_op();
80105034:	e8 b7 db ff ff       	call   80102bf0 <end_op>
  return 0;
80105039:	31 c0                	xor    %eax,%eax
}
8010503b:	c9                   	leave  
8010503c:	c3                   	ret    
8010503d:	8d 76 00             	lea    0x0(%esi),%esi
  char *path;
  struct inode *ip;

  begin_op();
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    end_op();
80105040:	e8 ab db ff ff       	call   80102bf0 <end_op>
    return -1;
80105045:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
8010504a:	c9                   	leave  
8010504b:	c3                   	ret    
8010504c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105050 <sys_mknod>:

int
sys_mknod(void)
{
80105050:	55                   	push   %ebp
80105051:	89 e5                	mov    %esp,%ebp
80105053:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105056:	e8 25 db ff ff       	call   80102b80 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010505b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010505e:	89 44 24 04          	mov    %eax,0x4(%esp)
80105062:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105069:	e8 92 f6 ff ff       	call   80104700 <argstr>
8010506e:	85 c0                	test   %eax,%eax
80105070:	78 5e                	js     801050d0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105072:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105075:	89 44 24 04          	mov    %eax,0x4(%esp)
80105079:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105080:	e8 eb f5 ff ff       	call   80104670 <argint>
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
80105085:	85 c0                	test   %eax,%eax
80105087:	78 47                	js     801050d0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80105089:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010508c:	89 44 24 04          	mov    %eax,0x4(%esp)
80105090:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80105097:	e8 d4 f5 ff ff       	call   80104670 <argint>
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
8010509c:	85 c0                	test   %eax,%eax
8010509e:	78 30                	js     801050d0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
801050a0:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
801050a4:	ba 03 00 00 00       	mov    $0x3,%edx
     (ip = create(path, T_DEV, major, minor)) == 0){
801050a9:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
801050ad:	89 04 24             	mov    %eax,(%esp)
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
801050b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801050b3:	e8 48 f7 ff ff       	call   80104800 <create>
801050b8:	85 c0                	test   %eax,%eax
801050ba:	74 14                	je     801050d0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
    return -1;
  }
  iunlockput(ip);
801050bc:	89 04 24             	mov    %eax,(%esp)
801050bf:	e8 2c c8 ff ff       	call   801018f0 <iunlockput>
  end_op();
801050c4:	e8 27 db ff ff       	call   80102bf0 <end_op>
  return 0;
801050c9:	31 c0                	xor    %eax,%eax
}
801050cb:	c9                   	leave  
801050cc:	c3                   	ret    
801050cd:	8d 76 00             	lea    0x0(%esi),%esi
  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
801050d0:	e8 1b db ff ff       	call   80102bf0 <end_op>
    return -1;
801050d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
801050da:	c9                   	leave  
801050db:	c3                   	ret    
801050dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801050e0 <sys_chdir>:

int
sys_chdir(void)
{
801050e0:	55                   	push   %ebp
801050e1:	89 e5                	mov    %esp,%ebp
801050e3:	53                   	push   %ebx
801050e4:	83 ec 24             	sub    $0x24,%esp
  char *path;
  struct inode *ip;

  begin_op();
801050e7:	e8 94 da ff ff       	call   80102b80 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801050ec:	8d 45 f4             	lea    -0xc(%ebp),%eax
801050ef:	89 44 24 04          	mov    %eax,0x4(%esp)
801050f3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801050fa:	e8 01 f6 ff ff       	call   80104700 <argstr>
801050ff:	85 c0                	test   %eax,%eax
80105101:	78 5a                	js     8010515d <sys_chdir+0x7d>
80105103:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105106:	89 04 24             	mov    %eax,(%esp)
80105109:	e8 d2 cd ff ff       	call   80101ee0 <namei>
8010510e:	85 c0                	test   %eax,%eax
80105110:	89 c3                	mov    %eax,%ebx
80105112:	74 49                	je     8010515d <sys_chdir+0x7d>
    end_op();
    return -1;
  }
  ilock(ip);
80105114:	89 04 24             	mov    %eax,(%esp)
80105117:	e8 94 c5 ff ff       	call   801016b0 <ilock>
  if(ip->type != T_DIR){
8010511c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
    iunlockput(ip);
80105121:	89 1c 24             	mov    %ebx,(%esp)
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
    end_op();
    return -1;
  }
  ilock(ip);
  if(ip->type != T_DIR){
80105124:	75 32                	jne    80105158 <sys_chdir+0x78>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105126:	e8 55 c6 ff ff       	call   80101780 <iunlock>
  iput(proc->cwd);
8010512b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105131:	8b 40 68             	mov    0x68(%eax),%eax
80105134:	89 04 24             	mov    %eax,(%esp)
80105137:	e8 84 c6 ff ff       	call   801017c0 <iput>
  end_op();
8010513c:	e8 af da ff ff       	call   80102bf0 <end_op>
  proc->cwd = ip;
80105141:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105147:	89 58 68             	mov    %ebx,0x68(%eax)
  return 0;
}
8010514a:	83 c4 24             	add    $0x24,%esp
  }
  iunlock(ip);
  iput(proc->cwd);
  end_op();
  proc->cwd = ip;
  return 0;
8010514d:	31 c0                	xor    %eax,%eax
}
8010514f:	5b                   	pop    %ebx
80105150:	5d                   	pop    %ebp
80105151:	c3                   	ret    
80105152:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    end_op();
    return -1;
  }
  ilock(ip);
  if(ip->type != T_DIR){
    iunlockput(ip);
80105158:	e8 93 c7 ff ff       	call   801018f0 <iunlockput>
    end_op();
8010515d:	e8 8e da ff ff       	call   80102bf0 <end_op>
  iunlock(ip);
  iput(proc->cwd);
  end_op();
  proc->cwd = ip;
  return 0;
}
80105162:	83 c4 24             	add    $0x24,%esp
  }
  ilock(ip);
  if(ip->type != T_DIR){
    iunlockput(ip);
    end_op();
    return -1;
80105165:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  iunlock(ip);
  iput(proc->cwd);
  end_op();
  proc->cwd = ip;
  return 0;
}
8010516a:	5b                   	pop    %ebx
8010516b:	5d                   	pop    %ebp
8010516c:	c3                   	ret    
8010516d:	8d 76 00             	lea    0x0(%esi),%esi

80105170 <sys_exec>:

int
sys_exec(void)
{
80105170:	55                   	push   %ebp
80105171:	89 e5                	mov    %esp,%ebp
80105173:	57                   	push   %edi
80105174:	56                   	push   %esi
80105175:	53                   	push   %ebx
80105176:	81 ec ac 00 00 00    	sub    $0xac,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
8010517c:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
80105182:	89 44 24 04          	mov    %eax,0x4(%esp)
80105186:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010518d:	e8 6e f5 ff ff       	call   80104700 <argstr>
80105192:	85 c0                	test   %eax,%eax
80105194:	0f 88 84 00 00 00    	js     8010521e <sys_exec+0xae>
8010519a:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801051a0:	89 44 24 04          	mov    %eax,0x4(%esp)
801051a4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801051ab:	e8 c0 f4 ff ff       	call   80104670 <argint>
801051b0:	85 c0                	test   %eax,%eax
801051b2:	78 6a                	js     8010521e <sys_exec+0xae>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801051b4:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
801051ba:	31 db                	xor    %ebx,%ebx
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801051bc:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
801051c3:	00 
801051c4:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
801051ca:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801051d1:	00 
801051d2:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
801051d8:	89 04 24             	mov    %eax,(%esp)
801051db:	e8 c0 f1 ff ff       	call   801043a0 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801051e0:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
801051e6:	89 7c 24 04          	mov    %edi,0x4(%esp)
801051ea:	8d 04 98             	lea    (%eax,%ebx,4),%eax
801051ed:	89 04 24             	mov    %eax,(%esp)
801051f0:	e8 fb f3 ff ff       	call   801045f0 <fetchint>
801051f5:	85 c0                	test   %eax,%eax
801051f7:	78 25                	js     8010521e <sys_exec+0xae>
      return -1;
    if(uarg == 0){
801051f9:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
801051ff:	85 c0                	test   %eax,%eax
80105201:	74 2d                	je     80105230 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105203:	89 74 24 04          	mov    %esi,0x4(%esp)
80105207:	89 04 24             	mov    %eax,(%esp)
8010520a:	e8 11 f4 ff ff       	call   80104620 <fetchstr>
8010520f:	85 c0                	test   %eax,%eax
80105211:	78 0b                	js     8010521e <sys_exec+0xae>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
80105213:	83 c3 01             	add    $0x1,%ebx
80105216:	83 c6 04             	add    $0x4,%esi
    if(i >= NELEM(argv))
80105219:	83 fb 20             	cmp    $0x20,%ebx
8010521c:	75 c2                	jne    801051e0 <sys_exec+0x70>
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
8010521e:	81 c4 ac 00 00 00    	add    $0xac,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
80105224:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
80105229:	5b                   	pop    %ebx
8010522a:	5e                   	pop    %esi
8010522b:	5f                   	pop    %edi
8010522c:	5d                   	pop    %ebp
8010522d:	c3                   	ret    
8010522e:	66 90                	xchg   %ax,%ax
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80105230:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105236:	89 44 24 04          	mov    %eax,0x4(%esp)
8010523a:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
      argv[i] = 0;
80105240:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105247:	00 00 00 00 
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
8010524b:	89 04 24             	mov    %eax,(%esp)
8010524e:	e8 5d b7 ff ff       	call   801009b0 <exec>
}
80105253:	81 c4 ac 00 00 00    	add    $0xac,%esp
80105259:	5b                   	pop    %ebx
8010525a:	5e                   	pop    %esi
8010525b:	5f                   	pop    %edi
8010525c:	5d                   	pop    %ebp
8010525d:	c3                   	ret    
8010525e:	66 90                	xchg   %ax,%ax

80105260 <sys_pipe>:

int
sys_pipe(void)
{
80105260:	55                   	push   %ebp
80105261:	89 e5                	mov    %esp,%ebp
80105263:	57                   	push   %edi
80105264:	56                   	push   %esi
80105265:	53                   	push   %ebx
80105266:	83 ec 2c             	sub    $0x2c,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105269:	8d 45 dc             	lea    -0x24(%ebp),%eax
8010526c:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
80105273:	00 
80105274:	89 44 24 04          	mov    %eax,0x4(%esp)
80105278:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010527f:	e8 2c f4 ff ff       	call   801046b0 <argptr>
80105284:	85 c0                	test   %eax,%eax
80105286:	78 7a                	js     80105302 <sys_pipe+0xa2>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105288:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010528b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010528f:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105292:	89 04 24             	mov    %eax,(%esp)
80105295:	e8 16 e0 ff ff       	call   801032b0 <pipealloc>
8010529a:	85 c0                	test   %eax,%eax
8010529c:	78 64                	js     80105302 <sys_pipe+0xa2>
8010529e:	65 8b 0d 04 00 00 00 	mov    %gs:0x4,%ecx
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
801052a5:	31 c0                	xor    %eax,%eax
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801052a7:	8b 5d e0             	mov    -0x20(%ebp),%ebx
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
801052aa:	8b 54 81 28          	mov    0x28(%ecx,%eax,4),%edx
801052ae:	85 d2                	test   %edx,%edx
801052b0:	74 16                	je     801052c8 <sys_pipe+0x68>
801052b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
801052b8:	83 c0 01             	add    $0x1,%eax
801052bb:	83 f8 10             	cmp    $0x10,%eax
801052be:	74 2f                	je     801052ef <sys_pipe+0x8f>
    if(proc->ofile[fd] == 0){
801052c0:	8b 54 81 28          	mov    0x28(%ecx,%eax,4),%edx
801052c4:	85 d2                	test   %edx,%edx
801052c6:	75 f0                	jne    801052b8 <sys_pipe+0x58>
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801052c8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
801052cb:	8d 70 08             	lea    0x8(%eax),%esi
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
801052ce:	31 d2                	xor    %edx,%edx
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
801052d0:	89 5c b1 08          	mov    %ebx,0x8(%ecx,%esi,4)
801052d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
801052d8:	83 7c 91 28 00       	cmpl   $0x0,0x28(%ecx,%edx,4)
801052dd:	74 31                	je     80105310 <sys_pipe+0xb0>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
801052df:	83 c2 01             	add    $0x1,%edx
801052e2:	83 fa 10             	cmp    $0x10,%edx
801052e5:	75 f1                	jne    801052d8 <sys_pipe+0x78>
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      proc->ofile[fd0] = 0;
801052e7:	c7 44 b1 08 00 00 00 	movl   $0x0,0x8(%ecx,%esi,4)
801052ee:	00 
    fileclose(rf);
801052ef:	89 1c 24             	mov    %ebx,(%esp)
801052f2:	e8 29 bb ff ff       	call   80100e20 <fileclose>
    fileclose(wf);
801052f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801052fa:	89 04 24             	mov    %eax,(%esp)
801052fd:	e8 1e bb ff ff       	call   80100e20 <fileclose>
    return -1;
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
80105302:	83 c4 2c             	add    $0x2c,%esp
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      proc->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
80105305:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
8010530a:	5b                   	pop    %ebx
8010530b:	5e                   	pop    %esi
8010530c:	5f                   	pop    %edi
8010530d:	5d                   	pop    %ebp
8010530e:	c3                   	ret    
8010530f:	90                   	nop
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
80105310:	89 7c 91 28          	mov    %edi,0x28(%ecx,%edx,4)
      proc->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80105314:	8b 4d dc             	mov    -0x24(%ebp),%ecx
80105317:	89 01                	mov    %eax,(%ecx)
  fd[1] = fd1;
80105319:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010531c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
}
8010531f:	83 c4 2c             	add    $0x2c,%esp
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
80105322:	31 c0                	xor    %eax,%eax
}
80105324:	5b                   	pop    %ebx
80105325:	5e                   	pop    %esi
80105326:	5f                   	pop    %edi
80105327:	5d                   	pop    %ebp
80105328:	c3                   	ret    
80105329:	66 90                	xchg   %ax,%ax
8010532b:	66 90                	xchg   %ax,%ax
8010532d:	66 90                	xchg   %ax,%ax
8010532f:	90                   	nop

80105330 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105330:	55                   	push   %ebp
80105331:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105333:	5d                   	pop    %ebp
#include "proc.h"

int
sys_fork(void)
{
  return fork();
80105334:	e9 e7 e5 ff ff       	jmp    80103920 <fork>
80105339:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105340 <sys_exit>:
}

int
sys_exit(void)
{
80105340:	55                   	push   %ebp
80105341:	89 e5                	mov    %esp,%ebp
80105343:	83 ec 08             	sub    $0x8,%esp
  exit();
80105346:	e8 35 e8 ff ff       	call   80103b80 <exit>
  return 0;  // not reached
}
8010534b:	31 c0                	xor    %eax,%eax
8010534d:	c9                   	leave  
8010534e:	c3                   	ret    
8010534f:	90                   	nop

80105350 <sys_wait>:

int
sys_wait(void)
{
80105350:	55                   	push   %ebp
80105351:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105353:	5d                   	pop    %ebp
}

int
sys_wait(void)
{
  return wait();
80105354:	e9 67 ea ff ff       	jmp    80103dc0 <wait>
80105359:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105360 <sys_kill>:
}

int
sys_kill(void)
{
80105360:	55                   	push   %ebp
80105361:	89 e5                	mov    %esp,%ebp
80105363:	83 ec 28             	sub    $0x28,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105366:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105369:	89 44 24 04          	mov    %eax,0x4(%esp)
8010536d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105374:	e8 f7 f2 ff ff       	call   80104670 <argint>
80105379:	85 c0                	test   %eax,%eax
8010537b:	78 13                	js     80105390 <sys_kill+0x30>
    return -1;
  return kill(pid);
8010537d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105380:	89 04 24             	mov    %eax,(%esp)
80105383:	e8 98 eb ff ff       	call   80103f20 <kill>
}
80105388:	c9                   	leave  
80105389:	c3                   	ret    
8010538a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
80105390:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return kill(pid);
}
80105395:	c9                   	leave  
80105396:	c3                   	ret    
80105397:	89 f6                	mov    %esi,%esi
80105399:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801053a0 <sys_getpid>:

int
sys_getpid(void)
{
  return proc->pid;
801053a0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  return kill(pid);
}

int
sys_getpid(void)
{
801053a6:	55                   	push   %ebp
801053a7:	89 e5                	mov    %esp,%ebp
  return proc->pid;
}
801053a9:	5d                   	pop    %ebp
}

int
sys_getpid(void)
{
  return proc->pid;
801053aa:	8b 40 10             	mov    0x10(%eax),%eax
}
801053ad:	c3                   	ret    
801053ae:	66 90                	xchg   %ax,%ax

801053b0 <sys_sbrk>:

int
sys_sbrk(void)
{
801053b0:	55                   	push   %ebp
801053b1:	89 e5                	mov    %esp,%ebp
801053b3:	53                   	push   %ebx
801053b4:	83 ec 24             	sub    $0x24,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
801053b7:	8d 45 f4             	lea    -0xc(%ebp),%eax
801053ba:	89 44 24 04          	mov    %eax,0x4(%esp)
801053be:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801053c5:	e8 a6 f2 ff ff       	call   80104670 <argint>
801053ca:	85 c0                	test   %eax,%eax
801053cc:	78 22                	js     801053f0 <sys_sbrk+0x40>
    return -1;
  addr = proc->sz;
801053ce:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  if(growproc(n) < 0)
801053d4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = proc->sz;
801053d7:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
801053d9:	89 14 24             	mov    %edx,(%esp)
801053dc:	e8 bf e4 ff ff       	call   801038a0 <growproc>
801053e1:	85 c0                	test   %eax,%eax
801053e3:	78 0b                	js     801053f0 <sys_sbrk+0x40>
    return -1;
  return addr;
801053e5:	89 d8                	mov    %ebx,%eax
}
801053e7:	83 c4 24             	add    $0x24,%esp
801053ea:	5b                   	pop    %ebx
801053eb:	5d                   	pop    %ebp
801053ec:	c3                   	ret    
801053ed:	8d 76 00             	lea    0x0(%esi),%esi
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
801053f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053f5:	eb f0                	jmp    801053e7 <sys_sbrk+0x37>
801053f7:	89 f6                	mov    %esi,%esi
801053f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105400 <sys_sleep>:
  return addr;
}

int
sys_sleep(void)
{
80105400:	55                   	push   %ebp
80105401:	89 e5                	mov    %esp,%ebp
80105403:	53                   	push   %ebx
80105404:	83 ec 24             	sub    $0x24,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105407:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010540a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010540e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105415:	e8 56 f2 ff ff       	call   80104670 <argint>
8010541a:	85 c0                	test   %eax,%eax
8010541c:	78 7e                	js     8010549c <sys_sleep+0x9c>
    return -1;
  acquire(&tickslock);
8010541e:	c7 04 24 e0 63 11 80 	movl   $0x801163e0,(%esp)
80105425:	e8 f6 ed ff ff       	call   80104220 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010542a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
8010542d:	8b 1d 20 6c 11 80    	mov    0x80116c20,%ebx
  while(ticks - ticks0 < n){
80105433:	85 d2                	test   %edx,%edx
80105435:	75 29                	jne    80105460 <sys_sleep+0x60>
80105437:	eb 4f                	jmp    80105488 <sys_sleep+0x88>
80105439:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(proc->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105440:	c7 44 24 04 e0 63 11 	movl   $0x801163e0,0x4(%esp)
80105447:	80 
80105448:	c7 04 24 20 6c 11 80 	movl   $0x80116c20,(%esp)
8010544f:	e8 ac e8 ff ff       	call   80103d00 <sleep>

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105454:	a1 20 6c 11 80       	mov    0x80116c20,%eax
80105459:	29 d8                	sub    %ebx,%eax
8010545b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010545e:	73 28                	jae    80105488 <sys_sleep+0x88>
    if(proc->killed){
80105460:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105466:	8b 40 24             	mov    0x24(%eax),%eax
80105469:	85 c0                	test   %eax,%eax
8010546b:	74 d3                	je     80105440 <sys_sleep+0x40>
      release(&tickslock);
8010546d:	c7 04 24 e0 63 11 80 	movl   $0x801163e0,(%esp)
80105474:	e8 d7 ee ff ff       	call   80104350 <release>
      return -1;
80105479:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}
8010547e:	83 c4 24             	add    $0x24,%esp
80105481:	5b                   	pop    %ebx
80105482:	5d                   	pop    %ebp
80105483:	c3                   	ret    
80105484:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
80105488:	c7 04 24 e0 63 11 80 	movl   $0x801163e0,(%esp)
8010548f:	e8 bc ee ff ff       	call   80104350 <release>
  return 0;
}
80105494:	83 c4 24             	add    $0x24,%esp
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
80105497:	31 c0                	xor    %eax,%eax
}
80105499:	5b                   	pop    %ebx
8010549a:	5d                   	pop    %ebp
8010549b:	c3                   	ret    
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
8010549c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054a1:	eb db                	jmp    8010547e <sys_sleep+0x7e>
801054a3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801054a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801054b0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801054b0:	55                   	push   %ebp
801054b1:	89 e5                	mov    %esp,%ebp
801054b3:	53                   	push   %ebx
801054b4:	83 ec 14             	sub    $0x14,%esp
  uint xticks;

  acquire(&tickslock);
801054b7:	c7 04 24 e0 63 11 80 	movl   $0x801163e0,(%esp)
801054be:	e8 5d ed ff ff       	call   80104220 <acquire>
  xticks = ticks;
801054c3:	8b 1d 20 6c 11 80    	mov    0x80116c20,%ebx
  release(&tickslock);
801054c9:	c7 04 24 e0 63 11 80 	movl   $0x801163e0,(%esp)
801054d0:	e8 7b ee ff ff       	call   80104350 <release>
  return xticks;
}
801054d5:	83 c4 14             	add    $0x14,%esp
801054d8:	89 d8                	mov    %ebx,%eax
801054da:	5b                   	pop    %ebx
801054db:	5d                   	pop    %ebp
801054dc:	c3                   	ret    
801054dd:	8d 76 00             	lea    0x0(%esi),%esi

801054e0 <sys_callcount>:

int sys_callcount(void) {
801054e0:	55                   	push   %ebp
801054e1:	89 e5                	mov    %esp,%ebp
801054e3:	83 ec 28             	sub    $0x28,%esp
  cprintf("Alexander_Lerma_A20315236\n");
801054e6:	c7 04 24 1d 75 10 80 	movl   $0x8010751d,(%esp)
801054ed:	e8 5e b1 ff ff       	call   80100650 <cprintf>
  int n;
  if(argint(0, &n) < 0)
801054f2:	8d 45 f4             	lea    -0xc(%ebp),%eax
801054f5:	89 44 24 04          	mov    %eax,0x4(%esp)
801054f9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105500:	e8 6b f1 ff ff       	call   80104670 <argint>
80105505:	85 c0                	test   %eax,%eax
80105507:	78 0f                	js     80105518 <sys_callcount+0x38>
    return -1;
  return proc->callcount[n];
80105509:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010550c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105512:	8b 44 90 7c          	mov    0x7c(%eax,%edx,4),%eax
}
80105516:	c9                   	leave  
80105517:	c3                   	ret    

int sys_callcount(void) {
  cprintf("Alexander_Lerma_A20315236\n");
  int n;
  if(argint(0, &n) < 0)
    return -1;
80105518:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return proc->callcount[n];
}
8010551d:	c9                   	leave  
8010551e:	c3                   	ret    
8010551f:	90                   	nop

80105520 <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
80105520:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105521:	ba 43 00 00 00       	mov    $0x43,%edx
80105526:	89 e5                	mov    %esp,%ebp
80105528:	b8 34 00 00 00       	mov    $0x34,%eax
8010552d:	83 ec 18             	sub    $0x18,%esp
80105530:	ee                   	out    %al,(%dx)
80105531:	b8 9c ff ff ff       	mov    $0xffffff9c,%eax
80105536:	b2 40                	mov    $0x40,%dl
80105538:	ee                   	out    %al,(%dx)
80105539:	b8 2e 00 00 00       	mov    $0x2e,%eax
8010553e:	ee                   	out    %al,(%dx)
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
  picenable(IRQ_TIMER);
8010553f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105546:	e8 a5 dc ff ff       	call   801031f0 <picenable>
}
8010554b:	c9                   	leave  
8010554c:	c3                   	ret    

8010554d <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
8010554d:	1e                   	push   %ds
  pushl %es
8010554e:	06                   	push   %es
  pushl %fs
8010554f:	0f a0                	push   %fs
  pushl %gs
80105551:	0f a8                	push   %gs
  pushal
80105553:	60                   	pusha  
  
  # Set up data and per-cpu segments.
  movw $(SEG_KDATA<<3), %ax
80105554:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105558:	8e d8                	mov    %eax,%ds
  movw %ax, %es
8010555a:	8e c0                	mov    %eax,%es
  movw $(SEG_KCPU<<3), %ax
8010555c:	66 b8 18 00          	mov    $0x18,%ax
  movw %ax, %fs
80105560:	8e e0                	mov    %eax,%fs
  movw %ax, %gs
80105562:	8e e8                	mov    %eax,%gs

  # Call trap(tf), where tf=%esp
  pushl %esp
80105564:	54                   	push   %esp
  call trap
80105565:	e8 e6 00 00 00       	call   80105650 <trap>
  addl $4, %esp
8010556a:	83 c4 04             	add    $0x4,%esp

8010556d <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
8010556d:	61                   	popa   
  popl %gs
8010556e:	0f a9                	pop    %gs
  popl %fs
80105570:	0f a1                	pop    %fs
  popl %es
80105572:	07                   	pop    %es
  popl %ds
80105573:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105574:	83 c4 08             	add    $0x8,%esp
  iret
80105577:	cf                   	iret   
80105578:	66 90                	xchg   %ax,%ax
8010557a:	66 90                	xchg   %ax,%ax
8010557c:	66 90                	xchg   %ax,%ax
8010557e:	66 90                	xchg   %ax,%ax

80105580 <tvinit>:
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80105580:	31 c0                	xor    %eax,%eax
80105582:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105588:	8b 14 85 0c a0 10 80 	mov    -0x7fef5ff4(,%eax,4),%edx
8010558f:	b9 08 00 00 00       	mov    $0x8,%ecx
80105594:	66 89 0c c5 22 64 11 	mov    %cx,-0x7fee9bde(,%eax,8)
8010559b:	80 
8010559c:	c6 04 c5 24 64 11 80 	movb   $0x0,-0x7fee9bdc(,%eax,8)
801055a3:	00 
801055a4:	c6 04 c5 25 64 11 80 	movb   $0x8e,-0x7fee9bdb(,%eax,8)
801055ab:	8e 
801055ac:	66 89 14 c5 20 64 11 	mov    %dx,-0x7fee9be0(,%eax,8)
801055b3:	80 
801055b4:	c1 ea 10             	shr    $0x10,%edx
801055b7:	66 89 14 c5 26 64 11 	mov    %dx,-0x7fee9bda(,%eax,8)
801055be:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
801055bf:	83 c0 01             	add    $0x1,%eax
801055c2:	3d 00 01 00 00       	cmp    $0x100,%eax
801055c7:	75 bf                	jne    80105588 <tvinit+0x8>
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
801055c9:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801055ca:	ba 08 00 00 00       	mov    $0x8,%edx
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
801055cf:	89 e5                	mov    %esp,%ebp
801055d1:	83 ec 18             	sub    $0x18,%esp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801055d4:	a1 0c a1 10 80       	mov    0x8010a10c,%eax

  initlock(&tickslock, "time");
801055d9:	c7 44 24 04 38 75 10 	movl   $0x80107538,0x4(%esp)
801055e0:	80 
801055e1:	c7 04 24 e0 63 11 80 	movl   $0x801163e0,(%esp)
{
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801055e8:	66 89 15 22 66 11 80 	mov    %dx,0x80116622
801055ef:	66 a3 20 66 11 80    	mov    %ax,0x80116620
801055f5:	c1 e8 10             	shr    $0x10,%eax
801055f8:	c6 05 24 66 11 80 00 	movb   $0x0,0x80116624
801055ff:	c6 05 25 66 11 80 ef 	movb   $0xef,0x80116625
80105606:	66 a3 26 66 11 80    	mov    %ax,0x80116626

  initlock(&tickslock, "time");
8010560c:	e8 8f eb ff ff       	call   801041a0 <initlock>
}
80105611:	c9                   	leave  
80105612:	c3                   	ret    
80105613:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105619:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105620 <idtinit>:

void
idtinit(void)
{
80105620:	55                   	push   %ebp
static inline void
lidt(struct gatedesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
80105621:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105626:	89 e5                	mov    %esp,%ebp
80105628:	83 ec 10             	sub    $0x10,%esp
8010562b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010562f:	b8 20 64 11 80       	mov    $0x80116420,%eax
80105634:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105638:	c1 e8 10             	shr    $0x10,%eax
8010563b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
8010563f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105642:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105645:	c9                   	leave  
80105646:	c3                   	ret    
80105647:	89 f6                	mov    %esi,%esi
80105649:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105650 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105650:	55                   	push   %ebp
80105651:	89 e5                	mov    %esp,%ebp
80105653:	57                   	push   %edi
80105654:	56                   	push   %esi
80105655:	53                   	push   %ebx
80105656:	83 ec 2c             	sub    $0x2c,%esp
80105659:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
8010565c:	8b 43 30             	mov    0x30(%ebx),%eax
8010565f:	83 f8 40             	cmp    $0x40,%eax
80105662:	0f 84 00 01 00 00    	je     80105768 <trap+0x118>
    if(proc->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105668:	83 e8 20             	sub    $0x20,%eax
8010566b:	83 f8 1f             	cmp    $0x1f,%eax
8010566e:	77 60                	ja     801056d0 <trap+0x80>
80105670:	ff 24 85 e0 75 10 80 	jmp    *-0x7fef8a20(,%eax,4)
80105677:	90                   	nop
  case T_IRQ0 + IRQ_TIMER:
    if(cpunum() == 0){
80105678:	e8 d3 d0 ff ff       	call   80102750 <cpunum>
8010567d:	85 c0                	test   %eax,%eax
8010567f:	90                   	nop
80105680:	0f 84 d2 01 00 00    	je     80105858 <trap+0x208>
      acquire(&tickslock);
      ticks++;
      wakeup(&ticks);
      release(&tickslock);
    }
    lapiceoi();
80105686:	e8 65 d1 ff ff       	call   801027f0 <lapiceoi>
8010568b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80105691:	85 c0                	test   %eax,%eax
80105693:	74 2d                	je     801056c2 <trap+0x72>
80105695:	8b 50 24             	mov    0x24(%eax),%edx
80105698:	85 d2                	test   %edx,%edx
8010569a:	0f 85 9c 00 00 00    	jne    8010573c <trap+0xec>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
801056a0:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
801056a4:	0f 84 86 01 00 00    	je     80105830 <trap+0x1e0>
    yield();

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
801056aa:	8b 40 24             	mov    0x24(%eax),%eax
801056ad:	85 c0                	test   %eax,%eax
801056af:	74 11                	je     801056c2 <trap+0x72>
801056b1:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
801056b5:	83 e0 03             	and    $0x3,%eax
801056b8:	66 83 f8 03          	cmp    $0x3,%ax
801056bc:	0f 84 d0 00 00 00    	je     80105792 <trap+0x142>
    exit();
}
801056c2:	83 c4 2c             	add    $0x2c,%esp
801056c5:	5b                   	pop    %ebx
801056c6:	5e                   	pop    %esi
801056c7:	5f                   	pop    %edi
801056c8:	5d                   	pop    %ebp
801056c9:	c3                   	ret    
801056ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
801056d0:	65 8b 0d 04 00 00 00 	mov    %gs:0x4,%ecx
801056d7:	85 c9                	test   %ecx,%ecx
801056d9:	0f 84 a9 01 00 00    	je     80105888 <trap+0x238>
801056df:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
801056e3:	0f 84 9f 01 00 00    	je     80105888 <trap+0x238>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801056e9:	0f 20 d7             	mov    %cr2,%edi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpunum(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801056ec:	8b 73 38             	mov    0x38(%ebx),%esi
801056ef:	e8 5c d0 ff ff       	call   80102750 <cpunum>
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpunum(), tf->eip,
801056f4:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpunum(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801056fb:	89 7c 24 1c          	mov    %edi,0x1c(%esp)
801056ff:	89 74 24 18          	mov    %esi,0x18(%esp)
80105703:	89 44 24 14          	mov    %eax,0x14(%esp)
80105707:	8b 43 34             	mov    0x34(%ebx),%eax
8010570a:	89 44 24 10          	mov    %eax,0x10(%esp)
8010570e:	8b 43 30             	mov    0x30(%ebx),%eax
80105711:	89 44 24 0c          	mov    %eax,0xc(%esp)
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpunum(), tf->eip,
80105715:	8d 42 6c             	lea    0x6c(%edx),%eax
80105718:	89 44 24 08          	mov    %eax,0x8(%esp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpunum(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010571c:	8b 42 10             	mov    0x10(%edx),%eax
8010571f:	c7 04 24 9c 75 10 80 	movl   $0x8010759c,(%esp)
80105726:	89 44 24 04          	mov    %eax,0x4(%esp)
8010572a:	e8 21 af ff ff       	call   80100650 <cprintf>
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpunum(), tf->eip,
            rcr2());
    proc->killed = 1;
8010572f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105735:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
8010573c:	0f b7 53 3c          	movzwl 0x3c(%ebx),%edx
80105740:	83 e2 03             	and    $0x3,%edx
80105743:	66 83 fa 03          	cmp    $0x3,%dx
80105747:	0f 85 53 ff ff ff    	jne    801056a0 <trap+0x50>
    exit();
8010574d:	e8 2e e4 ff ff       	call   80103b80 <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
80105752:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105758:	85 c0                	test   %eax,%eax
8010575a:	0f 85 40 ff ff ff    	jne    801056a0 <trap+0x50>
80105760:	e9 5d ff ff ff       	jmp    801056c2 <trap+0x72>
80105765:	8d 76 00             	lea    0x0(%esi),%esi
//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(proc->killed)
80105768:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010576e:	8b 70 24             	mov    0x24(%eax),%esi
80105771:	85 f6                	test   %esi,%esi
80105773:	0f 85 a7 00 00 00    	jne    80105820 <trap+0x1d0>
      exit();
    proc->tf = tf;
80105779:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
8010577c:	e8 ff ef ff ff       	call   80104780 <syscall>
    if(proc->killed)
80105781:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105787:	8b 58 24             	mov    0x24(%eax),%ebx
8010578a:	85 db                	test   %ebx,%ebx
8010578c:	0f 84 30 ff ff ff    	je     801056c2 <trap+0x72>
    yield();

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();
}
80105792:	83 c4 2c             	add    $0x2c,%esp
80105795:	5b                   	pop    %ebx
80105796:	5e                   	pop    %esi
80105797:	5f                   	pop    %edi
80105798:	5d                   	pop    %ebp
    if(proc->killed)
      exit();
    proc->tf = tf;
    syscall();
    if(proc->killed)
      exit();
80105799:	e9 e2 e3 ff ff       	jmp    80103b80 <exit>
8010579e:	66 90                	xchg   %ax,%ax
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
801057a0:	e8 1b ce ff ff       	call   801025c0 <kbdintr>
    lapiceoi();
801057a5:	e8 46 d0 ff ff       	call   801027f0 <lapiceoi>
801057aa:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
    break;
801057b0:	e9 dc fe ff ff       	jmp    80105691 <trap+0x41>
801057b5:	8d 76 00             	lea    0x0(%esi),%esi
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
801057b8:	e8 b3 c8 ff ff       	call   80102070 <ideintr>
    lapiceoi();
801057bd:	e8 2e d0 ff ff       	call   801027f0 <lapiceoi>
801057c2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
    break;
801057c8:	e9 c4 fe ff ff       	jmp    80105691 <trap+0x41>
801057cd:	8d 76 00             	lea    0x0(%esi),%esi
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_COM1:
    uartintr();
801057d0:	e8 1b 02 00 00       	call   801059f0 <uartintr>
    lapiceoi();
801057d5:	e8 16 d0 ff ff       	call   801027f0 <lapiceoi>
801057da:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
    break;
801057e0:	e9 ac fe ff ff       	jmp    80105691 <trap+0x41>
801057e5:	8d 76 00             	lea    0x0(%esi),%esi
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801057e8:	8b 7b 38             	mov    0x38(%ebx),%edi
801057eb:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
801057ef:	e8 5c cf ff ff       	call   80102750 <cpunum>
801057f4:	c7 04 24 44 75 10 80 	movl   $0x80107544,(%esp)
801057fb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
801057ff:	89 74 24 08          	mov    %esi,0x8(%esp)
80105803:	89 44 24 04          	mov    %eax,0x4(%esp)
80105807:	e8 44 ae ff ff       	call   80100650 <cprintf>
            cpunum(), tf->cs, tf->eip);
    lapiceoi();
8010580c:	e8 df cf ff ff       	call   801027f0 <lapiceoi>
80105811:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
    break;
80105817:	e9 75 fe ff ff       	jmp    80105691 <trap+0x41>
8010581c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(proc->killed)
      exit();
80105820:	e8 5b e3 ff ff       	call   80103b80 <exit>
80105825:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010582b:	e9 49 ff ff ff       	jmp    80105779 <trap+0x129>
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
80105830:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105834:	0f 85 70 fe ff ff    	jne    801056aa <trap+0x5a>
    yield();
8010583a:	e8 81 e4 ff ff       	call   80103cc0 <yield>

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
8010583f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105845:	85 c0                	test   %eax,%eax
80105847:	0f 85 5d fe ff ff    	jne    801056aa <trap+0x5a>
8010584d:	e9 70 fe ff ff       	jmp    801056c2 <trap+0x72>
80105852:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpunum() == 0){
      acquire(&tickslock);
80105858:	c7 04 24 e0 63 11 80 	movl   $0x801163e0,(%esp)
8010585f:	e8 bc e9 ff ff       	call   80104220 <acquire>
      ticks++;
      wakeup(&ticks);
80105864:	c7 04 24 20 6c 11 80 	movl   $0x80116c20,(%esp)

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpunum() == 0){
      acquire(&tickslock);
      ticks++;
8010586b:	83 05 20 6c 11 80 01 	addl   $0x1,0x80116c20
      wakeup(&ticks);
80105872:	e8 39 e6 ff ff       	call   80103eb0 <wakeup>
      release(&tickslock);
80105877:	c7 04 24 e0 63 11 80 	movl   $0x801163e0,(%esp)
8010587e:	e8 cd ea ff ff       	call   80104350 <release>
80105883:	e9 fe fd ff ff       	jmp    80105686 <trap+0x36>
80105888:	0f 20 d7             	mov    %cr2,%edi

  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
8010588b:	8b 73 38             	mov    0x38(%ebx),%esi
8010588e:	e8 bd ce ff ff       	call   80102750 <cpunum>
80105893:	89 7c 24 10          	mov    %edi,0x10(%esp)
80105897:	89 74 24 0c          	mov    %esi,0xc(%esp)
8010589b:	89 44 24 08          	mov    %eax,0x8(%esp)
8010589f:	8b 43 30             	mov    0x30(%ebx),%eax
801058a2:	c7 04 24 68 75 10 80 	movl   $0x80107568,(%esp)
801058a9:	89 44 24 04          	mov    %eax,0x4(%esp)
801058ad:	e8 9e ad ff ff       	call   80100650 <cprintf>
              tf->trapno, cpunum(), tf->eip, rcr2());
      panic("trap");
801058b2:	c7 04 24 3d 75 10 80 	movl   $0x8010753d,(%esp)
801058b9:	e8 a2 aa ff ff       	call   80100360 <panic>
801058be:	66 90                	xchg   %ax,%ax

801058c0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
801058c0:	a1 c0 a5 10 80       	mov    0x8010a5c0,%eax
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
801058c5:	55                   	push   %ebp
801058c6:	89 e5                	mov    %esp,%ebp
  if(!uart)
801058c8:	85 c0                	test   %eax,%eax
801058ca:	74 14                	je     801058e0 <uartgetc+0x20>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801058cc:	ba fd 03 00 00       	mov    $0x3fd,%edx
801058d1:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
801058d2:	a8 01                	test   $0x1,%al
801058d4:	74 0a                	je     801058e0 <uartgetc+0x20>
801058d6:	b2 f8                	mov    $0xf8,%dl
801058d8:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
801058d9:	0f b6 c0             	movzbl %al,%eax
}
801058dc:	5d                   	pop    %ebp
801058dd:	c3                   	ret    
801058de:	66 90                	xchg   %ax,%ax

static int
uartgetc(void)
{
  if(!uart)
    return -1;
801058e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(!(inb(COM1+5) & 0x01))
    return -1;
  return inb(COM1+0);
}
801058e5:	5d                   	pop    %ebp
801058e6:	c3                   	ret    
801058e7:	89 f6                	mov    %esi,%esi
801058e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801058f0 <uartputc>:
void
uartputc(int c)
{
  int i;

  if(!uart)
801058f0:	a1 c0 a5 10 80       	mov    0x8010a5c0,%eax
801058f5:	85 c0                	test   %eax,%eax
801058f7:	74 3f                	je     80105938 <uartputc+0x48>
    uartputc(*p);
}

void
uartputc(int c)
{
801058f9:	55                   	push   %ebp
801058fa:	89 e5                	mov    %esp,%ebp
801058fc:	56                   	push   %esi
801058fd:	be fd 03 00 00       	mov    $0x3fd,%esi
80105902:	53                   	push   %ebx
  int i;

  if(!uart)
80105903:	bb 80 00 00 00       	mov    $0x80,%ebx
    uartputc(*p);
}

void
uartputc(int c)
{
80105908:	83 ec 10             	sub    $0x10,%esp
8010590b:	eb 14                	jmp    80105921 <uartputc+0x31>
8010590d:	8d 76 00             	lea    0x0(%esi),%esi
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
80105910:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
80105917:	e8 f4 ce ff ff       	call   80102810 <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010591c:	83 eb 01             	sub    $0x1,%ebx
8010591f:	74 07                	je     80105928 <uartputc+0x38>
80105921:	89 f2                	mov    %esi,%edx
80105923:	ec                   	in     (%dx),%al
80105924:	a8 20                	test   $0x20,%al
80105926:	74 e8                	je     80105910 <uartputc+0x20>
    microdelay(10);
  outb(COM1+0, c);
80105928:	0f b6 45 08          	movzbl 0x8(%ebp),%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010592c:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105931:	ee                   	out    %al,(%dx)
}
80105932:	83 c4 10             	add    $0x10,%esp
80105935:	5b                   	pop    %ebx
80105936:	5e                   	pop    %esi
80105937:	5d                   	pop    %ebp
80105938:	f3 c3                	repz ret 
8010593a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105940 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80105940:	55                   	push   %ebp
80105941:	31 c9                	xor    %ecx,%ecx
80105943:	89 e5                	mov    %esp,%ebp
80105945:	89 c8                	mov    %ecx,%eax
80105947:	57                   	push   %edi
80105948:	bf fa 03 00 00       	mov    $0x3fa,%edi
8010594d:	56                   	push   %esi
8010594e:	89 fa                	mov    %edi,%edx
80105950:	53                   	push   %ebx
80105951:	83 ec 1c             	sub    $0x1c,%esp
80105954:	ee                   	out    %al,(%dx)
80105955:	be fb 03 00 00       	mov    $0x3fb,%esi
8010595a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010595f:	89 f2                	mov    %esi,%edx
80105961:	ee                   	out    %al,(%dx)
80105962:	b8 0c 00 00 00       	mov    $0xc,%eax
80105967:	b2 f8                	mov    $0xf8,%dl
80105969:	ee                   	out    %al,(%dx)
8010596a:	bb f9 03 00 00       	mov    $0x3f9,%ebx
8010596f:	89 c8                	mov    %ecx,%eax
80105971:	89 da                	mov    %ebx,%edx
80105973:	ee                   	out    %al,(%dx)
80105974:	b8 03 00 00 00       	mov    $0x3,%eax
80105979:	89 f2                	mov    %esi,%edx
8010597b:	ee                   	out    %al,(%dx)
8010597c:	b2 fc                	mov    $0xfc,%dl
8010597e:	89 c8                	mov    %ecx,%eax
80105980:	ee                   	out    %al,(%dx)
80105981:	b8 01 00 00 00       	mov    $0x1,%eax
80105986:	89 da                	mov    %ebx,%edx
80105988:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105989:	b2 fd                	mov    $0xfd,%dl
8010598b:	ec                   	in     (%dx),%al
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
8010598c:	3c ff                	cmp    $0xff,%al
8010598e:	74 52                	je     801059e2 <uartinit+0xa2>
    return;
  uart = 1;
80105990:	c7 05 c0 a5 10 80 01 	movl   $0x1,0x8010a5c0
80105997:	00 00 00 
8010599a:	89 fa                	mov    %edi,%edx
8010599c:	ec                   	in     (%dx),%al
8010599d:	b2 f8                	mov    $0xf8,%dl
8010599f:	ec                   	in     (%dx),%al

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
  inb(COM1+0);
  picenable(IRQ_COM1);
801059a0:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
801059a7:	bb 60 76 10 80       	mov    $0x80107660,%ebx

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
  inb(COM1+0);
  picenable(IRQ_COM1);
801059ac:	e8 3f d8 ff ff       	call   801031f0 <picenable>
  ioapicenable(IRQ_COM1, 0);
801059b1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801059b8:	00 
801059b9:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
801059c0:	e8 db c8 ff ff       	call   801022a0 <ioapicenable>

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
801059c5:	b8 78 00 00 00       	mov    $0x78,%eax
801059ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    uartputc(*p);
801059d0:	89 04 24             	mov    %eax,(%esp)
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
801059d3:	83 c3 01             	add    $0x1,%ebx
    uartputc(*p);
801059d6:	e8 15 ff ff ff       	call   801058f0 <uartputc>
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
801059db:	0f be 03             	movsbl (%ebx),%eax
801059de:	84 c0                	test   %al,%al
801059e0:	75 ee                	jne    801059d0 <uartinit+0x90>
    uartputc(*p);
}
801059e2:	83 c4 1c             	add    $0x1c,%esp
801059e5:	5b                   	pop    %ebx
801059e6:	5e                   	pop    %esi
801059e7:	5f                   	pop    %edi
801059e8:	5d                   	pop    %ebp
801059e9:	c3                   	ret    
801059ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801059f0 <uartintr>:
  return inb(COM1+0);
}

void
uartintr(void)
{
801059f0:	55                   	push   %ebp
801059f1:	89 e5                	mov    %esp,%ebp
801059f3:	83 ec 18             	sub    $0x18,%esp
  consoleintr(uartgetc);
801059f6:	c7 04 24 c0 58 10 80 	movl   $0x801058c0,(%esp)
801059fd:	e8 ae ad ff ff       	call   801007b0 <consoleintr>
}
80105a02:	c9                   	leave  
80105a03:	c3                   	ret    

80105a04 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105a04:	6a 00                	push   $0x0
  pushl $0
80105a06:	6a 00                	push   $0x0
  jmp alltraps
80105a08:	e9 40 fb ff ff       	jmp    8010554d <alltraps>

80105a0d <vector1>:
.globl vector1
vector1:
  pushl $0
80105a0d:	6a 00                	push   $0x0
  pushl $1
80105a0f:	6a 01                	push   $0x1
  jmp alltraps
80105a11:	e9 37 fb ff ff       	jmp    8010554d <alltraps>

80105a16 <vector2>:
.globl vector2
vector2:
  pushl $0
80105a16:	6a 00                	push   $0x0
  pushl $2
80105a18:	6a 02                	push   $0x2
  jmp alltraps
80105a1a:	e9 2e fb ff ff       	jmp    8010554d <alltraps>

80105a1f <vector3>:
.globl vector3
vector3:
  pushl $0
80105a1f:	6a 00                	push   $0x0
  pushl $3
80105a21:	6a 03                	push   $0x3
  jmp alltraps
80105a23:	e9 25 fb ff ff       	jmp    8010554d <alltraps>

80105a28 <vector4>:
.globl vector4
vector4:
  pushl $0
80105a28:	6a 00                	push   $0x0
  pushl $4
80105a2a:	6a 04                	push   $0x4
  jmp alltraps
80105a2c:	e9 1c fb ff ff       	jmp    8010554d <alltraps>

80105a31 <vector5>:
.globl vector5
vector5:
  pushl $0
80105a31:	6a 00                	push   $0x0
  pushl $5
80105a33:	6a 05                	push   $0x5
  jmp alltraps
80105a35:	e9 13 fb ff ff       	jmp    8010554d <alltraps>

80105a3a <vector6>:
.globl vector6
vector6:
  pushl $0
80105a3a:	6a 00                	push   $0x0
  pushl $6
80105a3c:	6a 06                	push   $0x6
  jmp alltraps
80105a3e:	e9 0a fb ff ff       	jmp    8010554d <alltraps>

80105a43 <vector7>:
.globl vector7
vector7:
  pushl $0
80105a43:	6a 00                	push   $0x0
  pushl $7
80105a45:	6a 07                	push   $0x7
  jmp alltraps
80105a47:	e9 01 fb ff ff       	jmp    8010554d <alltraps>

80105a4c <vector8>:
.globl vector8
vector8:
  pushl $8
80105a4c:	6a 08                	push   $0x8
  jmp alltraps
80105a4e:	e9 fa fa ff ff       	jmp    8010554d <alltraps>

80105a53 <vector9>:
.globl vector9
vector9:
  pushl $0
80105a53:	6a 00                	push   $0x0
  pushl $9
80105a55:	6a 09                	push   $0x9
  jmp alltraps
80105a57:	e9 f1 fa ff ff       	jmp    8010554d <alltraps>

80105a5c <vector10>:
.globl vector10
vector10:
  pushl $10
80105a5c:	6a 0a                	push   $0xa
  jmp alltraps
80105a5e:	e9 ea fa ff ff       	jmp    8010554d <alltraps>

80105a63 <vector11>:
.globl vector11
vector11:
  pushl $11
80105a63:	6a 0b                	push   $0xb
  jmp alltraps
80105a65:	e9 e3 fa ff ff       	jmp    8010554d <alltraps>

80105a6a <vector12>:
.globl vector12
vector12:
  pushl $12
80105a6a:	6a 0c                	push   $0xc
  jmp alltraps
80105a6c:	e9 dc fa ff ff       	jmp    8010554d <alltraps>

80105a71 <vector13>:
.globl vector13
vector13:
  pushl $13
80105a71:	6a 0d                	push   $0xd
  jmp alltraps
80105a73:	e9 d5 fa ff ff       	jmp    8010554d <alltraps>

80105a78 <vector14>:
.globl vector14
vector14:
  pushl $14
80105a78:	6a 0e                	push   $0xe
  jmp alltraps
80105a7a:	e9 ce fa ff ff       	jmp    8010554d <alltraps>

80105a7f <vector15>:
.globl vector15
vector15:
  pushl $0
80105a7f:	6a 00                	push   $0x0
  pushl $15
80105a81:	6a 0f                	push   $0xf
  jmp alltraps
80105a83:	e9 c5 fa ff ff       	jmp    8010554d <alltraps>

80105a88 <vector16>:
.globl vector16
vector16:
  pushl $0
80105a88:	6a 00                	push   $0x0
  pushl $16
80105a8a:	6a 10                	push   $0x10
  jmp alltraps
80105a8c:	e9 bc fa ff ff       	jmp    8010554d <alltraps>

80105a91 <vector17>:
.globl vector17
vector17:
  pushl $17
80105a91:	6a 11                	push   $0x11
  jmp alltraps
80105a93:	e9 b5 fa ff ff       	jmp    8010554d <alltraps>

80105a98 <vector18>:
.globl vector18
vector18:
  pushl $0
80105a98:	6a 00                	push   $0x0
  pushl $18
80105a9a:	6a 12                	push   $0x12
  jmp alltraps
80105a9c:	e9 ac fa ff ff       	jmp    8010554d <alltraps>

80105aa1 <vector19>:
.globl vector19
vector19:
  pushl $0
80105aa1:	6a 00                	push   $0x0
  pushl $19
80105aa3:	6a 13                	push   $0x13
  jmp alltraps
80105aa5:	e9 a3 fa ff ff       	jmp    8010554d <alltraps>

80105aaa <vector20>:
.globl vector20
vector20:
  pushl $0
80105aaa:	6a 00                	push   $0x0
  pushl $20
80105aac:	6a 14                	push   $0x14
  jmp alltraps
80105aae:	e9 9a fa ff ff       	jmp    8010554d <alltraps>

80105ab3 <vector21>:
.globl vector21
vector21:
  pushl $0
80105ab3:	6a 00                	push   $0x0
  pushl $21
80105ab5:	6a 15                	push   $0x15
  jmp alltraps
80105ab7:	e9 91 fa ff ff       	jmp    8010554d <alltraps>

80105abc <vector22>:
.globl vector22
vector22:
  pushl $0
80105abc:	6a 00                	push   $0x0
  pushl $22
80105abe:	6a 16                	push   $0x16
  jmp alltraps
80105ac0:	e9 88 fa ff ff       	jmp    8010554d <alltraps>

80105ac5 <vector23>:
.globl vector23
vector23:
  pushl $0
80105ac5:	6a 00                	push   $0x0
  pushl $23
80105ac7:	6a 17                	push   $0x17
  jmp alltraps
80105ac9:	e9 7f fa ff ff       	jmp    8010554d <alltraps>

80105ace <vector24>:
.globl vector24
vector24:
  pushl $0
80105ace:	6a 00                	push   $0x0
  pushl $24
80105ad0:	6a 18                	push   $0x18
  jmp alltraps
80105ad2:	e9 76 fa ff ff       	jmp    8010554d <alltraps>

80105ad7 <vector25>:
.globl vector25
vector25:
  pushl $0
80105ad7:	6a 00                	push   $0x0
  pushl $25
80105ad9:	6a 19                	push   $0x19
  jmp alltraps
80105adb:	e9 6d fa ff ff       	jmp    8010554d <alltraps>

80105ae0 <vector26>:
.globl vector26
vector26:
  pushl $0
80105ae0:	6a 00                	push   $0x0
  pushl $26
80105ae2:	6a 1a                	push   $0x1a
  jmp alltraps
80105ae4:	e9 64 fa ff ff       	jmp    8010554d <alltraps>

80105ae9 <vector27>:
.globl vector27
vector27:
  pushl $0
80105ae9:	6a 00                	push   $0x0
  pushl $27
80105aeb:	6a 1b                	push   $0x1b
  jmp alltraps
80105aed:	e9 5b fa ff ff       	jmp    8010554d <alltraps>

80105af2 <vector28>:
.globl vector28
vector28:
  pushl $0
80105af2:	6a 00                	push   $0x0
  pushl $28
80105af4:	6a 1c                	push   $0x1c
  jmp alltraps
80105af6:	e9 52 fa ff ff       	jmp    8010554d <alltraps>

80105afb <vector29>:
.globl vector29
vector29:
  pushl $0
80105afb:	6a 00                	push   $0x0
  pushl $29
80105afd:	6a 1d                	push   $0x1d
  jmp alltraps
80105aff:	e9 49 fa ff ff       	jmp    8010554d <alltraps>

80105b04 <vector30>:
.globl vector30
vector30:
  pushl $0
80105b04:	6a 00                	push   $0x0
  pushl $30
80105b06:	6a 1e                	push   $0x1e
  jmp alltraps
80105b08:	e9 40 fa ff ff       	jmp    8010554d <alltraps>

80105b0d <vector31>:
.globl vector31
vector31:
  pushl $0
80105b0d:	6a 00                	push   $0x0
  pushl $31
80105b0f:	6a 1f                	push   $0x1f
  jmp alltraps
80105b11:	e9 37 fa ff ff       	jmp    8010554d <alltraps>

80105b16 <vector32>:
.globl vector32
vector32:
  pushl $0
80105b16:	6a 00                	push   $0x0
  pushl $32
80105b18:	6a 20                	push   $0x20
  jmp alltraps
80105b1a:	e9 2e fa ff ff       	jmp    8010554d <alltraps>

80105b1f <vector33>:
.globl vector33
vector33:
  pushl $0
80105b1f:	6a 00                	push   $0x0
  pushl $33
80105b21:	6a 21                	push   $0x21
  jmp alltraps
80105b23:	e9 25 fa ff ff       	jmp    8010554d <alltraps>

80105b28 <vector34>:
.globl vector34
vector34:
  pushl $0
80105b28:	6a 00                	push   $0x0
  pushl $34
80105b2a:	6a 22                	push   $0x22
  jmp alltraps
80105b2c:	e9 1c fa ff ff       	jmp    8010554d <alltraps>

80105b31 <vector35>:
.globl vector35
vector35:
  pushl $0
80105b31:	6a 00                	push   $0x0
  pushl $35
80105b33:	6a 23                	push   $0x23
  jmp alltraps
80105b35:	e9 13 fa ff ff       	jmp    8010554d <alltraps>

80105b3a <vector36>:
.globl vector36
vector36:
  pushl $0
80105b3a:	6a 00                	push   $0x0
  pushl $36
80105b3c:	6a 24                	push   $0x24
  jmp alltraps
80105b3e:	e9 0a fa ff ff       	jmp    8010554d <alltraps>

80105b43 <vector37>:
.globl vector37
vector37:
  pushl $0
80105b43:	6a 00                	push   $0x0
  pushl $37
80105b45:	6a 25                	push   $0x25
  jmp alltraps
80105b47:	e9 01 fa ff ff       	jmp    8010554d <alltraps>

80105b4c <vector38>:
.globl vector38
vector38:
  pushl $0
80105b4c:	6a 00                	push   $0x0
  pushl $38
80105b4e:	6a 26                	push   $0x26
  jmp alltraps
80105b50:	e9 f8 f9 ff ff       	jmp    8010554d <alltraps>

80105b55 <vector39>:
.globl vector39
vector39:
  pushl $0
80105b55:	6a 00                	push   $0x0
  pushl $39
80105b57:	6a 27                	push   $0x27
  jmp alltraps
80105b59:	e9 ef f9 ff ff       	jmp    8010554d <alltraps>

80105b5e <vector40>:
.globl vector40
vector40:
  pushl $0
80105b5e:	6a 00                	push   $0x0
  pushl $40
80105b60:	6a 28                	push   $0x28
  jmp alltraps
80105b62:	e9 e6 f9 ff ff       	jmp    8010554d <alltraps>

80105b67 <vector41>:
.globl vector41
vector41:
  pushl $0
80105b67:	6a 00                	push   $0x0
  pushl $41
80105b69:	6a 29                	push   $0x29
  jmp alltraps
80105b6b:	e9 dd f9 ff ff       	jmp    8010554d <alltraps>

80105b70 <vector42>:
.globl vector42
vector42:
  pushl $0
80105b70:	6a 00                	push   $0x0
  pushl $42
80105b72:	6a 2a                	push   $0x2a
  jmp alltraps
80105b74:	e9 d4 f9 ff ff       	jmp    8010554d <alltraps>

80105b79 <vector43>:
.globl vector43
vector43:
  pushl $0
80105b79:	6a 00                	push   $0x0
  pushl $43
80105b7b:	6a 2b                	push   $0x2b
  jmp alltraps
80105b7d:	e9 cb f9 ff ff       	jmp    8010554d <alltraps>

80105b82 <vector44>:
.globl vector44
vector44:
  pushl $0
80105b82:	6a 00                	push   $0x0
  pushl $44
80105b84:	6a 2c                	push   $0x2c
  jmp alltraps
80105b86:	e9 c2 f9 ff ff       	jmp    8010554d <alltraps>

80105b8b <vector45>:
.globl vector45
vector45:
  pushl $0
80105b8b:	6a 00                	push   $0x0
  pushl $45
80105b8d:	6a 2d                	push   $0x2d
  jmp alltraps
80105b8f:	e9 b9 f9 ff ff       	jmp    8010554d <alltraps>

80105b94 <vector46>:
.globl vector46
vector46:
  pushl $0
80105b94:	6a 00                	push   $0x0
  pushl $46
80105b96:	6a 2e                	push   $0x2e
  jmp alltraps
80105b98:	e9 b0 f9 ff ff       	jmp    8010554d <alltraps>

80105b9d <vector47>:
.globl vector47
vector47:
  pushl $0
80105b9d:	6a 00                	push   $0x0
  pushl $47
80105b9f:	6a 2f                	push   $0x2f
  jmp alltraps
80105ba1:	e9 a7 f9 ff ff       	jmp    8010554d <alltraps>

80105ba6 <vector48>:
.globl vector48
vector48:
  pushl $0
80105ba6:	6a 00                	push   $0x0
  pushl $48
80105ba8:	6a 30                	push   $0x30
  jmp alltraps
80105baa:	e9 9e f9 ff ff       	jmp    8010554d <alltraps>

80105baf <vector49>:
.globl vector49
vector49:
  pushl $0
80105baf:	6a 00                	push   $0x0
  pushl $49
80105bb1:	6a 31                	push   $0x31
  jmp alltraps
80105bb3:	e9 95 f9 ff ff       	jmp    8010554d <alltraps>

80105bb8 <vector50>:
.globl vector50
vector50:
  pushl $0
80105bb8:	6a 00                	push   $0x0
  pushl $50
80105bba:	6a 32                	push   $0x32
  jmp alltraps
80105bbc:	e9 8c f9 ff ff       	jmp    8010554d <alltraps>

80105bc1 <vector51>:
.globl vector51
vector51:
  pushl $0
80105bc1:	6a 00                	push   $0x0
  pushl $51
80105bc3:	6a 33                	push   $0x33
  jmp alltraps
80105bc5:	e9 83 f9 ff ff       	jmp    8010554d <alltraps>

80105bca <vector52>:
.globl vector52
vector52:
  pushl $0
80105bca:	6a 00                	push   $0x0
  pushl $52
80105bcc:	6a 34                	push   $0x34
  jmp alltraps
80105bce:	e9 7a f9 ff ff       	jmp    8010554d <alltraps>

80105bd3 <vector53>:
.globl vector53
vector53:
  pushl $0
80105bd3:	6a 00                	push   $0x0
  pushl $53
80105bd5:	6a 35                	push   $0x35
  jmp alltraps
80105bd7:	e9 71 f9 ff ff       	jmp    8010554d <alltraps>

80105bdc <vector54>:
.globl vector54
vector54:
  pushl $0
80105bdc:	6a 00                	push   $0x0
  pushl $54
80105bde:	6a 36                	push   $0x36
  jmp alltraps
80105be0:	e9 68 f9 ff ff       	jmp    8010554d <alltraps>

80105be5 <vector55>:
.globl vector55
vector55:
  pushl $0
80105be5:	6a 00                	push   $0x0
  pushl $55
80105be7:	6a 37                	push   $0x37
  jmp alltraps
80105be9:	e9 5f f9 ff ff       	jmp    8010554d <alltraps>

80105bee <vector56>:
.globl vector56
vector56:
  pushl $0
80105bee:	6a 00                	push   $0x0
  pushl $56
80105bf0:	6a 38                	push   $0x38
  jmp alltraps
80105bf2:	e9 56 f9 ff ff       	jmp    8010554d <alltraps>

80105bf7 <vector57>:
.globl vector57
vector57:
  pushl $0
80105bf7:	6a 00                	push   $0x0
  pushl $57
80105bf9:	6a 39                	push   $0x39
  jmp alltraps
80105bfb:	e9 4d f9 ff ff       	jmp    8010554d <alltraps>

80105c00 <vector58>:
.globl vector58
vector58:
  pushl $0
80105c00:	6a 00                	push   $0x0
  pushl $58
80105c02:	6a 3a                	push   $0x3a
  jmp alltraps
80105c04:	e9 44 f9 ff ff       	jmp    8010554d <alltraps>

80105c09 <vector59>:
.globl vector59
vector59:
  pushl $0
80105c09:	6a 00                	push   $0x0
  pushl $59
80105c0b:	6a 3b                	push   $0x3b
  jmp alltraps
80105c0d:	e9 3b f9 ff ff       	jmp    8010554d <alltraps>

80105c12 <vector60>:
.globl vector60
vector60:
  pushl $0
80105c12:	6a 00                	push   $0x0
  pushl $60
80105c14:	6a 3c                	push   $0x3c
  jmp alltraps
80105c16:	e9 32 f9 ff ff       	jmp    8010554d <alltraps>

80105c1b <vector61>:
.globl vector61
vector61:
  pushl $0
80105c1b:	6a 00                	push   $0x0
  pushl $61
80105c1d:	6a 3d                	push   $0x3d
  jmp alltraps
80105c1f:	e9 29 f9 ff ff       	jmp    8010554d <alltraps>

80105c24 <vector62>:
.globl vector62
vector62:
  pushl $0
80105c24:	6a 00                	push   $0x0
  pushl $62
80105c26:	6a 3e                	push   $0x3e
  jmp alltraps
80105c28:	e9 20 f9 ff ff       	jmp    8010554d <alltraps>

80105c2d <vector63>:
.globl vector63
vector63:
  pushl $0
80105c2d:	6a 00                	push   $0x0
  pushl $63
80105c2f:	6a 3f                	push   $0x3f
  jmp alltraps
80105c31:	e9 17 f9 ff ff       	jmp    8010554d <alltraps>

80105c36 <vector64>:
.globl vector64
vector64:
  pushl $0
80105c36:	6a 00                	push   $0x0
  pushl $64
80105c38:	6a 40                	push   $0x40
  jmp alltraps
80105c3a:	e9 0e f9 ff ff       	jmp    8010554d <alltraps>

80105c3f <vector65>:
.globl vector65
vector65:
  pushl $0
80105c3f:	6a 00                	push   $0x0
  pushl $65
80105c41:	6a 41                	push   $0x41
  jmp alltraps
80105c43:	e9 05 f9 ff ff       	jmp    8010554d <alltraps>

80105c48 <vector66>:
.globl vector66
vector66:
  pushl $0
80105c48:	6a 00                	push   $0x0
  pushl $66
80105c4a:	6a 42                	push   $0x42
  jmp alltraps
80105c4c:	e9 fc f8 ff ff       	jmp    8010554d <alltraps>

80105c51 <vector67>:
.globl vector67
vector67:
  pushl $0
80105c51:	6a 00                	push   $0x0
  pushl $67
80105c53:	6a 43                	push   $0x43
  jmp alltraps
80105c55:	e9 f3 f8 ff ff       	jmp    8010554d <alltraps>

80105c5a <vector68>:
.globl vector68
vector68:
  pushl $0
80105c5a:	6a 00                	push   $0x0
  pushl $68
80105c5c:	6a 44                	push   $0x44
  jmp alltraps
80105c5e:	e9 ea f8 ff ff       	jmp    8010554d <alltraps>

80105c63 <vector69>:
.globl vector69
vector69:
  pushl $0
80105c63:	6a 00                	push   $0x0
  pushl $69
80105c65:	6a 45                	push   $0x45
  jmp alltraps
80105c67:	e9 e1 f8 ff ff       	jmp    8010554d <alltraps>

80105c6c <vector70>:
.globl vector70
vector70:
  pushl $0
80105c6c:	6a 00                	push   $0x0
  pushl $70
80105c6e:	6a 46                	push   $0x46
  jmp alltraps
80105c70:	e9 d8 f8 ff ff       	jmp    8010554d <alltraps>

80105c75 <vector71>:
.globl vector71
vector71:
  pushl $0
80105c75:	6a 00                	push   $0x0
  pushl $71
80105c77:	6a 47                	push   $0x47
  jmp alltraps
80105c79:	e9 cf f8 ff ff       	jmp    8010554d <alltraps>

80105c7e <vector72>:
.globl vector72
vector72:
  pushl $0
80105c7e:	6a 00                	push   $0x0
  pushl $72
80105c80:	6a 48                	push   $0x48
  jmp alltraps
80105c82:	e9 c6 f8 ff ff       	jmp    8010554d <alltraps>

80105c87 <vector73>:
.globl vector73
vector73:
  pushl $0
80105c87:	6a 00                	push   $0x0
  pushl $73
80105c89:	6a 49                	push   $0x49
  jmp alltraps
80105c8b:	e9 bd f8 ff ff       	jmp    8010554d <alltraps>

80105c90 <vector74>:
.globl vector74
vector74:
  pushl $0
80105c90:	6a 00                	push   $0x0
  pushl $74
80105c92:	6a 4a                	push   $0x4a
  jmp alltraps
80105c94:	e9 b4 f8 ff ff       	jmp    8010554d <alltraps>

80105c99 <vector75>:
.globl vector75
vector75:
  pushl $0
80105c99:	6a 00                	push   $0x0
  pushl $75
80105c9b:	6a 4b                	push   $0x4b
  jmp alltraps
80105c9d:	e9 ab f8 ff ff       	jmp    8010554d <alltraps>

80105ca2 <vector76>:
.globl vector76
vector76:
  pushl $0
80105ca2:	6a 00                	push   $0x0
  pushl $76
80105ca4:	6a 4c                	push   $0x4c
  jmp alltraps
80105ca6:	e9 a2 f8 ff ff       	jmp    8010554d <alltraps>

80105cab <vector77>:
.globl vector77
vector77:
  pushl $0
80105cab:	6a 00                	push   $0x0
  pushl $77
80105cad:	6a 4d                	push   $0x4d
  jmp alltraps
80105caf:	e9 99 f8 ff ff       	jmp    8010554d <alltraps>

80105cb4 <vector78>:
.globl vector78
vector78:
  pushl $0
80105cb4:	6a 00                	push   $0x0
  pushl $78
80105cb6:	6a 4e                	push   $0x4e
  jmp alltraps
80105cb8:	e9 90 f8 ff ff       	jmp    8010554d <alltraps>

80105cbd <vector79>:
.globl vector79
vector79:
  pushl $0
80105cbd:	6a 00                	push   $0x0
  pushl $79
80105cbf:	6a 4f                	push   $0x4f
  jmp alltraps
80105cc1:	e9 87 f8 ff ff       	jmp    8010554d <alltraps>

80105cc6 <vector80>:
.globl vector80
vector80:
  pushl $0
80105cc6:	6a 00                	push   $0x0
  pushl $80
80105cc8:	6a 50                	push   $0x50
  jmp alltraps
80105cca:	e9 7e f8 ff ff       	jmp    8010554d <alltraps>

80105ccf <vector81>:
.globl vector81
vector81:
  pushl $0
80105ccf:	6a 00                	push   $0x0
  pushl $81
80105cd1:	6a 51                	push   $0x51
  jmp alltraps
80105cd3:	e9 75 f8 ff ff       	jmp    8010554d <alltraps>

80105cd8 <vector82>:
.globl vector82
vector82:
  pushl $0
80105cd8:	6a 00                	push   $0x0
  pushl $82
80105cda:	6a 52                	push   $0x52
  jmp alltraps
80105cdc:	e9 6c f8 ff ff       	jmp    8010554d <alltraps>

80105ce1 <vector83>:
.globl vector83
vector83:
  pushl $0
80105ce1:	6a 00                	push   $0x0
  pushl $83
80105ce3:	6a 53                	push   $0x53
  jmp alltraps
80105ce5:	e9 63 f8 ff ff       	jmp    8010554d <alltraps>

80105cea <vector84>:
.globl vector84
vector84:
  pushl $0
80105cea:	6a 00                	push   $0x0
  pushl $84
80105cec:	6a 54                	push   $0x54
  jmp alltraps
80105cee:	e9 5a f8 ff ff       	jmp    8010554d <alltraps>

80105cf3 <vector85>:
.globl vector85
vector85:
  pushl $0
80105cf3:	6a 00                	push   $0x0
  pushl $85
80105cf5:	6a 55                	push   $0x55
  jmp alltraps
80105cf7:	e9 51 f8 ff ff       	jmp    8010554d <alltraps>

80105cfc <vector86>:
.globl vector86
vector86:
  pushl $0
80105cfc:	6a 00                	push   $0x0
  pushl $86
80105cfe:	6a 56                	push   $0x56
  jmp alltraps
80105d00:	e9 48 f8 ff ff       	jmp    8010554d <alltraps>

80105d05 <vector87>:
.globl vector87
vector87:
  pushl $0
80105d05:	6a 00                	push   $0x0
  pushl $87
80105d07:	6a 57                	push   $0x57
  jmp alltraps
80105d09:	e9 3f f8 ff ff       	jmp    8010554d <alltraps>

80105d0e <vector88>:
.globl vector88
vector88:
  pushl $0
80105d0e:	6a 00                	push   $0x0
  pushl $88
80105d10:	6a 58                	push   $0x58
  jmp alltraps
80105d12:	e9 36 f8 ff ff       	jmp    8010554d <alltraps>

80105d17 <vector89>:
.globl vector89
vector89:
  pushl $0
80105d17:	6a 00                	push   $0x0
  pushl $89
80105d19:	6a 59                	push   $0x59
  jmp alltraps
80105d1b:	e9 2d f8 ff ff       	jmp    8010554d <alltraps>

80105d20 <vector90>:
.globl vector90
vector90:
  pushl $0
80105d20:	6a 00                	push   $0x0
  pushl $90
80105d22:	6a 5a                	push   $0x5a
  jmp alltraps
80105d24:	e9 24 f8 ff ff       	jmp    8010554d <alltraps>

80105d29 <vector91>:
.globl vector91
vector91:
  pushl $0
80105d29:	6a 00                	push   $0x0
  pushl $91
80105d2b:	6a 5b                	push   $0x5b
  jmp alltraps
80105d2d:	e9 1b f8 ff ff       	jmp    8010554d <alltraps>

80105d32 <vector92>:
.globl vector92
vector92:
  pushl $0
80105d32:	6a 00                	push   $0x0
  pushl $92
80105d34:	6a 5c                	push   $0x5c
  jmp alltraps
80105d36:	e9 12 f8 ff ff       	jmp    8010554d <alltraps>

80105d3b <vector93>:
.globl vector93
vector93:
  pushl $0
80105d3b:	6a 00                	push   $0x0
  pushl $93
80105d3d:	6a 5d                	push   $0x5d
  jmp alltraps
80105d3f:	e9 09 f8 ff ff       	jmp    8010554d <alltraps>

80105d44 <vector94>:
.globl vector94
vector94:
  pushl $0
80105d44:	6a 00                	push   $0x0
  pushl $94
80105d46:	6a 5e                	push   $0x5e
  jmp alltraps
80105d48:	e9 00 f8 ff ff       	jmp    8010554d <alltraps>

80105d4d <vector95>:
.globl vector95
vector95:
  pushl $0
80105d4d:	6a 00                	push   $0x0
  pushl $95
80105d4f:	6a 5f                	push   $0x5f
  jmp alltraps
80105d51:	e9 f7 f7 ff ff       	jmp    8010554d <alltraps>

80105d56 <vector96>:
.globl vector96
vector96:
  pushl $0
80105d56:	6a 00                	push   $0x0
  pushl $96
80105d58:	6a 60                	push   $0x60
  jmp alltraps
80105d5a:	e9 ee f7 ff ff       	jmp    8010554d <alltraps>

80105d5f <vector97>:
.globl vector97
vector97:
  pushl $0
80105d5f:	6a 00                	push   $0x0
  pushl $97
80105d61:	6a 61                	push   $0x61
  jmp alltraps
80105d63:	e9 e5 f7 ff ff       	jmp    8010554d <alltraps>

80105d68 <vector98>:
.globl vector98
vector98:
  pushl $0
80105d68:	6a 00                	push   $0x0
  pushl $98
80105d6a:	6a 62                	push   $0x62
  jmp alltraps
80105d6c:	e9 dc f7 ff ff       	jmp    8010554d <alltraps>

80105d71 <vector99>:
.globl vector99
vector99:
  pushl $0
80105d71:	6a 00                	push   $0x0
  pushl $99
80105d73:	6a 63                	push   $0x63
  jmp alltraps
80105d75:	e9 d3 f7 ff ff       	jmp    8010554d <alltraps>

80105d7a <vector100>:
.globl vector100
vector100:
  pushl $0
80105d7a:	6a 00                	push   $0x0
  pushl $100
80105d7c:	6a 64                	push   $0x64
  jmp alltraps
80105d7e:	e9 ca f7 ff ff       	jmp    8010554d <alltraps>

80105d83 <vector101>:
.globl vector101
vector101:
  pushl $0
80105d83:	6a 00                	push   $0x0
  pushl $101
80105d85:	6a 65                	push   $0x65
  jmp alltraps
80105d87:	e9 c1 f7 ff ff       	jmp    8010554d <alltraps>

80105d8c <vector102>:
.globl vector102
vector102:
  pushl $0
80105d8c:	6a 00                	push   $0x0
  pushl $102
80105d8e:	6a 66                	push   $0x66
  jmp alltraps
80105d90:	e9 b8 f7 ff ff       	jmp    8010554d <alltraps>

80105d95 <vector103>:
.globl vector103
vector103:
  pushl $0
80105d95:	6a 00                	push   $0x0
  pushl $103
80105d97:	6a 67                	push   $0x67
  jmp alltraps
80105d99:	e9 af f7 ff ff       	jmp    8010554d <alltraps>

80105d9e <vector104>:
.globl vector104
vector104:
  pushl $0
80105d9e:	6a 00                	push   $0x0
  pushl $104
80105da0:	6a 68                	push   $0x68
  jmp alltraps
80105da2:	e9 a6 f7 ff ff       	jmp    8010554d <alltraps>

80105da7 <vector105>:
.globl vector105
vector105:
  pushl $0
80105da7:	6a 00                	push   $0x0
  pushl $105
80105da9:	6a 69                	push   $0x69
  jmp alltraps
80105dab:	e9 9d f7 ff ff       	jmp    8010554d <alltraps>

80105db0 <vector106>:
.globl vector106
vector106:
  pushl $0
80105db0:	6a 00                	push   $0x0
  pushl $106
80105db2:	6a 6a                	push   $0x6a
  jmp alltraps
80105db4:	e9 94 f7 ff ff       	jmp    8010554d <alltraps>

80105db9 <vector107>:
.globl vector107
vector107:
  pushl $0
80105db9:	6a 00                	push   $0x0
  pushl $107
80105dbb:	6a 6b                	push   $0x6b
  jmp alltraps
80105dbd:	e9 8b f7 ff ff       	jmp    8010554d <alltraps>

80105dc2 <vector108>:
.globl vector108
vector108:
  pushl $0
80105dc2:	6a 00                	push   $0x0
  pushl $108
80105dc4:	6a 6c                	push   $0x6c
  jmp alltraps
80105dc6:	e9 82 f7 ff ff       	jmp    8010554d <alltraps>

80105dcb <vector109>:
.globl vector109
vector109:
  pushl $0
80105dcb:	6a 00                	push   $0x0
  pushl $109
80105dcd:	6a 6d                	push   $0x6d
  jmp alltraps
80105dcf:	e9 79 f7 ff ff       	jmp    8010554d <alltraps>

80105dd4 <vector110>:
.globl vector110
vector110:
  pushl $0
80105dd4:	6a 00                	push   $0x0
  pushl $110
80105dd6:	6a 6e                	push   $0x6e
  jmp alltraps
80105dd8:	e9 70 f7 ff ff       	jmp    8010554d <alltraps>

80105ddd <vector111>:
.globl vector111
vector111:
  pushl $0
80105ddd:	6a 00                	push   $0x0
  pushl $111
80105ddf:	6a 6f                	push   $0x6f
  jmp alltraps
80105de1:	e9 67 f7 ff ff       	jmp    8010554d <alltraps>

80105de6 <vector112>:
.globl vector112
vector112:
  pushl $0
80105de6:	6a 00                	push   $0x0
  pushl $112
80105de8:	6a 70                	push   $0x70
  jmp alltraps
80105dea:	e9 5e f7 ff ff       	jmp    8010554d <alltraps>

80105def <vector113>:
.globl vector113
vector113:
  pushl $0
80105def:	6a 00                	push   $0x0
  pushl $113
80105df1:	6a 71                	push   $0x71
  jmp alltraps
80105df3:	e9 55 f7 ff ff       	jmp    8010554d <alltraps>

80105df8 <vector114>:
.globl vector114
vector114:
  pushl $0
80105df8:	6a 00                	push   $0x0
  pushl $114
80105dfa:	6a 72                	push   $0x72
  jmp alltraps
80105dfc:	e9 4c f7 ff ff       	jmp    8010554d <alltraps>

80105e01 <vector115>:
.globl vector115
vector115:
  pushl $0
80105e01:	6a 00                	push   $0x0
  pushl $115
80105e03:	6a 73                	push   $0x73
  jmp alltraps
80105e05:	e9 43 f7 ff ff       	jmp    8010554d <alltraps>

80105e0a <vector116>:
.globl vector116
vector116:
  pushl $0
80105e0a:	6a 00                	push   $0x0
  pushl $116
80105e0c:	6a 74                	push   $0x74
  jmp alltraps
80105e0e:	e9 3a f7 ff ff       	jmp    8010554d <alltraps>

80105e13 <vector117>:
.globl vector117
vector117:
  pushl $0
80105e13:	6a 00                	push   $0x0
  pushl $117
80105e15:	6a 75                	push   $0x75
  jmp alltraps
80105e17:	e9 31 f7 ff ff       	jmp    8010554d <alltraps>

80105e1c <vector118>:
.globl vector118
vector118:
  pushl $0
80105e1c:	6a 00                	push   $0x0
  pushl $118
80105e1e:	6a 76                	push   $0x76
  jmp alltraps
80105e20:	e9 28 f7 ff ff       	jmp    8010554d <alltraps>

80105e25 <vector119>:
.globl vector119
vector119:
  pushl $0
80105e25:	6a 00                	push   $0x0
  pushl $119
80105e27:	6a 77                	push   $0x77
  jmp alltraps
80105e29:	e9 1f f7 ff ff       	jmp    8010554d <alltraps>

80105e2e <vector120>:
.globl vector120
vector120:
  pushl $0
80105e2e:	6a 00                	push   $0x0
  pushl $120
80105e30:	6a 78                	push   $0x78
  jmp alltraps
80105e32:	e9 16 f7 ff ff       	jmp    8010554d <alltraps>

80105e37 <vector121>:
.globl vector121
vector121:
  pushl $0
80105e37:	6a 00                	push   $0x0
  pushl $121
80105e39:	6a 79                	push   $0x79
  jmp alltraps
80105e3b:	e9 0d f7 ff ff       	jmp    8010554d <alltraps>

80105e40 <vector122>:
.globl vector122
vector122:
  pushl $0
80105e40:	6a 00                	push   $0x0
  pushl $122
80105e42:	6a 7a                	push   $0x7a
  jmp alltraps
80105e44:	e9 04 f7 ff ff       	jmp    8010554d <alltraps>

80105e49 <vector123>:
.globl vector123
vector123:
  pushl $0
80105e49:	6a 00                	push   $0x0
  pushl $123
80105e4b:	6a 7b                	push   $0x7b
  jmp alltraps
80105e4d:	e9 fb f6 ff ff       	jmp    8010554d <alltraps>

80105e52 <vector124>:
.globl vector124
vector124:
  pushl $0
80105e52:	6a 00                	push   $0x0
  pushl $124
80105e54:	6a 7c                	push   $0x7c
  jmp alltraps
80105e56:	e9 f2 f6 ff ff       	jmp    8010554d <alltraps>

80105e5b <vector125>:
.globl vector125
vector125:
  pushl $0
80105e5b:	6a 00                	push   $0x0
  pushl $125
80105e5d:	6a 7d                	push   $0x7d
  jmp alltraps
80105e5f:	e9 e9 f6 ff ff       	jmp    8010554d <alltraps>

80105e64 <vector126>:
.globl vector126
vector126:
  pushl $0
80105e64:	6a 00                	push   $0x0
  pushl $126
80105e66:	6a 7e                	push   $0x7e
  jmp alltraps
80105e68:	e9 e0 f6 ff ff       	jmp    8010554d <alltraps>

80105e6d <vector127>:
.globl vector127
vector127:
  pushl $0
80105e6d:	6a 00                	push   $0x0
  pushl $127
80105e6f:	6a 7f                	push   $0x7f
  jmp alltraps
80105e71:	e9 d7 f6 ff ff       	jmp    8010554d <alltraps>

80105e76 <vector128>:
.globl vector128
vector128:
  pushl $0
80105e76:	6a 00                	push   $0x0
  pushl $128
80105e78:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80105e7d:	e9 cb f6 ff ff       	jmp    8010554d <alltraps>

80105e82 <vector129>:
.globl vector129
vector129:
  pushl $0
80105e82:	6a 00                	push   $0x0
  pushl $129
80105e84:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80105e89:	e9 bf f6 ff ff       	jmp    8010554d <alltraps>

80105e8e <vector130>:
.globl vector130
vector130:
  pushl $0
80105e8e:	6a 00                	push   $0x0
  pushl $130
80105e90:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80105e95:	e9 b3 f6 ff ff       	jmp    8010554d <alltraps>

80105e9a <vector131>:
.globl vector131
vector131:
  pushl $0
80105e9a:	6a 00                	push   $0x0
  pushl $131
80105e9c:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80105ea1:	e9 a7 f6 ff ff       	jmp    8010554d <alltraps>

80105ea6 <vector132>:
.globl vector132
vector132:
  pushl $0
80105ea6:	6a 00                	push   $0x0
  pushl $132
80105ea8:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80105ead:	e9 9b f6 ff ff       	jmp    8010554d <alltraps>

80105eb2 <vector133>:
.globl vector133
vector133:
  pushl $0
80105eb2:	6a 00                	push   $0x0
  pushl $133
80105eb4:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80105eb9:	e9 8f f6 ff ff       	jmp    8010554d <alltraps>

80105ebe <vector134>:
.globl vector134
vector134:
  pushl $0
80105ebe:	6a 00                	push   $0x0
  pushl $134
80105ec0:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80105ec5:	e9 83 f6 ff ff       	jmp    8010554d <alltraps>

80105eca <vector135>:
.globl vector135
vector135:
  pushl $0
80105eca:	6a 00                	push   $0x0
  pushl $135
80105ecc:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80105ed1:	e9 77 f6 ff ff       	jmp    8010554d <alltraps>

80105ed6 <vector136>:
.globl vector136
vector136:
  pushl $0
80105ed6:	6a 00                	push   $0x0
  pushl $136
80105ed8:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80105edd:	e9 6b f6 ff ff       	jmp    8010554d <alltraps>

80105ee2 <vector137>:
.globl vector137
vector137:
  pushl $0
80105ee2:	6a 00                	push   $0x0
  pushl $137
80105ee4:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80105ee9:	e9 5f f6 ff ff       	jmp    8010554d <alltraps>

80105eee <vector138>:
.globl vector138
vector138:
  pushl $0
80105eee:	6a 00                	push   $0x0
  pushl $138
80105ef0:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80105ef5:	e9 53 f6 ff ff       	jmp    8010554d <alltraps>

80105efa <vector139>:
.globl vector139
vector139:
  pushl $0
80105efa:	6a 00                	push   $0x0
  pushl $139
80105efc:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80105f01:	e9 47 f6 ff ff       	jmp    8010554d <alltraps>

80105f06 <vector140>:
.globl vector140
vector140:
  pushl $0
80105f06:	6a 00                	push   $0x0
  pushl $140
80105f08:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80105f0d:	e9 3b f6 ff ff       	jmp    8010554d <alltraps>

80105f12 <vector141>:
.globl vector141
vector141:
  pushl $0
80105f12:	6a 00                	push   $0x0
  pushl $141
80105f14:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80105f19:	e9 2f f6 ff ff       	jmp    8010554d <alltraps>

80105f1e <vector142>:
.globl vector142
vector142:
  pushl $0
80105f1e:	6a 00                	push   $0x0
  pushl $142
80105f20:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80105f25:	e9 23 f6 ff ff       	jmp    8010554d <alltraps>

80105f2a <vector143>:
.globl vector143
vector143:
  pushl $0
80105f2a:	6a 00                	push   $0x0
  pushl $143
80105f2c:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80105f31:	e9 17 f6 ff ff       	jmp    8010554d <alltraps>

80105f36 <vector144>:
.globl vector144
vector144:
  pushl $0
80105f36:	6a 00                	push   $0x0
  pushl $144
80105f38:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80105f3d:	e9 0b f6 ff ff       	jmp    8010554d <alltraps>

80105f42 <vector145>:
.globl vector145
vector145:
  pushl $0
80105f42:	6a 00                	push   $0x0
  pushl $145
80105f44:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80105f49:	e9 ff f5 ff ff       	jmp    8010554d <alltraps>

80105f4e <vector146>:
.globl vector146
vector146:
  pushl $0
80105f4e:	6a 00                	push   $0x0
  pushl $146
80105f50:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80105f55:	e9 f3 f5 ff ff       	jmp    8010554d <alltraps>

80105f5a <vector147>:
.globl vector147
vector147:
  pushl $0
80105f5a:	6a 00                	push   $0x0
  pushl $147
80105f5c:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80105f61:	e9 e7 f5 ff ff       	jmp    8010554d <alltraps>

80105f66 <vector148>:
.globl vector148
vector148:
  pushl $0
80105f66:	6a 00                	push   $0x0
  pushl $148
80105f68:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80105f6d:	e9 db f5 ff ff       	jmp    8010554d <alltraps>

80105f72 <vector149>:
.globl vector149
vector149:
  pushl $0
80105f72:	6a 00                	push   $0x0
  pushl $149
80105f74:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80105f79:	e9 cf f5 ff ff       	jmp    8010554d <alltraps>

80105f7e <vector150>:
.globl vector150
vector150:
  pushl $0
80105f7e:	6a 00                	push   $0x0
  pushl $150
80105f80:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80105f85:	e9 c3 f5 ff ff       	jmp    8010554d <alltraps>

80105f8a <vector151>:
.globl vector151
vector151:
  pushl $0
80105f8a:	6a 00                	push   $0x0
  pushl $151
80105f8c:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80105f91:	e9 b7 f5 ff ff       	jmp    8010554d <alltraps>

80105f96 <vector152>:
.globl vector152
vector152:
  pushl $0
80105f96:	6a 00                	push   $0x0
  pushl $152
80105f98:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80105f9d:	e9 ab f5 ff ff       	jmp    8010554d <alltraps>

80105fa2 <vector153>:
.globl vector153
vector153:
  pushl $0
80105fa2:	6a 00                	push   $0x0
  pushl $153
80105fa4:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80105fa9:	e9 9f f5 ff ff       	jmp    8010554d <alltraps>

80105fae <vector154>:
.globl vector154
vector154:
  pushl $0
80105fae:	6a 00                	push   $0x0
  pushl $154
80105fb0:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80105fb5:	e9 93 f5 ff ff       	jmp    8010554d <alltraps>

80105fba <vector155>:
.globl vector155
vector155:
  pushl $0
80105fba:	6a 00                	push   $0x0
  pushl $155
80105fbc:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80105fc1:	e9 87 f5 ff ff       	jmp    8010554d <alltraps>

80105fc6 <vector156>:
.globl vector156
vector156:
  pushl $0
80105fc6:	6a 00                	push   $0x0
  pushl $156
80105fc8:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80105fcd:	e9 7b f5 ff ff       	jmp    8010554d <alltraps>

80105fd2 <vector157>:
.globl vector157
vector157:
  pushl $0
80105fd2:	6a 00                	push   $0x0
  pushl $157
80105fd4:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80105fd9:	e9 6f f5 ff ff       	jmp    8010554d <alltraps>

80105fde <vector158>:
.globl vector158
vector158:
  pushl $0
80105fde:	6a 00                	push   $0x0
  pushl $158
80105fe0:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80105fe5:	e9 63 f5 ff ff       	jmp    8010554d <alltraps>

80105fea <vector159>:
.globl vector159
vector159:
  pushl $0
80105fea:	6a 00                	push   $0x0
  pushl $159
80105fec:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80105ff1:	e9 57 f5 ff ff       	jmp    8010554d <alltraps>

80105ff6 <vector160>:
.globl vector160
vector160:
  pushl $0
80105ff6:	6a 00                	push   $0x0
  pushl $160
80105ff8:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80105ffd:	e9 4b f5 ff ff       	jmp    8010554d <alltraps>

80106002 <vector161>:
.globl vector161
vector161:
  pushl $0
80106002:	6a 00                	push   $0x0
  pushl $161
80106004:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106009:	e9 3f f5 ff ff       	jmp    8010554d <alltraps>

8010600e <vector162>:
.globl vector162
vector162:
  pushl $0
8010600e:	6a 00                	push   $0x0
  pushl $162
80106010:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106015:	e9 33 f5 ff ff       	jmp    8010554d <alltraps>

8010601a <vector163>:
.globl vector163
vector163:
  pushl $0
8010601a:	6a 00                	push   $0x0
  pushl $163
8010601c:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106021:	e9 27 f5 ff ff       	jmp    8010554d <alltraps>

80106026 <vector164>:
.globl vector164
vector164:
  pushl $0
80106026:	6a 00                	push   $0x0
  pushl $164
80106028:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010602d:	e9 1b f5 ff ff       	jmp    8010554d <alltraps>

80106032 <vector165>:
.globl vector165
vector165:
  pushl $0
80106032:	6a 00                	push   $0x0
  pushl $165
80106034:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106039:	e9 0f f5 ff ff       	jmp    8010554d <alltraps>

8010603e <vector166>:
.globl vector166
vector166:
  pushl $0
8010603e:	6a 00                	push   $0x0
  pushl $166
80106040:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106045:	e9 03 f5 ff ff       	jmp    8010554d <alltraps>

8010604a <vector167>:
.globl vector167
vector167:
  pushl $0
8010604a:	6a 00                	push   $0x0
  pushl $167
8010604c:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106051:	e9 f7 f4 ff ff       	jmp    8010554d <alltraps>

80106056 <vector168>:
.globl vector168
vector168:
  pushl $0
80106056:	6a 00                	push   $0x0
  pushl $168
80106058:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010605d:	e9 eb f4 ff ff       	jmp    8010554d <alltraps>

80106062 <vector169>:
.globl vector169
vector169:
  pushl $0
80106062:	6a 00                	push   $0x0
  pushl $169
80106064:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106069:	e9 df f4 ff ff       	jmp    8010554d <alltraps>

8010606e <vector170>:
.globl vector170
vector170:
  pushl $0
8010606e:	6a 00                	push   $0x0
  pushl $170
80106070:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106075:	e9 d3 f4 ff ff       	jmp    8010554d <alltraps>

8010607a <vector171>:
.globl vector171
vector171:
  pushl $0
8010607a:	6a 00                	push   $0x0
  pushl $171
8010607c:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106081:	e9 c7 f4 ff ff       	jmp    8010554d <alltraps>

80106086 <vector172>:
.globl vector172
vector172:
  pushl $0
80106086:	6a 00                	push   $0x0
  pushl $172
80106088:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010608d:	e9 bb f4 ff ff       	jmp    8010554d <alltraps>

80106092 <vector173>:
.globl vector173
vector173:
  pushl $0
80106092:	6a 00                	push   $0x0
  pushl $173
80106094:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106099:	e9 af f4 ff ff       	jmp    8010554d <alltraps>

8010609e <vector174>:
.globl vector174
vector174:
  pushl $0
8010609e:	6a 00                	push   $0x0
  pushl $174
801060a0:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801060a5:	e9 a3 f4 ff ff       	jmp    8010554d <alltraps>

801060aa <vector175>:
.globl vector175
vector175:
  pushl $0
801060aa:	6a 00                	push   $0x0
  pushl $175
801060ac:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801060b1:	e9 97 f4 ff ff       	jmp    8010554d <alltraps>

801060b6 <vector176>:
.globl vector176
vector176:
  pushl $0
801060b6:	6a 00                	push   $0x0
  pushl $176
801060b8:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801060bd:	e9 8b f4 ff ff       	jmp    8010554d <alltraps>

801060c2 <vector177>:
.globl vector177
vector177:
  pushl $0
801060c2:	6a 00                	push   $0x0
  pushl $177
801060c4:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801060c9:	e9 7f f4 ff ff       	jmp    8010554d <alltraps>

801060ce <vector178>:
.globl vector178
vector178:
  pushl $0
801060ce:	6a 00                	push   $0x0
  pushl $178
801060d0:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801060d5:	e9 73 f4 ff ff       	jmp    8010554d <alltraps>

801060da <vector179>:
.globl vector179
vector179:
  pushl $0
801060da:	6a 00                	push   $0x0
  pushl $179
801060dc:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801060e1:	e9 67 f4 ff ff       	jmp    8010554d <alltraps>

801060e6 <vector180>:
.globl vector180
vector180:
  pushl $0
801060e6:	6a 00                	push   $0x0
  pushl $180
801060e8:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801060ed:	e9 5b f4 ff ff       	jmp    8010554d <alltraps>

801060f2 <vector181>:
.globl vector181
vector181:
  pushl $0
801060f2:	6a 00                	push   $0x0
  pushl $181
801060f4:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801060f9:	e9 4f f4 ff ff       	jmp    8010554d <alltraps>

801060fe <vector182>:
.globl vector182
vector182:
  pushl $0
801060fe:	6a 00                	push   $0x0
  pushl $182
80106100:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106105:	e9 43 f4 ff ff       	jmp    8010554d <alltraps>

8010610a <vector183>:
.globl vector183
vector183:
  pushl $0
8010610a:	6a 00                	push   $0x0
  pushl $183
8010610c:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106111:	e9 37 f4 ff ff       	jmp    8010554d <alltraps>

80106116 <vector184>:
.globl vector184
vector184:
  pushl $0
80106116:	6a 00                	push   $0x0
  pushl $184
80106118:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010611d:	e9 2b f4 ff ff       	jmp    8010554d <alltraps>

80106122 <vector185>:
.globl vector185
vector185:
  pushl $0
80106122:	6a 00                	push   $0x0
  pushl $185
80106124:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106129:	e9 1f f4 ff ff       	jmp    8010554d <alltraps>

8010612e <vector186>:
.globl vector186
vector186:
  pushl $0
8010612e:	6a 00                	push   $0x0
  pushl $186
80106130:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106135:	e9 13 f4 ff ff       	jmp    8010554d <alltraps>

8010613a <vector187>:
.globl vector187
vector187:
  pushl $0
8010613a:	6a 00                	push   $0x0
  pushl $187
8010613c:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106141:	e9 07 f4 ff ff       	jmp    8010554d <alltraps>

80106146 <vector188>:
.globl vector188
vector188:
  pushl $0
80106146:	6a 00                	push   $0x0
  pushl $188
80106148:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010614d:	e9 fb f3 ff ff       	jmp    8010554d <alltraps>

80106152 <vector189>:
.globl vector189
vector189:
  pushl $0
80106152:	6a 00                	push   $0x0
  pushl $189
80106154:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106159:	e9 ef f3 ff ff       	jmp    8010554d <alltraps>

8010615e <vector190>:
.globl vector190
vector190:
  pushl $0
8010615e:	6a 00                	push   $0x0
  pushl $190
80106160:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106165:	e9 e3 f3 ff ff       	jmp    8010554d <alltraps>

8010616a <vector191>:
.globl vector191
vector191:
  pushl $0
8010616a:	6a 00                	push   $0x0
  pushl $191
8010616c:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106171:	e9 d7 f3 ff ff       	jmp    8010554d <alltraps>

80106176 <vector192>:
.globl vector192
vector192:
  pushl $0
80106176:	6a 00                	push   $0x0
  pushl $192
80106178:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010617d:	e9 cb f3 ff ff       	jmp    8010554d <alltraps>

80106182 <vector193>:
.globl vector193
vector193:
  pushl $0
80106182:	6a 00                	push   $0x0
  pushl $193
80106184:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106189:	e9 bf f3 ff ff       	jmp    8010554d <alltraps>

8010618e <vector194>:
.globl vector194
vector194:
  pushl $0
8010618e:	6a 00                	push   $0x0
  pushl $194
80106190:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106195:	e9 b3 f3 ff ff       	jmp    8010554d <alltraps>

8010619a <vector195>:
.globl vector195
vector195:
  pushl $0
8010619a:	6a 00                	push   $0x0
  pushl $195
8010619c:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801061a1:	e9 a7 f3 ff ff       	jmp    8010554d <alltraps>

801061a6 <vector196>:
.globl vector196
vector196:
  pushl $0
801061a6:	6a 00                	push   $0x0
  pushl $196
801061a8:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801061ad:	e9 9b f3 ff ff       	jmp    8010554d <alltraps>

801061b2 <vector197>:
.globl vector197
vector197:
  pushl $0
801061b2:	6a 00                	push   $0x0
  pushl $197
801061b4:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801061b9:	e9 8f f3 ff ff       	jmp    8010554d <alltraps>

801061be <vector198>:
.globl vector198
vector198:
  pushl $0
801061be:	6a 00                	push   $0x0
  pushl $198
801061c0:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801061c5:	e9 83 f3 ff ff       	jmp    8010554d <alltraps>

801061ca <vector199>:
.globl vector199
vector199:
  pushl $0
801061ca:	6a 00                	push   $0x0
  pushl $199
801061cc:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801061d1:	e9 77 f3 ff ff       	jmp    8010554d <alltraps>

801061d6 <vector200>:
.globl vector200
vector200:
  pushl $0
801061d6:	6a 00                	push   $0x0
  pushl $200
801061d8:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801061dd:	e9 6b f3 ff ff       	jmp    8010554d <alltraps>

801061e2 <vector201>:
.globl vector201
vector201:
  pushl $0
801061e2:	6a 00                	push   $0x0
  pushl $201
801061e4:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801061e9:	e9 5f f3 ff ff       	jmp    8010554d <alltraps>

801061ee <vector202>:
.globl vector202
vector202:
  pushl $0
801061ee:	6a 00                	push   $0x0
  pushl $202
801061f0:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801061f5:	e9 53 f3 ff ff       	jmp    8010554d <alltraps>

801061fa <vector203>:
.globl vector203
vector203:
  pushl $0
801061fa:	6a 00                	push   $0x0
  pushl $203
801061fc:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106201:	e9 47 f3 ff ff       	jmp    8010554d <alltraps>

80106206 <vector204>:
.globl vector204
vector204:
  pushl $0
80106206:	6a 00                	push   $0x0
  pushl $204
80106208:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010620d:	e9 3b f3 ff ff       	jmp    8010554d <alltraps>

80106212 <vector205>:
.globl vector205
vector205:
  pushl $0
80106212:	6a 00                	push   $0x0
  pushl $205
80106214:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106219:	e9 2f f3 ff ff       	jmp    8010554d <alltraps>

8010621e <vector206>:
.globl vector206
vector206:
  pushl $0
8010621e:	6a 00                	push   $0x0
  pushl $206
80106220:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106225:	e9 23 f3 ff ff       	jmp    8010554d <alltraps>

8010622a <vector207>:
.globl vector207
vector207:
  pushl $0
8010622a:	6a 00                	push   $0x0
  pushl $207
8010622c:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106231:	e9 17 f3 ff ff       	jmp    8010554d <alltraps>

80106236 <vector208>:
.globl vector208
vector208:
  pushl $0
80106236:	6a 00                	push   $0x0
  pushl $208
80106238:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010623d:	e9 0b f3 ff ff       	jmp    8010554d <alltraps>

80106242 <vector209>:
.globl vector209
vector209:
  pushl $0
80106242:	6a 00                	push   $0x0
  pushl $209
80106244:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106249:	e9 ff f2 ff ff       	jmp    8010554d <alltraps>

8010624e <vector210>:
.globl vector210
vector210:
  pushl $0
8010624e:	6a 00                	push   $0x0
  pushl $210
80106250:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106255:	e9 f3 f2 ff ff       	jmp    8010554d <alltraps>

8010625a <vector211>:
.globl vector211
vector211:
  pushl $0
8010625a:	6a 00                	push   $0x0
  pushl $211
8010625c:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106261:	e9 e7 f2 ff ff       	jmp    8010554d <alltraps>

80106266 <vector212>:
.globl vector212
vector212:
  pushl $0
80106266:	6a 00                	push   $0x0
  pushl $212
80106268:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010626d:	e9 db f2 ff ff       	jmp    8010554d <alltraps>

80106272 <vector213>:
.globl vector213
vector213:
  pushl $0
80106272:	6a 00                	push   $0x0
  pushl $213
80106274:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106279:	e9 cf f2 ff ff       	jmp    8010554d <alltraps>

8010627e <vector214>:
.globl vector214
vector214:
  pushl $0
8010627e:	6a 00                	push   $0x0
  pushl $214
80106280:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106285:	e9 c3 f2 ff ff       	jmp    8010554d <alltraps>

8010628a <vector215>:
.globl vector215
vector215:
  pushl $0
8010628a:	6a 00                	push   $0x0
  pushl $215
8010628c:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106291:	e9 b7 f2 ff ff       	jmp    8010554d <alltraps>

80106296 <vector216>:
.globl vector216
vector216:
  pushl $0
80106296:	6a 00                	push   $0x0
  pushl $216
80106298:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010629d:	e9 ab f2 ff ff       	jmp    8010554d <alltraps>

801062a2 <vector217>:
.globl vector217
vector217:
  pushl $0
801062a2:	6a 00                	push   $0x0
  pushl $217
801062a4:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801062a9:	e9 9f f2 ff ff       	jmp    8010554d <alltraps>

801062ae <vector218>:
.globl vector218
vector218:
  pushl $0
801062ae:	6a 00                	push   $0x0
  pushl $218
801062b0:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801062b5:	e9 93 f2 ff ff       	jmp    8010554d <alltraps>

801062ba <vector219>:
.globl vector219
vector219:
  pushl $0
801062ba:	6a 00                	push   $0x0
  pushl $219
801062bc:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801062c1:	e9 87 f2 ff ff       	jmp    8010554d <alltraps>

801062c6 <vector220>:
.globl vector220
vector220:
  pushl $0
801062c6:	6a 00                	push   $0x0
  pushl $220
801062c8:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801062cd:	e9 7b f2 ff ff       	jmp    8010554d <alltraps>

801062d2 <vector221>:
.globl vector221
vector221:
  pushl $0
801062d2:	6a 00                	push   $0x0
  pushl $221
801062d4:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801062d9:	e9 6f f2 ff ff       	jmp    8010554d <alltraps>

801062de <vector222>:
.globl vector222
vector222:
  pushl $0
801062de:	6a 00                	push   $0x0
  pushl $222
801062e0:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801062e5:	e9 63 f2 ff ff       	jmp    8010554d <alltraps>

801062ea <vector223>:
.globl vector223
vector223:
  pushl $0
801062ea:	6a 00                	push   $0x0
  pushl $223
801062ec:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801062f1:	e9 57 f2 ff ff       	jmp    8010554d <alltraps>

801062f6 <vector224>:
.globl vector224
vector224:
  pushl $0
801062f6:	6a 00                	push   $0x0
  pushl $224
801062f8:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801062fd:	e9 4b f2 ff ff       	jmp    8010554d <alltraps>

80106302 <vector225>:
.globl vector225
vector225:
  pushl $0
80106302:	6a 00                	push   $0x0
  pushl $225
80106304:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106309:	e9 3f f2 ff ff       	jmp    8010554d <alltraps>

8010630e <vector226>:
.globl vector226
vector226:
  pushl $0
8010630e:	6a 00                	push   $0x0
  pushl $226
80106310:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106315:	e9 33 f2 ff ff       	jmp    8010554d <alltraps>

8010631a <vector227>:
.globl vector227
vector227:
  pushl $0
8010631a:	6a 00                	push   $0x0
  pushl $227
8010631c:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106321:	e9 27 f2 ff ff       	jmp    8010554d <alltraps>

80106326 <vector228>:
.globl vector228
vector228:
  pushl $0
80106326:	6a 00                	push   $0x0
  pushl $228
80106328:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010632d:	e9 1b f2 ff ff       	jmp    8010554d <alltraps>

80106332 <vector229>:
.globl vector229
vector229:
  pushl $0
80106332:	6a 00                	push   $0x0
  pushl $229
80106334:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106339:	e9 0f f2 ff ff       	jmp    8010554d <alltraps>

8010633e <vector230>:
.globl vector230
vector230:
  pushl $0
8010633e:	6a 00                	push   $0x0
  pushl $230
80106340:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106345:	e9 03 f2 ff ff       	jmp    8010554d <alltraps>

8010634a <vector231>:
.globl vector231
vector231:
  pushl $0
8010634a:	6a 00                	push   $0x0
  pushl $231
8010634c:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106351:	e9 f7 f1 ff ff       	jmp    8010554d <alltraps>

80106356 <vector232>:
.globl vector232
vector232:
  pushl $0
80106356:	6a 00                	push   $0x0
  pushl $232
80106358:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010635d:	e9 eb f1 ff ff       	jmp    8010554d <alltraps>

80106362 <vector233>:
.globl vector233
vector233:
  pushl $0
80106362:	6a 00                	push   $0x0
  pushl $233
80106364:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106369:	e9 df f1 ff ff       	jmp    8010554d <alltraps>

8010636e <vector234>:
.globl vector234
vector234:
  pushl $0
8010636e:	6a 00                	push   $0x0
  pushl $234
80106370:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106375:	e9 d3 f1 ff ff       	jmp    8010554d <alltraps>

8010637a <vector235>:
.globl vector235
vector235:
  pushl $0
8010637a:	6a 00                	push   $0x0
  pushl $235
8010637c:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106381:	e9 c7 f1 ff ff       	jmp    8010554d <alltraps>

80106386 <vector236>:
.globl vector236
vector236:
  pushl $0
80106386:	6a 00                	push   $0x0
  pushl $236
80106388:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010638d:	e9 bb f1 ff ff       	jmp    8010554d <alltraps>

80106392 <vector237>:
.globl vector237
vector237:
  pushl $0
80106392:	6a 00                	push   $0x0
  pushl $237
80106394:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106399:	e9 af f1 ff ff       	jmp    8010554d <alltraps>

8010639e <vector238>:
.globl vector238
vector238:
  pushl $0
8010639e:	6a 00                	push   $0x0
  pushl $238
801063a0:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801063a5:	e9 a3 f1 ff ff       	jmp    8010554d <alltraps>

801063aa <vector239>:
.globl vector239
vector239:
  pushl $0
801063aa:	6a 00                	push   $0x0
  pushl $239
801063ac:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801063b1:	e9 97 f1 ff ff       	jmp    8010554d <alltraps>

801063b6 <vector240>:
.globl vector240
vector240:
  pushl $0
801063b6:	6a 00                	push   $0x0
  pushl $240
801063b8:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801063bd:	e9 8b f1 ff ff       	jmp    8010554d <alltraps>

801063c2 <vector241>:
.globl vector241
vector241:
  pushl $0
801063c2:	6a 00                	push   $0x0
  pushl $241
801063c4:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801063c9:	e9 7f f1 ff ff       	jmp    8010554d <alltraps>

801063ce <vector242>:
.globl vector242
vector242:
  pushl $0
801063ce:	6a 00                	push   $0x0
  pushl $242
801063d0:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801063d5:	e9 73 f1 ff ff       	jmp    8010554d <alltraps>

801063da <vector243>:
.globl vector243
vector243:
  pushl $0
801063da:	6a 00                	push   $0x0
  pushl $243
801063dc:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
801063e1:	e9 67 f1 ff ff       	jmp    8010554d <alltraps>

801063e6 <vector244>:
.globl vector244
vector244:
  pushl $0
801063e6:	6a 00                	push   $0x0
  pushl $244
801063e8:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
801063ed:	e9 5b f1 ff ff       	jmp    8010554d <alltraps>

801063f2 <vector245>:
.globl vector245
vector245:
  pushl $0
801063f2:	6a 00                	push   $0x0
  pushl $245
801063f4:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801063f9:	e9 4f f1 ff ff       	jmp    8010554d <alltraps>

801063fe <vector246>:
.globl vector246
vector246:
  pushl $0
801063fe:	6a 00                	push   $0x0
  pushl $246
80106400:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106405:	e9 43 f1 ff ff       	jmp    8010554d <alltraps>

8010640a <vector247>:
.globl vector247
vector247:
  pushl $0
8010640a:	6a 00                	push   $0x0
  pushl $247
8010640c:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106411:	e9 37 f1 ff ff       	jmp    8010554d <alltraps>

80106416 <vector248>:
.globl vector248
vector248:
  pushl $0
80106416:	6a 00                	push   $0x0
  pushl $248
80106418:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010641d:	e9 2b f1 ff ff       	jmp    8010554d <alltraps>

80106422 <vector249>:
.globl vector249
vector249:
  pushl $0
80106422:	6a 00                	push   $0x0
  pushl $249
80106424:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106429:	e9 1f f1 ff ff       	jmp    8010554d <alltraps>

8010642e <vector250>:
.globl vector250
vector250:
  pushl $0
8010642e:	6a 00                	push   $0x0
  pushl $250
80106430:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106435:	e9 13 f1 ff ff       	jmp    8010554d <alltraps>

8010643a <vector251>:
.globl vector251
vector251:
  pushl $0
8010643a:	6a 00                	push   $0x0
  pushl $251
8010643c:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106441:	e9 07 f1 ff ff       	jmp    8010554d <alltraps>

80106446 <vector252>:
.globl vector252
vector252:
  pushl $0
80106446:	6a 00                	push   $0x0
  pushl $252
80106448:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010644d:	e9 fb f0 ff ff       	jmp    8010554d <alltraps>

80106452 <vector253>:
.globl vector253
vector253:
  pushl $0
80106452:	6a 00                	push   $0x0
  pushl $253
80106454:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106459:	e9 ef f0 ff ff       	jmp    8010554d <alltraps>

8010645e <vector254>:
.globl vector254
vector254:
  pushl $0
8010645e:	6a 00                	push   $0x0
  pushl $254
80106460:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106465:	e9 e3 f0 ff ff       	jmp    8010554d <alltraps>

8010646a <vector255>:
.globl vector255
vector255:
  pushl $0
8010646a:	6a 00                	push   $0x0
  pushl $255
8010646c:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106471:	e9 d7 f0 ff ff       	jmp    8010554d <alltraps>
80106476:	66 90                	xchg   %ax,%ax
80106478:	66 90                	xchg   %ax,%ax
8010647a:	66 90                	xchg   %ax,%ax
8010647c:	66 90                	xchg   %ax,%ax
8010647e:	66 90                	xchg   %ax,%ax

80106480 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106480:	55                   	push   %ebp
80106481:	89 e5                	mov    %esp,%ebp
80106483:	57                   	push   %edi
80106484:	56                   	push   %esi
80106485:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106487:	c1 ea 16             	shr    $0x16,%edx
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
8010648a:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
8010648b:	8d 3c 90             	lea    (%eax,%edx,4),%edi
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
8010648e:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
80106491:	8b 1f                	mov    (%edi),%ebx
80106493:	f6 c3 01             	test   $0x1,%bl
80106496:	74 28                	je     801064c0 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106498:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
8010649e:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
801064a4:	c1 ee 0a             	shr    $0xa,%esi
}
801064a7:	83 c4 1c             	add    $0x1c,%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
801064aa:	89 f2                	mov    %esi,%edx
801064ac:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
801064b2:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
801064b5:	5b                   	pop    %ebx
801064b6:	5e                   	pop    %esi
801064b7:	5f                   	pop    %edi
801064b8:	5d                   	pop    %ebp
801064b9:	c3                   	ret    
801064ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801064c0:	85 c9                	test   %ecx,%ecx
801064c2:	74 34                	je     801064f8 <walkpgdir+0x78>
801064c4:	e8 c7 bf ff ff       	call   80102490 <kalloc>
801064c9:	85 c0                	test   %eax,%eax
801064cb:	89 c3                	mov    %eax,%ebx
801064cd:	74 29                	je     801064f8 <walkpgdir+0x78>
      return 0;
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
801064cf:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801064d6:	00 
801064d7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801064de:	00 
801064df:	89 04 24             	mov    %eax,(%esp)
801064e2:	e8 b9 de ff ff       	call   801043a0 <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801064e7:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801064ed:	83 c8 07             	or     $0x7,%eax
801064f0:	89 07                	mov    %eax,(%edi)
801064f2:	eb b0                	jmp    801064a4 <walkpgdir+0x24>
801064f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }
  return &pgtab[PTX(va)];
}
801064f8:	83 c4 1c             	add    $0x1c,%esp
  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
      return 0;
801064fb:	31 c0                	xor    %eax,%eax
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}
801064fd:	5b                   	pop    %ebx
801064fe:	5e                   	pop    %esi
801064ff:	5f                   	pop    %edi
80106500:	5d                   	pop    %ebp
80106501:	c3                   	ret    
80106502:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106509:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106510 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106510:	55                   	push   %ebp
80106511:	89 e5                	mov    %esp,%ebp
80106513:	57                   	push   %edi
80106514:	56                   	push   %esi
80106515:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106516:	89 d3                	mov    %edx,%ebx
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106518:	83 ec 1c             	sub    $0x1c,%esp
8010651b:	8b 7d 08             	mov    0x8(%ebp),%edi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
8010651e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106524:	89 45 e0             	mov    %eax,-0x20(%ebp)
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106527:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
8010652b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
8010652e:	83 4d 0c 01          	orl    $0x1,0xc(%ebp)
{
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106532:	81 65 e4 00 f0 ff ff 	andl   $0xfffff000,-0x1c(%ebp)
80106539:	29 df                	sub    %ebx,%edi
8010653b:	eb 18                	jmp    80106555 <mappages+0x45>
8010653d:	8d 76 00             	lea    0x0(%esi),%esi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
80106540:	f6 00 01             	testb  $0x1,(%eax)
80106543:	75 3d                	jne    80106582 <mappages+0x72>
      panic("remap");
    *pte = pa | perm | PTE_P;
80106545:	0b 75 0c             	or     0xc(%ebp),%esi
    if(a == last)
80106548:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
8010654b:	89 30                	mov    %esi,(%eax)
    if(a == last)
8010654d:	74 29                	je     80106578 <mappages+0x68>
      break;
    a += PGSIZE;
8010654f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106555:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106558:	b9 01 00 00 00       	mov    $0x1,%ecx
8010655d:	89 da                	mov    %ebx,%edx
8010655f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80106562:	e8 19 ff ff ff       	call   80106480 <walkpgdir>
80106567:	85 c0                	test   %eax,%eax
80106569:	75 d5                	jne    80106540 <mappages+0x30>
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
8010656b:	83 c4 1c             	add    $0x1c,%esp

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
8010656e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
80106573:	5b                   	pop    %ebx
80106574:	5e                   	pop    %esi
80106575:	5f                   	pop    %edi
80106576:	5d                   	pop    %ebp
80106577:	c3                   	ret    
80106578:	83 c4 1c             	add    $0x1c,%esp
    if(a == last)
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
8010657b:	31 c0                	xor    %eax,%eax
}
8010657d:	5b                   	pop    %ebx
8010657e:	5e                   	pop    %esi
8010657f:	5f                   	pop    %edi
80106580:	5d                   	pop    %ebp
80106581:	c3                   	ret    
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
80106582:	c7 04 24 68 76 10 80 	movl   $0x80107668,(%esp)
80106589:	e8 d2 9d ff ff       	call   80100360 <panic>
8010658e:	66 90                	xchg   %ax,%ax

80106590 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106590:	55                   	push   %ebp
80106591:	89 e5                	mov    %esp,%ebp
80106593:	57                   	push   %edi
80106594:	89 c7                	mov    %eax,%edi
80106596:	56                   	push   %esi
80106597:	89 d6                	mov    %edx,%esi
80106599:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
8010659a:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801065a0:	83 ec 1c             	sub    $0x1c,%esp
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
801065a3:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
801065a9:	39 d3                	cmp    %edx,%ebx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801065ab:	89 4d e0             	mov    %ecx,-0x20(%ebp)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
801065ae:	72 3b                	jb     801065eb <deallocuvm.part.0+0x5b>
801065b0:	eb 5e                	jmp    80106610 <deallocuvm.part.0+0x80>
801065b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
801065b8:	8b 10                	mov    (%eax),%edx
801065ba:	f6 c2 01             	test   $0x1,%dl
801065bd:	74 22                	je     801065e1 <deallocuvm.part.0+0x51>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
801065bf:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
801065c5:	74 54                	je     8010661b <deallocuvm.part.0+0x8b>
        panic("kfree");
      char *v = P2V(pa);
801065c7:	81 c2 00 00 00 80    	add    $0x80000000,%edx
      kfree(v);
801065cd:	89 14 24             	mov    %edx,(%esp)
801065d0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801065d3:	e8 08 bd ff ff       	call   801022e0 <kfree>
      *pte = 0;
801065d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801065db:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
801065e1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801065e7:	39 f3                	cmp    %esi,%ebx
801065e9:	73 25                	jae    80106610 <deallocuvm.part.0+0x80>
    pte = walkpgdir(pgdir, (char*)a, 0);
801065eb:	31 c9                	xor    %ecx,%ecx
801065ed:	89 da                	mov    %ebx,%edx
801065ef:	89 f8                	mov    %edi,%eax
801065f1:	e8 8a fe ff ff       	call   80106480 <walkpgdir>
    if(!pte)
801065f6:	85 c0                	test   %eax,%eax
801065f8:	75 be                	jne    801065b8 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
801065fa:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80106600:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80106606:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010660c:	39 f3                	cmp    %esi,%ebx
8010660e:	72 db                	jb     801065eb <deallocuvm.part.0+0x5b>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106610:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106613:	83 c4 1c             	add    $0x1c,%esp
80106616:	5b                   	pop    %ebx
80106617:	5e                   	pop    %esi
80106618:	5f                   	pop    %edi
80106619:	5d                   	pop    %ebp
8010661a:	c3                   	ret    
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
      pa = PTE_ADDR(*pte);
      if(pa == 0)
        panic("kfree");
8010661b:	c7 04 24 12 70 10 80 	movl   $0x80107012,(%esp)
80106622:	e8 39 9d ff ff       	call   80100360 <panic>
80106627:	89 f6                	mov    %esi,%esi
80106629:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106630 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80106630:	55                   	push   %ebp
80106631:	89 e5                	mov    %esp,%ebp
80106633:	83 ec 18             	sub    $0x18,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
80106636:	e8 15 c1 ff ff       	call   80102750 <cpunum>
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010663b:	31 c9                	xor    %ecx,%ecx
8010663d:	ba ff ff ff ff       	mov    $0xffffffff,%edx

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
80106642:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80106648:	05 a0 27 11 80       	add    $0x801127a0,%eax
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010664d:	66 89 50 78          	mov    %dx,0x78(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106651:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106656:	66 89 48 7a          	mov    %cx,0x7a(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010665a:	31 c9                	xor    %ecx,%ecx
8010665c:	66 89 90 80 00 00 00 	mov    %dx,0x80(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106663:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106668:	66 89 88 82 00 00 00 	mov    %cx,0x82(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
8010666f:	31 c9                	xor    %ecx,%ecx
80106671:	66 89 90 90 00 00 00 	mov    %dx,0x90(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106678:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
8010667d:	66 89 88 92 00 00 00 	mov    %cx,0x92(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106684:	31 c9                	xor    %ecx,%ecx
80106686:	66 89 90 98 00 00 00 	mov    %dx,0x98(%eax)

  // Map cpu and proc -- these are private per cpu.
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
8010668d:	8d 90 b4 00 00 00    	lea    0xb4(%eax),%edx
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106693:	66 89 88 9a 00 00 00 	mov    %cx,0x9a(%eax)

  // Map cpu and proc -- these are private per cpu.
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
8010669a:	31 c9                	xor    %ecx,%ecx
8010669c:	66 89 88 88 00 00 00 	mov    %cx,0x88(%eax)
801066a3:	89 d1                	mov    %edx,%ecx
801066a5:	c1 e9 10             	shr    $0x10,%ecx
801066a8:	66 89 90 8a 00 00 00 	mov    %dx,0x8a(%eax)
801066af:	c1 ea 18             	shr    $0x18,%edx
801066b2:	88 88 8c 00 00 00    	mov    %cl,0x8c(%eax)
static inline void
lgdt(struct segdesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
801066b8:	b9 37 00 00 00       	mov    $0x37,%ecx
801066bd:	88 90 8f 00 00 00    	mov    %dl,0x8f(%eax)

  lgdt(c->gdt, sizeof(c->gdt));
801066c3:	8d 50 70             	lea    0x70(%eax),%edx
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801066c6:	c6 40 7d 9a          	movb   $0x9a,0x7d(%eax)
801066ca:	c6 40 7e cf          	movb   $0xcf,0x7e(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801066ce:	c6 80 85 00 00 00 92 	movb   $0x92,0x85(%eax)
801066d5:	c6 80 86 00 00 00 cf 	movb   $0xcf,0x86(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801066dc:	c6 80 95 00 00 00 fa 	movb   $0xfa,0x95(%eax)
801066e3:	c6 80 96 00 00 00 cf 	movb   $0xcf,0x96(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801066ea:	c6 80 9d 00 00 00 f2 	movb   $0xf2,0x9d(%eax)
801066f1:	c6 80 9e 00 00 00 cf 	movb   $0xcf,0x9e(%eax)

  // Map cpu and proc -- these are private per cpu.
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
801066f8:	c6 80 8d 00 00 00 92 	movb   $0x92,0x8d(%eax)
801066ff:	c6 80 8e 00 00 00 c0 	movb   $0xc0,0x8e(%eax)
80106706:	66 89 4d f2          	mov    %cx,-0xe(%ebp)
  pd[1] = (uint)p;
8010670a:	66 89 55 f4          	mov    %dx,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
8010670e:	c1 ea 10             	shr    $0x10,%edx
80106711:	66 89 55 f6          	mov    %dx,-0xa(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
80106715:	8d 55 f2             	lea    -0xe(%ebp),%edx
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106718:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
8010671c:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106720:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
80106727:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
8010672e:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
80106735:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
8010673c:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
80106743:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)
8010674a:	0f 01 12             	lgdtl  (%edx)
}

static inline void
loadgs(ushort v)
{
  asm volatile("movw %0, %%gs" : : "r" (v));
8010674d:	ba 18 00 00 00       	mov    $0x18,%edx
80106752:	8e ea                	mov    %edx,%gs
  lgdt(c->gdt, sizeof(c->gdt));
  loadgs(SEG_KCPU << 3);

  // Initialize cpu-local storage.
  cpu = c;
  proc = 0;
80106754:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
8010675b:	00 00 00 00 

  lgdt(c->gdt, sizeof(c->gdt));
  loadgs(SEG_KCPU << 3);

  // Initialize cpu-local storage.
  cpu = c;
8010675f:	65 a3 00 00 00 00    	mov    %eax,%gs:0x0
  proc = 0;
}
80106765:	c9                   	leave  
80106766:	c3                   	ret    
80106767:	89 f6                	mov    %esi,%esi
80106769:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106770 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80106770:	55                   	push   %ebp
80106771:	89 e5                	mov    %esp,%ebp
80106773:	56                   	push   %esi
80106774:	53                   	push   %ebx
80106775:	83 ec 10             	sub    $0x10,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80106778:	e8 13 bd ff ff       	call   80102490 <kalloc>
8010677d:	85 c0                	test   %eax,%eax
8010677f:	89 c6                	mov    %eax,%esi
80106781:	74 55                	je     801067d8 <setupkvm+0x68>
    return 0;
  memset(pgdir, 0, PGSIZE);
80106783:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010678a:	00 
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
8010678b:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
80106790:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106797:	00 
80106798:	89 04 24             	mov    %eax,(%esp)
8010679b:	e8 00 dc ff ff       	call   801043a0 <memset>
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801067a0:	8b 53 0c             	mov    0xc(%ebx),%edx
801067a3:	8b 43 04             	mov    0x4(%ebx),%eax
801067a6:	8b 4b 08             	mov    0x8(%ebx),%ecx
801067a9:	89 54 24 04          	mov    %edx,0x4(%esp)
801067ad:	8b 13                	mov    (%ebx),%edx
801067af:	89 04 24             	mov    %eax,(%esp)
801067b2:	29 c1                	sub    %eax,%ecx
801067b4:	89 f0                	mov    %esi,%eax
801067b6:	e8 55 fd ff ff       	call   80106510 <mappages>
801067bb:	85 c0                	test   %eax,%eax
801067bd:	78 19                	js     801067d8 <setupkvm+0x68>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801067bf:	83 c3 10             	add    $0x10,%ebx
801067c2:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
801067c8:	72 d6                	jb     801067a0 <setupkvm+0x30>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
}
801067ca:	83 c4 10             	add    $0x10,%esp
801067cd:	89 f0                	mov    %esi,%eax
801067cf:	5b                   	pop    %ebx
801067d0:	5e                   	pop    %esi
801067d1:	5d                   	pop    %ebp
801067d2:	c3                   	ret    
801067d3:	90                   	nop
801067d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801067d8:	83 c4 10             	add    $0x10,%esp
{
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
801067db:	31 c0                	xor    %eax,%eax
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
}
801067dd:	5b                   	pop    %ebx
801067de:	5e                   	pop    %esi
801067df:	5d                   	pop    %ebp
801067e0:	c3                   	ret    
801067e1:	eb 0d                	jmp    801067f0 <kvmalloc>
801067e3:	90                   	nop
801067e4:	90                   	nop
801067e5:	90                   	nop
801067e6:	90                   	nop
801067e7:	90                   	nop
801067e8:	90                   	nop
801067e9:	90                   	nop
801067ea:	90                   	nop
801067eb:	90                   	nop
801067ec:	90                   	nop
801067ed:	90                   	nop
801067ee:	90                   	nop
801067ef:	90                   	nop

801067f0 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
801067f0:	55                   	push   %ebp
801067f1:	89 e5                	mov    %esp,%ebp
801067f3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801067f6:	e8 75 ff ff ff       	call   80106770 <setupkvm>
801067fb:	a3 24 6c 11 80       	mov    %eax,0x80116c24
// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106800:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106805:	0f 22 d8             	mov    %eax,%cr3
void
kvmalloc(void)
{
  kpgdir = setupkvm();
  switchkvm();
}
80106808:	c9                   	leave  
80106809:	c3                   	ret    
8010680a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106810 <switchkvm>:
// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106810:	a1 24 6c 11 80       	mov    0x80116c24,%eax

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80106815:	55                   	push   %ebp
80106816:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106818:	05 00 00 00 80       	add    $0x80000000,%eax
8010681d:	0f 22 d8             	mov    %eax,%cr3
}
80106820:	5d                   	pop    %ebp
80106821:	c3                   	ret    
80106822:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106829:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106830 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80106830:	55                   	push   %ebp
80106831:	89 e5                	mov    %esp,%ebp
80106833:	53                   	push   %ebx
80106834:	83 ec 14             	sub    $0x14,%esp
80106837:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
8010683a:	85 db                	test   %ebx,%ebx
8010683c:	0f 84 94 00 00 00    	je     801068d6 <switchuvm+0xa6>
    panic("switchuvm: no process");
  if(p->kstack == 0)
80106842:	8b 43 08             	mov    0x8(%ebx),%eax
80106845:	85 c0                	test   %eax,%eax
80106847:	0f 84 a1 00 00 00    	je     801068ee <switchuvm+0xbe>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
8010684d:	8b 43 04             	mov    0x4(%ebx),%eax
80106850:	85 c0                	test   %eax,%eax
80106852:	0f 84 8a 00 00 00    	je     801068e2 <switchuvm+0xb2>
    panic("switchuvm: no pgdir");

  pushcli();
80106858:	e8 73 da ff ff       	call   801042d0 <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
8010685d:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106863:	b9 67 00 00 00       	mov    $0x67,%ecx
80106868:	8d 50 08             	lea    0x8(%eax),%edx
8010686b:	66 89 88 a0 00 00 00 	mov    %cx,0xa0(%eax)
80106872:	89 d1                	mov    %edx,%ecx
80106874:	66 89 90 a2 00 00 00 	mov    %dx,0xa2(%eax)
8010687b:	c1 ea 18             	shr    $0x18,%edx
8010687e:	88 90 a7 00 00 00    	mov    %dl,0xa7(%eax)
80106884:	c1 e9 10             	shr    $0x10,%ecx
  cpu->gdt[SEG_TSS].s = 0;
  cpu->ts.ss0 = SEG_KDATA << 3;
80106887:	ba 10 00 00 00       	mov    $0x10,%edx
8010688c:	66 89 50 10          	mov    %dx,0x10(%eax)
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
    panic("switchuvm: no pgdir");

  pushcli();
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
80106890:	88 88 a4 00 00 00    	mov    %cl,0xa4(%eax)
80106896:	c6 80 a6 00 00 00 40 	movb   $0x40,0xa6(%eax)
  cpu->gdt[SEG_TSS].s = 0;
8010689d:	c6 80 a5 00 00 00 89 	movb   $0x89,0xa5(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
  cpu->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
801068a4:	8b 4b 08             	mov    0x8(%ebx),%ecx
801068a7:	8d 91 00 10 00 00    	lea    0x1000(%ecx),%edx
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  cpu->ts.iomb = (ushort) 0xFFFF;
801068ad:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx

  pushcli();
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
  cpu->gdt[SEG_TSS].s = 0;
  cpu->ts.ss0 = SEG_KDATA << 3;
  cpu->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
801068b2:	89 50 0c             	mov    %edx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  cpu->ts.iomb = (ushort) 0xFFFF;
801068b5:	66 89 48 6e          	mov    %cx,0x6e(%eax)
}

static inline void
ltr(ushort sel)
{
  asm volatile("ltr %0" : : "r" (sel));
801068b9:	b8 30 00 00 00       	mov    $0x30,%eax
801068be:	0f 00 d8             	ltr    %ax
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
801068c1:	8b 43 04             	mov    0x4(%ebx),%eax
801068c4:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
801068c9:	0f 22 d8             	mov    %eax,%cr3
  popcli();
}
801068cc:	83 c4 14             	add    $0x14,%esp
801068cf:	5b                   	pop    %ebx
801068d0:	5d                   	pop    %ebp
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  cpu->ts.iomb = (ushort) 0xFFFF;
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
801068d1:	e9 2a da ff ff       	jmp    80104300 <popcli>
// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
801068d6:	c7 04 24 6e 76 10 80 	movl   $0x8010766e,(%esp)
801068dd:	e8 7e 9a ff ff       	call   80100360 <panic>
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
    panic("switchuvm: no pgdir");
801068e2:	c7 04 24 99 76 10 80 	movl   $0x80107699,(%esp)
801068e9:	e8 72 9a ff ff       	call   80100360 <panic>
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
801068ee:	c7 04 24 84 76 10 80 	movl   $0x80107684,(%esp)
801068f5:	e8 66 9a ff ff       	call   80100360 <panic>
801068fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106900 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80106900:	55                   	push   %ebp
80106901:	89 e5                	mov    %esp,%ebp
80106903:	57                   	push   %edi
80106904:	56                   	push   %esi
80106905:	53                   	push   %ebx
80106906:	83 ec 1c             	sub    $0x1c,%esp
80106909:	8b 75 10             	mov    0x10(%ebp),%esi
8010690c:	8b 45 08             	mov    0x8(%ebp),%eax
8010690f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *mem;

  if(sz >= PGSIZE)
80106912:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80106918:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *mem;

  if(sz >= PGSIZE)
8010691b:	77 54                	ja     80106971 <inituvm+0x71>
    panic("inituvm: more than a page");
  mem = kalloc();
8010691d:	e8 6e bb ff ff       	call   80102490 <kalloc>
  memset(mem, 0, PGSIZE);
80106922:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106929:	00 
8010692a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106931:	00 
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
80106932:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106934:	89 04 24             	mov    %eax,(%esp)
80106937:	e8 64 da ff ff       	call   801043a0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
8010693c:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106942:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106947:	89 04 24             	mov    %eax,(%esp)
8010694a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010694d:	31 d2                	xor    %edx,%edx
8010694f:	c7 44 24 04 06 00 00 	movl   $0x6,0x4(%esp)
80106956:	00 
80106957:	e8 b4 fb ff ff       	call   80106510 <mappages>
  memmove(mem, init, sz);
8010695c:	89 75 10             	mov    %esi,0x10(%ebp)
8010695f:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106962:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106965:	83 c4 1c             	add    $0x1c,%esp
80106968:	5b                   	pop    %ebx
80106969:	5e                   	pop    %esi
8010696a:	5f                   	pop    %edi
8010696b:	5d                   	pop    %ebp
  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
  memset(mem, 0, PGSIZE);
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
  memmove(mem, init, sz);
8010696c:	e9 cf da ff ff       	jmp    80104440 <memmove>
inituvm(pde_t *pgdir, char *init, uint sz)
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
80106971:	c7 04 24 ad 76 10 80 	movl   $0x801076ad,(%esp)
80106978:	e8 e3 99 ff ff       	call   80100360 <panic>
8010697d:	8d 76 00             	lea    0x0(%esi),%esi

80106980 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80106980:	55                   	push   %ebp
80106981:	89 e5                	mov    %esp,%ebp
80106983:	57                   	push   %edi
80106984:	56                   	push   %esi
80106985:	53                   	push   %ebx
80106986:	83 ec 1c             	sub    $0x1c,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80106989:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80106990:	0f 85 98 00 00 00    	jne    80106a2e <loaduvm+0xae>
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80106996:	8b 75 18             	mov    0x18(%ebp),%esi
80106999:	31 db                	xor    %ebx,%ebx
8010699b:	85 f6                	test   %esi,%esi
8010699d:	75 1a                	jne    801069b9 <loaduvm+0x39>
8010699f:	eb 77                	jmp    80106a18 <loaduvm+0x98>
801069a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801069a8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801069ae:	81 ee 00 10 00 00    	sub    $0x1000,%esi
801069b4:	39 5d 18             	cmp    %ebx,0x18(%ebp)
801069b7:	76 5f                	jbe    80106a18 <loaduvm+0x98>
801069b9:	8b 55 0c             	mov    0xc(%ebp),%edx
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801069bc:	31 c9                	xor    %ecx,%ecx
801069be:	8b 45 08             	mov    0x8(%ebp),%eax
801069c1:	01 da                	add    %ebx,%edx
801069c3:	e8 b8 fa ff ff       	call   80106480 <walkpgdir>
801069c8:	85 c0                	test   %eax,%eax
801069ca:	74 56                	je     80106a22 <loaduvm+0xa2>
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
801069cc:	8b 00                	mov    (%eax),%eax
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
801069ce:	bf 00 10 00 00       	mov    $0x1000,%edi
801069d3:	8b 4d 14             	mov    0x14(%ebp),%ecx
  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
801069d6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
801069db:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
801069e1:	0f 42 fe             	cmovb  %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
801069e4:	05 00 00 00 80       	add    $0x80000000,%eax
801069e9:	89 44 24 04          	mov    %eax,0x4(%esp)
801069ed:	8b 45 10             	mov    0x10(%ebp),%eax
801069f0:	01 d9                	add    %ebx,%ecx
801069f2:	89 7c 24 0c          	mov    %edi,0xc(%esp)
801069f6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
801069fa:	89 04 24             	mov    %eax,(%esp)
801069fd:	e8 3e af ff ff       	call   80101940 <readi>
80106a02:	39 f8                	cmp    %edi,%eax
80106a04:	74 a2                	je     801069a8 <loaduvm+0x28>
      return -1;
  }
  return 0;
}
80106a06:	83 c4 1c             	add    $0x1c,%esp
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
80106a09:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return 0;
}
80106a0e:	5b                   	pop    %ebx
80106a0f:	5e                   	pop    %esi
80106a10:	5f                   	pop    %edi
80106a11:	5d                   	pop    %ebp
80106a12:	c3                   	ret    
80106a13:	90                   	nop
80106a14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106a18:	83 c4 1c             	add    $0x1c,%esp
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
80106a1b:	31 c0                	xor    %eax,%eax
}
80106a1d:	5b                   	pop    %ebx
80106a1e:	5e                   	pop    %esi
80106a1f:	5f                   	pop    %edi
80106a20:	5d                   	pop    %ebp
80106a21:	c3                   	ret    

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
80106a22:	c7 04 24 c7 76 10 80 	movl   $0x801076c7,(%esp)
80106a29:	e8 32 99 ff ff       	call   80100360 <panic>
{
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
80106a2e:	c7 04 24 68 77 10 80 	movl   $0x80107768,(%esp)
80106a35:	e8 26 99 ff ff       	call   80100360 <panic>
80106a3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106a40 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80106a40:	55                   	push   %ebp
80106a41:	89 e5                	mov    %esp,%ebp
80106a43:	57                   	push   %edi
80106a44:	56                   	push   %esi
80106a45:	53                   	push   %ebx
80106a46:	83 ec 1c             	sub    $0x1c,%esp
80106a49:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
80106a4c:	85 ff                	test   %edi,%edi
80106a4e:	0f 88 7e 00 00 00    	js     80106ad2 <allocuvm+0x92>
    return 0;
  if(newsz < oldsz)
80106a54:	3b 7d 0c             	cmp    0xc(%ebp),%edi
    return oldsz;
80106a57:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
    return 0;
  if(newsz < oldsz)
80106a5a:	72 78                	jb     80106ad4 <allocuvm+0x94>
    return oldsz;

  a = PGROUNDUP(oldsz);
80106a5c:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80106a62:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
80106a68:	39 df                	cmp    %ebx,%edi
80106a6a:	77 4a                	ja     80106ab6 <allocuvm+0x76>
80106a6c:	eb 72                	jmp    80106ae0 <allocuvm+0xa0>
80106a6e:	66 90                	xchg   %ax,%ax
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
80106a70:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106a77:	00 
80106a78:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106a7f:	00 
80106a80:	89 04 24             	mov    %eax,(%esp)
80106a83:	e8 18 d9 ff ff       	call   801043a0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106a88:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106a8e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106a93:	89 04 24             	mov    %eax,(%esp)
80106a96:	8b 45 08             	mov    0x8(%ebp),%eax
80106a99:	89 da                	mov    %ebx,%edx
80106a9b:	c7 44 24 04 06 00 00 	movl   $0x6,0x4(%esp)
80106aa2:	00 
80106aa3:	e8 68 fa ff ff       	call   80106510 <mappages>
80106aa8:	85 c0                	test   %eax,%eax
80106aaa:	78 44                	js     80106af0 <allocuvm+0xb0>
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80106aac:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106ab2:	39 df                	cmp    %ebx,%edi
80106ab4:	76 2a                	jbe    80106ae0 <allocuvm+0xa0>
    mem = kalloc();
80106ab6:	e8 d5 b9 ff ff       	call   80102490 <kalloc>
    if(mem == 0){
80106abb:	85 c0                	test   %eax,%eax
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
80106abd:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80106abf:	75 af                	jne    80106a70 <allocuvm+0x30>
      cprintf("allocuvm out of memory\n");
80106ac1:	c7 04 24 e5 76 10 80 	movl   $0x801076e5,(%esp)
80106ac8:	e8 83 9b ff ff       	call   80100650 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80106acd:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106ad0:	77 48                	ja     80106b1a <allocuvm+0xda>
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
      return 0;
80106ad2:	31 c0                	xor    %eax,%eax
    }
  }
  return newsz;
}
80106ad4:	83 c4 1c             	add    $0x1c,%esp
80106ad7:	5b                   	pop    %ebx
80106ad8:	5e                   	pop    %esi
80106ad9:	5f                   	pop    %edi
80106ada:	5d                   	pop    %ebp
80106adb:	c3                   	ret    
80106adc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106ae0:	83 c4 1c             	add    $0x1c,%esp
80106ae3:	89 f8                	mov    %edi,%eax
80106ae5:	5b                   	pop    %ebx
80106ae6:	5e                   	pop    %esi
80106ae7:	5f                   	pop    %edi
80106ae8:	5d                   	pop    %ebp
80106ae9:	c3                   	ret    
80106aea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
80106af0:	c7 04 24 fd 76 10 80 	movl   $0x801076fd,(%esp)
80106af7:	e8 54 9b ff ff       	call   80100650 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80106afc:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106aff:	76 0d                	jbe    80106b0e <allocuvm+0xce>
80106b01:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106b04:	89 fa                	mov    %edi,%edx
80106b06:	8b 45 08             	mov    0x8(%ebp),%eax
80106b09:	e8 82 fa ff ff       	call   80106590 <deallocuvm.part.0>
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
80106b0e:	89 34 24             	mov    %esi,(%esp)
80106b11:	e8 ca b7 ff ff       	call   801022e0 <kfree>
      return 0;
80106b16:	31 c0                	xor    %eax,%eax
80106b18:	eb ba                	jmp    80106ad4 <allocuvm+0x94>
80106b1a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106b1d:	89 fa                	mov    %edi,%edx
80106b1f:	8b 45 08             	mov    0x8(%ebp),%eax
80106b22:	e8 69 fa ff ff       	call   80106590 <deallocuvm.part.0>
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
80106b27:	31 c0                	xor    %eax,%eax
80106b29:	eb a9                	jmp    80106ad4 <allocuvm+0x94>
80106b2b:	90                   	nop
80106b2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106b30 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80106b30:	55                   	push   %ebp
80106b31:	89 e5                	mov    %esp,%ebp
80106b33:	8b 55 0c             	mov    0xc(%ebp),%edx
80106b36:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106b39:	8b 45 08             	mov    0x8(%ebp),%eax
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80106b3c:	39 d1                	cmp    %edx,%ecx
80106b3e:	73 08                	jae    80106b48 <deallocuvm+0x18>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106b40:	5d                   	pop    %ebp
80106b41:	e9 4a fa ff ff       	jmp    80106590 <deallocuvm.part.0>
80106b46:	66 90                	xchg   %ax,%ax
80106b48:	89 d0                	mov    %edx,%eax
80106b4a:	5d                   	pop    %ebp
80106b4b:	c3                   	ret    
80106b4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106b50 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106b50:	55                   	push   %ebp
80106b51:	89 e5                	mov    %esp,%ebp
80106b53:	56                   	push   %esi
80106b54:	53                   	push   %ebx
80106b55:	83 ec 10             	sub    $0x10,%esp
80106b58:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80106b5b:	85 f6                	test   %esi,%esi
80106b5d:	74 59                	je     80106bb8 <freevm+0x68>
80106b5f:	31 c9                	xor    %ecx,%ecx
80106b61:	ba 00 00 00 80       	mov    $0x80000000,%edx
80106b66:	89 f0                	mov    %esi,%eax
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106b68:	31 db                	xor    %ebx,%ebx
80106b6a:	e8 21 fa ff ff       	call   80106590 <deallocuvm.part.0>
80106b6f:	eb 12                	jmp    80106b83 <freevm+0x33>
80106b71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106b78:	83 c3 01             	add    $0x1,%ebx
80106b7b:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
80106b81:	74 27                	je     80106baa <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80106b83:	8b 14 9e             	mov    (%esi,%ebx,4),%edx
80106b86:	f6 c2 01             	test   $0x1,%dl
80106b89:	74 ed                	je     80106b78 <freevm+0x28>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106b8b:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106b91:	83 c3 01             	add    $0x1,%ebx
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106b94:	81 c2 00 00 00 80    	add    $0x80000000,%edx
      kfree(v);
80106b9a:	89 14 24             	mov    %edx,(%esp)
80106b9d:	e8 3e b7 ff ff       	call   801022e0 <kfree>
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106ba2:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
80106ba8:	75 d9                	jne    80106b83 <freevm+0x33>
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80106baa:	89 75 08             	mov    %esi,0x8(%ebp)
}
80106bad:	83 c4 10             	add    $0x10,%esp
80106bb0:	5b                   	pop    %ebx
80106bb1:	5e                   	pop    %esi
80106bb2:	5d                   	pop    %ebp
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80106bb3:	e9 28 b7 ff ff       	jmp    801022e0 <kfree>
freevm(pde_t *pgdir)
{
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
80106bb8:	c7 04 24 19 77 10 80 	movl   $0x80107719,(%esp)
80106bbf:	e8 9c 97 ff ff       	call   80100360 <panic>
80106bc4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106bca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106bd0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106bd0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106bd1:	31 c9                	xor    %ecx,%ecx

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106bd3:	89 e5                	mov    %esp,%ebp
80106bd5:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106bd8:	8b 55 0c             	mov    0xc(%ebp),%edx
80106bdb:	8b 45 08             	mov    0x8(%ebp),%eax
80106bde:	e8 9d f8 ff ff       	call   80106480 <walkpgdir>
  if(pte == 0)
80106be3:	85 c0                	test   %eax,%eax
80106be5:	74 05                	je     80106bec <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80106be7:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80106bea:	c9                   	leave  
80106beb:	c3                   	ret    
{
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80106bec:	c7 04 24 2a 77 10 80 	movl   $0x8010772a,(%esp)
80106bf3:	e8 68 97 ff ff       	call   80100360 <panic>
80106bf8:	90                   	nop
80106bf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106c00 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80106c00:	55                   	push   %ebp
80106c01:	89 e5                	mov    %esp,%ebp
80106c03:	57                   	push   %edi
80106c04:	56                   	push   %esi
80106c05:	53                   	push   %ebx
80106c06:	83 ec 2c             	sub    $0x2c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80106c09:	e8 62 fb ff ff       	call   80106770 <setupkvm>
80106c0e:	85 c0                	test   %eax,%eax
80106c10:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106c13:	0f 84 b2 00 00 00    	je     80106ccb <copyuvm+0xcb>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106c19:	8b 45 0c             	mov    0xc(%ebp),%eax
80106c1c:	85 c0                	test   %eax,%eax
80106c1e:	0f 84 9c 00 00 00    	je     80106cc0 <copyuvm+0xc0>
80106c24:	31 db                	xor    %ebx,%ebx
80106c26:	eb 48                	jmp    80106c70 <copyuvm+0x70>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80106c28:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80106c2e:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106c35:	00 
80106c36:	89 7c 24 04          	mov    %edi,0x4(%esp)
80106c3a:	89 04 24             	mov    %eax,(%esp)
80106c3d:	e8 fe d7 ff ff       	call   80104440 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80106c42:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106c45:	8d 96 00 00 00 80    	lea    -0x80000000(%esi),%edx
80106c4b:	89 14 24             	mov    %edx,(%esp)
80106c4e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106c53:	89 da                	mov    %ebx,%edx
80106c55:	89 44 24 04          	mov    %eax,0x4(%esp)
80106c59:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106c5c:	e8 af f8 ff ff       	call   80106510 <mappages>
80106c61:	85 c0                	test   %eax,%eax
80106c63:	78 41                	js     80106ca6 <copyuvm+0xa6>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106c65:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106c6b:	39 5d 0c             	cmp    %ebx,0xc(%ebp)
80106c6e:	76 50                	jbe    80106cc0 <copyuvm+0xc0>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80106c70:	8b 45 08             	mov    0x8(%ebp),%eax
80106c73:	31 c9                	xor    %ecx,%ecx
80106c75:	89 da                	mov    %ebx,%edx
80106c77:	e8 04 f8 ff ff       	call   80106480 <walkpgdir>
80106c7c:	85 c0                	test   %eax,%eax
80106c7e:	74 5b                	je     80106cdb <copyuvm+0xdb>
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
80106c80:	8b 30                	mov    (%eax),%esi
80106c82:	f7 c6 01 00 00 00    	test   $0x1,%esi
80106c88:	74 45                	je     80106ccf <copyuvm+0xcf>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80106c8a:	89 f7                	mov    %esi,%edi
    flags = PTE_FLAGS(*pte);
80106c8c:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
80106c92:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80106c95:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
80106c9b:	e8 f0 b7 ff ff       	call   80102490 <kalloc>
80106ca0:	85 c0                	test   %eax,%eax
80106ca2:	89 c6                	mov    %eax,%esi
80106ca4:	75 82                	jne    80106c28 <copyuvm+0x28>
      goto bad;
  }
  return d;

bad:
  freevm(d);
80106ca6:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106ca9:	89 04 24             	mov    %eax,(%esp)
80106cac:	e8 9f fe ff ff       	call   80106b50 <freevm>
  return 0;
80106cb1:	31 c0                	xor    %eax,%eax
}
80106cb3:	83 c4 2c             	add    $0x2c,%esp
80106cb6:	5b                   	pop    %ebx
80106cb7:	5e                   	pop    %esi
80106cb8:	5f                   	pop    %edi
80106cb9:	5d                   	pop    %ebp
80106cba:	c3                   	ret    
80106cbb:	90                   	nop
80106cbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106cc0:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106cc3:	83 c4 2c             	add    $0x2c,%esp
80106cc6:	5b                   	pop    %ebx
80106cc7:	5e                   	pop    %esi
80106cc8:	5f                   	pop    %edi
80106cc9:	5d                   	pop    %ebp
80106cca:	c3                   	ret    
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
80106ccb:	31 c0                	xor    %eax,%eax
80106ccd:	eb e4                	jmp    80106cb3 <copyuvm+0xb3>
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
80106ccf:	c7 04 24 4e 77 10 80 	movl   $0x8010774e,(%esp)
80106cd6:	e8 85 96 ff ff       	call   80100360 <panic>

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
80106cdb:	c7 04 24 34 77 10 80 	movl   $0x80107734,(%esp)
80106ce2:	e8 79 96 ff ff       	call   80100360 <panic>
80106ce7:	89 f6                	mov    %esi,%esi
80106ce9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106cf0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80106cf0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106cf1:	31 c9                	xor    %ecx,%ecx

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80106cf3:	89 e5                	mov    %esp,%ebp
80106cf5:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106cf8:	8b 55 0c             	mov    0xc(%ebp),%edx
80106cfb:	8b 45 08             	mov    0x8(%ebp),%eax
80106cfe:	e8 7d f7 ff ff       	call   80106480 <walkpgdir>
  if((*pte & PTE_P) == 0)
80106d03:	8b 00                	mov    (%eax),%eax
80106d05:	89 c2                	mov    %eax,%edx
80106d07:	83 e2 05             	and    $0x5,%edx
    return 0;
  if((*pte & PTE_U) == 0)
80106d0a:	83 fa 05             	cmp    $0x5,%edx
80106d0d:	75 11                	jne    80106d20 <uva2ka+0x30>
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
80106d0f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106d14:	05 00 00 00 80       	add    $0x80000000,%eax
}
80106d19:	c9                   	leave  
80106d1a:	c3                   	ret    
80106d1b:	90                   	nop
80106d1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
80106d20:	31 c0                	xor    %eax,%eax
  return (char*)P2V(PTE_ADDR(*pte));
}
80106d22:	c9                   	leave  
80106d23:	c3                   	ret    
80106d24:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106d2a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106d30 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80106d30:	55                   	push   %ebp
80106d31:	89 e5                	mov    %esp,%ebp
80106d33:	57                   	push   %edi
80106d34:	56                   	push   %esi
80106d35:	53                   	push   %ebx
80106d36:	83 ec 1c             	sub    $0x1c,%esp
80106d39:	8b 5d 14             	mov    0x14(%ebp),%ebx
80106d3c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106d3f:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80106d42:	85 db                	test   %ebx,%ebx
80106d44:	75 3a                	jne    80106d80 <copyout+0x50>
80106d46:	eb 68                	jmp    80106db0 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80106d48:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106d4b:	89 f2                	mov    %esi,%edx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80106d4d:	89 7c 24 04          	mov    %edi,0x4(%esp)
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80106d51:	29 ca                	sub    %ecx,%edx
80106d53:	81 c2 00 10 00 00    	add    $0x1000,%edx
80106d59:	39 da                	cmp    %ebx,%edx
80106d5b:	0f 47 d3             	cmova  %ebx,%edx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80106d5e:	29 f1                	sub    %esi,%ecx
80106d60:	01 c8                	add    %ecx,%eax
80106d62:	89 54 24 08          	mov    %edx,0x8(%esp)
80106d66:	89 04 24             	mov    %eax,(%esp)
80106d69:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80106d6c:	e8 cf d6 ff ff       	call   80104440 <memmove>
    len -= n;
    buf += n;
80106d71:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    va = va0 + PGSIZE;
80106d74:	8d 8e 00 10 00 00    	lea    0x1000(%esi),%ecx
    n = PGSIZE - (va - va0);
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
80106d7a:	01 d7                	add    %edx,%edi
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80106d7c:	29 d3                	sub    %edx,%ebx
80106d7e:	74 30                	je     80106db0 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
80106d80:	8b 45 08             	mov    0x8(%ebp),%eax
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
80106d83:	89 ce                	mov    %ecx,%esi
80106d85:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80106d8b:	89 74 24 04          	mov    %esi,0x4(%esp)
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
80106d8f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
80106d92:	89 04 24             	mov    %eax,(%esp)
80106d95:	e8 56 ff ff ff       	call   80106cf0 <uva2ka>
    if(pa0 == 0)
80106d9a:	85 c0                	test   %eax,%eax
80106d9c:	75 aa                	jne    80106d48 <copyout+0x18>
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
80106d9e:	83 c4 1c             	add    $0x1c,%esp
  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
80106da1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
80106da6:	5b                   	pop    %ebx
80106da7:	5e                   	pop    %esi
80106da8:	5f                   	pop    %edi
80106da9:	5d                   	pop    %ebp
80106daa:	c3                   	ret    
80106dab:	90                   	nop
80106dac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106db0:	83 c4 1c             	add    $0x1c,%esp
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
80106db3:	31 c0                	xor    %eax,%eax
}
80106db5:	5b                   	pop    %ebx
80106db6:	5e                   	pop    %esi
80106db7:	5f                   	pop    %edi
80106db8:	5d                   	pop    %ebp
80106db9:	c3                   	ret    
