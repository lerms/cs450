#include "types.h"
#include "user.h"

struct test {
	int a;
	int arr[50];
};

void test(int testsize) {
	int i;
	for(i = 0; i < 1000 * testsize; i++) {
		struct test *x = (struct test *)malloc(sizeof(struct test));
		x->a = (int)malloc(sizeof(int));
		memset(x->arr, 0, sizeof(x->arr));
	}
}

int main(int argc, char **argv) {
	printf(1, "Initial Memory Status: \n");
	memcount();
	test(5);
	printf(1, "Final Memory Status: \n");
	memcount();
	exit();
}