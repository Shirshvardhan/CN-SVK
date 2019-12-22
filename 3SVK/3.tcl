set ns [new Simulator]
set nf [open prog3.nam w]
$ns namtrace-all $nf
set tf [open prog3.tr w]
$ns trace-all $tf



proc finish {} {
	global ns nf tf
	$ns flush-trace
	close $nf
	close $tf

	exec nam prog3.nam &
	exec awk -f 3.awk prog3.tr &
	exit 0
}

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]

$ns duplex-link $n0 $n2 10Mb 10ms DropTail
$ns duplex-link $n1 $n2 10Mb 10ms DropTail
$ns duplex-link $n2 $n3 4Mb 10ms DropTail

#$ns queue-limit $n2 $n3 10

#TCP-0 connect sink-3 FTP on TCP

set tcp0 [new Agent/TCP]
$ns attach-agent $n0 $tcp0

set sink30 [new Agent/TCPSink]
$ns attach-agent $n3 $sink30

$ns connect $tcp0 $sink30

set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0

$ns color 1 Red

#UDP-1 connect Sink-3 CBR on UDP
set udp1 [new Agent/UDP]
$ns attach-agent $n1 $udp1

set null31 [new Agent/Null]
$ns attach-agent $n3 $null31

$ns connect $udp1 $null31

set cbr1 [new Application/Traffic/CBR]

$cbr1 attach-agent $udp1

$ns at 0.1 "$ftp0 start"
$ns at 0.2 "$cbr1 start"
$ns at 4.4 "$ftp0 stop"
$ns at 4.5 "$cbr1 stop"
$ns at 5.0 "finish"
$ns run






