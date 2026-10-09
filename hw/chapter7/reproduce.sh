#!/usr/bin/env bash
set -euo pipefail
# Run from /workspaces/ostep-codespace-lab. Regenerates the 23 raw outputs.
test -f ./ext/ostep-homework/cpu-sched/scheduler.py
mkdir -p hw/chapter7/data
python3 ./ext/ostep-homework/cpu-sched/scheduler.py -l 200,200,200 -p FIFO -s 1234 -c > hw/chapter7/data/q1_fifo.txt
python3 ./ext/ostep-homework/cpu-sched/scheduler.py -l 200,200,200 -p SJF -s 1234 -c > hw/chapter7/data/q1_sjf.txt
python3 ./ext/ostep-homework/cpu-sched/scheduler.py -l 100,200,300 -p FIFO -s 1234 -c > hw/chapter7/data/q2_fifo.txt
python3 ./ext/ostep-homework/cpu-sched/scheduler.py -l 100,200,300 -p SJF -s 1234 -c > hw/chapter7/data/q2_sjf.txt
python3 ./ext/ostep-homework/cpu-sched/scheduler.py -l 200,200,200 -p RR -s 1234 -q 1 -c > hw/chapter7/data/q3_rr_equal_q1.txt
python3 ./ext/ostep-homework/cpu-sched/scheduler.py -l 100,200,300 -p RR -s 1234 -q 1 -c > hw/chapter7/data/q3_rr_mixed_q1.txt
python3 ./ext/ostep-homework/cpu-sched/scheduler.py -l 300,200,100 -p FIFO -s 1234 -c > hw/chapter7/data/q4_reverse_fifo.txt
python3 ./ext/ostep-homework/cpu-sched/scheduler.py -l 300,200,100 -p SJF -s 1234 -c > hw/chapter7/data/q4_reverse_sjf.txt
python3 ./ext/ostep-homework/cpu-sched/scheduler.py -l 2,4,6 -p SJF -s 1234 -c > hw/chapter7/data/q5_sorted_sjf.txt
python3 ./ext/ostep-homework/cpu-sched/scheduler.py -l 2,4,6 -p RR -s 1234 -q 1 -c > hw/chapter7/data/q5_sorted_rr_q1.txt
python3 ./ext/ostep-homework/cpu-sched/scheduler.py -l 2,4,6 -p RR -s 1234 -q 4 -c > hw/chapter7/data/q5_sorted_rr_q4.txt
python3 ./ext/ostep-homework/cpu-sched/scheduler.py -l 2,4,6 -p RR -s 1234 -q 6 -c > hw/chapter7/data/q5_sorted_rr_q6.txt
python3 ./ext/ostep-homework/cpu-sched/scheduler.py -l 6,2,4 -p SJF -s 1234 -c > hw/chapter7/data/q5_reverse_sjf.txt
python3 ./ext/ostep-homework/cpu-sched/scheduler.py -l 6,2,4 -p RR -s 1234 -q 6 -c > hw/chapter7/data/q5_reverse_rr_q6.txt
python3 ./ext/ostep-homework/cpu-sched/scheduler.py -l 10,20,30 -p SJF -s 1234 -c > hw/chapter7/data/q6_scale_10_sjf.txt
python3 ./ext/ostep-homework/cpu-sched/scheduler.py -l 100,200,300 -p SJF -s 1234 -c > hw/chapter7/data/q6_scale_100_sjf.txt
python3 ./ext/ostep-homework/cpu-sched/scheduler.py -l 1000,2000,3000 -p SJF -s 1234 -c > hw/chapter7/data/q6_scale_1000_sjf.txt
python3 ./ext/ostep-homework/cpu-sched/scheduler.py -l 200,200,200 -p RR -s 1234 -q 1 -c > hw/chapter7/data/q7_rr_q1.txt
python3 ./ext/ostep-homework/cpu-sched/scheduler.py -l 200,200,200 -p RR -s 1234 -q 5 -c > hw/chapter7/data/q7_rr_q5.txt
python3 ./ext/ostep-homework/cpu-sched/scheduler.py -l 200,200,200 -p RR -s 1234 -q 10 -c > hw/chapter7/data/q7_rr_q10.txt
python3 ./ext/ostep-homework/cpu-sched/scheduler.py -l 200,200,200 -p RR -s 1234 -q 50 -c > hw/chapter7/data/q7_rr_q50.txt
python3 ./ext/ostep-homework/cpu-sched/scheduler.py -l 200,200,200 -p RR -s 1234 -q 200 -c > hw/chapter7/data/q7_rr_q200.txt
python3 ./ext/ostep-homework/cpu-sched/scheduler.py -l 200,200,200 -p RR -s 1234 -q 300 -c > hw/chapter7/data/q7_rr_q300.txt
