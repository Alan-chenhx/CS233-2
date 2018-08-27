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
## // Draw a line on canvas from start_pos to end_pos.
## // start_pos will always be smaller than end_pos.
## void draw_line(unsigned int start_pos, unsigned int end_pos,
##                Canvas* canvas) {
##     unsigned int width = canvas->width;
##     unsigned int step_size = 1;
##     // Check if the line is vertical.
##     if (end_pos - start_pos >= width) {
##         step_size = width;
##     }
##     // Update the canvas with the new line.
##     for (int pos = start_pos; pos != end_pos + step_size;
##              pos += step_size) {
##         canvas->canvas[pos / width][pos % width] = canvas->pattern;
##     }
## }

.globl draw_line
draw_line:
        # Your code goes here :)
        lw 	$t0, 4($a2) 	#t0 = canvas->width
        li 	$t1, 1 		#steps_size = t1 = 1
        sub 	$t2, $a1, $a0 	#t2 = end_pos - start_pos
        blt 	$t2, $t0, continue
        move 	$t1, $t0 	# step_size = width

continue:
	move 	$t3, $a0 	# t3 = pos = a0
loop:
	add 	$t4, $a1, $t1 	# t4 = end_pos+ step_size
	beq 	$t4, $t3, done
#RHS
	lb 	$t5, 8($a2) 	# t5 = canvas->pattern
#LHS
	lw 	$t6, 12($a2) 	# t6 = canvas->canvas; start position
	div 	$t7, $t3, $t0 	# t7 = pos / width
	rem 	$t8, $t3, $t0 	# t8 = pos % width
	sll 	$t7, $t7, 2 	# t7 = t7 *4
	add 	$t7, $t6, $t7 	# start position + 4*pos/width
	lw 	$t9, 0($t7) 	# t9 = *(char**)
	add  	$t9, $t9, $t8 	# find the position address
	sb 	$t5, 0($t9) 	#store byte


	add 	$t3, $t3, $t1 	# pos+=step_size
	j 	loop;
done:
        jr	$ra
