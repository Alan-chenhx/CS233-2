 # syscall constants
PRINT_STRING            = 4
PRINT_CHAR              = 11
PRINT_INT               = 1

# memory-mapped I/O
VELOCITY                = 0xffff0010
ANGLE                   = 0xffff0014
ANGLE_CONTROL           = 0xffff0018

BOT_X                   = 0xffff0020
BOT_Y                   = 0xffff0024

TIMER                   = 0xffff001c

PRINT_INT_ADDR          = 0xffff0080
PRINT_FLOAT_ADDR        = 0xffff0084
PRINT_HEX_ADDR          = 0xffff0088

ASTEROID_MAP            = 0xffff0050
COLLECT_ASTEROID        = 0xffff00c8

GET_CARGO               = 0xffff00c4

# interrupt constants
BONK_INT_MASK           = 0x1000
BONK_ACK                = 0xffff0060

TIMER_INT_MASK          = 0x8000
TIMER_ACK               = 0xffff006c


.data
# put your data things here
.align 2
asteroid_map: .space 1024


.text

main:
        # put your code here :)

        la 		$t0, asteroid_map
        sw 		$t0, ASTEROID_MAP 	#t0 can't be changed; t0 = &asteroid_map
#------------------------------------------------------#


       	lw 		$t1, 4($t0) 		#t1 = astroid[0]
       	sll 	$t3, $t1, 16
       	srl 	$t3, $t3, 16		# t3 = y
       	srl 	$t2, $t1, 16 		# t2 = x

       	la 		$t4, BOT_X
       	lw 		$t4, 0($t4)			# t4 = BOT_X
       	la 		$t5, BOT_Y
       	lw 		$t5, 0($t5)			# t5 = BOT_Y

        li      $t6, 10
        sw      $t6, VELOCITY           #VELOCITY = 10
while_loop:
        beq     $t3, $t5, x_move
up:
        blt     $t3, $t5, go_up
down:
        bgt     $t3, $t5, go_down
continue:




        # note that we infinite loop to avoid stopping the simulation early
        j       main

go_right:
                li              $t6, 0
                sw              $t6, ANGLE
                li              $t6, 1
                sw              $t6, ANGLE_CONTROL
                j               x_move_continue
go_left:
                li              $t6, 180
                sw              $t6, ANGLE
                li              $t6, 1
                sw              $t6, ANGLE_CONTROL
                j               right
go_down:
                li              $t6, 30
                sw              $t6, ANGLE
                li              $t6, 1
                sw              $t6, ANGLE_CONTROL
                j               continue
go_up:
                li              $t6, -30
                sw              $t6, ANGLE
                li              $t6, 1
                sw              $t6, ANGLE_CONTROL
                j               down

x_move:

                la 		$t4, BOT_X
                lw 		$t4, 0($t4)			# t4 = BOT_X
                bgt             $t4, 200, change_direction
here:
                ble             $t4, 45, skip
                la 		$t5, BOT_Y
                lw 		$t5, 0($t5)
                beq     $t2, $t4, collect
                blt     $t2, $t4, go_left
right:
                bgt     $t2, $t4, go_right
x_move_continue:
                j       continue

skip:
                add     $t0, $t0, 8
                j       continue
change_direction:
                li              $t6, 60
                sw              $t6, ANGLE
                li              $t6, 0
                sw              $t6, ANGLE_CONTROL
                add             $t0, $t0, 8
                j               here

collect:
                lw              $t7, 8($t0)             #t7 = point
                sw              $t7, COLLECT_ASTEROID
                add     $t0, $t0, 8
                j               continue
