module control #(
    parameter STATE_WIDTH = 2,
    parameter COUNTER_SIZE = 3
  ) (
    input clk, rst_in,
    input [(COUNTER_SIZE-1):0] counter,
    output wire enP, rst_out
  );

  localparam start = 0, charge = 1, final = 2 ;
  reg [(STATE_WIDTH-1):0] reg_state, next;
  reg enP_sg, rst_out_sg;

  always @(posedge clk) begin
    if (rst_in)
        reg_state <= start;
    else 
        reg_state <= next;
  end

  always @(*) begin
    case (reg_state)
      start: begin
        next = charge;
        enP_sg = 1'b1;
        rst_out_sg = 1'b1;       
      end     
      charge: begin
        if (counter == 3'd4) begin
          next = final;
          enP_sg = 1'b0;
          rst_out_sg = 1'b0;       
        end 
        else begin
          next = charge;
          enP_sg = 1'b1;
          rst_out_sg = 1'b0;        
        end
      end
      final: begin
        next = final;
        enP_sg = 1'b0;
        rst_out_sg = 1'b0;
      end
    endcase
  end
  assign enP = enP_sg;
  assign rst_out = rst_out_sg;
endmodule