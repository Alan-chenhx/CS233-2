/**
 * @file
 * Contains the implementation of the countOnes function.
 */

unsigned countOnes(unsigned input) {
	unsigned rmask1 = 0x55555555;
	unsigned lmask1 = 0xaaaaaaaa;
	unsigned rmask2 = 0x33333333;
	unsigned lmask2 = 0xcccccccc;
	unsigned rmask3 = 0x0f0f0f0f;
	unsigned lmask3 = 0xf0f0f0f0;
	unsigned rmask4 = 0x00ff00ff;
	unsigned lmask4 = 0xff00ff00;
	unsigned rmask5 = 0x0000ffff;
	unsigned lmask5 = 0xffff0000;

	unsigned step1 = (input&rmask1)+((input&lmask1)>>1);
	unsigned step2 = (step1&rmask2)+((step1&lmask2)>>2);
	unsigned step3 = (step2&rmask3)+((step2&lmask3)>>4);
	unsigned step4 = (step3&rmask4)+((step3&lmask4)>>8);
	unsigned step5 = (step4&rmask5)+((step4&lmask5)>>16);
	return step5;
}
