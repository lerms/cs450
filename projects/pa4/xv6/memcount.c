#include "types.h"
#include "user.h"
#define INT_MAX 2147483647

struct test {
	int a;
	int arr[50];
};

void test(int testsize) {
	int size = sizeof(struct test) * testsize;
	printf(1,"Allocated a pointer to test struct of size  %d\n", size);
	struct test *x = (struct test *)malloc(size);
	x->a = INT_MAX;
}

int main(int argc, char **argv) {
	int testsize = atoi(argv[1]);
	if(testsize == 0) {
		exit();
	}
	printf(1, "Test size: %d\n", testsize);
	printf(1, "Initial Memory Status:\n");
	memcount();
	test(testsize);
	printf(1, "Final Memory Status:\n");
	memcount();
	exit();
}