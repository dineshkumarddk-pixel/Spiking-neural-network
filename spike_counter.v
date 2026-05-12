module spike_counter #(
    parameter NEURONS = 10,
    parameter CNT_W   = 16
)(
    input  wire clk,
    input  wire rst,
    input  wire fire_enable,
    input  wire [NEURONS-1:0] fire_vector,

    input  wire layer_reset,

    output reg [NEURONS*CNT_W-1:0] spike_count_bus
);

integer i;

always @(posedge clk or posedge rst)
begin
    if (rst || layer_reset)
    begin
        spike_count_bus <= {NEURONS*CNT_W{1'b0}};
    end

    else if (fire_enable)
    begin
        for(i = 0; i < NEURONS; i = i + 1)
        begin
            if(fire_vector[i])
                spike_count_bus[i*CNT_W +: CNT_W] 
                <= spike_count_bus[i*CNT_W +: CNT_W] + 1;
        end
    end
end

endmodule