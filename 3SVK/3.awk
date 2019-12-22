BEGIN {
	tcpsent=0;
	udpsent=0;
	tcpr=0;
	udpr=0;
}
{
	event=$1;
	pkttype=$5;
	if(pkttype=="tcp")
	{
	tcpsent++;
	}
	if(pkttype=="cbr")
	{
	udpsent++;
	}
	if(pkttype=="tcp" && event=="r" )
	{
	tcpr++;
	}
	if(pkttype=="cbr" && event=="r" )
	{
	udpr++;
	}
}
END {
	printf("\nTCP SENT %d \n",tcpsent);
	printf("udp SENT %d \n",udpsent);
	printf("TCP REC %d \n",tcpr);
	printf("udp REC %d \n",udpr);


}