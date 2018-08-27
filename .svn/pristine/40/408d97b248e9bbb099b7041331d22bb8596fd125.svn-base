/**
 * @file
 * Contains the implementation of the extractMessage function.
 */

#include <iostream> // might be useful for debugging
#include <assert.h>
#include "extractMessage.h"

using namespace std;

char *extractMessage(const char *message_in, int length) {
   // length must be a multiple of 8
   assert((length % 8) == 0);

   // allocate an array for the output
   char *message_out = new char[length];

	// TODO: write your code here
   int i=0; 
   while (i<length){
   	//get every char in messege_in:
   	char i1 = message_in[i];
   	char i2 = message_in[i+1];
   	char i3 = message_in[i+2];
   	char i4 = message_in[i+3];
   	char i5 = message_in[i+4];
   	char i6 = message_in[i+5];
   	char i7 = message_in[i+6];
   	char i8 = message_in[i+7];
   	//decode the ith char
   	message_out[i+0]=(i1&0x01)|((i2&0x01)<<1)|((i3&0x01)<<2)|((i4&0x01)<<3)|((i5&0x01)<<4)|((i6&0x01)<<5)|((i7&0x01)<<6)|((i8&0x01)<<7);
   	message_out[i+1]=((i1&0x02)>>1)|(i2&0x02)|((i3&0x02)<<1)|((i4&0x02)<<2)|((i5&0x02)<<3)|((i6&0x02)<<4)|((i7&0x02)<<5)|((i8&0x02)<<6);
   	message_out[i+2]=((i1&0x04)>>2)|((i2&0x04)>>1)|(i3&0x04)|((i4&0x04)<<1)|((i5&0x04)<<2)|((i6&0x04)<<3)|((i7&0x04)<<4)|((i8&0x04)<<5);
   	message_out[i+3]=((i1&0x08)>>3)|((i2&0x08)>>2)|((i3&0x08)>>1)|(i4&0x08)|((i5&0x08)<<1)|((i6&0x08)<<2)|((i7&0x08)<<3)|((i8&0x08)<<4);
   	message_out[i+4]=((i1&0x10)>>4)|((i2&0x10)>>3)|((i3&0x10)>>2)|((i4&0x10)>>1)|(i5&0x10)|((i6&0x10)<<1)|((i7&0x10)<<2)|((i8&0x10)<<3);
   	message_out[i+5]=((i1&0x20)>>5)|((i2&0x20)>>4)|((i3&0x20)>>3)|((i4&0x20)>>2)|((i5&0x20)>>1)|(i6&0x20)|((i7&0x20)<<1)|((i8&0x20)<<2);
   	message_out[i+6]=((i1&0x40)>>6)|((i2&0x40)>>5)|((i3&0x40)>>4)|((i4&0x40)>>3)|((i5&0x40)>>2)|((i6&0x40)>>1)|(i7&0x40)|((i8&0x40)<<1);
   	message_out[i+7]=((i1&0x80)>>7)|((i2&0x80)>>6)|((i3&0x80)>>5)|((i4&0x80)>>4)|((i5&0x80)>>3)|((i6&0x80)>>2)|((i7&0x80)>>1)|(i8&0x80);
   	
   	i+=8;
   }

	return message_out;
}
