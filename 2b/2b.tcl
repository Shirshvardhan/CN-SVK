set ns [new Simulator]

set tf [open 2b.tr w]
$ns trace-all $tf

set nf [open 2b.nam w]
$ns namtrace-all $nf

proc finish { } {
 global ns nf tf
 $ns flush-trace
 close $nf
 close $tf 

 exec awk -f 2b.awk 2b.tr &
 exec nam 2b.nam
 exit 0
}

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]

$ns color 1 Red

$ns duplex-link $n0 $n2 2Mb 10ms DropTail
$ns duplex-link $n1 $n2 2Mb 10ms DropTail
$ns duplex-link $n2 $n3 1Mb 10ms DropTail

set tcp0 [new Agent/TCP]
$ns attach-agent $n0 $tcp0
set sink30 [new Agent/TCPSink]
$ns attach-agent $n3 $sink30
$ns connect $tcp0 $sink30
$tcp0 set fid_ 0

set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0
$ftp0 set type_ FTP

set tcp1 [new Agent/TCP]
$ns attach-agent $n1 $tcp1
set sink31 [new Agent/TCPSink]
$ns attach-agent $n3 $sink31
$ns connect $tcp1 $sink31
$tcp1 set fid_ 1

set telnet1 [new Application/Telnet]
$telnet1 attach-agent $tcp1
$telnet1 set type_ Telnet

$ns at 0.5 "$ftp0 start"
$ns at 0.5 "$telnet1 start"
$ns at 24.5 "$ftp0 stop"
$ns at 24.5 "$telnet1 stop"
$ns at 25.0 "finish"
$ns run
