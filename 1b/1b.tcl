set ns [new Simulator]

set nd [open 1.tr w]
$ns trace-all $nd
set nf [open 1.nam w]
$ns namtrace-all $nf

proc finish { } {
 global ns nf nd
 $ns flush-trace
 close $nf
 close $nd

 exec awk -f stats.awk 1.tr &
 exec nam 1.nam &
 exec xgraph gra.txt &
 exit 0
}

set n1 [$ns node]        
set n2 [$ns node]
set n3 [$ns node]

$ns duplex-link $n1 $n2 1Mb 20ms DropTail
$ns duplex-link $n2 $n3 1Mb 20ms DropTail

$ns queue-limit $n1 $n2 10
$ns queue-limit $n2 $n3 10


set udp0 [new Agent/UDP]
$ns attach-agent $n1 $udp0

set null0 [new Agent/Null]     
$ns attach-agent $n3 $null0

set cbr0 [new Application/Traffic/CBR]

$cbr0 attach-agent $udp0



$ns connect $udp0 $null0

$ns at .5 "$cbr0 start"
$ns at 2.0 "$cbr0 stop"
$ns at 2.0 "finish"

$ns run






