# Computer Organization (234118), HW2: x86-64 assembly

Hand-written x86-64 assembly (`students_code.S`) called from a C driver
(`main.c`). The routines read a codeword from a file via raw Linux syscalls,
compute its Hamming weight, negate the first k bits, and balance the word
with Knuth's algorithm.

```bash
gcc -no-pie main.c students_code.S -o main.out && ./main.out
./create_input.sh    # generates test inputs
```
