# OSTEP Ch.4 Homework Answers

> 本次为重做：此前曾在本地进行练习验证。本次在课程 Codespace 中先提交并 push 预测，再重新运行验证；预测在第一次提交后保持不变。

默认：`-L 5 -S SWITCH_ON_IO -I IO_RUN_LATER`。所有时间单位为 tick。

状态表用 0 表示原始输出中的空白 CPU/IOs；`*` 表示本 tick 有 I/O 完成。`RUN:io` 和 `RUN:io_done` 都计入 CPU Busy；I/O 在发起之后的 5 tick 计入 IO Busy。最后一条指令在该行仍显示 RUN，下一 tick 才显示 DONE。

## Q1

命令：`python3 process-run.py -l 5:100,5:100`

- Prediction / 预测：总时间 **10**；CPU Busy **10**，利用率 **100.00%**；IO Busy **0**，利用率 **0.00%**。
- Reasoning / 理由：两个进程都只有 CPU 指令。PID 0 完成后 PID 1 接着运行，没有 I/O 阻塞，因此 CPU 始终忙碌。

```text
Time PID 0          PID 1          CPU IOs
1    RUN:cpu        READY          1   0
2    RUN:cpu        READY          1   0
3    RUN:cpu        READY          1   0
4    RUN:cpu        READY          1   0
5    RUN:cpu        READY          1   0
6    DONE           RUN:cpu        1   0
7    DONE           RUN:cpu        1   0
8    DONE           RUN:cpu        1   0
9    DONE           RUN:cpu        1   0
10   DONE           RUN:cpu        1   0
```

## Q2

命令：`python3 process-run.py -l 4:100,1:0`

- Prediction / 预测：总时间 **11**；CPU Busy **6**，利用率 **54.55%**；IO Busy **5**，利用率 **45.45%**。
- Reasoning / 理由：PID 1 在 t=1–4 为 READY；到 t=5 才发起 I/O。t=6–10 没有其他工作可以运行，t=11 处理完成。总时间为 4+1+5+1=11。

```text
Time PID 0          PID 1          CPU IOs
1    RUN:cpu        READY          1   0
2    RUN:cpu        READY          1   0
3    RUN:cpu        READY          1   0
4    RUN:cpu        READY          1   0
5    DONE           RUN:io         1   0
6    DONE           BLOCKED        0   1
7    DONE           BLOCKED        0   1
8    DONE           BLOCKED        0   1
9    DONE           BLOCKED        0   1
10   DONE           BLOCKED        0   1
11*  DONE           RUN:io_done    1   0
```

## Q3

命令：`python3 process-run.py -l 1:0,4:100`

- Prediction / 预测：总时间 **7**；CPU Busy **6**，利用率 **85.71%**；IO Busy **5**，利用率 **71.43%**。
- Reasoning / 理由：先发起 I/O 后，PID 1 的 4 个 CPU tick 与 I/O 等待重叠。只有 t=6 空闲，t=7 处理完成；调换进程顺序把总时间从 11 缩短为 7。

```text
Time PID 0          PID 1          CPU IOs
1    RUN:io         READY          1   0
2    BLOCKED        RUN:cpu        1   1
3    BLOCKED        RUN:cpu        1   1
4    BLOCKED        RUN:cpu        1   1
5    BLOCKED        RUN:cpu        1   1
6    BLOCKED        DONE           0   1
7*   RUN:io_done    DONE           1   0
```

## Q4

命令：`python3 process-run.py -l 1:0,4:100 -S SWITCH_ON_END`

- Prediction / 预测：总时间 **11**；CPU Busy **6**，利用率 **54.55%**；IO Busy **5**，利用率 **45.45%**。
- Reasoning / 理由：SWITCH_ON_END 不在 I/O 发起时切换。即使 PID 1 已 READY，t=2–6 CPU 仍空闲。PID 0 在 t=7 完成，PID 1 才能从 t=8 开始。

```text
Time PID 0          PID 1          CPU IOs
1    RUN:io         READY          1   0
2    BLOCKED        READY          0   1
3    BLOCKED        READY          0   1
4    BLOCKED        READY          0   1
5    BLOCKED        READY          0   1
6    BLOCKED        READY          0   1
7*   RUN:io_done    READY          1   0
8    DONE           RUN:cpu        1   0
9    DONE           RUN:cpu        1   0
10   DONE           RUN:cpu        1   0
11   DONE           RUN:cpu        1   0
```

## Q5

命令：`python3 process-run.py -l 1:0,4:100 -S SWITCH_ON_IO`

- Prediction / 预测：总时间 **7**；CPU Busy **6**，利用率 **85.71%**；IO Busy **5**，利用率 **71.43%**。
- Reasoning / 理由：发起 I/O 时切换到 READY 的 PID 1，利用 4 个等待 tick。因此结果与默认策略的 Q3 相同，比 Q4 少 4 tick。

```text
Time PID 0          PID 1          CPU IOs
1    RUN:io         READY          1   0
2    BLOCKED        RUN:cpu        1   1
3    BLOCKED        RUN:cpu        1   1
4    BLOCKED        RUN:cpu        1   1
5    BLOCKED        RUN:cpu        1   1
6    BLOCKED        DONE           0   1
7*   RUN:io_done    DONE           1   0
```

## Q6

命令：`python3 process-run.py -l 3:0,5:100,5:100,5:100 -S SWITCH_ON_IO -I IO_RUN_LATER`

- Prediction / 预测：总时间 **31**；CPU Busy **21**，利用率 **67.74%**；IO Busy **15**，利用率 **48.39%**。
- Reasoning / 理由：PID 0 的首次 I/O 在 t=7 完成，但 IO_RUN_LATER 不抢占当前的 PID 2。之后按轮转次序运行 PID 3，直到 t=17 才轮到 PID 0。后两次等待发生时其他进程都已结束，产生 10 个 CPU 空闲 tick。

```text
Time PID 0          PID 1          PID 2          PID 3          CPU IOs
1    RUN:io         READY          READY          READY          1   0
2    BLOCKED        RUN:cpu        READY          READY          1   1
3    BLOCKED        RUN:cpu        READY          READY          1   1
4    BLOCKED        RUN:cpu        READY          READY          1   1
5    BLOCKED        RUN:cpu        READY          READY          1   1
6    BLOCKED        RUN:cpu        READY          READY          1   1
7*   READY          DONE           RUN:cpu        READY          1   0
8    READY          DONE           RUN:cpu        READY          1   0
9    READY          DONE           RUN:cpu        READY          1   0
10   READY          DONE           RUN:cpu        READY          1   0
11   READY          DONE           RUN:cpu        READY          1   0
12   READY          DONE           DONE           RUN:cpu        1   0
13   READY          DONE           DONE           RUN:cpu        1   0
14   READY          DONE           DONE           RUN:cpu        1   0
15   READY          DONE           DONE           RUN:cpu        1   0
16   READY          DONE           DONE           RUN:cpu        1   0
17   RUN:io_done    DONE           DONE           DONE           1   0
18   RUN:io         DONE           DONE           DONE           1   0
19   BLOCKED        DONE           DONE           DONE           0   1
20   BLOCKED        DONE           DONE           DONE           0   1
21   BLOCKED        DONE           DONE           DONE           0   1
22   BLOCKED        DONE           DONE           DONE           0   1
23   BLOCKED        DONE           DONE           DONE           0   1
24*  RUN:io_done    DONE           DONE           DONE           1   0
25   RUN:io         DONE           DONE           DONE           1   0
26   BLOCKED        DONE           DONE           DONE           0   1
27   BLOCKED        DONE           DONE           DONE           0   1
28   BLOCKED        DONE           DONE           DONE           0   1
29   BLOCKED        DONE           DONE           DONE           0   1
30   BLOCKED        DONE           DONE           DONE           0   1
31*  RUN:io_done    DONE           DONE           DONE           1   0
```

## Q7

命令：`python3 process-run.py -l 3:0,5:100,5:100,5:100 -S SWITCH_ON_IO -I IO_RUN_IMMEDIATE`

- Prediction / 预测：总时间 **21**；CPU Busy **21**，利用率 **100.00%**；IO Busy **15**，利用率 **71.43%**。
- Reasoning / 理由：I/O 完成时立即恢复 PID 0，使它尽早发出下一次 I/O。三段各 5 tick 的等待分别被三个 CPU 进程填满，21 个 CPU tick 连续执行。

```text
Time PID 0          PID 1          PID 2          PID 3          CPU IOs
1    RUN:io         READY          READY          READY          1   0
2    BLOCKED        RUN:cpu        READY          READY          1   1
3    BLOCKED        RUN:cpu        READY          READY          1   1
4    BLOCKED        RUN:cpu        READY          READY          1   1
5    BLOCKED        RUN:cpu        READY          READY          1   1
6    BLOCKED        RUN:cpu        READY          READY          1   1
7*   RUN:io_done    DONE           READY          READY          1   0
8    RUN:io         DONE           READY          READY          1   0
9    BLOCKED        DONE           RUN:cpu        READY          1   1
10   BLOCKED        DONE           RUN:cpu        READY          1   1
11   BLOCKED        DONE           RUN:cpu        READY          1   1
12   BLOCKED        DONE           RUN:cpu        READY          1   1
13   BLOCKED        DONE           RUN:cpu        READY          1   1
14*  RUN:io_done    DONE           DONE           READY          1   0
15   RUN:io         DONE           DONE           READY          1   0
16   BLOCKED        DONE           DONE           RUN:cpu        1   1
17   BLOCKED        DONE           DONE           RUN:cpu        1   1
18   BLOCKED        DONE           DONE           RUN:cpu        1   1
19   BLOCKED        DONE           DONE           RUN:cpu        1   1
20   BLOCKED        DONE           DONE           RUN:cpu        1   1
21*  RUN:io_done    DONE           DONE           DONE           1   0
```

## Q8

指令列表（省略自动插入的 io_done）：seed 1：PID 0 = cpu, io, io；PID 1 = cpu, cpu, cpu。seed 2：PID 0 = io, io, cpu；PID 1 = cpu, io, io。seed 3：PID 0 = cpu, io, cpu；PID 1 = io, io, cpu。
### q8-s1-default

命令：`python3 process-run.py -s 1 -l 3:50,3:50`

- Prediction / 预测：总时间 **15**；CPU Busy **8**，利用率 **53.33%**；IO Busy **10**，利用率 **66.67%**。
- Reasoning / 理由：PID 1 只有 3 条 CPU 指令，在首次 I/O 完成前已结束，故立即运行与默认策略相同。不在 I/O 时切换会把这 3 tick 推迟到 PID 0 结束后。

```text
Time PID 0          PID 1          CPU IOs
1    RUN:cpu        READY          1   0
2    RUN:io         READY          1   0
3    BLOCKED        RUN:cpu        1   1
4    BLOCKED        RUN:cpu        1   1
5    BLOCKED        RUN:cpu        1   1
6    BLOCKED        DONE           0   1
7    BLOCKED        DONE           0   1
8*   RUN:io_done    DONE           1   0
9    RUN:io         DONE           1   0
10   BLOCKED        DONE           0   1
11   BLOCKED        DONE           0   1
12   BLOCKED        DONE           0   1
13   BLOCKED        DONE           0   1
14   BLOCKED        DONE           0   1
15*  RUN:io_done    DONE           1   0
```

### q8-s1-immediate

命令：`python3 process-run.py -s 1 -l 3:50,3:50 -I IO_RUN_IMMEDIATE`

- Prediction / 预测：总时间 **15**；CPU Busy **8**，利用率 **53.33%**；IO Busy **10**，利用率 **66.67%**。
- Reasoning / 理由：PID 1 只有 3 条 CPU 指令，在首次 I/O 完成前已结束，故立即运行与默认策略相同。不在 I/O 时切换会把这 3 tick 推迟到 PID 0 结束后。

```text
Time PID 0          PID 1          CPU IOs
1    RUN:cpu        READY          1   0
2    RUN:io         READY          1   0
3    BLOCKED        RUN:cpu        1   1
4    BLOCKED        RUN:cpu        1   1
5    BLOCKED        RUN:cpu        1   1
6    BLOCKED        DONE           0   1
7    BLOCKED        DONE           0   1
8*   RUN:io_done    DONE           1   0
9    RUN:io         DONE           1   0
10   BLOCKED        DONE           0   1
11   BLOCKED        DONE           0   1
12   BLOCKED        DONE           0   1
13   BLOCKED        DONE           0   1
14   BLOCKED        DONE           0   1
15*  RUN:io_done    DONE           1   0
```

### q8-s1-end

命令：`python3 process-run.py -s 1 -l 3:50,3:50 -S SWITCH_ON_END`

- Prediction / 预测：总时间 **18**；CPU Busy **8**，利用率 **44.44%**；IO Busy **10**，利用率 **55.56%**。
- Reasoning / 理由：PID 1 只有 3 条 CPU 指令，在首次 I/O 完成前已结束，故立即运行与默认策略相同。不在 I/O 时切换会把这 3 tick 推迟到 PID 0 结束后。

```text
Time PID 0          PID 1          CPU IOs
1    RUN:cpu        READY          1   0
2    RUN:io         READY          1   0
3    BLOCKED        READY          0   1
4    BLOCKED        READY          0   1
5    BLOCKED        READY          0   1
6    BLOCKED        READY          0   1
7    BLOCKED        READY          0   1
8*   RUN:io_done    READY          1   0
9    RUN:io         READY          1   0
10   BLOCKED        READY          0   1
11   BLOCKED        READY          0   1
12   BLOCKED        READY          0   1
13   BLOCKED        READY          0   1
14   BLOCKED        READY          0   1
15*  RUN:io_done    READY          1   0
16   DONE           RUN:cpu        1   0
17   DONE           RUN:cpu        1   0
18   DONE           RUN:cpu        1   0
```

### q8-s2-default

命令：`python3 process-run.py -s 2 -l 3:50,3:50`

- Prediction / 预测：总时间 **16**；CPU Busy **10**，利用率 **62.50%**；IO Busy **14**，利用率 **87.50%**。
- Reasoning / 理由：两个进程可以交替发起 I/O，部分时间有两项 I/O 同时进行。本例各次 I/O 完成时没有需要被抢占的 CPU 工作，因此 default 和 IMMEDIATE 的轨迹相同。END 使两个进程顺序执行，失去重叠。

```text
Time PID 0          PID 1          CPU IOs
1    RUN:io         READY          1   0
2    BLOCKED        RUN:cpu        1   1
3    BLOCKED        RUN:io         1   1
4    BLOCKED        BLOCKED        0   2
5    BLOCKED        BLOCKED        0   2
6    BLOCKED        BLOCKED        0   2
7*   RUN:io_done    BLOCKED        1   1
8    RUN:io         BLOCKED        1   1
9*   BLOCKED        RUN:io_done    1   1
10   BLOCKED        RUN:io         1   1
11   BLOCKED        BLOCKED        0   2
12   BLOCKED        BLOCKED        0   2
13   BLOCKED        BLOCKED        0   2
14*  RUN:io_done    BLOCKED        1   1
15   RUN:cpu        BLOCKED        1   1
16*  DONE           RUN:io_done    1   0
```

### q8-s2-immediate

命令：`python3 process-run.py -s 2 -l 3:50,3:50 -I IO_RUN_IMMEDIATE`

- Prediction / 预测：总时间 **16**；CPU Busy **10**，利用率 **62.50%**；IO Busy **14**，利用率 **87.50%**。
- Reasoning / 理由：两个进程可以交替发起 I/O，部分时间有两项 I/O 同时进行。本例各次 I/O 完成时没有需要被抢占的 CPU 工作，因此 default 和 IMMEDIATE 的轨迹相同。END 使两个进程顺序执行，失去重叠。

```text
Time PID 0          PID 1          CPU IOs
1    RUN:io         READY          1   0
2    BLOCKED        RUN:cpu        1   1
3    BLOCKED        RUN:io         1   1
4    BLOCKED        BLOCKED        0   2
5    BLOCKED        BLOCKED        0   2
6    BLOCKED        BLOCKED        0   2
7*   RUN:io_done    BLOCKED        1   1
8    RUN:io         BLOCKED        1   1
9*   BLOCKED        RUN:io_done    1   1
10   BLOCKED        RUN:io         1   1
11   BLOCKED        BLOCKED        0   2
12   BLOCKED        BLOCKED        0   2
13   BLOCKED        BLOCKED        0   2
14*  RUN:io_done    BLOCKED        1   1
15   RUN:cpu        BLOCKED        1   1
16*  DONE           RUN:io_done    1   0
```

### q8-s2-end

命令：`python3 process-run.py -s 2 -l 3:50,3:50 -S SWITCH_ON_END`

- Prediction / 预测：总时间 **30**；CPU Busy **10**，利用率 **33.33%**；IO Busy **20**，利用率 **66.67%**。
- Reasoning / 理由：两个进程可以交替发起 I/O，部分时间有两项 I/O 同时进行。本例各次 I/O 完成时没有需要被抢占的 CPU 工作，因此 default 和 IMMEDIATE 的轨迹相同。END 使两个进程顺序执行，失去重叠。

```text
Time PID 0          PID 1          CPU IOs
1    RUN:io         READY          1   0
2    BLOCKED        READY          0   1
3    BLOCKED        READY          0   1
4    BLOCKED        READY          0   1
5    BLOCKED        READY          0   1
6    BLOCKED        READY          0   1
7*   RUN:io_done    READY          1   0
8    RUN:io         READY          1   0
9    BLOCKED        READY          0   1
10   BLOCKED        READY          0   1
11   BLOCKED        READY          0   1
12   BLOCKED        READY          0   1
13   BLOCKED        READY          0   1
14*  RUN:io_done    READY          1   0
15   RUN:cpu        READY          1   0
16   DONE           RUN:cpu        1   0
17   DONE           RUN:io         1   0
18   DONE           BLOCKED        0   1
19   DONE           BLOCKED        0   1
20   DONE           BLOCKED        0   1
21   DONE           BLOCKED        0   1
22   DONE           BLOCKED        0   1
23*  DONE           RUN:io_done    1   0
24   DONE           RUN:io         1   0
25   DONE           BLOCKED        0   1
26   DONE           BLOCKED        0   1
27   DONE           BLOCKED        0   1
28   DONE           BLOCKED        0   1
29   DONE           BLOCKED        0   1
30*  DONE           RUN:io_done    1   0
```

### q8-s3-default

命令：`python3 process-run.py -s 3 -l 3:50,3:50`

- Prediction / 预测：总时间 **18**；CPU Busy **9**，利用率 **50.00%**；IO Busy **11**，利用率 **61.11%**。
- Reasoning / 理由：默认策略下 t=9 PID 0 执行最后一条 cpu，PID 1 虽已完成 I/O 仍等待。IMMEDIATE 在 t=9 抢占 PID 0，t=10 即发起 PID 1 的下一次 I/O，再用 t=11 执行 PID 0 的最后一条指令，使结束时间提前 1 tick。END 完全串行。

```text
Time PID 0          PID 1          CPU IOs
1    RUN:cpu        READY          1   0
2    RUN:io         READY          1   0
3    BLOCKED        RUN:io         1   1
4    BLOCKED        BLOCKED        0   2
5    BLOCKED        BLOCKED        0   2
6    BLOCKED        BLOCKED        0   2
7    BLOCKED        BLOCKED        0   2
8*   RUN:io_done    BLOCKED        1   1
9*   RUN:cpu        READY          1   0
10   DONE           RUN:io_done    1   0
11   DONE           RUN:io         1   0
12   DONE           BLOCKED        0   1
13   DONE           BLOCKED        0   1
14   DONE           BLOCKED        0   1
15   DONE           BLOCKED        0   1
16   DONE           BLOCKED        0   1
17*  DONE           RUN:io_done    1   0
18   DONE           RUN:cpu        1   0
```

### q8-s3-immediate

命令：`python3 process-run.py -s 3 -l 3:50,3:50 -I IO_RUN_IMMEDIATE`

- Prediction / 预测：总时间 **17**；CPU Busy **9**，利用率 **52.94%**；IO Busy **11**，利用率 **64.71%**。
- Reasoning / 理由：默认策略下 t=9 PID 0 执行最后一条 cpu，PID 1 虽已完成 I/O 仍等待。IMMEDIATE 在 t=9 抢占 PID 0，t=10 即发起 PID 1 的下一次 I/O，再用 t=11 执行 PID 0 的最后一条指令，使结束时间提前 1 tick。END 完全串行。

```text
Time PID 0          PID 1          CPU IOs
1    RUN:cpu        READY          1   0
2    RUN:io         READY          1   0
3    BLOCKED        RUN:io         1   1
4    BLOCKED        BLOCKED        0   2
5    BLOCKED        BLOCKED        0   2
6    BLOCKED        BLOCKED        0   2
7    BLOCKED        BLOCKED        0   2
8*   RUN:io_done    BLOCKED        1   1
9*   READY          RUN:io_done    1   0
10   READY          RUN:io         1   0
11   RUN:cpu        BLOCKED        1   1
12   DONE           BLOCKED        0   1
13   DONE           BLOCKED        0   1
14   DONE           BLOCKED        0   1
15   DONE           BLOCKED        0   1
16*  DONE           RUN:io_done    1   0
17   DONE           RUN:cpu        1   0
```

### q8-s3-end

命令：`python3 process-run.py -s 3 -l 3:50,3:50 -S SWITCH_ON_END`

- Prediction / 预测：总时间 **24**；CPU Busy **9**，利用率 **37.50%**；IO Busy **15**，利用率 **62.50%**。
- Reasoning / 理由：默认策略下 t=9 PID 0 执行最后一条 cpu，PID 1 虽已完成 I/O 仍等待。IMMEDIATE 在 t=9 抢占 PID 0，t=10 即发起 PID 1 的下一次 I/O，再用 t=11 执行 PID 0 的最后一条指令，使结束时间提前 1 tick。END 完全串行。

```text
Time PID 0          PID 1          CPU IOs
1    RUN:cpu        READY          1   0
2    RUN:io         READY          1   0
3    BLOCKED        READY          0   1
4    BLOCKED        READY          0   1
5    BLOCKED        READY          0   1
6    BLOCKED        READY          0   1
7    BLOCKED        READY          0   1
8*   RUN:io_done    READY          1   0
9    RUN:cpu        READY          1   0
10   DONE           RUN:io         1   0
11   DONE           BLOCKED        0   1
12   DONE           BLOCKED        0   1
13   DONE           BLOCKED        0   1
14   DONE           BLOCKED        0   1
15   DONE           BLOCKED        0   1
16*  DONE           RUN:io_done    1   0
17   DONE           RUN:io         1   0
18   DONE           BLOCKED        0   1
19   DONE           BLOCKED        0   1
20   DONE           BLOCKED        0   1
21   DONE           BLOCKED        0   1
22   DONE           BLOCKED        0   1
23*  DONE           RUN:io_done    1   0
24   DONE           RUN:cpu        1   0
```

