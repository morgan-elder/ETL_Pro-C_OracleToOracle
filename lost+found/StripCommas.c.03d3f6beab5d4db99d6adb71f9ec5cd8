#include <string.h>
#include <stdlib.h>

void StripCommas(char *str,int length)
{
    char temp[51];
    int i,j;
    memset(temp,' ',50);
    for(i = length-1, j = length-1; i >= 0; i--)
    {
        if(str[i] != ',')
        {
            temp[j] = str[i];
            j--;
        }
       
    }
    strncpy(str,temp,length);
}
