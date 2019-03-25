## WIP: Testing with sgsnemu/iperf3:

## Prerequisites

### Setting up the iperf-sink

### Setting up the sgsnemu

### Checking functionality

## Testing

1)Baseline VXLan-test, use iperf over `eth0-interface`:
```
iperf3 -c  <iperf-sink-ip>
Connecting to host <iperf-sink-ip>, port 5201
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bitrate
[  5]   0.00-5.54   sec  8.52 GBytes  13.2 Gbits/sec
```

2)Avg/Min/Max delay through sgsnemu(to intern sink), use `ping` with `-q` flag:
```
ping -q <iperf-sink-ip>
PING <iperf-sink-ip> (<iperf-sink-ip>): 56 data bytes
--- <iperf-sink-ip> ping statistics ---
8 packets transmitted, 8 packets received, 0% packet loss
round-trip min/avg/max = 0.710/1.770/3.701 ms
```

3)Avg/Min/Max delay through sgsnemu(to public internet), use `ping` with `-q` flag:
```
ping -q 8.8.8.8
PING 8.8.8.8 (8.8.8.8): 56 data bytes
--- 8.8.8.8 ping statistics ---
```

4)Stresstest:
```
/ # iperf3 -c <iperf-sink-ip> -u -b 10000000m -f m
 ID] Interval           Transfer     Bitrate         Jitter    Lost/Total Datagrams
[TOTAL]   0.00-10.00  sec  1.15 GBytes   990 Mbits/sec  0.000 ms  0/885428 (0%)  sender
```
5)Try opening multiple seperate connections:
```
/ # iperf3 -c <iperf-sink-ip> -u -P 30
[SINGLE CONNECTION] 0.00-33.18  sec  1.25 MBytes   316 Kbits/sec
[SUM OF CONNECTIONS]   0.00-33.18  sec  37.5 MBytes  9.49 Mbits/sec
```
6)Stresstest with multiple seperate connections:
```
iperf3 -c <iperf-sink-ip> -u -P 5 -b 1000000m
[SINGLE CONNECTION]  0.00-10.00  sec   451 MBytes   379 Mbits/sec
[SUM OF CONNECTIONS]   0.00-10.00  sec  2.20 GBytes  1.89 Gbits/sec  0.000 ms
```
