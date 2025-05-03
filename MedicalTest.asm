# Author: Ahmad Hussin & Mohammad Qadi
# ID: 1210326 & 1211099
# Section: 1

.data
file_name: .asciiz "C:\\Users\\hussi\\OneDrive - student.birzeit.edu\\Desktop\\data.txt"
  file_buffer: .space 1024
  file_read_size: .word 1024
  menu: .asciiz "\nPlease choose an option:\n1) Add a new medical test\n2) Search for a patient by ID\n3) Search for upnormal tests\n4) Find average test values\n5) Update an existing test result\n6) Delete a test\n7) Exit\n"
  invalidd: .asciiz "This is an invalid option, Please try again\n"
hello_message : .asciiz "welcome to the programme !!\n"
id_message : .asciiz "please enter the patient ID number : (7-digit number)\n"
date_message : .asciiz "please enter the test date : (YYYY-MM any other formate will not be accepted ! ) \n"
test_message : .asciiz "please enter the test type : ( BBB any other formate will not be accepted ! )\n"
result_message : .asciiz "please enter the test result : (x.x any other format will not be accepted)\n"
bpt_first_message : .asciiz "please enter the systolic blood pressure : (x.x any other format will not be accepted !!)\n"
bpt_second_message : .asciiz "please enter the diastolic blood pressure : (x.x any other format will not be accepted !!\n)"
test_name_error:.asciiz "error in test name !! \n"
can_not_create_heap_message: .asciiz "error making a new node !!\n"
can_not_open_file_message: .asciiz "can not open the file  !!\n"
data_format_error_in_test_name_message:.asciiz "error in reading test name !!! \n"
data_format_error_in_date_message:.asciiz "error in reading test date !!! \n"
data_format_error_in_reading_number_message:  .asciiz "error in reading or converting number .\nplease make sure to follow the format !!! \n"
starting_date_message: .asciiz "please enter the starting date (YYYY-MM) :\n"
ending_date_message: .asciiz "please enter the ending date (YYYY-MM) :\n"
patient_based_operation_message: .asciiz
"please enter your selection : \n 1-Retrieve all patient tests.\n 2-Retrieve all up normal patient tests\n 3-Retrieve all patient tests in a given specific period. \n"


hgb: .asciiz "HGB, "
bgt: .asciiz "BGT, "
bpt: .asciiz "BPT, "
ldl: .asciiz "LDL, "
date_seperator: .asciiz "-"
space: .asciiz " "
newline: .asciiz "\n"
comma_space: .asciiz ", "
colon: .asciiz ":"

.align 2
ourstring: .space 8
Date_input: .space 8
Name_input: .space 4 

###head of linked lists to hold each test type
hgb_head: .word 0 #next
bgt_head: .word 0 #next
bpt_head: .word 0 #next
ldl_head: .word 0 #next

node_bpt_size: .word 20 
node_size: .word 16
node: .space 12 #temp node 
buffer:.space 30 

integer_buffer: .space 30
float_buffer: .space 30 
temp_buffer: .space 30 

hgb_average: .space 4
bgt_average: .space 4
ldl_average: .space 4
bpt_average: .space 4

hgb_max: .float 17.2
hgb_min: .float 13.8

bgt_max: .float 99 
bgt_min: .float 70 

ldl_normal: .float 100

bpt_first: .float 120
bpt_second: .float 80

test_line_to_write_on_file: .space 100

Date_String: .space 20

ID_inp: .asciiz "ID:"


#  ____________________________________________________________________________________________________________________________________#
# |                                                                                                                                   |#
# |                                                                                                                                   |#
# |                                                            MACROS                                                                 |#  
# |                                                                                                                                   |# 
# |___________________________________________________________________________________________________________________________________|#


.macro print_string (%something)
   # move $a0, int
    li $v0, 4 
    la $a0, %something 
    syscall
.end_macro

.macro print_stringg (%something)
   # move $a0, int
    li $v0, 4 
    move $a0, %something 
    syscall
.end_macro

.macro print_int (%something)
   # move $a0, int
    li $v0, 1 
    move $a0, %something 
    syscall
.end_macro    

.macro input_int
   li $v0, 5
   syscall
.end_macro

.macro input_float
   li $v0, 6
   syscall
.end_macro 
 
.macro input_string
    li $v0,8
    la $a0, ourstring # the name of the string we want to input
    li $a1, 8   # the size of the string
    syscall
   
.end_macro         
          
.macro printstr (%str)
  .data 
    label: .asciiz %str
  .text 
    li $v0, 4 
    la $a0, label 
    syscall     
.end_macro

.macro print_static_message (%message_address) ## print a message address stored in memory 
	la $a0 , %message_address
	li $v0 , 4
	syscall
.end_macro              

.macro print_float (%something)
    li $v0, 2
    mov.s $f12, %something
    syscall
      
.end_macro                  
            
.macro save_address
   addi $sp, $sp, -4
   sw $ra, 0($sp) 
.end_macro

.macro return_address
   lw $ra, 0($sp)
   addi $sp, $sp, 4
.end_macro       

############################################### CODE ################################################################# 

.text
.globl main
 main:
 
    ## reading the file
    la $a0 , file_name
    la $a1 , file_buffer
    lw $a2 , file_read_size
    
    jal read_file
    
my_menu:
   # printing the menu with its options    
   print_string (menu) 
   input_int
   move $t0,$v0
   beq $t0,1,option1
   beq $t0,2,option2
   beq $t0,3,option3
   beq $t0,4,option4
   beq $t0,5,option5
   beq $t0,6,option6
   beq $t0,7,option7
   b invalid_option 

option1:
  jal add_new_test
  b my_menu  
option2:
  jal patient_based_operation
  b my_menu            
option3:

  jal Find_Upnormal
  b my_menu
  
option4:

  jal calculate_average
  b my_menu
  
option5:

   printstr ("Enter the ID:")
   #print_string (ID_inp) 
   input_int
    
   move $t1, $v0 
    
   printstr ("TestName:")
    
   li $v0, 8
   la $a0, Name_input
   li $a1, 4
   syscall

   la $t7, Name_input
    
   printstr ("\n")
   printstr ("Date:")
   li $v0, 8
   la $a0, Date_input 
   li $a1, 8
   syscall
    
   la  $t8, Date_input  
 
   move $a0, $t7
   move $a1, $t1
   move $a2, $t8
   
  jal Update

  b my_menu
  
option6:

   printstr ("ID:")
   input_int
    
   move $t1, $v0 
    
   printstr ("TestName:")
    
   li $v0, 8
   la $a0, Name_input
   li $a1, 4
   syscall

   la $t7, Name_input
    
   printstr ("\n")
   printstr ("Date:")
   li $v0, 8
   la $a0, Date_input 
   li $a1, 8
   syscall
    
   la  $t8, Date_input  
 
   move $a0, $t7
   move $a1, $t1
   move $a2, $t8


 jal Delete

 b my_menu
 
option7:

 printstr ("Do you want to save changes?\nEnter 1 if yes, 0 if no: ")
 input_int
 beq $v0, 0, finish
 jal write_to_file
 b finish  
 
invalid_option:

 printstr ("Invalid option, try again\n")
 b my_menu 
 
###### finish #######
finish:
 li $v0,10
 syscall    


####################################### FUNCTIONS ################################################


#------------------------------------------------------------------------------------------#
# This function will find the average value for each test in our test records

calculate_average:

# save the value of s0 register

    addi $sp, $sp , -4
    sw	$s0 , 0($sp)
    
### calculte the average value for the hgb test
   ##  0 --> ID
   ##  4 --> Date
   ##  8 --> Result
   ## 12 --> Next
   
    lw $s0, hgb_head
    beq $s0, 0, no_hgb  # check if the hgp list is empty
    li $t1,0   ## --> This is a counter for the number of hgb tests
    mtc1 $t1, $f0
    cvt.s.w $f0, $f0
    
loophgb:
     
     beq $s0,0, finish_hgb_averaging  
     lw $t0, 8($s0)
     mtc1 $t0, $f1
     
     add.s $f0, $f0, $f1
     addi $t1, $t1, 1    
     lw $s0, 12($s0)
    
j loophgb
  
finish_hgb_averaging:
    mtc1 $t1, $f1
    cvt.s.w $f1, $f1
    div.s $f0, $f0, $f1  
    printstr ("The average value of the HGB test is: ")
    print_float ($f0)
    printstr ("\n")
no_hgb: 
   
# ---------- start averaging BGT -----------#    
    
    lw $s0, bgt_head
    beq $s0, 0, no_bgt  # check if the bgt list is empty
    li $t1,0   ## --> This is a counter for the number of hgb tests
    mtc1 $t1, $f0
    cvt.s.w $f0, $f0
    
loopbgt:
     
     beq $s0,0, finish_bgt_averaging  
     lw $t0, 8($s0)
     mtc1 $t0, $f1
     
     add.s $f0, $f0, $f1
     addi $t1, $t1, 1    
     lw $s0, 12($s0)
    
j loopbgt
  
finish_bgt_averaging:
    mtc1 $t1, $f1
    cvt.s.w $f1, $f1
    div.s $f0, $f0, $f1  
    printstr ("The average value of the BGT test is: ")
    print_float ($f0)
    printstr ("\n")
no_bgt:  
      
# ---------- start averaging LDL -----------#    
    
    lw $s0, ldl_head
    beq $s0, 0, no_ldl # check if the ldl list is empty
    li $t1,0   ## --> This is a counter for the number of hgb tests
    mtc1 $t1, $f0
    cvt.s.w $f0, $f0
    
loopldl:
     
     beq $s0,0, finish_ldl_averaging  
     lw $t0, 8($s0)
     mtc1 $t0, $f1
     
     add.s $f0, $f0, $f1
     addi $t1, $t1, 1    
     lw $s0, 12($s0)
    
j loopldl
  
finish_ldl_averaging:
    mtc1 $t1, $f1
    cvt.s.w $f1, $f1
    div.s $f0, $f0, $f1  
    printstr ("The average value of the LDL test is: ")
    print_float ($f0)
    printstr ("\n")

no_ldl: 
         
# ---------- start averaging BPT -----------#    
    
    lw $s0, bpt_head
    beq $s0, 0, no_bpt   # check if the bpt list is empty
    li $t1,0   ## --> This is a counter for the number of hgb tests
    mtc1 $t1, $f0
    cvt.s.w $f0, $f0
    
loopbpt:
     
     beq $s0,0, finish_bpt_averaging  
     lw $t0, 8($s0)
     lw $t2, 16($s0)
     mtc1 $t0, $f1
     
     add.s $f0, $f0, $f1
     
     mtc1 $t2, $f1
     add.s $f2, $f2, $f1
     
     addi $t1, $t1, 1    
     lw $s0, 12($s0)
    
j loopbpt
  
finish_bpt_averaging:
    mtc1 $t1, $f1
    cvt.s.w $f1, $f1
    div.s $f0, $f0, $f1
    div.s $f2, $f2, $f1  
    printstr ("The average value of the first BPT result (Systolic Blood Pressure) is: ")
    print_float ($f0)
    printstr ("\n")
     
    printstr ("The average value of the second BPT result (Diastolic Blood Pressure) is: ")
    print_float ($f2)
    printstr ("\n")
                
no_bpt:
    
    lw	$s0 , 0($sp)                                                        
    addi $sp, $sp , 4
jr $ra

#------------------------------------------------------------------------------------------#

# This function will delete a test based on the ID, Name, Date
# The params of the function will be in $a0, $a1, $a2
#--->>  a0 => Name
#--->>  a1 => ID
#--->>  a2 => Date

Delete:
     
     li $t5,0  
     addi $sp, $sp , -20
     sw $s0, 0($sp) 
     sw $s1, 4($sp)      
     sw $s2, 8($sp)
     sw $s3, 12($sp)
     sw $s4, 16($sp)
                     
     move $s1, $a0
     move $s2, $a1
     move $s3, $a2 
     
     save_address          
     jal check_test_name
     return_address
      
     beq $v0, 0, none_of_above 
     beq $v0, 1, is_hgp
     beq $v0, 2, is_bgt
     beq $v0, 3, is_ldl
     beq $v0, 4, is_bpt
 
               
is_hgp:

  lw $s0, hgb_head
   
  save_address
  jal same_proc
  return_address
  
  b doneee                    
is_bgt:

  lw $s0, bgt_head
   

  save_address    
  jal same_proc
  return_address
  
  b doneee
       
is_ldl:

  lw $s0, ldl_head
   
  save_address 
  jal same_proc
  return_address
  b doneee
  
is_bpt:

  lw $s0, bpt_head
   
  save_address 
  jal same_proc
  return_address

  b doneee
none_of_above:
  printstr ("\nInvalid Test name\n")
  b skopy 
  
doneee: 
    beq $t6,1,deleteeed
    printstr ("\nThe informaion you have entered was not found, please check your data and try again :)\n")
    b skopy    
deleteeed:
    printstr ("\nThe test has been deleted successfully\n")
    li $t6, 0

skopy:
                          
     lw $s0, 0($sp)                  
     lw $s1, 4($sp)      
     lw $s2, 8($sp)
     lw $s3, 12($sp)
     lw $s4, 16($sp)
     addi $sp, $sp , 20
                            
jr $ra

#------------------------------------------------------------------------------------------#
# This function will convert the date to number and store it in $t8

get_Date:
  li $t8, 0   
looping:
    lb $t4, ($s3)
    beq $t4,45, skipme
    beq $t4,0, endd
    subi $t4, $t4,48
    mul $t8,$t8,10 
    add $t8,$t8,$t4
skipme:               
    addi $s3,$s3, 1    
         
j looping
  
endd:

jr $ra

#------------------------------------------------------------------------------------------#

# this function will perform the deleting process
same_proc:

    li $t6, 0 # => this will be used as a flag to check if the deleting process passed or faild
iterate_list:
   beq $s0, 0 ,return_back
   lw $t1, 0($s0)
   beq $t1, $s2, check_Datee
   b move_node
   
check_Datee:
   addi $sp, $sp , -4
   sw $ra, 0($sp)
   
   move $s3, $a2           
   jal get_Date
   lw $t1, 4($s0)
 
   lw $ra, 0($sp)
   addi $sp, $sp , 4
   beq $t8, $t1, Deleteee
   
move_node:
   
   move $t5, $s0     # t5 will contain the previous node
                               
   lw $s0, 12($s0)
      
j iterate_list

Deleteee:
     #move $t5, $s0 
     beq $t5,0 , delete_the_first  # if we are deleting the first node
     lw $s0, 12($s0)
     sw $s0, 12 ($t5)
     b sskkiipp
     
delete_the_first:

     beq $v0, 1, move_hgb_head
     beq $v0, 2, move_bgt_head
     beq $v0, 3, move_ldl_head
     beq $v0, 4, move_bpt_head
move_hgb_head:
      lw $s4, 12($s0)       
      sw $s4, hgb_head
      li $t6, 1 
      lw $s0, hgb_head        
j iterate_list 
move_bgt_head:
 
      lw $s4, 12($s0)       
      sw $s4, bgt_head
      li $t6, 1
      lw $s0, bgt_head        
j iterate_list 
                 
move_ldl_head:     
 
      lw $s4, 12($s0)       
      sw $s4, ldl_head
      li $t6, 1
      lw $s0, ldl_head
               
j iterate_list 
      
move_bpt_head:

      lw $s4, 12($s0)       
      sw $s4, bpt_head
      li $t6, 1
      lw $s0, bpt_head
              
j iterate_list                                       
     
sskkiipp:         
     li $t6, 1
     b iterate_list

return_back:          
jr $ra

# ------------------------------------------------------------------------------ #
# This function will Update a test result based on the ID, Name, Date
# The params of the function will be in $a0, $a1, $a2
#--->>  a0 => Name
#--->>  a1 => ID
#--->>  a2 => Date
Update:
     li $t0, 0  # ==> this will be used as a flag to check if the update passed or not
     
     addi $sp, $sp , -20
     sw	$ra , 0($sp)
     sw $s0, 4($sp) 
     sw $s1, 8($sp)      
     sw $s2, 12($sp)
     sw $s3, 16($sp)
                
     move $s1, $a0
     move $s2, $a1
     move $s3, $a2 
      
          
     jal check_test_name
     
     lw $ra, 0($sp)     
     addi $sp, $sp, 4
      
     beq $v0, 0, its_none_of_above 
     beq $v0, 1, its_hgp
     beq $v0, 2, its_bgt
     beq $v0, 3, its_ldl
     beq $v0, 4, its_bpt 

its_hgp:
   lw $s0, hgb_head
   
 
   save_address
   move $s3, $a2
   jal update_steps 
   
   return_address
  b updated_or_not

its_bgt:

   lw $s0, bgt_head
   
 
   save_address
   move $s3, $a2
   jal update_steps 
   
   return_address

  b updated_or_not

its_ldl:
  
   lw $s0, ldl_head
   
 
   save_address
   move $s3, $a2
   jal update_steps 
   
   return_address

  b updated_or_not
  
its_bpt:
   lw $s0, bpt_head
   
   save_address
   move $s3, $a2
   
   jal update_steps_BPT
   
   return_address
  b updated_or_not
  
its_none_of_above:
   printstr ("\nEnter a valid test name\n")
   b invalid_name
        
updated_or_not:
     beq $t0, 1, passed_update  
     printstr ("Failed to update the test, check the data you entered and try again\n")
     b invalid_name 
passed_update:
     printstr ("The result has updated successfully\n")
     lw $s0, 4($sp) 
     lw $s1, 8($sp)      
     lw $s2, 12($sp)
     lw $s3, 16($sp)
     addi $sp, $sp , 16

invalid_name:                                        
jr $ra

# ------------------------------------------------------------------- #
# this fucntion will perform the process of updating the tests reuslt except the BPT 
update_steps:
   printstr ("\nPlease enter the NewResult: ")
   input_float
up:
   beq $s0, 0 ,return_backkk
   lw $t1, 0($s0)
   beq $t1, $s2, check_Dateee
   b movee_node
   
check_Dateee:
   addi $sp, $sp , -4
   sw $ra, 0($sp)
    
   move $s3, $a2         
   jal get_Date
   lw $t1, 4($s0)
 
   lw $ra, 0($sp)
   addi $sp, $sp , 4
   beq $t8, $t1, go_update
movee_node:
   lw $s0, 12 ($s0)
   b up  
go_update:
   li $t0, 1
   mfc1 $t7, $f0
   sw $t7, 8($s0)
   lw $s0, 12($s0)
   b up    
return_backkk:

jr $ra

# --------------------------------------------------------------- #
# this fucntion will perform the process of updating the BPT reuslt 
update_steps_BPT:
   
   printstr ("\nPlease enter the first NewResult: ")
   input_float
   mov.s $f1, $f0
   printstr ("\nPlease enter the second NewResult: ")
   input_float
   
upp:
   beq $s0, 0 ,return_backkkk
   lw $t1, 0($s0)
   beq $t1, $s2, check_Dateeee
   b movee_nodee
   
check_Dateeee:
   addi $sp, $sp , -4
   sw $ra, 0($sp)
    
   move $s3, $a2         
   jal get_Date
   lw $t1, 4($s0)
 
   lw $ra, 0($sp)
   addi $sp, $sp , 4
   beq $t8, $t1, goo_update 
movee_nodee:
   lw $s0, 12 ($s0)
   b upp  
goo_update:
   li $t0, 1
   mfc1 $t7, $f1
   sw $t7, 8($s0)

   mfc1 $t7, $f0
   sw $t7, 16($s0)
   lw $s0, 12($s0)
   b upp    
return_backkkk:

jr $ra

# ------------------------------------------------------------------- #
Find_Upnormal:
    li $t7,0
    mtc1 $t7,$f0
    cvt.s.w $f0,$f0
        
    mtc1 $t7,$f2
    cvt.s.w $f2,$f2
    
    mtc1 $t7,$f4
    cvt.s.w $f4,$f4    

    mtc1 $t7,$f5
    cvt.s.w $f5,$f5
            
    addi $sp, $sp, -4
    sw $s0, 0($sp)
    
 # input the name of the test
    printstr ("Enter the name of the test: ")
    li $v0, 8
    la $a0, Name_input
    li $a1, 4
    syscall
    
    la $t7, Name_input
    
    save_address
    jal check_test_name
    return_address 

      
     beq $v0, 0, does_not_exist 
     beq $v0, 1, hgb_test
     beq $v0, 2, bgt_test
     beq $v0, 3, ldl_test
     beq $v0, 4, bpt_test 
   
hgb_test:
  lw $s0, hgb_head
    
loop_overr:
  beq  $s0, 0, baraa 
  lw $t7, 8($s0)
  mtc1 $t7, $f2

  save_address
  jal normality_hgb
  return_address
  
  beq $t0, 1, print_it 
  b inc
print_it:   
 
   lw $t5, 0($s0)
   printstr ("\n")
   print_int ($t5)
   printstr (": ")
   
   printstr ("Hgb, ")
   
   lw $t5, 4($s0)
   move $a0, $t5
   save_address
   jal print_Datee
   return_address

   printstr (", ")
   
   lw $t5, 8($s0)
   mtc1 $t5, $f5
   print_float ($f5)
   
inc:      
   lw $s0, 12 ($s0) 
                                                 
j loop_overr
      
# -------#
            
bgt_test:
    lw $s0, bgt_head
    
loop_overrr:
  beq  $s0, 0, baraa 
  lw $t7, 8($s0)
  mtc1 $t7, $f2
  
  save_address
  jal normality_bgt
  return_address
  
  beq $t0, 1, print_itt 
    b incc
print_itt:   
   
   lw $t5, 0($s0)
   printstr ("\n")
   print_int ($t5)
   printstr (": ")
   
   printstr ("BGT, ")
   
   lw $a0, 4($s0)
   save_address
   jal print_Datee
   return_address

   printstr (", ")
   
   lw $t5, 8($s0)
   mtc1 $t5, $f5
   print_float ($f5)
   
incc:     
   lw $s0, 12 ($s0)                                               
j loop_overrr

# -------#

ldl_test:

    lw $s0, ldl_head
    
loop_overrrr:
  beq  $s0, 0, baraa 
  lw $t7, 8($s0)
  mtc1 $t7, $f2
  
  save_address
  jal normality_ldl
  return_address
  
  beq $t0, 1, print_IT 
  b inccc
print_IT:   

   lw $t5, 0($s0)
   printstr ("\n")
   print_int ($t5)
   printstr (": ")
   
   printstr ("LDL, ")
   
   lw $a0, 4($s0)
   save_address
   jal print_Datee
   return_address
   printstr (", ")
   
   lw $t5, 8($s0)
   mtc1 $t5, $f5
   print_float ($f5)
   
inccc:     
   lw $s0, 12 ($s0)                                               
j loop_overrrr

# -------#

bpt_test:
  lw $s0, bpt_head
loop_overrrrr: 
  beq  $s0, 0, baraa 
  lw $t7, 8($s0)
  mtc1 $t7, $f2
  
  lw $t7, 16($s0)
  mtc1 $t7, $f4
  
  
  save_address
  jal normality_bpt
  return_address
  
  beq $t0, 1, print_It 
  b incccc
print_It:   

   lw $t5, 0($s0)
   printstr ("\n")
   print_int ($t5)
   printstr (": ")
   
   printstr ("BPT, ")
   
   lw $a0, 4($s0)
   save_address
   jal print_Datee
   return_address
   printstr (", ")
   
   lw $t5, 8($s0)
   mtc1 $t5, $f5
   print_float ($f5)
   
   printstr (", ")    
   lw $t5, 16($s0)
   mtc1 $t5, $f5
   print_float ($f5)   
   
incccc:     
   lw $s0, 12 ($s0)                                               
j  loop_overrrrr
  
does_not_exist:
   printstr ("\nThe name you entered is incorrect, Please check your inforamtion and try again :)\n")
baraa:
jr $ra

# ---------------------------------------------------------------------------------------------- #

# The following functions will take the result of the test and it will return a boolean, 1--> upnormal, 0--> normal
# The result will be in $f2 (in BPT the second will be in $f3), The output will be in $t0

normality_hgb:
   li $t0, 0
   lwc1 $f0, hgb_max
   lwc1 $f1, hgb_min
   
   c.lt.s $f0, $f2
   bc1t upnormal_hgp
   c.lt.s $f2, $f1
   bc1t upnormal_hgp
   b end_normality_hgb
   
upnormal_hgp:   
    li $t0,1
    
end_normality_hgb:          
jr $ra

# --------------------------------------------------- #
normality_bgt:
   li $t0, 0
   lwc1 $f0, bgt_max
   lwc1 $f1, bgt_min
   
   c.lt.s $f0, $f2 
   bc1t upnormal_bgt
   c.lt.s $f2, $f1
   bc1t upnormal_bgt
   b end_normality_bgt
   
upnormal_bgt:   
    li $t0,1
    
end_normality_bgt:   
jr $ra

# --------------------------------------------------- #
normality_ldl:
   li $t0, 0
   lwc1 $f0, ldl_normal
   c.lt.s $f2, $f0
   bc1t upnormal_ldl
   b end_normality_ldl
   
upnormal_ldl:   
   li $t0, 1
   
end_normality_ldl:      
jr $ra

# --------------------------------------------------- #

normality_bpt:
   li $t0, 0
   lwc1 $f0, bpt_first
   lwc1 $f1, bpt_second
   
   c.lt.s $f2, $f0
   bc1t upnormal_bpt
   
   c.lt.s $f4, $f1
   bc1t upnormal_bpt
   
   b end_normality_bpt
   
upnormal_bpt:   
   li $t0, 1
   
end_normality_bpt:
jr $ra

#----------------------------------------------------------------------------------------#
# this function will print the date as the format in the project statement
# it will take the Date in the $a0 as parameters
print_Datee:
  addi $sp, $sp, -4
  sw $s0, 0($sp) 
 
  save_address
  la $a1, Date_String  
  jal int_to_string
  move $s0, $v0  
  return_address  

 li $t6,0 ## counter
loop_date:  
   lb $t5, ($s0)
   beq $t6, 4, print_dash   
   beq $t6, 7, job_done
   
   li $v0,11
   move $a0, $t5
   syscall
   
   addi $s0, $s0, 1
   addi $t6, $t6, 1
 j loop_date
    
print_dash:
   la $t5, date_seperator
   
   li $v0,4
   move $a0, $t5
   syscall
   
   addi $t6, $t6, 1
  j loop_date       
job_done:                                                            
                              
  lw $s0, 0($sp)
  addi $sp, $sp, 4                                  
jr $ra



#########
#### create node 
########
# Argument: no
#
# Return: $v0 = address of the allocated data
create_new_node: 
                ## $t0 is used to store the address of the correct test last node
                ## the address of allocated space is in V0 if V0
    addi $sp, $sp , -4 
    sw	$ra , ($sp)
    lw $a0 , node_size
    li $v0 , 9
    syscall 
    lw $ra , ($sp) 
    addi $sp , $sp , 4
    jr $ra
################################################################################################
#############################################################################################
####################### allocate a new 


#########
#### create bpt node 
########
# Argument: no
#
# Return: $v0 = address of the allocated data
create_new_bpt_node: ## the address of allocated space is in V0 if V0
    addi $sp, $sp , -4 
    sw	$ra , ($sp)
    
    lw $a0 , node_bpt_size
    li $v0 , 9
    syscall 
    beq $v0 , -1 , can_not_create_heap
    lw $ra , ($sp) 
    addi $sp , $sp , 4
    jr $ra
####
##end of function
####



# Function to convert a string of numbers to an integer
# Input: $a0 - address of the number string
#        $a1 - length of the number string
# Output: $v0 - the integer value
#       : $a0 - will be the end address 
str_to_int:
    # Save the callee-saved registers
    addi $sp, $sp , -20
    sw	$ra , ($sp)
    sw	$s0 , 4($sp)
    sw	$s1 , 8($sp)
    sw	$s2 , 12($sp)
    sw  $s3 , 16($sp)
    
    
    move $s0, $a1 # number of digites to s0
    move $s3, $a0 # address of the string buffer to s3
    li $s1, 0  # Initialize the integer value to 0
    li $s2, 0  # Loop counter
    
str_to_int_loop:
    # Load the current digit
    lb $a0, ($s3)
    
    jal char_to_int
    
    
    # Multiply the current integer value by 10 and add the new digit
    mul $s1, $s1, 10
    add $s1, $s1, $v0
    
    # Move to the next digit
    addi $s3, $s3, 1
    addi $s2, $s2, 1
    
    # Repeat the loop until all digits are processed
    blt $s2, $s0, str_to_int_loop

    
    # save the result to output
    move $v0, $s1
    # save the reached memory address to a0
    move $a0, $s3 
    # Restore the callee-saved registers and return the integer value
    lw $ra , ($sp) 
    lw	$s0 , 4($sp)
    lw	$s1 , 8($sp)
    lw	$s2 , 12($sp)
    lw  $s3 , 16($sp)
    addi $sp , $sp , 20
    
    jr $ra
############
##########   end
###########



# Argument: $a0 = buffer address
#
# Return: $f1 = float value
convert_to_float:
    
    addi $sp , $sp , -4 
    sw $ra , ($sp)
    # Initialize variables
    li $t0, 0         # Index
    li $t1, 0         # Integer part
    mtc1 $zero, $f1   # Float part (initialized to 0)
    li $t2, 10        # Divisor for float part
    move $t3 , $a0 
    li $t6, 0          

start:
    # Read integer part
read_integer:
    lb $t4, 0($t3)
    beq $t4, '.', read_float
    beq $t4, $zero, convert_to_float_end
    beq $t4, '\n', convert_to_float_end
    beq $t4, '\r', convert_to_float_end
    beq $t4, ',', convert_to_float_end
    
    move $a0 , $t4
    jal char_to_int 
    move $t4 , $v0
    mul $t1, $t1, 10
    add $t1, $t1, $t4
    addi $t3, $t3, 1
    j read_integer

read_float:
    addi $t3, $t3, 1   # Skip the decimal point
    li $t2, 1         # Divisor for float part
    li $t6 , 0          # hold the float value as integer 
read_float_loop:
    # read the char from buffer amd convert it to float digit
    lb $t4, 0($t3)
    beq $t4, $zero, convert_to_float_end
    beq $t4 , ',' , convert_to_float_end
    beq $t4 , '\n' , convert_to_float_end
    beq $t4 , '\r' , convert_to_float_end
    move $a0 , $t4
    jal char_to_int 
    move $t4 , $v0
    mul $t6 ,$t6 , 10 
    add $t6 , $t6 , $t4
    mul $t2, $t2, 10
    addi $t3, $t3, 1
    j read_float_loop

convert_to_float_end:
    mtc1 $t2 , $f1 #divisor
    cvt.s.w $f3 , $f1 
    mtc1 $t1 , $f1 
    cvt.s.w $f5 ,$f1 # integer part
    beq $t6 , $zero ,zero_floating # if the float pint value is 0 then only set the value of integer to 
    mtc1 $t6, $f1     # Move float that is in iteger 
    cvt.s.w $f7, $f1
    div.s $f9 , $f7 , $f3 
    add.s $f1 , $f9 , $f5 
    j end_str_to_float_function
zero_floating: 
    mov.s $f1,$f5 
end_str_to_float_function:

    move $a0 , $t3 # save the reached byte address in a0 >> either null , \n , ,'
    lw $ra , ($sp)
    addi $sp , $sp , 4
    jr $ra            # Return to calee function 

###
## end of function
###



#########
#### convert char to number 
########
# Argument: $a0 = char
#
# Return: $v0 = digit value
char_to_int:

    addi $sp , $sp , -4 
    sw $ra , ($sp)
    blt  $a0 , '0' ,data_format_error_in_reading_number
    bgt $a0 , '9' , data_format_error_in_reading_number
    subi $v0 , $a0 , '0'
    lw $ra , ($sp)
    addi $sp , $sp , 4
    jr $ra            # Return to calee function 
#####
### end of function
#####



################
##
#### convert integer to string with null termination and save it in buffer 
##
#################
# Inputs:
    #### $a0 - integer value to convert
    #### $a1 - address of the buffer to store the string
    # output
    #### $v0 - start of buffer address where the number is written 
    #### $v1 - the address of null termenation of the string 
    ####
int_to_string:
    # Save the callee-saved registers
    addi $sp, $sp , -16
    sw	$ra , ($sp)
    sw	$s0 , 4($sp)
    sw	$s1 , 8($sp)
    sw	$s2 , 12($sp)
    # Initialize the buffer pointer
    move $s0, $a1                                      
    # move to the end of buffer                        
    addi $s0 , $s0 , 9                          
    move $v1 , $s0                                       
    move $s2 , $zero                                    
    # add null termenation
    sb $zero, ($s0)
    #move to least significant digit address
    addi $s0 ,$s0 , -1 
    #make sure that the number is not zero
    bne $a0 , $zero , int_to_string_non_zero_int
    # it it zero 
    addi $s2, $s2, '0'
    sb $s2, ($s0)
    j int_to_string_done
int_to_string_non_zero_int:

convert_number:
    # Convert the number digit by digit
    li $s1, 10
int_to_string_convert_loop:
    # Get the current digit
    divu $a0, $s1 # divide number by 10
    mfhi $s2 # save reminder to s2
    mflo $a0 # save qutien to a0

    # Convert the digit to ASCII and store it
    addi $s2, $s2, '0'
    sb $s2, ($s0)
    
    # Check if we're done
    beq $a0, $zero, int_to_string_done
    addi $s0, $s0, -1 # move to next address
    j int_to_string_convert_loop
    
int_to_string_done:
    # set the output address
    move $v0, $s0
    # restore calee registers 
    lw $ra , ($sp) 
    lw	$s0 , 4($sp)
    lw	$s1 , 8($sp)
    lw	$s2 , 12($sp)
    addi $sp , $sp , 16
    jr $ra
############################
######
######## integer to string function end 
######
############################



#############################
########
########## convert the float to string 
########
#############################
# Inputs:
#### $f15 - float value to convert
#### $a0 - address of the buffer to store the string
# output:
#### $v0 - start of buffer address where the number is written . (the buffer should be at least 25 )
#### $v1 - end ot the buffer where the number is written . (null termenation)
#############################
float_to_string:

    # save calee funciton reegisters
    addi $sp, $sp, -24
    sw $s0, 0($sp)
    sw $s1, 4($sp)
    sw $s2, 8($sp)
    sw $s3, 12($sp)
    sw $s4, 16($sp) # pointer to temp node 
    sw $s5, 20($sp) # test type >> 1 , 2, 3,4 
    sw $ra, 24($sp)

    move $s2 , $a0
    move $s3 , $a0
    # Convert float to integer
    cvt.w.s $f1, $f15
    # save the int part in s0
    mfc1 $s0, $f1
    #again convert the int part to float 
    cvt.s.w $f1 , $f1 
    # save 100.0 as float in f5
    li $t0 , 100
    mtc1 $t0 , $f3 
    cvt.s.w $f5 , $f3

    # Calculate fractional part
    sub.s $f1, $f15, $f1
    mul.s $f1, $f1, $f5 
    cvt.w.s $f1, $f1
    mfc1 $s1, $f1 # s1 contain the 2 fraction of floaing number as integer 
    
    ## call the int_to_str to convert the first part to str 
    move $a0 , $s0 
    la $a1 , integer_buffer 
    jal int_to_string
    

    move $a0 , $v0 
    move $a1 , $s2 
    sub $a2 , $v1 , $v0 
    jal copy_str


    move $s2 , $v0

    li $t1 ,'.'
    sb $t1 , ($s2)
    addi $s2 , $s2 , 1

    # find the int to str for fraction part
    move $a0 , $s1 
    la $a1 , float_buffer
    jal int_to_string

    move $a0 , $v0 
    move $a1 , $s2 
    sub $a2 , $v1 , $v0 
    jal copy_str
    
    move $s2 , $v0 # end of the float number 
    
    move $v0 , $s3 
    move $v1 , $s2 
    # copy the values
    
    #copy the str to float buffer 



float_to_string_end:
    # restore calee registers 
# Restore registers and return
    lw $s0, 0($sp)
    lw $s1, 4($sp)
    lw $s2, 8($sp)
    lw $s3, 12($sp)
    lw $s4, 16($sp)
    lw $s5, 20($sp) 
    lw $ra, 24($sp)

    addi $sp, $sp, 24   
    
    jr $ra



############################
######
######## float to string function end 
######
############################



#############################
########
########## copy str >> take a memory of data then copy the amount of data to destination address 
########
#############################
# Inputs:
#### $a0 - source buffer address
#### $a1 - dest buffer address
#####$a2 - lenght of data to copy
# output:
#### $v0 - address of null termenation char
#############################
copy_str:
    
    # save calee funciton reegisters
    addi $sp, $sp , -4
    sw	$ra , ($sp)

    move $t0 , $a0
    move $t1 , $a1 
    move $t2 ,$a2
    add $t3 , $t1,$t2 # the last address to read 
    move $t4 , $zero
    # if the length is zero then end 
    beq $a2 , $zero , copy_str_end
copy_str_loop:
    lb $t4 , ($t0) 
    sb $t4 , ($t1)
    addi $t0 , $t0, 1
    addi $t1 , $t1, 1
    beq $t3 ,$t1 , copy_str_end 
    j copy_str_loop

copy_str_end:
    
    #add a null termination to text 
    sb $zero , ($t3)
    # set output the address of null termenation of text 
    move $v0 , $t3 
    # restore calee registers 
    lw $ra , ($sp )
    addi $sp , $sp , 4
    jr $ra
############################
######
######## copy str function end
######
############################




#########
#### errors .... 
########

can_not_open_file: #######invalid char_to_digit 
    la $a0 , can_not_open_file_message
    li $v0 , 4
    syscall 
    li $v0 , 10
    syscall

data_format_error_in_test_name:
    la $a0 , data_format_error_in_test_name_message
    li $v0 , 4
    syscall 
    li $v0 , 10
    syscall


can_not_create_heap:
    la $a0 , can_not_create_heap_message
    li $v0 , 4
    syscall 
    li $v0 , 10
    syscall

data_format_error_in_date:
    la $a0 , data_format_error_in_date_message
    li $v0 , 4
    syscall 
    li $v0 , 10
    syscall

data_format_error_in_reading_number:
    la $a0 , data_format_error_in_reading_number_message
    li $v0 , 4
    syscall 
    li $v0 , 10
    syscall


##########
####### end of errors ...
##########




# 1111111: RRR, 2042-03, 13.5, 213.1\n file format !!!!!!



# Function to read file and store test records to linked list
# Input: $a0 - file name address
#        $a1 - buffer address (save the file read)
#        $a2 - size of buffer 
# Output: $v0 - 
#       
read_file:
    # Save registers
    addi $sp, $sp, -24
    sw $s0, 0($sp)
    sw $s1, 4($sp)
    sw $s2, 8($sp)
    sw $s3, 12($sp)
    sw $s4, 16($sp) # pointer to temp node 
    sw $s5, 20($sp) # test type >> 1 , 2, 3,4 
    sw $ra, 24($sp)
    

    # Open the file
    move $s0, $a0  # filename address
    move $s1, $a1  # buffer address
    move $s2, $a2  # buffer size
    li $a1 , 0
    li $a2 , 0
    li $v0 , 13
    syscall
    #check if the file opened successfully 
    beq $v0 , -1 , can_not_open_file # need_change

    move $s3, $v0  # file descriptor
    
    # Read the file contents into the buffer
    li $v0, 14     # system call code for read
    move $a0, $s3  # file descriptor
    move $a1, $s1  # buffer address
    move $a2, $s2  # buffer size
    syscall

    # check if the file is empty or can not be read
    blt $v0 , $zero , can_not_open_file
    beq $v0, 3  ,read_file_done # empty file 	
    la $s6 , node # temproray node to save test

read_line:
    move $s4 , $s6
    # read the id 
    move $a0 , $s1
    li $a1 , 7 

    jal str_to_int

    sw $v0 , ($s4)
    addi $s4, $s4 , 4
    addi $a0 ,$a0, 2 
    move $s1 , $a0
    #read the test name 

    jal check_test_name
    beq $v0, $zero , data_format_error_in_test_name #change
    move $s5 , $v0 # hold the test type 1,2,3,4,0
    
    addi $a0,$a0 , 5
    # read date 
    li $a1 , 4
    jal str_to_int 
    move $s0 , $v0 
    mul $s0 ,$s0 ,100
    li $a1 , 2
    addi $a0 , $a0 , 1 
    jal str_to_int
    blt $v0 , 1 , data_format_error_in_date # change , check month number
    bgt $v0 , 12 ,data_format_error_in_date # change
    add $s0 , $s0 ,$v0
    sw $s0 , ($s4) 
    addi $s4 , $s4 , 4
    addi $a0 ,$a0, 2 
read_result: 

    jal convert_to_float 
    swc1 $f1  , ($s4)

    move $s1 , $a0 # save the current buffer address in file 
    
    #save the address of temp node to t0
    la $t0 , node

    # check the type of the test
    beq $s5 , 1 , test_one 
    beq $s5 , 2 , test_two 
    beq $s5 , 3 , test_three 
    beq $s5 , 4 , test_foure 

#add the test to apropriate linked list 
test_one:
    jal create_new_node
    # store the address of new node to next of head
    lw $t1,hgb_head
    la $t2 , hgb_head
    sw $v0 , ($t2)
    
    #save id 
    lw $t6 , ($t0)
    sw $t6 , ($v0)
    addi $v0 , $v0 , 4
    #save date
    lw $t6 , 4($t0)
    sw $t6 , ($v0)
    addi $v0 , $v0 , 4
    #save result
    lwc1 $f3 , 8($t0)
    swc1 $f3 , ($v0)
    addi $v0 , $v0 , 4
    sw $t1 , ($v0)
    
    
    j is_file_end
    
    
test_two:
    jal create_new_node
    # store the address of new node to next of head
    lw $t1,bgt_head
    la $t2 , bgt_head
    sw $v0 , ($t2)
    
    #save id 
    lw $t6 , ($t0)
    sw $t6 , ($v0)
    addi $v0 , $v0 , 4
    #save date
    lw $t6 , 4($t0)
    sw $t6 , ($v0)
    addi $v0 , $v0 , 4
    #save result
    lwc1 $f3 , 8($t0)
    swc1 $f3 , ($v0)
    addi $v0 , $v0 , 4
    sw $t1 , ($v0)
    
    
    j is_file_end
    


test_three:
    jal create_new_node
    # store the address of new node to next of head
    #insert the node
    lw $t1,ldl_head
    la $t2 , ldl_head
    sw $v0 , ($t2)
    #save id 
    lw $t6 , ($t0)
    sw $t6 , ($v0)
    addi $v0 , $v0 , 4
    #save date
    lw $t6 , 4($t0)
    sw $t6 , ($v0)
    addi $v0 , $v0 , 4
    #save result
    lwc1 $f3 , 8($t0)
    swc1 $f3 , ($v0)
    addi $v0 , $v0 , 4
    sw $t1 , ($v0)
    
    j is_file_end
    


test_foure:
    # read final result
    addi $s1 ,$s1, 2 
    move $a0 , $s1
    jal convert_to_float
    move $s1 , $a0
    # save the node 

    jal create_new_bpt_node
    # store the address of new node to next of head
    lw $t1,bpt_head
    la $t2 , bpt_head
    sw $v0 , ($t2)
    la $t0 , node
    #save id 
    lw $t6 , ($t0)
    sw $t6 , ($v0)
    addi $v0 , $v0 , 4
    #save date
    lw $t6 , 4($t0)
    sw $t6 , ($v0)
    addi $v0 , $v0 , 4
    #save result
    lwc1 $f3 , 8($t0)
    swc1 $f3 , ($v0)
    addi $v0 , $v0 , 4
    sw $t1 , ($v0)
    addi $v0 ,$v0, 4
    swc1 $f1 , ($v0)
    
    j is_file_end
    


is_file_end:

    add  $s1 , $s1 , 2
    lb $a0 , ($s1)
    beq $a0 , $zero , read_file_done
    beq $a0 , '\r' , read_file_done
    beq $a0 , ' ' , read_file_done


    
    j read_line


read_file_done:
    # Close the file
    li $v0, 16  # system call code for close
    move $a0, $s3  # file descriptor
    syscall

    # Restore registers and return
    lw $s0, 0($sp)
    lw $s1, 4($sp)
    lw $s2, 8($sp)
    lw $s3, 12($sp)
    lw $s4, 16($sp) # pointer to temp node 
    lw $s5, 20($sp) # test type >> 1 , 2, 3,4 
    lw $ra, 24($sp)

    addi $sp, $sp, 24
    jr $ra
############################
######
######## read_file end
######
############################



#############################
########
########## check test name
########
#############################
# Inputs:
#### $a0 - address of string
# output:
#### $v0 - 1, 2, 3, 4 if the string matches "hgb", "Bgt", "ldl", or "bpt" respectively, 0 otherwise
#############################
check_test_name:
    # Save registers
    addi $sp, $sp, -16
    sw $s0, 0($sp)
    sw $s1, 4($sp)
    sw $s2, 8($sp)
    sw $ra, 12($sp)
    

    # Load the 3-character string into registers
    lb $s0, ($a0)    # first character
    lb $s1, 1($a0)   # second character
    lb $s2, 2($a0)   # third character

    beq $s0 , 'H' ,second_hgp
    beq $s0 , 'h' ,second_hgp
    j check_bgt
second_hgp:
    beq $s1 , 'G' ,third_hgp
    beq $s1 , 'g' ,third_hgp
    j check_bgt
third_hgp:
    beq $s2 , 'B' , set_1
    beq $s2 , 'b' , set_1 
    j check_bgt

check_bgt:
    beq $s0 , 'B' ,second_bgt
    beq $s0 , 'b' ,second_bgt
    j check_ldl
second_bgt:
    beq $s1 , 'G' ,third_bgt
    beq $s1 , 'g' ,third_bgt
    j check_ldl
third_bgt:
    beq $s2 , 'T' , set_2
    beq $s2 , 't' , set_2
    j check_ldl

check_ldl:
    beq $s0 , 'L' ,second_ldl
    beq $s0 , 'l' ,second_ldl
    j check_bpt
second_ldl:
    beq $s1 , 'D' ,third_ldl
    beq $s1 , 'd' ,third_ldl
    j check_bpt
third_ldl:
    beq $s2 , 'L' , set_3
    beq $s2 , 'l' , set_3 
    j check_bpt


check_bpt:
    beq $s0 , 'B' ,second_bpt
    beq $s0 , 'b' ,second_bpt
    j set_0
second_bpt:
    beq $s1 , 'P' ,third_bpt
    beq $s1 , 'p' ,third_bpt
    j set_0
third_bpt:
    beq $s2 , 'T' , set_4
    beq $s2 , 't' , set_4
    j set_0


set_0:
    li $v0 , 0
j check_test_name_done

set_1:
    li $v0 , 1
j check_test_name_done

set_2:
    li $v0 , 2
j check_test_name_done

set_3:
    li $v0 , 3
j check_test_name_done

set_4:
    li $v0 , 4
j check_test_name_done

check_test_name_done:
    # Restore registers and return
    lw $s0, 0($sp)
    lw $s1, 4($sp)
    lw $s2, 8($sp)
    lw $ra, 12($sp)
    addi $sp, $sp, 16
    jr $ra

####################3
######
######### end of check test name 
######
####################



#############################
########
########## check test name
########
#############################
# Inputs:
#### $a0 - address of node 
#### $a1 - test num (1,2,3,4)
#############################
print_node:

    # Load the address of the struct
    la $t0, ($a0)

    #print id
    lw $a0, ($t0)
    li $v0 , 1
    syscall

    la $a0 ,colon
    li $v0 , 4
    syscall
    la $a0 , space
    syscall
    
    #print test name 
    beq $a1 , 1 , print_hgb
    beq $a1 , 2 , print_bgt
    beq $a1 , 3 , print_ldl
    beq $a1 , 4 , print_bpt

    
print_hgb: 
    la $a0 , hgb
    j print_date
print_bgt: 
    la $a0 , bgt
    j print_date
print_bpt:
    la $a0 ,bpt
    j print_date
print_ldl: 
    la $a0 , ldl 


print_date:
    li $v0 , 4
    syscall
    
    li $t2 , 100
    lw $a0 , 4($t0)
    divu $a0 , $t2 
    mflo $a0 
    li $v0 , 1 
    syscall
    la $a0 , date_seperator
    li $v0 , 4
    syscall
    mfhi $a0 
    li $v0 , 1 
    syscall
    la $a0 , comma_space
    li $v0 , 4 
    syscall


    # Load the float value
    lwc1 $f12, 8($t0)
    li $v0 , 2
    syscall

    

    bne $a1 , 4 , print_node_end
    la $a0 , comma_space 
    li $v0 , 4
    syscall
    # Load the float value
    lwc1 $f12, 16($t0)
    li $v0 , 2
    syscall

print_node_end:
    la $a0 , newline 
    li $v0 , 4
    syscall
    jr $ra

#############################
########
########## print_node_end
########
#############################



#############################
########
########## add new test
########
#############################
# Inputs:
#############################
add_new_test:
    # Save registers
    addi $sp, $sp, -24
    sw $s0, 0($sp)
    sw $s1, 4($sp)
    sw $s2, 8($sp)
    sw $s3, 12($sp)
    sw $s4, 16($sp) # pointer to temp node 
    sw $s5, 20($sp) # test type >> 1 , 2, 3,4 
    sw $ra, 24($sp)

    la $s0 , buffer # s0 will hold the buffer address
    #get the user id
    
    #print meassage
    print_static_message(id_message)
    #read input
    li $v0 , 8
    move $a0 , $s0
    li $a1 , 10
    syscall
    # str to int conversion
    li $a1 , 7
    jal str_to_int
    move $s1 , $v0 # s1 hold id

    # get test name 
    
    # print message
    print_static_message(test_message)
    #read data
    li $v0 , 8
    move $a0 , $s0
    li $a1 , 10
    syscall
    #test name check
    jal check_test_name
    move $s2 , $v0  # s2 hold test num
    #save test type



    # get the test date

    # print message
    print_static_message(date_message)
    #read data
    li $v0 , 8
    move $a0 , $s0
    li $a1 , 10
    syscall


    #convert date
    li $a1 , 4
    jal str_to_int 
    move $s3 , $v0 
    mul $s3 ,$s3 ,100
    li $a1 , 2
    addi $a0 , $a0 , 1 
    jal str_to_int
    blt $v0 , 1 , data_format_error_in_date # change , check month number
    bgt $v0 , 12 ,data_format_error_in_date # change
    add $s3 , $s3 ,$v0 # s3 hold date 


    #get the test result

    # print message
    print_static_message(result_message)
    #read data
    li $v0 , 8
    move $a0 , $s0
    li $a1 , 10
    syscall
    # convert result 
    jal convert_to_float
    
    beq $s2 , 1 , add_new_test_test_one 
    beq $s2 , 2 , add_new_test_test_two 
    beq $s2 , 3 , add_new_test_test_three 
    beq $s2 , 4 , add_new_test_test_foure 

    la $a0 , test_name_error
    li $v0 , 4
    syscall
    j add_new_test_end

add_new_test_test_one:
    jal create_new_node
    lw $t1,hgb_head
    la $t2 , hgb_head
    sw $v0 , ($t2)

    j add_new_test_insert_to_linked_list


add_new_test_test_two:
    jal create_new_node
    # store the address of new node to next of head
    lw $t1,bgt_head
    la $t2 , bgt_head
    sw $v0 , ($t2)

    j add_new_test_insert_to_linked_list



add_new_test_test_three:
    jal create_new_node
    # store the address of new node to next of head
    lw $t1,ldl_head
    la $t2 , ldl_head
    sw $v0 , ($t2)


    j add_new_test_insert_to_linked_list


add_new_test_test_foure:
    mov.s $f15 , $f1 # hold first reslut in f15
    # read second result
    print_static_message(bpt_second_message)
    #read data
    li $v0 , 8
    move $a0 , $s0
    li $a1 , 10
    syscall

    # convert result 
    jal convert_to_float

    jal create_new_bpt_node
    lw $t1,bpt_head
    la $t2 , bpt_head
    sw $v0 , ($t2)

    sw $s1 , ($v0)
    sw $s3 , 4($v0)
    swc1 $f15 , 8($v0)
    sw $t1 , 12($v0)
    swc1 $f1 , 16($v0)

    j add_new_test_end

add_new_test_insert_to_linked_list:
    sw $s1 , ($v0)
    sw $s3 , 4($v0)
    swc1 $f1 , 8($v0)
    sw $t1 , 12($v0)


add_new_test_end:
    # Restore registers and return
    lw $s0, 0($sp)
    lw $s1, 4($sp)
    lw $s2, 8($sp)
    lw $s3, 12($sp)
    lw $s4, 16($sp) # pointer to temp node 
    lw $s5, 20($sp) # test type >> 1 , 2, 3,4 
    lw $ra, 24($sp)

    addi $sp, $sp, 24
    jr $ra
#############################
########
########## add new test
########
#############################



#############################
########
########## patient based operation
######## traverse a linked list and do some function on them when the id is the inputed id .
#############################
# Inputs: 
#############################
patient_based_operation:
    addi $sp, $sp, -24
    sw $s0, 0($sp)
    sw $s1, 4($sp)
    sw $s2, 8($sp)
    sw $s3, 12($sp)
    sw $s4, 16($sp) # pointer to temp node 
    sw $s5, 20($sp) # test type >> 1 , 2, 3,4 
    sw $ra, 24($sp)


# get id 
#print meassage
    print_static_message(id_message)
    #read input
    li $v0 , 8
    la $a0 , buffer
    li $a1 , 10
    syscall
    # str to int conversion
    li $a1 , 7
    jal str_to_int
    move $s1 , $v0 # s1 hold id
    

    print_static_message(patient_based_operation_message)
    #read input
    li $v0 , 8
    la $a0 , buffer
    li $a1 , 10
    syscall
    # str to int conversion
    li $a1 , 1
    jal str_to_int
    move $t0 , $v0 # s1 hold id


    move $a1 , $s1 # move the id to a1 
    beq $t0 , 1 ,patient_based_operation_get_all_user_tests
    beq $t0 , 2 , patient_based_operation_get_up_normal_tests
    beq $t0 , 3 , patient_based_operation_get_all_tests_in_specific_period
    j patient_based_operation_end

patient_based_operation_get_all_user_tests:
# retrive all patient tests 
    la $a0 , dummy_function
    j patient_based_operation_end


patient_based_operation_get_up_normal_tests:
#retrive all up normal patient test
    la $a0 , check_test_validity 
    j patient_based_operation_end




patient_based_operation_get_all_tests_in_specific_period:
# retrive all patients test in specific period
    

    # print message
    print_static_message(starting_date_message)
    #read data
    li $v0 , 8
    la $a0 , buffer
    li $a1 , 10
    syscall


    #convert date
    li $a1 , 4
    jal str_to_int 
    move $s3 , $v0 
    mul $s3 ,$s3 ,100
    li $a1 , 2
    addi $a0 , $a0 , 1 
    jal str_to_int
    blt $v0 , 1 , data_format_error_in_date # change , check month number
    bgt $v0 , 12 ,data_format_error_in_date # change
    add $s3 , $s3 ,$v0 # s3 hold date 

    # print message
    print_static_message(ending_date_message)
    #read data
    li $v0 , 8
    la $a0 , buffer
    li $a1 , 10
    syscall


    #convert date
    li $a1 , 4
    jal str_to_int 
    move $s4 , $v0 
    mul $s4 ,$s4 ,100
    li $a1 , 2
    addi $a0 , $a0 , 1 
    jal str_to_int
    blt $v0 , 1 , data_format_error_in_date # change , check month number
    bgt $v0 , 12 ,data_format_error_in_date # change
    add $s4 , $s4 ,$v0 # s4 hold  ending date 

    move $a2 , $s3 
    move $a3 , $s4 
    move $a1 , $s1 
    la $a0 , check_date_period

    
patient_based_operation_end:

    jal traverse_and_do_on_patient
    # Restore registers and return
    lw $s0, 0($sp)
    lw $s1, 4($sp)
    lw $s2, 8($sp)
    lw $s3, 12($sp)
    lw $s4, 16($sp)
    lw $s5, 20($sp) 
    lw $ra, 24($sp)
    addi $sp, $sp, 24

    jr $ra




#############################
########
########## patient based operation
########
#############################


#############################
########
########## Traverse and do a function if patient id is equal
########
#############################
# Inputs:
###### $a0 - address of the function to be applied to each node
###### $a1 - targeted user id 
###### $a2 - parameter for called function # set it to -1 if you want to use the node info as parameters 
###### $a3 - parameter for called function
#############################
traverse_and_do_on_patient:
    addi $sp, $sp, -24
    sw $s0, 0($sp)
    sw $s1, 4($sp)
    sw $s2, 8($sp)
    sw $s3, 12($sp)
    sw $s4, 16($sp) # pointer to temp node 
    sw $s5, 20($sp) # test type >> 1 , 2, 3,4 
    sw $ra, 24($sp)
    # save regesters    
    move $s0 , $a0 
    move $s1 , $a1 
    move $s3 , $a2 
    move $s4 , $a3 
    move $a0 , $s3 
    move $a1 , $s4

traverse_and_do_on_patient_hgb:
    lw $a2 , hgb_head 
    li $a3, 1
    j traverse_and_do_on_patient_loop

traverse_and_do_on_patient_bgt:
    li $a3, 2
    lw $a2 , bgt_head 
    j traverse_and_do_on_patient_loop
traverse_and_do_on_patient_ldl:
    li $a3, 3
    lw $a2 , ldl_head 
    j traverse_and_do_on_patient_loop

traverse_and_do_on_patient_bpt:
    lw $a2 , bpt_head 
    li $a3 , 4

traverse_and_do_on_patient_loop:
    # Call the function on the current node

    
    beq $a2, $zero, traverse_and_do_on_patient_linked_list_end


    lw $t6 , ($a2) 
    bne $s1 , $t6 , traverse_and_do_on_patient_no_print_node

    jalr $s0 

    beq $zero , $v0 , traverse_and_do_on_patient_no_print_node
    move $a0 , $a2 
    move $a1 , $a3
    jal print_node 
    move $a0 , $s3 
    move $a1 , $s4

traverse_and_do_on_patient_no_print_node:
    # Move to the next node
    lw $a2, 12($a2)

    j traverse_and_do_on_patient_loop

traverse_and_do_on_patient_linked_list_end:
    addi $a3 , $a3 , 1
    beq $a3 , 2 , traverse_and_do_on_patient_bgt
    beq $a3 , 3 , traverse_and_do_on_patient_ldl
    beq $a3 , 4 , traverse_and_do_on_patient_bpt

traverse_and_do_on_patient_end:
	# Restore registers and return
    lw $s0, 0($sp)
    lw $s1, 4($sp)
    lw $s2, 8($sp)
    lw $s3, 12($sp)
    lw $s4, 16($sp)
    lw $s5, 20($sp) 
    lw $ra, 24($sp)
    addi $sp, $sp, 24


    jr $ra

#############################
########
########## travers list function 
########
#############################



#############################
########
########## check validity 
########
#############################
# Inputs:
###### $a2 - address of the node
###### $a3 - test type  
# outputs:
###### $v0 - is upnormal 
#############################
check_test_validity:
    addi $sp, $sp, -24
    sw $s0, 0($sp)
    sw $s1, 4($sp)
    sw $s2, 8($sp)
    sw $s3, 12($sp)
    sw $s4, 16($sp) # pointer to temp node 
    sw $s5, 20($sp) # test type >> 1 , 2, 3,4 
    sw $ra, 24($sp)

    li $v0 , 0
    beq $zero , $a2 , check_test_validity_end 
    li $v0  ,1
    lwc1 $f2 , 8($a2) # first result 
    beq $a3 , 1 , check_test_validity_hgb
    beq $a3 , 2 , check_test_validity_bgt
    beq $a3 , 3 , check_test_validity_ldl
    beq $a3 , 4 , check_test_validity_bpt
    
    j check_test_validity_up_normal

check_test_validity_hgb:
    lwc1 $f0, hgb_max
    lwc1 $f1, hgb_min
    
    c.lt.s $f0, $f2
    bc1t check_test_validity_end
    c.lt.s $f2, $f1
    bc1t check_test_validity_end
    j check_test_validity_up_normal


check_test_validity_bgt:

    lwc1 $f0, bgt_max
    lwc1 $f1, bgt_min
    
    c.lt.s $f0, $f2 
    bc1t check_test_validity_end
    c.lt.s $f2, $f1
    bc1t check_test_validity_end
    j check_test_validity_up_normal

check_test_validity_ldl:
    lwc1 $f0, ldl_normal

    
    c.lt.s $f0, $f2 
    bc1t check_test_validity_end
    
    j check_test_validity_up_normal

check_test_validity_bpt:
    lwc1 $f3 , 16($a2) # second result 

    lwc1 $f0, bpt_first
    lwc1 $f1, bpt_second
    
    c.lt.s $f0, $f2
    bc1t check_test_validity_end

    c.lt.s $f1, $f3
    bc1t check_test_validity_end
    
    j check_test_validity_up_normal




check_test_validity_up_normal:   
    li $v0,0


check_test_validity_end:
    # Restore registers and return
    lw $s0, 0($sp)
    lw $s1, 4($sp)
    lw $s2, 8($sp)
    lw $s3, 12($sp)
    lw $s4, 16($sp)
    lw $s5, 20($sp) 
    lw $ra, 24($sp)
    addi $sp, $sp, 24


    jr $ra

#############################
########
########## check validity end 
########
#############################




#############################
########
########## dummy function return 1 always
########
#############################
# Inputs:
# outputs: 1
#############################
dummy_function: 
    li $v0 , 1 
    jr $ra
#############################
########
########## end dummy function 
########
#############################



#############################
########
########## check date period 
########
#############################
# Inputs:
########## $a0 - starting period 
########## $a1 - ending period
########## $a2 - node address 
# outputs: 1 if node date in within the period 
#############################
check_date_period:
    li $v0 , 0 
    beq $a2 , $zero ,  check_date_period_end
    lw $t0 , 4($a2)
    blt $t0 , $a0 , check_date_period_end 
    bgt $t0 , $a1 , check_date_period_end 
    li $v0 , 1 
check_date_period_end:
    jr $ra
#############################
########
########## end dummy function 
########
#############################



#############################
########
########## write node to file  
########
#############################
#############################
write_to_file:
    addi $sp, $sp, -24
    sw $s0, 0($sp)
    sw $s1, 4($sp)
    sw $s2, 8($sp)
    sw $s3, 12($sp)
    sw $s4, 16($sp) # pointer to temp node 
    sw $s5, 20($sp) # test type >> 1 , 2, 3,4 
    sw $ra, 24($sp)


# opent the file in write mode 
###
# Open the file in write mode
    li $v0, 13      # syscall code for open file
    la $a0, file_name # address of filename string
    li $a1, 1       # flag for write mode
    li $a2, 0       # mode is ignored
    syscall
    blt $v0 , $zero , can_not_open_file 

    move $s1 , $v0 # save the file in s1 
    
    # $s0 will be the pointer to node 
    # $s2 will be the test type counter 
    # $s3 will be the buffer address
    la $s3 , buffer # will be use to save each value to it 
    la $s5 , test_line_to_write_on_file
    # $s4 will hold the reached position in writ to line buffer 
    # $s5 will hold write to line address
# check if the linked list is empty 
###

###
    lw $s0 , hgb_head
    li $s2 , 1 
    j write_line_to_file

write_to_file_new_linked_list:
    lw $s0 , bgt_head
    beq $s2 , 2 , write_line_to_file
    lw $s0 , ldl_head
    beq $s2 , 3 , write_line_to_file
    lw $s0 , bpt_head
    beq $s2 , 4 , write_line_to_file
    j write_to_file_end


write_line_to_file:

    beq $zero , $s0 , write_to_file_end
### 
#convert the id to str 
###
    lw  $a0 , ($s0) 
    move $a1 , $s3 
    jal int_to_string
    move $a1 , $s5 
    move $a0 , $v0 
    li $a2 , 7 
    jal copy_str
    li $s4 , 7

###

## add seperator 

    li $t0 , ':'
    sb $t0 , 7($s5)
    li $t0 , ' '
    sb $t0 , 8($s5)
    addi $s4 , $s4 ,2
    

#add the test name 
###
    add $a1 , $s5 , $s4 
    li $a2 , 5 
    
    beq $s2 , 1 , write_to_file_hgb
    beq $s2 , 2 , write_to_file_bgt
    beq $s2 , 3 , write_to_file_ldl
    beq $s2 , 4 , write_to_file_bpt

write_to_file_hgb:
    la $a0 , hgb
    j write_to_file_write_test_name

write_to_file_bgt:
    la $a0 , bgt
    j write_to_file_write_test_name

write_to_file_ldl:
    la $a0 , ldl
    j write_to_file_write_test_name

write_to_file_bpt:
    la $a0 , bpt

write_to_file_write_test_name: 
    
    jal copy_str
    addi  $s4 ,$s4 , 5



#convert the date 
###
    lw $a0 , 4($s0)
    move $a1 , $s3
    jal int_to_string
    

    move $a0 , $v0

    li $a2 , 6
    add $a1 , $s5 , $s4 
    
    jal copy_str
    
    addi $s4 , $s4, 4 


    add $t0 , $s4 , $s5 
    lb $t1 , 1($t0)
    sb $t1 , 2($t0)
    lb $t1 , ($t0)
    sb $t1 , 1($t0)
    
    
    li $t6 , '-'
    sb $t6 , 0($t0)
    
    addi $s4 , $s4 , 3


    # add seperator 
    la $a0 , comma_space
    add $a1 , $s5 , $s4 
    li $a2 , 2 
    jal copy_str

    addi $s4 , $s4 , 2 

#

#convert result 

    lwc1 $f15 , 8($s0)
    add $a0 , $s4 , $s5
    jal float_to_string
    sub $t0 , $v1 , $v0 
    add $s4 , $s4 , $t0

###

    bne $s2 , 4 , write_to_file_end_of_line


    la $a0 , comma_space
    add $a1 , $s5 , $s4 
    li $a2 , 2 
    jal copy_str 
    addi $s4 , $s4 , 2 

    lwc1 $f15 , 16($s0)
    add $a0 , $s4 , $s5 
    jal float_to_string
    sub $t0 , $v1 , $v0 
    add $s4 , $s4 , $t0

write_to_file_end_of_line: 
    # add \r
    li $t0 , '\r'
    add $t1 , $s4 , $s5 
    sb $t0 , ($t1)
    addi $s4 , $s4 , 1 


############

write_to_file_new_line:
    #add \n if there is more 
    li $t0 , '\n'
    add $t1 , $s4 , $s5
    sb $t0 , ($t1)
    addi $s4 , $s4 , 1 
    # write the line to file 
    move $a0 , $s1 
    move $a1 , $s5 
    move $a2 , $s4 
    li $v0 , 15 
    syscall 


    lw $s0 , 12($s0)
    beq $s0 , $zero , write_to_file_end
    j write_line_to_file


###
write_to_file_end:  
    
    
    addi $s2 , $s2 ,1
    beq $s2 , 2 , write_to_file_new_linked_list
    beq $s2 , 3 , write_to_file_new_linked_list
    beq $s2 , 4 , write_to_file_new_linked_list


    
    #close the file 
    li $v0 , 16
    syscall 


# Restore registers and return
    lw $s0, 0($sp)
    lw $s1, 4($sp)
    lw $s2, 8($sp)
    lw $s3, 12($sp)
    lw $s4, 16($sp)
    lw $s5, 20($sp) 
    lw $ra, 24($sp)
    addi $sp, $sp, 24

    jr $ra
#############################
########
########## write node to file 
########
#############################