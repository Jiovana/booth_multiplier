module top #(
    parameter INPUT_WIDTH = 6,
    parameter OUTPUT_WIDTH = 12,
    parameter COUNTER_SIZE = 3
  ) (
    input clk_in, rst_in, 
    input [(INPUT_WIDTH-1):0] multiplicand_in, multiplier_in,
    output wire [(OUTPUT_WIDTH-1):0] product_top,
    output wire [(COUNTER_SIZE-1):0] counter_top
  );

  wire rst_fsm, enP_fsm;
  //wire [(OUTPUT_WIDTH-1):0] product_out;
  reg [(COUNTER_SIZE-1):0] reg_count;
  
  boothmulti #(
    .INPUT_WIDTH(INPUT_WIDTH),
    .OUTPUT_WIDTH(OUTPUT_WIDTH)
  ) BoothMulti (
    .clk(clk_in), 
    .rst(rst_fsm),
    .enP(enP_fsm),
    .multiplicand(multiplicand_in), 
    .multiplier(multiplier_in),
    .product(product_top)
  ); 

  control #(
    .COUNTER_SIZE(COUNTER_SIZE)
  ) Fsm (
    .clk(clk_in),
    .rst_in(rst_in),
    .counter(reg_count),
    .enP(enP_fsm),
    .rst_out(rst_fsm)
  );

  always @(posedge clk_in) begin
    if (rst_in)
      reg_count <= 'b0;
    else 
      reg_count <= reg_count + 3'b001;
  end

  assign counter_top = reg_count;

endmodule