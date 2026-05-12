module lopd_index_generator_L3 #(
    parameter N = 256,
    parameter IDX_W = 8
)(
    input  wire              clk,
    input  wire              rst,
    input  wire              load,
    input  wire [N-1:0]      spike_in,

    output reg  [IDX_W-1:0]  synapse_idx,
    output reg               valid,
    output wire              done
);

    reg [N-1:0] spike_reg;

    
    reg [IDX_W-1:0] next_index;
    reg             found;
    integer k;

    assign done = (spike_reg == {N{1'b0}});

    
    always @(*) begin
        found = 1'b0;
        next_index = {IDX_W{1'b0}};

        for (k = N-1; k >= 0; k = k - 1) begin
            if (!found && spike_reg[k]) begin
                next_index = k[IDX_W-1:0];
                found = 1'b1;
            end
        end
    end

    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            spike_reg   <= {N{1'b0}};
            synapse_idx <= {IDX_W{1'b0}};
            valid       <= 1'b0;
        end 
        else if (load) begin
            spike_reg   <= spike_in;   
            valid       <= 1'b0;
        end 
        else begin
            if (found) begin
                synapse_idx <= next_index;  
                valid       <= 1'b1;
                spike_reg[next_index] <= 1'b0;
            end 
            else begin
                valid <= 1'b0;
            end
        end
    end

endmodule