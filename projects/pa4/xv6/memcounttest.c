#include "types.h"
#include "user.h"

static int run_all() {
	char *testsizes[] = {"1", "10", "100", "1000", "10000","50000", "100000", "500000" ,"1000000", "10000000"};
	int n_sizes = 10;
	int i;
	for(i = 0; i < n_sizes; i++) {
		if (fork() == 0) {
			exec("./memcount", &(testsizes[i]));
		}
		wait();
	}
	return 0;
}

int main(int argc, char **argv) {
	run_all();
	exit();
}