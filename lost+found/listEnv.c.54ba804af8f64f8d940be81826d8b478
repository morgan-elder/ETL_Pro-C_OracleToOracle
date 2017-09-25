#include <stdio.h>
extern char **environ;

void main()
{
    char **env;
    for (env = environ; *env; ++env)
        printf("%s\n", *env);
}
