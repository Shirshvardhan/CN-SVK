set ns [new Simulator]

set tf [open 1.tr w]
$ns trace-all $tf
set nf [open 1.nam w]
$ns namtrace-all $nf

proc finish { } {
 global ns nf tf
 $ns flush-trace
 close $nf
 close $tf

 exec awk -f stats.awk 1.tr &
 exec nam 1.nam &
 # exec xgraph gra.txt &
 exit 0
}

set n0 [$ns node]        
set n1 [$ns node]
set n2 [$ns node]

$ns duplex-link $n0 $n1 1Mb 20ms DropTail
$ns duplex-link $n1 $n2 .3Mb 20ms DropTail

set udp0 [new Agent/UDP]
$ns attach-agent $n0 $udp0

set null2 [new Agent/Null]     
$ns attach-agent $n2 $null2

set cbr0 [new Application/Traffic/CBR]

$cbr0 attach-agent $udp0

$ns connect $udp0 $null2

$ns at .5 "$cbr0 start"
$ns at 2.0 "$cbr0 stop"
$ns at 2.0 "finish"

$ns run






