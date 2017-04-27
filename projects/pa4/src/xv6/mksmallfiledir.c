#include "types.h"
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
    int i;

    if(argc < 2){
        printf(2, "Usage: mksmallfiledir files...\n");
        exit();
    }

    for(i = 1; i < argc; i++){
        if(mkSmallFileDir(argv[i]) < 0){
            printf(2, "mksmallfiledir: %s failed to create\n", argv[i]);
            break;
        }
    }

    exit();
}
