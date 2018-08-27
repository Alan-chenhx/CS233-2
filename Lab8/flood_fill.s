.text

# struct Canvas {
#     // Height and width of the canvas.
#     unsigned int height;
#     unsigned int width;
#     // The pattern to draw on the canvas.
#     unsigned char pattern;
#     // Each char* is null-terminated and has same length.
#     char** canvas;
# };
#
# // Mark an empty region as visited on the canvas using flood fill algorithm.
# void flood_fill(int row, int col, unsigned char marker, Canvas* canvas) {
#     // Check the current position is valid.
#     if (row < 0 || col < 0 ||
#         row >= canvas->height || col >= canvas->width) {
#         return;
#     }
#     unsigned char curr = canvas->canvas[row][col];
#     if (curr != canvas->pattern && curr != marker) {
#         // Mark the current pos as visited.
#         canvas->canvas[row][col] = marker;
#         // Flood fill four neighbors.
#         flood_fill(row - 1, col, marker, canvas);
#         flood_fill(row, col + 1, marker, canvas);
#         flood_fill(row + 1, col, marker, canvas);
#         flood_fill(row, col - 1, marker, canvas);
#     }
# }

.globl flood_fill
flood_fill:
        # Your code goes here :)
        sub     $sp,$sp, 32
        sw      $ra, 0($sp)
        sw      $s0, 4($sp)
        sw      $s1, 8($sp)
        sw      $s2, 12($sp)
        sw      $s3, 16($sp)
        sw      $s4, 20($sp)
        sw      $s5, 24($sp)
        sw      $s6, 28($sp)

        move    $s0, $a0        #s0 = row
        move    $s1, $a1        #s1 = col
        move    $s2, $a2        #s2 = marker
        move    $s3, $a3        #s3 = Canvas
        lw      $s4, 0($a3)     #s4 = canvas->Height
        lw      $s5, 4($a3)     #s5 = canvas->width
        lbu      $s6, 8($a3)     #s6 = canvas->pattern

base_case0:
        bgez     $s0, base_case1
        j       done
base_case1:
        bgez     $s1, base_case2
        j       done
base_case2:
        blt      $s0, $s4, base_case3
        j       done
base_case3:
        blt      $s1, $s5, continue
        j       done
continue:
        lw      $t0 ,12($a3)    #t0 = canvas->canvas
        sll     $t1, $s0, 2
        add     $t0, $t0, $t1
        lw      $t0, 0($t0)     # lw(canvas + 4*row), dereference once
        add     $t0, $t0, $s1   # lw(t0 + col), dereference twice
        lbu      $t2, 0($t0)     # t2 = cavas->Canvas[row][col] = curr
first_if:
        beq     $t2, $s6, done 
        j       second_if
second_if:
        beq     $t2, $s2, done
        j       recursive_part
recursive_part:
        sb      $s2, 0($t0)
        move    $a0, $s0 
        move    $a1, $s1
        move    $a2, $s2
        move    $a3, $s3       
        sub     $a0, $s0, 1     #row = row -1   
        jal     flood_fill
        move    $a0, $s0 
        move    $a1, $s1
        move    $a2, $s2
        move    $a3, $s3 
        add     $a1, $s1, 1     # col += 1
        jal     flood_fill
        move    $a0, $s0 
        move    $a1, $s1
        move    $a2, $s2
        move    $a3, $s3 
        add     $a0, $s0, 1     # row += 1
        jal     flood_fill
        move    $a0, $s0 
        move    $a1, $s1
        move    $a2, $s2
        move    $a3, $s3 
        sub     $a1, $s1, 1     # row -= 1
        jal     flood_fill

done:
        lw      $ra, 0($sp)
        lw      $s0, 4($sp)
        lw      $s1, 8($sp)
        lw      $s2, 12($sp)
        lw      $s3, 16($sp)
        lw      $s4, 20($sp)
        lw      $s5, 24($sp)
        lw      $s6, 28($sp)
        add     $sp, $sp, 32
        jr      $ra
