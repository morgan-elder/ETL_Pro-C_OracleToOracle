#include <sys/types.h>
#include <sys/socket.h>
#include <netdb.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>

#ifdef WIN32
    #include <Windows.h>
    #include <tchar.h>
#else
    #include <unistd.h>
#endif

void __GetMachineName(char* machineName)
{
    char Name[150];
    int i=0;

    #ifdef WIN32
        TCHAR infoBuf[150];
        DWORD bufCharCount = 150;
        memset(Name, 0, 150);
        if( GetComputerName( infoBuf, &bufCharCount ) )
        {
            for(i=0; i<150; i++)
            {
                Name[i] = infoBuf[i];
            }
        }
        else
        {
            strcpy(Name, "Unknown_Host_Name");
        }
    #else
        memset(Name, 0, 150);
        gethostname(Name, 150);
    #endif
    strncpy(machineName,Name, 150);
}


char *getHostname() {
  struct addrinfo hints, *info, *p;
  int gai_result;
  static char hostname[1024] ;

  hostname[1023] = '\0';
  gethostname(hostname, 1023);

  memset(&hints, 0, sizeof hints);
  hints.ai_family = AF_UNSPEC; /*either IPV4 or IPV6*/
  hints.ai_socktype = SOCK_STREAM;
  hints.ai_flags = AI_CANONNAME;

  if ((gai_result = getaddrinfo(hostname, "http", &hints, &info)) != 0) {
      fprintf(stderr, "getaddrinfo: %s\n", gai_strerror(gai_result));
      exit(1);
  }
  printf("hostname=%s\n", hostname) ;
  for(p = info; p != NULL; p = p->ai_next) {
      if (p->ai_canonname != NULL) {
        printf("hostname: %s\n", p->ai_canonname);
      } 
  }

  freeaddrinfo(info);
  return hostname ;
}
int main(int argc, char **argv) {
  char machine_name[151] ;

  printf("hostname=%s\n", getHostname()) ;
  __GetMachineName(machine_name) ;
  printf("machine_name=%s\n", machine_name) ;
}
