_______________________________________________________________________________

Creator:Alex Lerma & Sahand Zeinali
_________________________________________________________________________________

What is this?

XV6 along with the callcount and memcount system calls added to it.
_________________________________________________________________________________

How to run the file:


1. Input ls to identify where xv6 is located if not try and find it on the path

2. Once identified input cd xv6

3. Once in the folder, input make clean to make sure the folder is clean

4. Enter make to build xv6

5. Enter make qemu (or make qemu-nox) to run and start qemu

<<<<<<< HEAD
5. Once in qemu, input (either in terminal or qemu) memcounttest to run the test file.
=======
6. Once in qemu, input (either in terminal or qemu) memcounttest to run the test suite. The tests consist of different allocation sizes for a struct until kvmalloc runs out of memory. The test simply runs memcount.c with different arguments. You can input a int into memcount (e.g. memcount 20) to run more.
>>>>>>> 0be3fa625631783fbc23dde8e672ab56e3729564

_________________________________________________________________________________


