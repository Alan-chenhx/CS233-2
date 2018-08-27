module keypad(valid, number, a, b, c, d, e, f, g);
   output 	valid;
   output [3:0] number;
   wire temp;
   input 	a, b, c, d, e, f, g;


   assign temp = (a&&g)||(c&&g)||(!a&&!b&&!c&&!d&&!e&&!f&&!g);

   xor x1(valid,1,temp);

   assign number[0] = (a&&d)||(c&&d)||(b&&e)||(a&&f)||(c&&f);
   assign number[1] = (b&&d)||(c&&d)||(c&&e)||(a&&f);
   assign number[2] = (a&&e)||(b&&e)||(c&&e)||(a&&f);
   assign number[3] = (b&&f)||(c&&f);

endmodule // keypad
