#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"
#include "fs.h"

#define TEST_SIZE 500

static void error(int fd) {
    printf(1, "Failed with result %d\n", fd);
    exit();
}

int main(void) {

    char buf[TEST_SIZE];
    int fd, i;
    int n;


    printf(1, "Starting open and write test with test size %d\n", TEST_SIZE);

    //test open and write with small file set
    for(i = 0; i < TEST_SIZE; i++) {
        if((fd = open("test.txt", O_CREATE | O_SMALL_FILE | O_RDWR)) < 0)
            error(fd);

        if((n = write(fd, &buf[i], 1)) != 1)
            error(n);

        close(fd);
    }


    if((fd = open("test.txt", O_CREATE | O_SMALL_FILE | O_RDWR)) < 0){
        error(fd);
    }

    printf(1, "OPEN & WRITE are both good.\n");

    printf(1, "Starting READ test using the written data\n");

    //test read
    char c;
    if((n = read(fd, &c, 10)) != 1) {
        error(n);
    }
    close(fd);

    if(c != buf[TEST_SIZE-1]) {
        printf(1, "ERROR! char c obtained from READ should == buf[TEST_SIZE-1]\n");
        error(fd);
    }

    printf(1, "READ is good.\n");

    printf(1, "OPEN, READ, and WRITE all pass.\n");
    exit();
}