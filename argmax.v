module argmax #(
    parameter NEURONS = 10,
    parameter CNT_W   = 16
)(
    input  wire clk,
    input  wire start,

    input  wire [NEURONS*CNT_W-1:0] spike_count_bus,

    output reg [$clog2(NEURONS)-1:0] predicted_digit
);

integer i;

reg [CNT_W-1:0] max_val;
reg [CNT_W-1:0] current_val;

always @(posedge clk)
begin
    if(start)
    begin
        max_val = spike_count_bus[0*CNT_W +: CNT_W];
        predicted_digit = 0;

        for(i = 1; i < NEURONS; i = i + 1)
        begin
            current_val = spike_count_bus[i*CNT_W +: CNT_W];

            if(current_val > max_val)
            begin
                max_val = current_val;
                predicted_digit = i;
            end
        end
    end
end

endmodule