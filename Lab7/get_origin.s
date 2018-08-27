.text

## unsigned int get_origin(unsigned int pos, unsigned int* origins) {
##     while (pos != origins[pos]) {
##         pos = origins[pos];
##     }
##     return pos;
## }

.globl get_origin
get_origin:
	# Your code goes here :)
	move 	$t0, $a0	#  t0 = a0, pos is at t0
loop:
	sll	$t1, $t0,2;	#left shift pos by 2
	add	$t1, $a1, $t1	#add pos and origin address to get origin[pos];
	lw	$t1, 0($t1)	#t1 = origin[pos]
	beq	$t0, $t1, get_origin_return	# if  pos==  origins[pos]then
	move	$t0, $t1	#move origin[pos] to pos;
	j	loop	#loop through
get_origin_return:
	move 	$v0, $t0		# $v0 = $t0
	jr	$ra					# jump to$ra
