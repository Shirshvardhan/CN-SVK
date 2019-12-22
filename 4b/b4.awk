BEGIN{
 count=0;
}

{
 event=$1;
 if(event=="d"){
   count++;
 }
}

END{
 printf("No of pakets dropped : %d\n",count);
}
