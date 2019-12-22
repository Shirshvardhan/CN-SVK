set ns [new Simulator]

set tf [open 5b.tr w]
$ns trace-all $tf

set nf [open ex5.nam w]
$ns namtrace-all $nf

proc finish {} {
global ns tf nf
$ns flush-trace

close $tf
close $nf

exec awk -f 5b.awk 5b.tr &
exec nam ex5.nam 
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

set lan [$ns newLan "$n3 $n4 $n5" 0.5Mb 40ms LL Queue/DropTail MAC/Csma/CdChannel]

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

$ns at 0.3 "$cbr1 start"
$ns at 0.8 "$ftp0 start"
$ns at 7.0 "$cbr1 stop"
$ns at 7.5 "$ftp0 stop"
$ns at 8.0 "finish"

$ns run
