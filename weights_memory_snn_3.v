module weights_memory_snn_L3 #(
    parameter INPUTS  = 512,   
    parameter NEURONS = 256,
    parameter W       = 8,
    parameter PACK    = 8
)(
    input  wire clk,
    input  wire rst,
    input  wire read_en,

    input  wire [$clog2(INPUTS)-1:0] synapse_idx,
    input  wire [$clog2(NEURONS)-1:0] neuron_idx,

    output reg signed [W-1:0] weight_out
);

localparam WORD_W    = PACK * W;
localparam LOG_BANKS = NEURONS / PACK;   
localparam PHY_BANKS = LOG_BANKS / 2;    
localparam DEPTH     = INPUTS * 2;



(* ram_style="block" *) reg [WORD_W-1:0] bram0  [0:DEPTH-1];
(* ram_style="block" *) reg [WORD_W-1:0] bram1  [0:DEPTH-1];
(* ram_style="block" *) reg [WORD_W-1:0] bram2  [0:DEPTH-1];
(* ram_style="block" *) reg [WORD_W-1:0] bram3  [0:DEPTH-1];
(* ram_style="block" *) reg [WORD_W-1:0] bram4  [0:DEPTH-1];
(* ram_style="block" *) reg [WORD_W-1:0] bram5  [0:DEPTH-1];
(* ram_style="block" *) reg [WORD_W-1:0] bram6  [0:DEPTH-1];
(* ram_style="block" *) reg [WORD_W-1:0] bram7  [0:DEPTH-1];
(* ram_style="block" *) reg [WORD_W-1:0] bram8  [0:DEPTH-1];
(* ram_style="block" *) reg [WORD_W-1:0] bram9  [0:DEPTH-1];
(* ram_style="block" *) reg [WORD_W-1:0] bram10 [0:DEPTH-1];
(* ram_style="block" *) reg [WORD_W-1:0] bram11 [0:DEPTH-1];
(* ram_style="block" *) reg [WORD_W-1:0] bram12 [0:DEPTH-1];
(* ram_style="block" *) reg [WORD_W-1:0] bram13 [0:DEPTH-1];
(* ram_style="block" *) reg [WORD_W-1:0] bram14 [0:DEPTH-1];
(* ram_style="block" *) reg [WORD_W-1:0] bram15 [0:DEPTH-1];




initial begin
    $readmemh("packbank_L3_0.mem", bram0, 0);
    $readmemh("packbank_L3_1.mem", bram0, INPUTS);

    $readmemh("packbank_L3_2.mem", bram1, 0);
    $readmemh("packbank_L3_3.mem", bram1, INPUTS);

    $readmemh("packbank_L3_4.mem", bram2, 0);
    $readmemh("packbank_L3_5.mem", bram2, INPUTS);

    $readmemh("packbank_L3_6.mem", bram3, 0);
    $readmemh("packbank_L3_7.mem", bram3, INPUTS);

    $readmemh("packbank_L3_8.mem", bram4, 0);
    $readmemh("packbank_L3_9.mem", bram4, INPUTS);

    $readmemh("packbank_L3_10.mem", bram5, 0);
    $readmemh("packbank_L3_11.mem", bram5, INPUTS);

    $readmemh("packbank_L3_12.mem", bram6, 0);
    $readmemh("packbank_L3_13.mem", bram6, INPUTS);

    $readmemh("packbank_L3_14.mem", bram7, 0);
    $readmemh("packbank_L3_15.mem", bram7, INPUTS);

    $readmemh("packbank_L3_16.mem", bram8, 0);
    $readmemh("packbank_L3_17.mem", bram8, INPUTS);

    $readmemh("packbank_L3_18.mem", bram9, 0);
    $readmemh("packbank_L3_19.mem", bram9, INPUTS);

    $readmemh("packbank_L3_20.mem", bram10, 0);
    $readmemh("packbank_L3_21.mem", bram10, INPUTS);

    $readmemh("packbank_L3_22.mem", bram11, 0);
    $readmemh("packbank_L3_23.mem", bram11, INPUTS);

    $readmemh("packbank_L3_24.mem", bram12, 0);
    $readmemh("packbank_L3_25.mem", bram12, INPUTS);

    $readmemh("packbank_L3_26.mem", bram13, 0);
    $readmemh("packbank_L3_27.mem", bram13, INPUTS);

    $readmemh("packbank_L3_28.mem", bram14, 0);
    $readmemh("packbank_L3_29.mem", bram14, INPUTS);

    $readmemh("packbank_L3_30.mem", bram15, 0);
    $readmemh("packbank_L3_31.mem", bram15, INPUTS);
end




wire [2:0] offset = neuron_idx[2:0];
wire [4:0] bank   = neuron_idx[7:3];   
wire [3:0] phy    = bank[4:1];
wire row_sel      = bank[0];

reg [WORD_W-1:0] word_q;



always @(posedge clk) begin
    if(read_en) begin
        case(phy)
            0  : word_q <= bram0 [ row_sel ? synapse_idx+INPUTS : synapse_idx ];
            1  : word_q <= bram1 [ row_sel ? synapse_idx+INPUTS : synapse_idx ];
            2  : word_q <= bram2 [ row_sel ? synapse_idx+INPUTS : synapse_idx ];
            3  : word_q <= bram3 [ row_sel ? synapse_idx+INPUTS : synapse_idx ];
            4  : word_q <= bram4 [ row_sel ? synapse_idx+INPUTS : synapse_idx ];
            5  : word_q <= bram5 [ row_sel ? synapse_idx+INPUTS : synapse_idx ];
            6  : word_q <= bram6 [ row_sel ? synapse_idx+INPUTS : synapse_idx ];
            7  : word_q <= bram7 [ row_sel ? synapse_idx+INPUTS : synapse_idx ];
            8  : word_q <= bram8 [ row_sel ? synapse_idx+INPUTS : synapse_idx ];
            9  : word_q <= bram9 [ row_sel ? synapse_idx+INPUTS : synapse_idx ];
            10 : word_q <= bram10[ row_sel ? synapse_idx+INPUTS : synapse_idx ];
            11 : word_q <= bram11[ row_sel ? synapse_idx+INPUTS : synapse_idx ];
            12 : word_q <= bram12[ row_sel ? synapse_idx+INPUTS : synapse_idx ];
            13 : word_q <= bram13[ row_sel ? synapse_idx+INPUTS : synapse_idx ];
            14 : word_q <= bram14[ row_sel ? synapse_idx+INPUTS : synapse_idx ];
            15 : word_q <= bram15[ row_sel ? synapse_idx+INPUTS : synapse_idx ];
        endcase
    end
end


always @(posedge clk)
    weight_out <= word_q[offset*W +: W];

endmodule