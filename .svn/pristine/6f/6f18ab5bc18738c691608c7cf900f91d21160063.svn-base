.text

## struct Lines {
##     unsigned int num_lines;
##     // An int* array of size 2, where first element is an array of start pos
##     // and second element is an array of end pos for each line.
##     // start pos always has a smaller value than end pos.
##     unsigned int* coords[2];
## };
##
## struct Solution {
##     unsigned int length;
##     int* counts;
## };
##
## // Count the number of disjoint empty area after adding each line.
## // Store the count values into the Solution struct.
## void count_disjoint_regions(const Lines* lines, Canvas* canvas,
##                             Solution* solution) {
##     // Iterate through each step.
##     for (unsigned int i = 0; i < lines->num_lines; i++) {
##         unsigned int start_pos = lines->coords[0][i];
##         unsigned int end_pos = lines->coords[1][i];
##         // Draw line on canvas.
##         draw_line(start_pos, end_pos, canvas);
##         // Run flood fill algorithm on the updated canvas.
##         // In each even iteration, fill with marker 'A', otherwise use 'B'.
##         unsigned int count =
##                 count_disjoint_regions_step('A' + (i % 2), canvas);
##         // Update the solution struct. Memory for counts is preallocated.
##         solution->counts[i] = count;
##     }
## }

.globl count_disjoint_regions
count_disjoint_regions:
        # Your code goes here :)
        sub     $sp, $sp, 36
        sw      $ra, 0($sp)
        sw      $s0, 4($sp)
        sw      $s1, 8($sp)
        sw      $s2, 12($sp)
        sw      $s3, 16($sp)
        sw      $s4, 20($sp)
        sw      $s5, 24($sp)
        sw      $s6, 28($sp)
        sw      $s7, 32($sp)
        move    $s0, $a0                #
        move    $s1, $a1
        move    $s2, $a2
        lw      $s3, 0($a0)             #lines->num_lines   = s3
        lw      $s4, 4($a0)             #lines->coord[0]       = s4
        lw      $s5, 8($a0)             #lines->coords[1]      = s5
        lw      $s6, 4($a2)             #solution->counts   = s6
        li      $s7, 0                  # s7 = i =0
loop:
        bge     $s7, $s3, done

        sll     $t1, $s7, 2             # i*4
        add     $t1, $s4, $t1           # &(coord[0][i])
        lw      $t1, 0($t1)             # t1 = coord[0][i] = start_pos

        sll     $t2, $s7, 2
        add     $t2, $s5, $t2
        lw      $t2, 0($t2)             # t2 = end_pos


        move    $a0, $t1                #start_pos = a0
        move    $a1, $t2                #end_pos = a1
        move    $a2, $s1                #canvas = a2
        jal     draw_line
        lw      $s1, 8($sp)
        rem     $t4, $s7, 2             # t4 = i%2
        add     $a0, $t4, 65            # 'A' + (i%2)
        move    $a1, $s1                # a1 = s1
        jal     count_disjoint_regions_step
        lw      $s1, 8($sp)
        move    $t5, $v0                # t5 = count = count_disjoint_regions_step
        sll     $t6, $s7, 2             # t6 = i*4
        add     $t6, $t6, $s6           # t6 = i*4 + counts
        sw      $t5, 0($t6)
        add     $s7, $s7, 1             # i++
        j       loop
done:

        lw      $ra, 0($sp)
        lw      $s0, 4($sp)
        lw      $s1, 8($sp)
        lw      $s2, 12($sp)
        lw      $s3, 16($sp)
        lw      $s4, 20($sp)
        lw      $s5, 24($sp)
        lw      $s6, 28($sp)
        lw      $s7, 32($sp)
        add     $sp, $sp, 36
        jr      $ra
