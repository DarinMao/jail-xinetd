#include <stdio.h>
#include <stdlib.h>
#include <grp.h>
#include <unistd.h>

#define DIE(message) do { \
  perror(message); exit(EXIT_FAILURE); \
} while (0)

int main() {
  if (chroot("/srv") == -1)
    DIE("chroot");
  if (chdir("/app") == -1)
    DIE("chdir");
  if (setgroups(0, NULL) == -1)
    DIE("setgroups");
  if (setgid(1000) == -1)
    DIE("setgid");
  if (setuid(1000) == -1)
    DIE("setuid");
  if (execle("/app/run", "/app/run", NULL, NULL) == -1)
    DIE("exec");
}
