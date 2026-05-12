module weights_memory_output #(
    parameter INPUTS  = 256,   
    parameter NEURONS = 10,    
    parameter W       = 8,     
    parameter DT_W    = 8
)(
    input  wire clk,
    input  wire rst,

    input  wire read_en,
    input  wire [DT_W-1:0] delta_time,

    input  wire [$clog2(INPUTS)-1:0] synapse_idx,

    output reg [NEURONS*W-1:0] weights_out
);

    localparam TOTAL_WEIGHTS = INPUTS * NEURONS;


    (* ram_style = "block" *)
    reg [W-1:0] weight_mem [0:TOTAL_WEIGHTS-1];

    integer n;
    integer base_addr;

    wire delta_valid;
    wire weight_rd_en;

    assign delta_valid  = (delta_time != {DT_W{1'b0}});
    assign weight_rd_en = read_en & delta_valid;


    initial begin
        $readmemh("D:/8081/Spiking_Neural_Network/Simulation/output_layer_weights.mem", weight_mem);
    end

    always @(posedge clk) begin
        if (rst) begin
            weights_out <= {NEURONS*W{1'b0}};
        end
        else if (weight_rd_en) begin

            base_addr = synapse_idx * NEURONS;

            for (n = 0; n < NEURONS; n = n + 1) begin
                weights_out[n*W +: W] <= weight_mem[base_addr + n];
            end

        end
    end

endmodule