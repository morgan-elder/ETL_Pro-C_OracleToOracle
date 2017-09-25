/* vim: ts=2:sw=2:sts=2:et:syntax=c: */
#include <stdio.h>
#include "varcharSetup.h" 
#define GET_INT getInt
#define PRINT_INT printInt
#define GET_FLOAT getFloat
#define PRINT_FLOAT printFlot

struct varchar {
	unsigned short len;
	unsigned char arr[25];
} ;

struct varchar2 {
	unsigned short len;
	unsigned char arr[10];
} ;




int main(int argc, char **argv) {
	int i = 0 ;
	short x_i = 1 ;
	int x_int = 0 ;
	struct varchar x;
	struct varchar2 dse ;
  short dse_i;
  int dse_int;
	struct varchar2 dsef ;
  short dsef_i = 0 ;
  float dsef_float = 0 ;
  char stuff = 'q';
  char stuff_src = 'x';
  short stuff_i =  1;

  struct interface intf[] = {
    INTFN(x,"this is it"),
    INTF(x,"stuff"),
    INTFI(x,"2"),
    INTFN(x,""),
    INTF(dse,"Douglas S. Elder"),
    INTF(dse,"Jill E. Elder"),
    INTFI(dse,""),
    INTFI(dse,"Interface"),
    INTFN(dse,"Junk"),
    INTFF(dsef,"2.3"),
    INTFC(stuff,stuff_src),
    { }
  } ;


	printf("testVarcharSetup\n") ;

  printf("&stuff=%x\n", &stuff) ;
  printf("stuff=%c\n", stuff) ;
  printf("sizeof(dse.arr)=%d\n", sizeof(dse.arr));

  i = INITVCHAR(x);
  DUMPVCHAR(x) ;
  i = INITVCHAR(dse);
  DUMPVCHAR(dse);
  i = SETVCHAR(dse,"This is a test") ;
  PVCHAR(dse) ;
  i = varcharSetup(x.arr, sizeof(x.arr), &x.len, "stuff", NULL, NULL, NULL);
  PVCHAR(x);
  i = varcharSetup(x.arr, sizeof(x.arr), &x.len, "2", &x_i, &x_int, getInt);
	printf("i=%d x.len=%d x.arr=%s ind=%d num=%d\n", i, x.len, x.arr,
		x_i, x_int) ;
	x_int = 0;
  i = varcharSetup(x.arr, sizeof(x.arr), &x.len, "", &x_i, &x_int, getInt);
	printf("i=%d x.len=%d x.arr=%s ind=%d num=%d\n", i, x.len, x.arr,
		x_i, x_int) ;
  int indx = 0 ;
  for (indx = 0; intf[indx].arr != NULL; indx++) {
    x_i = 1 ;
    x_int = 0 ;
    dse_i = 1 ;
    dse_int = 0 ;
    dsef_i = 1 ;
    dsef_float = 0.0;
	  i = varcharSetup(intf[indx].arr, intf[indx].size, 
          intf[indx].len, intf[indx].src, intf[indx].ind, intf[indx].num, intf[indx].f);
    if (i > 1)
      printf("i=%d x.len=%d x.arr=%s ", i, (*intf[indx].len), intf[indx].arr) ;
    else if (i == 1)
      printf("i=%d x.arr=%c ", i,  (*intf[indx].arr)) ;
    else if (i == 0)
      printf("i=%d x.arr=NULL ", i) ;
    if (intf[indx].ind == NULL)
      printf("ind=NULL ") ;
    else
      printf("ind=%d ",(*intf[indx].ind)) ;
    if (intf[indx].pf != NULL) {
      printf("num=") ;
      intf[indx].pf(intf[indx].num);
    }
    printf("\n") ;
  }
  for (indx = 0; intf[indx].arr != NULL; indx++) {
    x_i = 1 ;
    x_int = 0 ;
    dse_i = 1 ;
    dse_int = 0 ;
	  i = varcharSetup2(&intf[indx]) ;
    printf("name=%s ", intf[indx].name) ;
    if (i > 1)
      printf("i=%d x.len=%d x.arr=%s ", i, (*intf[indx].len), intf[indx].arr) ;
    else if (i == 1)
      printf("i=%d x.arr=%c ", i, (*intf[indx].arr)) ;
    else if (i == 0)
      printf("i=%d x.arr=NULL ", i) ;
    if (intf[indx].ind == NULL)
      printf("ind=NULL ") ;
    else
      printf("ind=%d ",(*intf[indx].ind)) ;
    
    if (intf[indx].num != NULL && intf[indx].pf != NULL) {
      printf("num=") ;
      intf[indx].pf(intf[indx].num);
    }

    printf("\n") ;
  }

  printf("dsef.arr=%s\n", dsef.arr );    
  printf("dsef_i=%d\n", dsef_i) ;    
  printf("dsef_float=%f\n", dsef_float) ;    

  { char str[10] ;
    char stuff[] = "stuff" ;
    STRINIT(str) ;
    printf("str=(%s) strlen(str)=%d\n", str, strlen(str)) ;
    STRSET(str,stuff) ;
    printf("str=%s strlen(str)=%d\n", str, strlen(str)) ;
  } 

  { char buf[80] ;
    STR2SPACES(buf) ;
    printf("strlen(buf)=%d buf=(%s)\n", strlen(buf), buf);
  }

  { char mystr[] = "   Douglas S. Elder         " ;
    char tstr[] = "this is it.       " ;
    char buf[80] ;
    int first = 0 ;
    int last = 0 ;
    int len = 0 ;
    int pos = 0 ;
    memset(buf,' ',sizeof(buf));
    first = getFirstNonBlank(mystr,strlen(mystr)) ;
    printf("first=%d\n", first) ;
    last = getLastNonBlank(mystr, strlen(mystr)) ;
    printf("last=%d\n", last) ;
    len = last - first + 1 ;
    printf("%.*s\n", len, &mystr[first]) ;
    strncpy(buf,&mystr[first],len) ;
    pos = pos + len + 1 ;
    first = getFirstNonBlank(tstr, strlen(tstr)) ;
    printf("first=%d\n", first) ;
    last = getLastNonBlank(tstr, strlen(tstr)) ;
    len = last - first + 1 ;
    printf("last=%d\n", last) ;
    printf("%.*s\n", len, &tstr[first]) ;
    strncpy(&buf[pos], &tstr[first], len) ;
    pos = pos + len ;
    buf[pos] = '\0' ;
    printf("buf=(%s)\n", buf) ;
  }
  { struct myrec {
      char field1[5];
      char field2[10];
      char field3[2];
    } ;
    struct myrec rec ;
    struct myrec rec2 ;
    memset(&rec,' ',sizeof(rec));
    memset(&rec2,' ',sizeof(rec2));

    printf("testVarcharSetup: rec *********************************************\n") ;
    printf("testVarcharSetup: setting rec.field1\n") ;
    RECFLDSET(rec.field1," xyz ") ;
    printf("testVarcharSetup: rec.field1=") ;
    XDUMPCHAR(rec.field1,sizeof(rec.field1));

    printf("\ntestVarcharSetup: setting rec.field2\n") ;
    RECFLDSET(rec.field2,"  5432 ") ;
    printf("testVarcharSetup: rec.field2=") ;
    XDUMPCHAR(rec.field2,sizeof(rec.field2));

    printf("\ntestVarcharSetup: setting rec.field3\n") ;
    RECFLDSET(rec.field3,"") ;
    printf("testVarcharSetup: rec.field3=") ;
    XDUMPCHAR(rec.field3,sizeof(rec.field3));
    printf("\n") ;

    printf("testVarcharSetup: rec2 *********************************************\n") ;
    printf("\ntestVarcharSetup: before rec2.field1=") ;
    XDUMPCHAR(rec2.field1,sizeof(rec2.field1));
    printf("\n") ;
    printf("testVarcharSetup: setting rec2.field1\n") ;
    REC2REC(rec2.field1, rec.field1) ;
    printf("\ntestVarcharSetup: after rec2.field1=") ;
    XDUMPCHAR(rec2.field1,sizeof(rec2.field1));
    printf("\n") ;

    printf("\ntestVarcharSetup: before rec2.field2=") ;
    XDUMPCHAR(rec2.field2,sizeof(rec2.field2));
    printf("\n") ;
    printf("testVarcharSetup: setting rec2.field2\n") ;
    REC2REC(rec2.field2, rec.field2) ;
    printf("\ntestVarcharSetup: after rec2.field2=") ;
    XDUMPCHAR(rec2.field2,sizeof(rec2.field2));
    printf("\n") ;

    printf("\ntestVarcharSetup: before rec2.field3=") ;
    XDUMPCHAR(rec2.field3,sizeof(rec2.field3));
    printf("\n") ;
    printf("testVarcharSetup: setting rec2.field3\n") ;
    REC2REC(rec2.field3, rec.field3) ;
    printf("\ntestVarcharSetup: after rec2.field3=") ;
    XDUMPCHAR(rec2.field3,sizeof(rec2.field3));
    printf("\n") ;

  }

}
