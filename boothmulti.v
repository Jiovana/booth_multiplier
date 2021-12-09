module boothmulti #(
    parameter INPUT_WIDTH = 6 ,
    parameter INTERNAL_WIDTH = 14,
    parameter OUTPUT_WIDTH = 12
  )(
    input clk, rst, enP,
    input [(INPUT_WIDTH-1):0] multiplicand, multiplier,
    output wire [(OUTPUT_WIDTH-1):0] product
  ); 

  // regs need to have one more bit at the end - dummy bit
  // reg_A stores the multiplicand
  // reg_S stores the two's complement of the multiplicand
  // reg_P stores the multiplier and the partial products of the multiplication
  reg signed [INTERNAL_WIDTH:0] reg_A, reg_S ; 
  reg signed [(INTERNAL_WIDTH-1):0] reg_P;

  wire signed [(INPUT_WIDTH-1):0] complement2_A;
 
  wire signed [INTERNAL_WIDTH:0] sum, s_double, a_double, mux_input;
  wire signed [(INTERNAL_WIDTH-1):0]  mux_op ;
  wire en_Op;

  assign complement2_A = ~(multiplicand) + 6'd1;

  assign s_double = reg_S <<< 1'b1; // 2 x S
  assign a_double = reg_A <<< 1'd1; // 2 x A

  /* this mux selects the sum's input, based on the table:
  P2 P1 P0
  0 | 0 0 - NO Op
  0 | 0 1 - A
  0 | 1 0 - A
  0 | 1 1 - 2A
  1 | 0 0 - 2S
  1 | 0 1 - S
  1 | 1 0 - S
  1 | 1 1 - NO Op
  The other operand is P. The sum only needs to be executed on the 7 MSBs.
  We have 7 bits (total 14) instead of 6 to keep the signal in 2A and 2S. 
  */
  assign mux_input = (reg_P[2]) ? ((reg_P[1] ^ reg_P[0]) ? reg_S : s_double) 
                                  : ((reg_P[1] ^ reg_P[0]) ? reg_A : a_double);

  assign sum = mux_input + reg_P[(INTERNAL_WIDTH-1):7];

  /*Mux_op chooses between the sum result or P. 
  P is selected only for the NO Op cases in the table above, and the sum for the others.  
  Hence, we can use the same signals to obtain en_OP, creating a logic expression to give us the 
  required output: P2!P1 + !P2P0 + P1!P0
  */
  assign en_Op = (reg_P[2] & ~reg_P[1]) | (~reg_P[2] & reg_P[0]) | (reg_P[1] & ~reg_P[0]);

  assign mux_op = (en_Op) ? {sum,reg_P[6:0]} : reg_P;

  // register the inputs
  always @(posedge clk) begin
    if (rst) begin
      reg_A <= {multiplicand[5], multiplicand}; // concatenation to preserve signal 
      reg_S <= {complement2_A[5], complement2_A};
    end
    
  end

  // register the product
  always @(posedge clk) begin
    if (rst) begin
        reg_P <= {7'd0,multiplier,1'b0};
    end       
    else if (enP)
      reg_P <= mux_op >>> 2'b10; //Each cycle P is shifted 2 positions to the right
  end

  assign product = reg_P[OUTPUT_WIDTH:1];

endmodule
