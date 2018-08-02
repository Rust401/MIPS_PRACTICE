            .data
message_s:  .asciiz "\r\nSuccess! Location: "
message_f:  .asciiz "\r\nFail!\r\n"
s_end:      .asciiz "\r\n"
buf:        .space 100


            .text
            .globl main

main:       la $a0,buf
            li $a1,100
            li $v0,8
            syscall

inputchar:  li $v0,12
            syscall
            sub $t0,$v0,63
            beqz $t0,exit

            li $t1,0
            la $s0,buf              # s0 save the buff address

find_loop:  lb $s1,0($s0)           # t1 is the iterator
            sub $t0,$v0,$s1         # s1 is the current char in the string to match
            beqz $t0,success
            addi $t1,$t1,1
            slt $t2,$t1,$a1         # t2 is the flag. t2==1?in the loop:out the loop
            beqz $t2,fail
            addi $s0,$s0,1
            j find_loop

success:    la $a0,message_s
            li $v0,4                #pirnt string
            syscall                 
            addi $a0,$t1,1
            li $v0,1                #print int
            syscall      
            la $a0,s_end
            li $v0,4
            syscall                 #print the string(endl)
            j inputchar       

fail:       la $a0,message_f
            li $v0,4
            syscall
            j inputchar    

exit:       li $v0,10
            syscall