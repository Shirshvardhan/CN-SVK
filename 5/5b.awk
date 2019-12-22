BEGIN{
 count=0;
}
{
 event=$1;
 if (event=="d")
 {count++;}
}
END{
 printf("the no of packts dropped %d\n ",count)
}
