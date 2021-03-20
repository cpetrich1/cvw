////////////////////////////////////////////////////////////////////////////////
//
// Block Name:	add.v
// Author:		David Harris
// Date:		11/12/1995
//
// Block Description:
//       This block performs the addition of the product and addend.   It also
//   contains logic necessary to adjust the signs for effective subtracts 
//   and negative results. 
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
module add(r, s, t, sum,
		   negsum, invz, selsum1, killprod, negsum0, negsum1, proddenorm);
////////////////////////////////////////////////////////////////////////////////

	input 		[105:0]		r;     			// partial product 1
	input 		[105:0]		s;              // partial product 2
	input 		[163:0]		t;             	// aligned addend 
	input					invz;       	// invert addend
	input 					selsum1;    	// select +1 mode of compound adder 
	input					killprod;    	// z >> product
	input					negsum;      	// Negate sum 
	input 					proddenorm;
	output		[163:0]		sum;         	// sum
	output					negsum0;     	// sum was negative in +0 mode
	output					negsum1;     	// sum was negative in +1 mode 

	// Internal nodes

	wire		[105:0]		r2;				// partial product possibly zeroed out
	wire		[105:0]		s2;				// partial product possibly zeroed out
	wire		[163:0]		t2;				// addend after inversion if necessary
	wire		[163:0] 	sum0;			// sum of compound adder +0 mode
	wire		[163:0] 	sum1;			// sum of compound adder +1 mode
	wire		[163:0] 	prodshifted;			// sum of compound adder +1 mode

	// Invert addend if z's sign is diffrent from the product's sign

	assign t2 = invz ? ~t : t;
	
	// Zero out product if Z >> product or product really should be zero

	assign r2 = killprod ? 106'b0 : r;
	assign s2 = killprod ? 106'b0 : s;

	// Compound adder
	// Consists of 3:2 CSA followed by long compound CPA
	assign prodshifted = {56'b0, r2, 2'b0} + {56'b0, s2, 2'b0};
	assign sum0 = prodshifted + t2 + 158'b0;
	assign sum1 = prodshifted + t2 + 158'b1;
	
	// Check sign bits in +0/1 modes 
	assign negsum0 = sum0[157];
	assign negsum1 = sum1[157];

	// Mux proper result (+Oil mode and inversion) using 4:1 mux
 
	assign sum = selsum1 ? (negsum ? -sum1 : sum1) : (negsum ? -sum0 : sum0);
	
endmodule