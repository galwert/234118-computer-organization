# 234118 Computer Organization and Programming (Technion)

x86-64 assembly assignments.

| Folder | Assignment |
|---|---|
| `hw1-assembly-basics/` | Five standalone assembly exercises (`ex1.asm` to `ex5.asm`): arithmetic, loops, memory access and calling conventions |
| `hw2-hamming-weight-syscalls/` | Assembly routines called from C: file reading through raw Linux syscalls, Hamming weight, bit negation and Knuth's word-balancing algorithm |

```bash
cd hw2-hamming-weight-syscalls && gcc -no-pie main.c students_code.S -o main.out && ./main.out
```
