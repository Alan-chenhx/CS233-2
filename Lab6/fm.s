# add your own tests for the full machine here!
# feel free to take inspiration from all.s and/or lwbr2.s

.data
# your test data goes here

.text
main:
	add $4,$0,0xf0000001
	add $5,$0,0x00000eef
	slt  $6,$5,$4
	# your test code goes here
