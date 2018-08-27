.text

## struct Canvas {
##     // Height and width of the canvas.
##     unsigned int height;
##     unsigned int width;
##     // The pattern to draw on the canvas.
##     unsigned char pattern;
##     // Each char* is null-terminated and has same length.
##     char** canvas;
## };
##
## // Count the number of disjoint empty area in a given canvas.
## unsigned int count_disjoint_regions_step(unsigned char marker,
##                                          Canvas* canvas) {
##     unsigned int region_count = 0;
##     for (unsigned int row = 0; row < canvas->height; row++) {
##         for (unsigned int col = 0; col < canvas->width; col++) {
##             unsigned char curr_char = canvas->canvas[row][col];
##             if (curr_char != canvas->pattern && curr_char != marker) {
##                 region_count ++;
##                 flood_fill(row, col, marker, canvas);
##             }
##         }
##     }
##     return region_count;
## }

.globl count_disjoint_regions_step
count_disjoint_regions_step:
        # Your code goes here :)
        sub 	$sp, $sp, 36
        sw 		$ra, 0($sp)
        sw 		$s0, 4($sp)
        sw 		$s1, 8($sp)
        sw 		$s2, 12($sp)
        sw 		$s3, 16($sp)
        sw 		$s4, 20($sp)
        sw 		$s5, 24($sp)
        sw 		$s6, 28($sp)
        sw 		$s7, 32($sp)
        move 	        $s0, $a0 			#s0 =  a0 = marker;
        move 	        $s1, $a1			#s1 = a1 = canvas
        lw 		$s2, 0($a1) 		#s2 = cavas->height
        lw 		$s3, 4($a1) 		#s3 = canvas->width
        li 		$s5, 0				# s5 = row = 0
        li 		$s6, 0				# s6 = col = 0
        li 		$s7, 0				#region_count = 0
first_loop:
		bge 	$s5, $s2, return
second_loop:
		bge 	$s6, $s3, first_loop_done

		lw      $t0 ,12($s1)
                sll     $t1, $s5, 2
                add     $t0, $t0, $t1
                lw      $t0, 0($t0)
                add     $t0, $t0, $s6 		#t0 = &(canvas->canvas[row][col])
                lbu     $t2, 0($t0)     	# t2 = canvas->canvas[row][col] = curr_char

                lbu 	$t3, 8($s1) 		#t3 = canvas->pattern
first_if:
                bne 	$t2, $t3, second_if
                j 	second_loop_done
second_if:
		bne 	$t2, $s0, continue
		j 	second_loop_done
continue:
		add 	$s7, $s7, 1 		#region_count++
		move 	$a0, $s5
		move 	$a1, $s6
		move 	$a2, $s0
		move 	$a3, $s1
		jal 	flood_fill
second_loop_done:
		add 	$s6, $s6, 1      #col ++
		j 	second_loop

first_loop_done:
		add 	$s5, $s5, 1 	# row++
                li      $s6, 0
		j 	first_loop


return:
        lw 		$ra, 0($sp)
        lw 		$s0, 4($sp)
        lw 		$s1, 8($sp)
        lw 		$s2, 12($sp)
        lw 		$s3, 16($sp)
        lw 		$s4, 20($sp)
        lw 		$s5, 24($sp)
        lw 		$s6, 28($sp)
        lw 		$s7, 32($sp)

        move 	        $v0, $s7
        add 	        $sp, $sp, 36
        jr              $ra
