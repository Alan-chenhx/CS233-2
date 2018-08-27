.text

## void add_dot(unsigned int pos, unsigned int* canvas) {
##     unsigned int row = pos >> 5;
##     unsigned int col = 31 - (pos & 31);
##     canvas[row] |= (1 << col);
## }

.globl add_dot
add_dot:
	# Your code goes here :)
	srl	$t1, $a0, 5 ##row(t1)=a0>>5
	sll	$t1, $t1, 2
	and	$t2, $a0, 31
	add	$t3, $0, 31
	sub	$t4, $t3, $t2 ##col
	add	$t5, $a1, $t1
	lw	$t7, 0($t5) #3canvas[row]
	li	$t3, 1
	sll	$t6, $t3, $t4 #1<<col
	or	$t8, $t7, $t6
	sw	$t8, 0($t5)
	jr	$ra
