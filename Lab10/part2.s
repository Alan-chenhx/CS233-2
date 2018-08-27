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

STATION_LOC             = 0xffff0054
DROPOFF_ASTEROIDS       = 0xffff005c

GET_CARGO               = 0xffff00c4

# interrupt constants
BONK_INT_MASK           = 0x1000
BONK_ACK                = 0xffff0060

TIMER_INT_MASK          = 0x8000
TIMER_ACK               = 0xffff006c

STATION_ENTER_INT_MASK  = 0x400
STATION_ENTER_ACK       = 0xffff0058

STATION_EXIT_INT_MASK   = 0x2000
STATION_EXIT_ACK        = 0xffff0064


.data
# put your data things here
zero_two_five:   .float 0.25
.align 2
asteroid_map: .space 1024


.text

main:
        # put your code here :)

        la 		$t0, asteroid_map
        sw 		$t0, ASTEROID_MAP 	#t0 can't be changed; t0 = &asteroid_map
#------------------------------------------------------#


do:
       	lw 		$t1, 4($t0) 		#t1 = astroid[0]
       	sll 	        $t3, $t1, 16
       	srl 	        $t3, $t3, 16		# t3 = y
       	srl 	        $t2, $t1, 16 		# t2 = x



go_to_y_coord:
        la 		$t4, BOT_X
        lw 		$t4, 0($t4)			# t4 = BOT_X
        la 		$t5, BOT_Y
        lw 		$t5, 0($t5)			# t5 = BOT_Y

        li              $t6, 10
        sw              $t6, VELOCITY           #VELOCITY = 10
##################condition check###################
        beq             $t5, $t3, go_to_x_coord
edge_check:
        blt             $t4, 45, correction
end_edge_check:
        blt             $t5, $t3, go_down

        bgt             $t5, $t3, go_up
here2:
        j               go_to_y_coord
go_to_x_coord:
        la 		$t4, BOT_X
        lw 		$t4, 0($t4)			# t4 = BOT_X
        la 		$t5, BOT_Y
        lw 		$t5, 0($t5)			# t5 = BOT_Y
        li              $t6, 10
        sw              $t6, VELOCITY           #VELOCITY = 10
        ############condition check##########
        beq             $t4, $t2, collect
        blt             $t4, $t2, go_right
        bgt             $t4, $t2, go_left
here4:
        j               go_to_x_coord

collect:
        lw              $t7, 8($t0)             #t7 = point
        sw              $t7, COLLECT_ASTEROID
        add             $t0, $t0, 8
        la              $a0, GET_CARGO
        lw              $a0, 0($a0)
        bge             $a0, 60, go_to_station_y_move
        j               do

go_up:
        li              $t6, -90
        sw              $t6, ANGLE
        li              $t6, 1
        sw              $t6, ANGLE_CONTROL
        j               here2
go_down:
        li              $t6, 90
        sw              $t6, ANGLE
        li              $t6, 1
        sw              $t6, ANGLE_CONTROL
        j               here2
go_right:
        bge             $t4, 280, set_angle_90

        li              $t6, 0
        sw              $t6, ANGLE
        li              $t6, 1
        sw              $t6, ANGLE_CONTROL
here3:
        j               here4
go_left:
        li              $t6, 180
        sw              $t6, ANGLE
        li              $t6, 1
        sw              $t6, ANGLE_CONTROL
        j               here4
correction:# move to right if too close
        li              $t6, 0
        sw              $t6, ANGLE
        li              $t6, 1
        sw              $t6, ANGLE_CONTROL
        j               here2
set_angle_90:
        li              $t6, 90#### 180??
        sw              $t6, ANGLE
        li              $t6, 1
        sw              $t6, ANGLE_CONTROL
        j               here3

go_to_station_y_move:


        la 		$t4, BOT_X
        lw 		$t4, 0($t4)			# t4 = BOT_X
        la 		$t5, BOT_Y
        lw 		$t5, 0($t5)			# t5 = BOT_Y
        li              $t6, 10
        sw              $t6, VELOCITY           #VELOCITY = 10
        li              $t6, 90
        sw              $t6, ANGLE
        li              $t6, 1
        sw              $t6, ANGLE_CONTROL
        bge             $t5, 200, x_move
        j               go_to_station_y_move

x_move:
        bge             $t4, 285, ready_to_drop
        la 		$t4, BOT_X
        lw 		$t4, 0($t4)			# t4 = BOT_X
        la 		$t5, BOT_Y
        lw 		$t5, 0($t5)			# t5 = BOT_Y
        li              $t6, 10
        sw              $t6, VELOCITY           #VELOCITY = 10
        # bge             $t5, 285, continue
        li              $t6, 0
        sw              $t6, ANGLE
        li              $t6, 1
        sw              $t6, ANGLE_CONTROL
        j               x_move

ready_to_drop:
        li              $t6, 10
        sw              $t6, VELOCITY           #VELOCITY = 10
        li              $t6, 0
        sw              $t6, ANGLE
        li              $t6, 1
        sw              $t6, ANGLE_CONTROL
        # li              $a0, 0x2401
        # mtc0            $a0, $12
        #
        # mfc0            $a0, $13
        # srl             $a1, $a0, 2
        # andi            $a1, $a1, 0x1F
        # # bne             $t1, $0, non_interrupt
        #
        # srl             $a1, $a0, 10
        # andi            $t6, $a1, 0x1
        # srl             $a1, $a0, 13
        # andi            $t7, $a1, 0x1
        # li              $a2, 1
        sw              $a2, STATION_ENTER_ACK
        sw              $a2, DROPOFF_ASTEROIDS
        j               ready_to_drop
