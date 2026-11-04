.global hamming_weight, negate_first_k, bring_balance_to_the_word, read_input

.section .bss
.lcomm path, 1024

.section .text
read_input:
  pushq %rbp
  movq %rsp, %rbp
  mov %rdi, %r9 # r9 holds address to codeword(function parameter)
  
  lea path(%rip), %rdi
  call get_path
  lea path(%rip), %rdi
  movq $2, %rax  # sys_open
  movq $0, %rsi  # open flags
  movq $256, %rdx  # permissions
  syscall
  # rax now holds the file descriptor
  mov %rax, %rdi  # rdi holds file descriptor
  mov %rax, %r12
  # now we will read from the file until char 0xa

  sub $8, %rsp  # allocate 8 bytes on stack
  mov %rsp, %rsi # pointer to array
  read_num:
  movq $0, %rax  # sys_read
  movq $1, %rdx # read one char 
  syscall

  movb (%rsi), %bl
  cmpb $0xa, %bl
  je found_newline
  inc %rsi # rsi++
  jmp read_num

  found_newline:
  movb $0, (%rsi) # null terminate the string
  movq %rsp, %rdi  # parameter for atam_atol
  pushq %r9
  call atam_atol
  popq %r9

 
  movq %rax, %r13 # length of array
  movq %r12, %rdi # fd
  movq %rsp, %rsi # medium
  movq $0, %r10 # iterator

  read_loop:
  movq $0, %rax # sys_read
  movq $1, %rdx # read one char
  syscall
  movb (%rsi), %bl
  movb %bl, (%r9, %r10, 1)
  cmp %r10, %r13
  je finish_read
  cmp $0, %rax
  je finish_read
  inc %r10
  jmp read_loop
  finish_read:

  # sys_close
  movq $3, %rax # sys_close
  movq %r12, %rdi # file descriptor
  syscall

  add $8, %rsp  # free the stack
  movw %r13w, %ax # num
  mov $8, %cx
  movq $0, %rdi
  div %cl
  movq %r9, %rdi
  leave
  ret

hamming_weight:
  pushq %rbp
  movq %rsp, %rbp
  movq $0, %rbx # counter for number of of words passed
  movq $0, %rcx # counter for the number of bytes passed in word
  movq $0, %rax # counter for the number of 1 bits found

  hamming_weight_loop:
  leaq (%rdi,%rbx,8), %r9
  movq (%r9,%rcx,1), %r9 
  cmpq $8, %rcx
  
  inc %rcx
  je passed_word
  inner_loop:
  cmpq $0,%r9
  je passed_word
  test $1,%r9 
  jz bit_processed
  inc %rax
  bit_processed:
  shr $1,%r9
  jmp inner_loop


  passed_word:
  movq $0, %rcx
  inc %rbx
  cmpq %rbx, %rsi # finsihed all
  je hamming_weight_finished
  jmp hamming_weight_loop
  hamming_weight_finished:
  leave
  ret


negate_first_k:
  # rdi = codeword, rsi = num of bits
  pushq %rbp
  movq %rsp, %rbp
  
  pushq %rdi

  xor %rbx, %rbx # bl is current byte
  movq $0, %r8 # current byte index (0, 1, ..., 6, 7)
  negate_loop:
  mov %rsi, %rax
  movq $0, %rdx # bits to NOT in byte
  movq $8, %rcx # divisor
  div %rcx
  # now rdx contains num of bits to NOT in current byte
  cmp $0, %rax # quotient is 0?
  je last_byte_negate
  movb (%rsp, %r8, 1), %bl
  not %bl
  movb %bl, (%rsp, %r8, 1)
  inc %r8
  sub $8, %rsi
  jmp negate_loop

  last_byte_negate:
  cmp $0, %rdx # remainder is 0?
  je finish_negate
  movb (%rsp, %r8, 1), %bl
  movq $8, %rcx
  sub %rdx, %rcx
  shl %cl, %rbx
  not %bl
  shr %cl, %rbx
  movb %bl, (%rsp, %r8, 1)
  popq %rax

  finish_negate:
  leave
  ret

bring_balance_to_the_word:
pushq %rbp
  movq %rsp, %rbp
  movq $0, %rax # counter
  pushq %rax
  pushq %rdi
  pushq %rsi
  
  popq %rsi
  popq %rdi
  popq %rax
  balance_loop:
  pushq %rax
  pushq %rdi
  pushq %rsi

  popq %rsi
  popq %rdi
  popq %rax

  ret
