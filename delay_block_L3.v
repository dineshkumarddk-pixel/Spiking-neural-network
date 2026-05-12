module delay_block_L3 #(
    parameter DT_WIDTH = 8
)(
    input  wire clk,
    input  wire rst,

    input  wire load_dt_h3,
    input  wire hold_dt_h3,

    input  wire [DT_WIDTH-1:0] delta_time_in_h3,

    output reg  [DT_WIDTH-1:0] delta_time_out_h3
);

    reg [DT_WIDTH-1:0] dt_reg_h3;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            dt_reg_h3        <= 0;
            delta_time_out_h3 <= 0;
        end 
        else begin
          
            if (load_dt_h3)
                dt_reg_h3 <= delta_time_in_h3;

                       if (!hold_dt_h3)
                delta_time_out_h3 <= dt_reg_h3;
        end
    end

endmodule