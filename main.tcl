
# creating the simulator object
set ns [new Simulator] 


#Open the NAM trace file
set nf [open out.nam w]
$ns namtrace-all $nf


#Define a 'finish' procedure
proc finish {} {
    global ns nf
    $ns flush-trace
    #Close the NAM trace file
    close $nf
    #Execute NAM on the trace file
    exec nam out.nam &
    exit 0
}

# generating a random number between 5 and max + 5
proc randomGenerator {max} {
    return [expr {int(rand()*$max) + 5}]
}


#Create four nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]


$ns duplex-link $n0 $n2 100Mb 5ms DropTail
$ns duplex-link $n1 $n2 100Mb [randomGenerator 20]ms DropTail
$ns duplex-link $n2 $n3 100Kb 1ms DropTail
$ns duplex-link $n3 $n4 100Mb 5ms DropTail
$ns duplex-link $n3 $n5 100Mb [randomGenerator 20]ms DropTail



$ns at 5.0 "finish"

