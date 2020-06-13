#limited queue
#www.ns2blogger.blogspot.in
#mail us: ns2blogger@gmail.com
#$ns queue-limit $n2 $n3 10
#queue-limit is for limiting the number of queue.
#In this code, there are 18 packets dropped in queue between node2 and node3.
#We can check the number of dropped packets from tracing file and monitor-queue file which is generated #by monitor-queue.

#—————————
#example4.tcl
#—————————

#create a simulator object
set ns [new Simulator]

#Define different colors for data flows, for NAM
$ns color 1 Blue
$ns color 2 Red

#Open the NAM trace file
set nf [open out_example4.nam w]
$ns namtrace-all $nf

#Open the Trace file
set tf [open out_example4.tr w]
$ns trace-all $tf

#Define a finish procedure
proc finish {} {
global ns nf tf
$ns flush-trace
#Close the NAM trace file
close $nf
#close the trace file
close $tf
#Execute NAM on the trace file
exec nam out_example4.nam &
exit 0
}

#Create four nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]

#color node
$n0 color blue
$n1 color red
$n2 color green

#Create links between the nodes
$ns duplex-link $n0 $n2 2Mb 10ms DropTail
$ns duplex-link $n1 $n2 2Mb 10ms DropTail
$ns duplex-link $n2 $n3 1.7Mb 20ms DropTail

#Color links
$ns duplex-link-op $n0 $n2 color "yellow"

#Set Queue size of link (n2-n3) to 10
$ns queue-limit $n2 $n3 10

#Give node position (for NAM)
$ns duplex-link-op $n0 $n2 orient right-down
$ns duplex-link-op $n1 $n2 orient right-up
$ns duplex-link-op $n2 $n3 orient right

#Monitor the queue for link (n2-n3) (for NAM)
$ns duplex-link-op $n2 $n3 queuePos 0.5

#Setup a TCP connection
set tcp [new Agent/TCP]
#$tcp set class_ 2
$ns attach-agent $n0 $tcp
set sink [new Agent/TCPSink]
$ns attach-agent $n3 $sink
$ns connect $tcp $sink
$tcp set fid_ 1

#Setup a FTP over TCP connection
set ftp [new Application/FTP]
$ftp attach-agent $tcp
$ftp set type_ FTP

#Setup a UDP connection
set udp [new Agent/UDP]
$ns attach-agent $n1 $udp
set null [new Agent/Null]
$ns attach-agent $n3 $null
$ns connect $udp $null
$udp set fid_ 2

#Setup cbr over UDP connection
set cbr [new Application/Traffic/CBR]
$cbr attach-agent $udp
$cbr set type_ CBR
$cbr set packet_size_ 1000
$cbr set rate_ 1mb
$cbr set random_ false

#tracing queue in node2
set qm [$ns monitor-queue $n2 $n3 [open qm4.out w] 1];
[$ns link $n2 $n3] queue-sample-timeout; #start tracing

#Schedule events for the CBR and FTP agents
$ns at 0.1 "$cbr start"
$ns at 1.0 "$ftp start"
$ns at 4.0 "$ftp stop"
$ns at 4.5 "$cbr stop"

#Detach tcp and sink agents (not really necessary)
$ns at 4.5 "$ns detach-agent $n0 $tcp ; $ns detach-agent $n3 $sink"

#Call the finish procedure after 5 seconds of simulation time
$ns at 5.0 "finish"

#Print CBR packet size and interval
puts "CBR packet size = [$cbr set packet_size_]"
puts "CBR interval = [$cbr set interval_]"

#Run the simulation
$ns run
