///////////////////////////////////////////
// priority_encoder.sv
//
// Written: tfleming@hmc.edu & jtorrey@hmc.edu 7 April 2021
// Based on implementation from https://www.allaboutcircuits.com/ip-cores/communication-controller/priority-encoder/
// *** Give proper LGPL attribution for above source
// Modified:
//
// Purpose: One-hot encoding to binary encoder
//
// A component of the Wally configurable RISC-V project.
//
// Copyright (C) 2021 Harvey Mudd College & Oklahoma State University
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation
// files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy,
// modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software
// is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
// BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT
// OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
///////////////////////////////////////////

`include "wally-config.vh"

// *** We should look for a better parameterized priority encoder. This has a
// bad code smell and might not synthesize
module priority_encoder #(parameter BINARY_BITS = 3) (
  input  [(2**BINARY_BITS)-1:0] one_hot,
  output [BINARY_BITS-1:0] binary
);

  localparam ONE_HOT_BITS = 2**BINARY_BITS;

  genvar i, j;
  generate
    for (i = 0; i < ONE_HOT_BITS; i++) begin
      for (j = 0; j < BINARY_BITS; j++) begin
        if (i[j]) begin
          assign binary[j] = one_hot[i];
        end
      end
    end
  endgenerate

endmodule