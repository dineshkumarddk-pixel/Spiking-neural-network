module delay_block_L2 #(
    parameter DT_WIDTH = 8
)(
    input  wire clk,
    input  wire rst,
    input  wire load_dt,              
    input  wire hold_dt,              
    input  wire [DT_WIDTH-1:0] delta_time_in,
    output reg  [DT_WIDTH-1:0] delta_time_out
);

    reg [DT_WIDTH-1:0] dt_reg;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            dt_reg <= 0;
            delta_time_out <= 0;
        end else begin
            
            if (load_dt)
                dt_reg <= delta_time_in;

            
            if (!hold_dt)
                delta_time_out <= dt_reg;
        end
    end

endmodule