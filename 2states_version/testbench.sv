`timescale 1ns/1ps
//defines
`define PERIOD #2
`define HALF_PERIOD #1 

module testbench #(
  parameter INPUT_WIDTH = 6,
  parameter OUTPUT_WIDTH = 12,
  parameter COUNTER_SIZE = 4
  )();

  reg tb_clk, tb_reset;
  reg [(INPUT_WIDTH-1):0] tb_multiplicand, tb_multiplier;
  reg [(OUTPUT_WIDTH-1):0] product_out;
  reg [(COUNTER_SIZE-1):0] counter_out; 

  top #(
    .INPUT_WIDTH(INPUT_WIDTH),
    .OUTPUT_WIDTH(OUTPUT_WIDTH),
    .COUNTER_SIZE(COUNTER_SIZE)
  ) DuT_top (
    .clk_in(tb_clk), 
    .rst_in(tb_reset), 
    .multiplicand_in(tb_multiplicand), 
    .multiplier_in(tb_multiplier),
    .product_top(product_out),
    .counter_top(counter_out)
  );

  always `HALF_PERIOD tb_clk <= ~tb_clk;

  initial begin
    tb_clk = 1'b1;
    tb_reset = 1'b1;
    tb_multiplicand = 6'd31;
    tb_multiplier = 6'd24;
    `PERIOD;
    `HALF_PERIOD;
    tb_reset = 1'b0;
    
    while (counter_out <= 3'd6) begin
      `PERIOD;
    end
    `HALF_PERIOD;
    tb_reset = 1'b1;
    
    tb_multiplicand =-6'd20;
    tb_multiplier = -6'd31;
    `HALF_PERIOD;
    `PERIOD;
    tb_reset = 1'b0;
    while (counter_out <= 3'd6) begin
      `PERIOD;
    end
    `HALF_PERIOD;
     tb_reset = 1'b1;
    
    tb_multiplicand = -6'd23;
    tb_multiplier = -6'd17;
    `HALF_PERIOD;
    `PERIOD;
    tb_reset = 1'b0;
    while (counter_out <= 3'd6) begin
      `PERIOD;
    end
    `PERIOD;


  end

endmodule
