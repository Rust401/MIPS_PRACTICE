            .data
A_Z:     	.asciiz
            "Alpha ","Bravo ","China ","Delta ","Echo ","Foxtrot ",
            "Golf ","Hotel ","India ","Juliet ","Kilo ","Lima ",
            "Mary ","November ","Oscar ","Paper ","Quebec ","Research ",
            "Sierra ","Tango ","Uniform ","Victor ","Whisky ","X-ray ",
            "Yankee ","Zulu "
AZ_offset:  .word
            0,7,14,21,28,34,43,49,56,63,71,
            77,83,89,99,106,113,121,131,
            139,146,155,163,171,178,186
a_z:     	.asciiz
            "alpha ","bravo ","china ","delta ","echo ","foxtrot ",
            "golf ","hotel ","india ","juliet ","kilo ","lima ",
            "mary ","november ","oscar ","paper ","quebec ","research ",
            "sierra ","tango ","uniform ","victor ","whisky ","x-ray ",
            "yankee ","zulu "
az_offset:  .word
            0,7,14,21,28,34,43,49,56,63,71,
            77,83,89,99,106,113,121,131,
            139,146,155,163,171,178,186
number:     .asciiz
            "zero ", "First ", "Second ", "Third ", "Fourth ",
            "Fifth ", "Sixth ", "Seventh ","Eighth ","Ninth "
n_offset:   .word
            0,6,13,21,28,36,43,50,59,67

            .text
            .globl main
main:		li $v0,12			#char = getchar();
			syscall
			sub $t0,$v0,63   	#if(char=='?)goto exit;
			beqz $t0,exit

			sub $t0,$v0,48		#else if(char<'0')goto others;
			slt $s0,$t0,$0		
			bnez $s0,others		


			#number?
			sub $t0,$t0,10		#else if(char<='9')goto get_num;
			slt $s1,$t0,$0
			bnez $s1,get_num
			

			#captal?			#else if(char>'A' && char<'Z')goto get_AZ;
			sub $t0,$v0,91
			slt $s3,$t0,$0
			sub $t0,$v0,64
			sgt $s4,$t0,$0
			and $s0,$s3,$s4
			bnez $s0,get_AZ

			#low case?
			sub $t0,$v0,123		#else if(char>'a'&& char<'z')goto get_az;
			slt $s3,$t0,$0
			sub $t0,$v0,96
			sgt $s4,$t0,$0
			and $s0,$s3,$s4
			bnez $s0,get_az
			j others			#else goto others;

get_AZ:		sub $t0,$v0,65		#int i = char-'A'
			sll $t0,$t0,2		#i* = 4
			la $s0,AZ_offset	#int *addressOfAZ_offset = &AZ_offset
			add $s0,$s0,$t0		#addressOfAZ_offset+ = 4*i
			lw $s1,($s0)		#int offset = *addressOfAZ_offset
			la $a0,A_Z			#char *addressOfAZ = &A_Z
			add $a0,$a0,$s1		#addressOfAZ+ = offset
			li $v0,4			#cout<<*addressOfAZ
			syscall
			j main				#goto main

get_az:		sub $t0,$v0,97		#same to the get_az
			sll $t0,$t0,2
			la $s0,az_offset
			add $s0,$s0,$t0
			lw $s1,($s0)
			la $a0,a_z
			add $a0,$a0,$s1
			li $v0,4
			syscall
			j main	

get_num:	sub $t0,$v0,48		#same to the get_AZ && get_az
			sll $t0,$t0,2
			la $s0,n_offset
			add $s0,$s0,$t0
			lw $s1,($s0)
			la $a0,number
			add $a0,$a0,$s1
			li $v0,4
			syscall
			j main
			
others:		li $a0,42			#char = '*'
			li $v0,11			#print char
			syscall
			j main

exit:		li $v0,10			#exit
			syscall