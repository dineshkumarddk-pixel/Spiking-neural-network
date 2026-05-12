module lopd_index_generator_L2 #(
    parameter N = 512,
    parameter IDX_W = 9,
    parameter GROUP = 16
)(
    input  wire              clk,
    input  wire              rst,
    input  wire              load,
    input  wire [N-1:0]      spike_in,

    output reg  [IDX_W-1:0]  synapse_idx,
    output reg               valid,
    output reg               done
);

localparam NG = (N+GROUP-1)/GROUP;
localparam GIDX = 4;              
localparam GGIDX = 5;             

reg [N-1:0] spike_reg;

reg group_has_spike [0:NG-1];

integer g;
always @(*) begin
    for(g=0; g<NG; g=g+1)
        group_has_spike[g] = |spike_reg[g*GROUP +: GROUP];
end

reg [GGIDX-1:0] sel_group;
reg group_found;

integer j;
always @(*) begin
    sel_group = 0;
    group_found = 0;
    for(j=NG-1; j>=0; j=j-1) begin
        if(!group_found && group_has_spike[j]) begin
            sel_group = j;
            group_found = 1;
        end
    end
end

reg [GIDX-1:0] local_idx;
reg local_found;

integer m;
always @(*) begin
    local_idx = 0;
    local_found = 0;
    for(m=GROUP-1; m>=0; m=m-1) begin
        if(!local_found && spike_reg[{sel_group,m}]) begin
            local_idx = m;
            local_found = 1;
        end
    end
end

wire found = group_found & local_found;


wire [IDX_W-1:0] next_index = {sel_group, local_idx};

always @(posedge clk or posedge rst) begin
    if(rst) begin
        spike_reg   <= 0;
        synapse_idx <= 0;
        valid       <= 0;
        done        <= 1;
    end
    else if(load) begin
        spike_reg   <= spike_in;
        valid       <= 0;
        done        <= (spike_in==0);
    end
    else begin
        if(found) begin
            synapse_idx <= next_index;
            valid       <= 1;
            spike_reg[next_index] <= 1'b0;
            done <= 0;
        end
        else begin
            valid <= 0;
            done  <= 1;
        end
    end
end

endmodule