module weights_memory_snn_L2 #(
    parameter INPUTS  = 800,
    parameter NEURONS = 512,
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

localparam WORD_W = PACK * W;
localparam LOG_BANKS = NEURONS / PACK;     
localparam PHY_BANKS = LOG_BANKS / 2;      
localparam DEPTH = INPUTS * 2;


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
(* ram_style="block" *) reg [WORD_W-1:0] bram16 [0:DEPTH-1];
(* ram_style="block" *) reg [WORD_W-1:0] bram17 [0:DEPTH-1];
(* ram_style="block" *) reg [WORD_W-1:0] bram18 [0:DEPTH-1];
(* ram_style="block" *) reg [WORD_W-1:0] bram19 [0:DEPTH-1];
(* ram_style="block" *) reg [WORD_W-1:0] bram20 [0:DEPTH-1];
(* ram_style="block" *) reg [WORD_W-1:0] bram21 [0:DEPTH-1];
(* ram_style="block" *) reg [WORD_W-1:0] bram22 [0:DEPTH-1];
(* ram_style="block" *) reg [WORD_W-1:0] bram23 [0:DEPTH-1];
(* ram_style="block" *) reg [WORD_W-1:0] bram24 [0:DEPTH-1];
(* ram_style="block" *) reg [WORD_W-1:0] bram25 [0:DEPTH-1];
(* ram_style="block" *) reg [WORD_W-1:0] bram26 [0:DEPTH-1];
(* ram_style="block" *) reg [WORD_W-1:0] bram27 [0:DEPTH-1];
(* ram_style="block" *) reg [WORD_W-1:0] bram28 [0:DEPTH-1];
(* ram_style="block" *) reg [WORD_W-1:0] bram29 [0:DEPTH-1];
(* ram_style="block" *) reg [WORD_W-1:0] bram30 [0:DEPTH-1];
(* ram_style="block" *) reg [WORD_W-1:0] bram31 [0:DEPTH-1];



initial begin
    $readmemh("packbank_L2_0.mem", bram0, 0);
    $readmemh("packbank_L2_1.mem", bram0, INPUTS);
    
    $readmemh("packbank_L2_2.mem", bram1, 0);
    $readmemh("packbank_L2_3.mem", bram1, INPUTS);
    
    $readmemh("packbank_L2_4.mem", bram2, 0);
    $readmemh("packbank_L2_5.mem", bram2, INPUTS);
    
    $readmemh("packbank_L2_6.mem",  bram3, 0); 
    $readmemh("packbank_L2_7.mem",  bram3, INPUTS);

    $readmemh("packbank_L2_8.mem",  bram4, 0);
    $readmemh("packbank_L2_9.mem",  bram4, INPUTS);

    $readmemh("packbank_L2_10.mem", bram5, 0);
    $readmemh("packbank_L2_11.mem", bram5, INPUTS);

    $readmemh("packbank_L2_12.mem", bram6, 0);
    $readmemh("packbank_L2_13.mem", bram6, INPUTS);

    $readmemh("packbank_L2_14.mem", bram7, 0);
    $readmemh("packbank_L2_15.mem", bram7, INPUTS);

    $readmemh("packbank_L2_16.mem", bram8, 0);
    $readmemh("packbank_L2_17.mem", bram8, INPUTS);

    $readmemh("packbank_L2_18.mem", bram9, 0);
    $readmemh("packbank_L2_19.mem", bram9, INPUTS);

    $readmemh("packbank_L2_20.mem", bram10, 0);
    $readmemh("packbank_L2_21.mem", bram10, INPUTS);

    $readmemh("packbank_L2_22.mem", bram11, 0);
    $readmemh("packbank_L2_23.mem", bram11, INPUTS);

    $readmemh("packbank_L2_24.mem", bram12, 0);
    $readmemh("packbank_L2_25.mem", bram12, INPUTS);

    $readmemh("packbank_L2_26.mem", bram13, 0);
    $readmemh("packbank_L2_27.mem", bram13, INPUTS);

    $readmemh("packbank_L2_28.mem", bram14, 0);
    $readmemh("packbank_L2_29.mem", bram14, INPUTS);

    $readmemh("packbank_L2_30.mem", bram15, 0);
    $readmemh("packbank_L2_31.mem", bram15, INPUTS);

    $readmemh("packbank_L2_32.mem", bram16, 0);
    $readmemh("packbank_L2_33.mem", bram16, INPUTS);

    $readmemh("packbank_L2_34.mem", bram17, 0);
    $readmemh("packbank_L2_35.mem", bram17, INPUTS);

    $readmemh("packbank_L2_36.mem", bram18, 0);
    $readmemh("packbank_L2_37.mem", bram18, INPUTS);

    $readmemh("packbank_L2_38.mem", bram19, 0);
    $readmemh("packbank_L2_39.mem", bram19, INPUTS);

    $readmemh("packbank_L2_40.mem", bram20, 0);
    $readmemh("packbank_L2_41.mem", bram20, INPUTS);

    $readmemh("packbank_L2_42.mem", bram21, 0);
    $readmemh("packbank_L2_43.mem", bram21, INPUTS);

    $readmemh("packbank_L2_44.mem", bram22, 0);
    $readmemh("packbank_L2_45.mem", bram22, INPUTS);

    $readmemh("packbank_L2_46.mem", bram23, 0);
    $readmemh("packbank_L2_47.mem", bram23, INPUTS);

    $readmemh("packbank_L2_48.mem", bram24, 0);
    $readmemh("packbank_L2_49.mem", bram24, INPUTS);

    $readmemh("packbank_L2_50.mem", bram25, 0);
    $readmemh("packbank_L2_51.mem", bram25, INPUTS);

    $readmemh("packbank_L2_52.mem", bram26, 0);
    $readmemh("packbank_L2_53.mem", bram26, INPUTS);

    $readmemh("packbank_L2_54.mem", bram27, 0);
    $readmemh("packbank_L2_55.mem", bram27, INPUTS);

    $readmemh("packbank_L2_56.mem", bram28, 0);
    $readmemh("packbank_L2_57.mem", bram28, INPUTS);

    $readmemh("packbank_L2_58.mem", bram29, 0);
    $readmemh("packbank_L2_59.mem", bram29, INPUTS);

    $readmemh("packbank_L2_60.mem", bram30, 0);
    $readmemh("packbank_L2_61.mem", bram30, INPUTS);

    $readmemh("packbank_L2_62.mem", bram31, 0);
    $readmemh("packbank_L2_63.mem", bram31, INPUTS);
end




wire [2:0] offset = neuron_idx[2:0];
wire [5:0] bank   = neuron_idx[8:3];   
wire [4:0] phy    = bank[5:1];
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
            16 : word_q <= bram16[ row_sel ? synapse_idx+INPUTS : synapse_idx ];
            17 : word_q <= bram17[ row_sel ? synapse_idx+INPUTS : synapse_idx ];
            18 : word_q <= bram18[ row_sel ? synapse_idx+INPUTS : synapse_idx ];
            19 : word_q <= bram19[ row_sel ? synapse_idx+INPUTS : synapse_idx ];
            20 : word_q <= bram20[ row_sel ? synapse_idx+INPUTS : synapse_idx ];
            21 : word_q <= bram21[ row_sel ? synapse_idx+INPUTS : synapse_idx ];
            22 : word_q <= bram22[ row_sel ? synapse_idx+INPUTS : synapse_idx ];
            23 : word_q <= bram23[ row_sel ? synapse_idx+INPUTS : synapse_idx ];
            24 : word_q <= bram24[ row_sel ? synapse_idx+INPUTS : synapse_idx ];
            25 : word_q <= bram25[ row_sel ? synapse_idx+INPUTS : synapse_idx ];
            26 : word_q <= bram26[ row_sel ? synapse_idx+INPUTS : synapse_idx ];
            27 : word_q <= bram27[ row_sel ? synapse_idx+INPUTS : synapse_idx ];
            28 : word_q <= bram28[ row_sel ? synapse_idx+INPUTS : synapse_idx ];
            29 : word_q <= bram29[ row_sel ? synapse_idx+INPUTS : synapse_idx ];
            30 : word_q <= bram30[ row_sel ? synapse_idx+INPUTS : synapse_idx ];
            31 : word_q <= bram31[ row_sel ? synapse_idx+INPUTS : synapse_idx ];
        endcase
    end
end




always @(posedge clk)
    weight_out <= word_q[offset*W +: W];

endmodule