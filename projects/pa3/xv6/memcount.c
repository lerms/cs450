#include "types.h"
#include "user.h"

struct test {
	int a;
	int arr[50];
};

void test(int testsize) {
	int i;
	for(i = 0; i < testsize; i++) {
		struct test *x = (struct test *)malloc(sizeof(struct test));
		x->a = (int)malloc(sizeof(int));
		memset(x->arr, 0, sizeof(x->arr));
	}
}

int main(int argc, char **argv) {
	int testsize = atoi(argv[1]);
	if(testsize == 0) {
<<<<<<< HEAD
		printf(1, "Did not enter testsize, defaulting to testsize = 10 (10 structs will be allocated) \n");
=======
		printf(1, "Did not enter testsize, defaulting to testsize = 10 (10 structs will be allocated)\n");
>>>>>>> 1bc5798bd453e971598b331783779647c64dacc3
		testsize = 10;
	}
	printf(1, "Test size: %d\n", testsize);
	printf(1, "Initial Memory Status: \n");
	memcount();
	test(testsize);
	printf(1, "Final Memory Status: \n");
	memcount();
	exit();
}