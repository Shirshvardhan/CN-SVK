set ns [new Simulator]

set tf [open 4b.tr w]
$ns trace-all $tf

set nf [open 4b.nam w]
$ns namtrace-all $nf

proc finish { } {
 global ns nf tf

 $ns flush-trace
 close $nf
 close $tf

 exec awk -f 4b.awk 4b.tr &
 exec nam 4b.nam
 exit 0
}

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]
set n6 [$ns node]


$ns duplex-link $n1 $n0 1Mb 10ms DropTail
$ns duplex-link $n2 $n0 1Mb 10ms DropTail
$ns duplex-link $n4 $n0 1Mb 10ms DropTail
$ns duplex-link $n3 $n0 1Mb 10ms DropTail
$ns duplex-link $n5 $n0 1Mb 10ms DropTail
$ns duplex-link $n6 $n0 1Mb 10ms DropTail

#Here, i just removed the '/'
Agent/Ping instproc recv {from rtt} {
$self instvar node_
puts "node [$node_ id] recieved ping answer from $from with round-trip-time $rtt ms"
}

set p1 [new Agent/Ping]
set p2 [new Agent/Ping]
set p3 [new Agent/Ping]
set p4 [new Agent/Ping]
set p5 [new Agent/Ping]
set p6 [new Agent/Ping]

$ns attach-agent $n1 $p1
$ns attach-agent $n2 $p2
$ns attach-agent $n3 $p3
$ns attach-agent $n4 $p4
$ns attach-agent $n5 $p5
$ns attach-agent $n6 $p6

#We need to set the queue limit to show some drop of packets. Following values are just random queue limit values, 
#Any value like 1,2,3 is a perfect one. 
$ns queue-limit $n0 $n4 0
$ns queue-limit $n0 $n5 2
$ns queue-limit $n0 $n6 2

 
$ns connect $p1 $p4
$ns connect $p2 $p5
$ns connect $p3 $p6

$ns at 0.1  "$p1 send"
$ns at 0.3  "$p2 send"
$ns at 0.5  "$p3 send"
$ns at 1.0  "$p4 send"
$ns at 1.2  "$p5 send"
$ns at 1.4  "$p6 send"
$ns at 2.0  "finish"
$ns run

