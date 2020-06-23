
### bottleneck

The smaller bandwidth on the 2 - 3 link makes it the bottleneck. The default TCP packet size in ns-2 is 1000 bytes, so the bottleneck bandwidth is nominally 100 / 8 packets/sec


### CWND

for getting cwnd we can use two methods that one of them envolves ns-2 tcp variables and the second one tracks the cwnd variable each 0.1 seconds that calls itself.


### goodPut

The goodput of a TCP connection is, properly, the number of application bytes received

Since ACKs started with number 0, this means we sent some packets successfully. The theoretical bandwidth was 100/8 packets/s and as we ran the simulation for 100 seconds so we can conclude that the rate of goodPut here as an example 50%, so this is about an 81% goodput. Use of the ack_ value this way tells us how much data was actually delivered.
An alternative statistic is the final value of maxseq_ which represents the number of distinct packets sent;

by printing these two varibales we can use them to calculate the rate of goodPut for each tcp connection and the flow attributed to it.