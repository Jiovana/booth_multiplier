module control #(
    parameter STATE_WIDTH = 2,
    parameter COUNTER_SIZE = 4
  ) (
    input clk, rst_in,
    input [(COUNTER_SIZE-1):0] counter,
    output wire enP, rst_out, enInp
  );

  //two state version means we have 2 main states now, muxes and charge
  // muxes raises enInp - saving the mux_input result and the enable for mux_op
  // charge raises enP - saving the partial product in reg_P
  localparam start = 0, muxes = 1, charge = 2, final = 3 ;
  reg [(STATE_WIDTH-1):0] reg_state, next;
  reg enP_sg, rst_out_sg, enInp_sg;

  always @(posedge clk) begin
    if (rst_in)
        reg_state <= start;
    else 
        reg_state <= next;
  end

  //slightly more complex fsm with 4 states now. 
  always @(*) begin
    case (reg_state)
      start: begin
        next = muxes;
        enP_sg = 1'b0;
        rst_out_sg = 1'b1;
        enInp_sg = 1'b1;
      end
      muxes: begin
          next = charge;
          enP_sg = 1'b1;
          rst_out_sg = 1'b0;
          enInp_sg = 1'b0;
      end
      charge: begin
        if (counter == 4'd6) begin
          next = final;
          enP_sg = 1'b0;
          rst_out_sg = 1'b0;
          enInp_sg = 1'b0;
        end else begin
          next = muxes;
          enP_sg = 1'b0;
          rst_out_sg = 1'b0;
          enInp_sg = 1'b1;
        end
      end
      final: begin
        next = final;
        enP_sg = 1'b0;
        rst_out_sg = 1'b0;
        enInp_sg = 1'b0;
      end
    endcase
  end
  assign enP = enP_sg;
  assign rst_out = rst_out_sg;
  assign enInp = enInp_sg;
endmodule