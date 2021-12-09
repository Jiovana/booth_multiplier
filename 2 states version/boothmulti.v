module boothmulti #(
    parameter INPUT_WIDTH = 6 ,
    parameter INTERNAL_WIDTH = 14,
    parameter OUTPUT_WIDTH = 12
  )(
    input clk, rst, enP, enInp,
    input [(INPUT_WIDTH-1):0] multiplicand, multiplier,
    output wire [(OUTPUT_WIDTH-1):0] product
  ); 

  // regs need to have one more bit at the end - dummy bit
  // reg_A stores the multiplicand
  // reg_S stores the two's complement of the multiplicand
  // reg_P stores the multiplier and the partial products of the multiplication


  
  reg signed [6:0] reg_A, reg_S, reg_mux_inp ; 
  reg signed [(INTERNAL_WIDTH-1):0] reg_P;
  reg reg_enableOp;
  wire signed [(INPUT_WIDTH-1):0] complement2_A;
 
  wire signed [6:0] sum, s_double, a_double, mux_input;
  wire signed [(INTERNAL_WIDTH-1):0]  mux_op ;
  wire en_Op;

  assign complement2_A = ~(multiplicand) + 6'd1;

  assign s_double = reg_S <<< 1'b1; // 2 x S
  assign a_double = reg_A <<< 1'd1; // 2 x A

  assign mux_input = (reg_P[2]) ? ((reg_P[1] ^ reg_P[0]) ? reg_S : s_double) 
                                  : ((reg_P[1] ^ reg_P[0]) ? reg_A : a_double);

  always @(posedge clk) begin
  if (enInp) begin
      reg_mux_inp <= mux_input;
      reg_enableOp <= en_Op;
    end 
  end

  assign sum = reg_mux_inp + reg_P[(INTERNAL_WIDTH-1):7];

  assign en_Op = (reg_P[2] & ~reg_P[1]) | (~reg_P[2] & reg_P[0]) 
  | (reg_P[1] & ~reg_P[0]);

  assign mux_op = (reg_enableOp) ? {sum,reg_P[6:0]} : reg_P;

  // register the inputs
  always @(posedge clk) begin
    if (rst) begin
      reg_A <= {multiplicand[5], multiplicand};
      reg_S <= {complement2_A[5], complement2_A};
    end
    
  end

  // register the product
  always @(posedge clk) begin
    if (rst) begin
        reg_P <= {7'd0,multiplier,1'b0};
    end
        
    else if (enP)
      reg_P <= mux_op >>> 2'b10;
  end

  assign product = reg_P[OUTPUT_WIDTH:1];

endmodule
