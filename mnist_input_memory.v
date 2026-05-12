module mnist_latency_memory #(
    parameter N = 784,
    parameter W = 8,
    parameter NUM_IMAGES = 1,
    parameter TOTAL = N * NUM_IMAGES
)(
    input  wire clk,
    input  wire load_image,
    input  wire [$clog2(NUM_IMAGES)-1:0] image_index,
    output reg  [N*W-1:0] in_times
);

    
    reg [W-1:0] dataset_mem [0:TOTAL-1];

    integer i;
    integer base_addr;

    
    initial begin
        $readmemh("mnist_one_image.mem", dataset_mem);
    end

    always @(posedge clk) begin
        if (load_image) begin
            
            base_addr = image_index * N;

            
            for (i = 0; i < N; i = i + 1) begin
                in_times[i*W +: W] <= dataset_mem[base_addr + i];
            end
        end
    end

endmodule

