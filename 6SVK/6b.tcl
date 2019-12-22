set ns [new Simulator]

set tf [open 6b.tr w]
$ns trace-all $tf

set nf [open 6b.nam w]
$ns namtrace-all $nf

proc finish {} {
	global ns nf tf
	$ns flush-trace

	close $nf
	close $tf

	exec awk -f 6b.awk 6b.tr &
	exec nam 6b.nam &
	exit 0
}

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]


$ns duplex-link $n0 $n2 2Mb 10ms DropTail
$ns duplex-link $n1 $n2 2Mb 10ms DropTail
$ns duplex-link $n2 $n3 0.3Mb 100ms DropTail

set lan [$ns newLan "$n3 $n4 $n5" 0.5Mb 40ms LL Queue/DropTail MAC/802_3 Channel]

set tcp0 [new Agent/TCP]
$ns attach-agent $n0 $tcp0

set sink40 [new Agent/TCPSink]
$ns attach-agent $n4 $sink40
$ns connect $tcp0 $sink40

set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0

set udp1 [new Agent/UDP]
$ns attach-agent $n1 $udp1

set null51 [new Agent/Null]
$ns attach-agent $n5 $null51
$ns connect $udp1 $null51

set cbr1 [new Application/Traffic/CBR]
$cbr1 attach-agent $udp1

set err [new ErrorModel]
$err set rate_ 0.1 #change rate to 0.1 so on for xgraph
$ns lossmodel $err $n2 $n3

$ns at 0.1 "$cbr1 start"
$ns at 1.0 "$ftp0 start"
$ns at 124.0 "$ftp0 stop"
$ns at 124.5 "$cbr1 stop"
$ns at 125.0 "finish"

$ns run