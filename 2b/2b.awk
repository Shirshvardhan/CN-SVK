BEGIN{
 tcpsize1=0;
 numtcp1=0;
 tcpsize2=0;
 numtcp2=0;
 totaltcp1=0;
 totaltcp2=0;
}

{
 event=$1;
 pkttyp=$5;
 pktsize=$6;
 fromnode=$9;
 tonode=$10;
 if(pkttyp=="tcp" && fromnode=="0.0" && tonode=="3.0" && event=="r"){
  numtcp1++;
  tcpsize1=pktsize;
 }
 if(pkttyp=="tcp" && fromnode=="1.0" && tonode=="3.1" && event=="r"){
  numtcp2++;
  tcpsize2=pktsize;
 }
}

END{
 totaltcp1= numtcp1*tcpsize1*8;
 totaltcp2= numtcp2*tcpsize2*8;
 tp1=totaltcp1/24;
 tp2=totaltcp2/24;
printf(" %d %d %d %d ",numtcp1,numtcp2,tcpsize2,tcpsize1);
printf("The Throughput of FTP application is %d \n", tp1);
printf("The Throughput of TELNET application is %d \n", tp2);
}
