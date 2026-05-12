module weights_memory_snn #(
    parameter INPUTS  = 784,
    parameter NEURONS = 799,
    parameter W       = 8,
    parameter PACK    = 8,
    parameter DT_W    = 8
)(
    input  wire clk,
    input  wire rst,
    input  wire read_en,
    input  wire [DT_W-1:0] delta_time,
    input  wire [$clog2(INPUTS)-1:0] synapse_idx,

    output reg [NEURONS*W-1:0] weights_out,
    output reg valid_out
);

localparam LOG_BANKS = (NEURONS + PACK - 1) / PACK;   
localparam PHY_BANKS = (LOG_BANKS + 1) / 2;           
localparam WORD_W    = PACK * W;
localparam DEPTH     = INPUTS * 2;


(* ram_style="block" *) reg [WORD_W-1:0] bram0 [0:DEPTH-1];
(* ram_style="block" *) reg [WORD_W-1:0] bram1 [0:DEPTH-1];
(* ram_style="block" *) reg [WORD_W-1:0] bram2 [0:DEPTH-1];
(* ram_style="block" *) reg [WORD_W-1:0] bram3 [0:DEPTH-1];
(* ram_style="block" *) reg [WORD_W-1:0] bram4 [0:DEPTH-1];
(* ram_style="block" *) reg [WORD_W-1:0] bram5 [0:DEPTH-1];
(* ram_style="block" *) reg [WORD_W-1:0] bram6 [0:DEPTH-1];
(* ram_style="block" *) reg [WORD_W-1:0] bram7 [0:DEPTH-1];
(* ram_style="block" *) reg [WORD_W-1:0] bram8 [0:DEPTH-1];
(* ram_style="block" *) reg [WORD_W-1:0] bram9 [0:DEPTH-1];
(* ram_style="block" *) reg [WORD_W-1:0] bram10 [0:INPUTS-1];
(* ram_style="block" *) reg [WORD_W-1:0] bram11 [0:INPUTS-1];
(* ram_style="block" *) reg [WORD_W-1:0] bram12 [0:INPUTS-1];
(* ram_style="block" *) reg [WORD_W-1:0] bram13 [0:INPUTS-1];
(* ram_style="block" *) reg [WORD_W-1:0] bram14 [0:INPUTS-1];
(* ram_style="block" *) reg [WORD_W-1:0] bram15 [0:INPUTS-1];
(* ram_style="block" *) reg [WORD_W-1:0] bram16 [0:INPUTS-1];
(* ram_style="block" *) reg [WORD_W-1:0] bram17 [0:INPUTS-1];
(* ram_style="block" *) reg [WORD_W-1:0] bram18 [0:INPUTS-1];
(* ram_style="block" *) reg [WORD_W-1:0] bram19 [0:INPUTS-1];
(* ram_style="block" *) reg [WORD_W-1:0] bram20 [0:INPUTS-1];
(* ram_style="block" *) reg [WORD_W-1:0] bram21 [0:INPUTS-1];
(* ram_style="block" *) reg [WORD_W-1:0] bram22 [0:INPUTS-1];
(* ram_style="block" *) reg [WORD_W-1:0] bram23 [0:INPUTS-1];
(* ram_style="block" *) reg [WORD_W-1:0] bram24 [0:INPUTS-1];
(* ram_style="block" *) reg [WORD_W-1:0] bram25 [0:INPUTS-1];
(* ram_style="block" *) reg [WORD_W-1:0] bram26 [0:INPUTS-1];
(* ram_style="block" *) reg [WORD_W-1:0] bram27 [0:INPUTS-1];
(* ram_style="block" *) reg [WORD_W-1:0] bram28 [0:INPUTS-1];
(* ram_style="block" *) reg [WORD_W-1:0] bram29 [0:INPUTS-1];
(* ram_style="block" *) reg [WORD_W-1:0] bram30 [0:INPUTS-1];
(* ram_style="block" *) reg [WORD_W-1:0] bram31 [0:INPUTS-1];
(* ram_style="block" *) reg [WORD_W-1:0] bram32 [0:INPUTS-1];
(* ram_style="block" *) reg [WORD_W-1:0] bram33 [0:INPUTS-1];
(* ram_style="block" *) reg [WORD_W-1:0] bram34 [0:INPUTS-1];
(* ram_style="block" *) reg [WORD_W-1:0] bram35 [0:INPUTS-1];
(* ram_style="block" *) reg [WORD_W-1:0] bram36 [0:INPUTS-1];
(* ram_style="block" *) reg [WORD_W-1:0] bram37 [0:INPUTS-1];
(* ram_style="block" *) reg [WORD_W-1:0] bram38 [0:INPUTS-1];
(* ram_style="block" *) reg [WORD_W-1:0] bram39 [0:INPUTS-1];
(* ram_style="block" *) reg [WORD_W-1:0] bram40 [0:INPUTS-1];
(* ram_style="block" *) reg [WORD_W-1:0] bram41 [0:INPUTS-1];
(* ram_style="block" *) reg [WORD_W-1:0] bram42 [0:INPUTS-1];
(* ram_style="block" *) reg [WORD_W-1:0] bram43 [0:INPUTS-1];
(* ram_style="block" *) reg [WORD_W-1:0] bram44 [0:INPUTS-1];
(* ram_style="block" *) reg [WORD_W-1:0] bram45 [0:INPUTS-1];
(* ram_style="block" *) reg [WORD_W-1:0] bram46 [0:INPUTS-1];
(* ram_style="block" *) reg [WORD_W-1:0] bram47 [0:INPUTS-1];
(* ram_style="block" *) reg [WORD_W-1:0] bram48 [0:INPUTS-1];
(* ram_style="block" *) reg [WORD_W-1:0] bram49 [0:INPUTS-1];




initial begin
    $readmemh("packbank_0.mem", bram0, 0);
    $readmemh("packbank_1.mem", bram0, INPUTS);

    $readmemh("packbank_2.mem", bram1, 0);
    $readmemh("packbank_3.mem", bram1, INPUTS);
    
    $readmemh("packbank_4.mem", bram2, 0);
    $readmemh("packbank_5.mem", bram2, INPUTS);
    
    $readmemh("packbank_6.mem", bram3, 0);
    $readmemh("packbank_7.mem", bram3, INPUTS);

    $readmemh("packbank_8.mem", bram4, 0);
    $readmemh("packbank_9.mem", bram4, INPUTS);
    
    $readmemh("packbank_10.mem", bram5, 0);
    $readmemh("packbank_11.mem", bram5, INPUTS);
    
    $readmemh("packbank_12.mem", bram6, 0);
    $readmemh("packbank_13.mem", bram6, INPUTS);

    $readmemh("packbank_14.mem", bram7, 0);
    $readmemh("packbank_15.mem", bram7, INPUTS);
    
    $readmemh("packbank_16.mem", bram8, 0);
    $readmemh("packbank_17.mem", bram8, INPUTS);
    
    $readmemh("packbank_18.mem", bram9, 0);
    $readmemh("packbank_19.mem", bram9, INPUTS);

    $readmemh("packbank_20.mem", bram10, 0);
    $readmemh("packbank_21.mem", bram10, INPUTS);
    
    $readmemh("packbank_22.mem", bram11, 0);
    $readmemh("packbank_23.mem", bram11, INPUTS);
    
    $readmemh("packbank_24.mem", bram12, 0);
    $readmemh("packbank_25.mem", bram12, INPUTS);

    $readmemh("packbank_26.mem", bram13, 0);
    $readmemh("packbank_27.mem", bram13, INPUTS);

    $readmemh("packbank_28.mem", bram14, 0);
    $readmemh("packbank_29.mem", bram14, INPUTS);

    $readmemh("packbank_30.mem", bram15, 0);
    $readmemh("packbank_31.mem", bram15, INPUTS);

    $readmemh("packbank_32.mem", bram16, 0);
    $readmemh("packbank_33.mem", bram16, INPUTS);

    $readmemh("packbank_34.mem", bram17, 0);
    $readmemh("packbank_35.mem", bram17, INPUTS);

    $readmemh("packbank_36.mem", bram18, 0);
    $readmemh("packbank_37.mem", bram18, INPUTS);
    
    $readmemh("packbank_38.mem", bram19, 0);
    $readmemh("packbank_39.mem", bram19, INPUTS);
    
    $readmemh("packbank_40.mem", bram20, 0);
    $readmemh("packbank_41.mem", bram20, INPUTS);
    
    $readmemh("packbank_42.mem", bram21, 0);
    $readmemh("packbank_43.mem", bram21, INPUTS);

    $readmemh("packbank_44.mem", bram22, 0);
    $readmemh("packbank_45.mem", bram22, INPUTS);
    
    $readmemh("packbank_46.mem", bram23, 0);
    $readmemh("packbank_47.mem", bram23, INPUTS);
    
    $readmemh("packbank_48.mem", bram24, 0);
    $readmemh("packbank_49.mem", bram24, INPUTS);
    
    $readmemh("packbank_50.mem", bram25, 0);
    $readmemh("packbank_51.mem", bram25, INPUTS);

    $readmemh("packbank_52.mem", bram26, 0);
    $readmemh("packbank_53.mem", bram26, INPUTS);
    
    $readmemh("packbank_54.mem", bram27, 0);
    $readmemh("packbank_55.mem", bram27, INPUTS);
    
    $readmemh("packbank_56.mem", bram28, 0);
    $readmemh("packbank_57.mem", bram28, INPUTS);
    
    $readmemh("packbank_58.mem", bram29, 0);
    $readmemh("packbank_59.mem", bram29, INPUTS);
    
    $readmemh("packbank_60.mem", bram30, 0);
    $readmemh("packbank_61.mem", bram30, INPUTS);
    
    $readmemh("packbank_62.mem", bram31, 0);
    $readmemh("packbank_63.mem", bram31, INPUTS);
    
    $readmemh("packbank_64.mem", bram32, 0);
    $readmemh("packbank_65.mem", bram32, INPUTS);
    
    $readmemh("packbank_66.mem", bram33, 0);
    $readmemh("packbank_67.mem", bram33, INPUTS);
    
    $readmemh("packbank_68.mem", bram34, 0);
    $readmemh("packbank_69.mem", bram34, INPUTS);
    
    $readmemh("packbank_70.mem", bram35, 0);
    $readmemh("packbank_71.mem", bram35, INPUTS);
    
    $readmemh("packbank_72.mem", bram36, 0);
    $readmemh("packbank_73.mem", bram36, INPUTS);
    
    $readmemh("packbank_74.mem", bram37, 0);
    $readmemh("packbank_75.mem", bram37, INPUTS);
    
    $readmemh("packbank_76.mem", bram38, 0);
    $readmemh("packbank_77.mem", bram38, INPUTS);
    
    $readmemh("packbank_78.mem", bram39, 0);
    $readmemh("packbank_79.mem", bram39, INPUTS);
    
    $readmemh("packbank_80.mem", bram40, 0);
    $readmemh("packbank_81.mem", bram40, INPUTS);
    
    $readmemh("packbank_82.mem", bram41, 0);
    $readmemh("packbank_83.mem", bram41, INPUTS);
    
    $readmemh("packbank_84.mem", bram42, 0);
    $readmemh("packbank_85.mem", bram42, INPUTS);
    
    $readmemh("packbank_86.mem", bram43, 0);
    $readmemh("packbank_87.mem", bram43, INPUTS);
    
    $readmemh("packbank_88.mem", bram44, 0);
    $readmemh("packbank_89.mem", bram44, INPUTS);
    
    $readmemh("packbank_90.mem", bram45, 0);
    $readmemh("packbank_91.mem", bram45, INPUTS);
    
    $readmemh("packbank_92.mem", bram46, 0);
    $readmemh("packbank_93.mem", bram46, INPUTS);
    
    $readmemh("packbank_94.mem", bram47, 0);
    $readmemh("packbank_95.mem", bram47, INPUTS);
    
    $readmemh("packbank_96.mem", bram48, 0);
    $readmemh("packbank_97.mem", bram48, INPUTS);
    
    $readmemh("packbank_98.mem", bram49, 0);
    $readmemh("packbank_99.mem", bram49, INPUTS);

    
end

reg read_en_d;

always @(posedge clk)
    read_en_d <= read_en & (delta_time != 0);



reg [WORD_W-1:0] packed_word [0:LOG_BANKS-1];

always @(posedge clk) begin
    packed_word[0] <= bram0[synapse_idx];
    packed_word[1] <= bram0[synapse_idx + INPUTS];

    packed_word[2] <= bram1[synapse_idx];
    packed_word[3] <= bram1[synapse_idx + INPUTS];
    
    packed_word[4]  <= bram2[synapse_idx];
    packed_word[5]  <= bram2[synapse_idx + INPUTS];

    packed_word[6]  <= bram3[synapse_idx];
    packed_word[7]  <= bram3[synapse_idx + INPUTS];
    
    packed_word[8]  <= bram4[synapse_idx];
    packed_word[9]  <= bram4[synapse_idx + INPUTS];
    
    packed_word[10] <= bram5[synapse_idx];
    packed_word[11] <= bram5[synapse_idx + INPUTS];
    
    packed_word[12] <= bram6[synapse_idx];
    packed_word[13] <= bram6[synapse_idx + INPUTS];
    
    packed_word[14] <= bram7[synapse_idx];
    packed_word[15] <= bram7[synapse_idx + INPUTS];
    
    packed_word[16] <= bram8[synapse_idx];
    packed_word[17] <= bram8[synapse_idx + INPUTS];
    
    packed_word[18] <= bram9[synapse_idx];
    packed_word[19] <= bram9[synapse_idx + INPUTS];
    
    packed_word[20] <= bram10[synapse_idx];
    packed_word[21] <= bram10[synapse_idx + INPUTS];
    
    packed_word[22] <= bram11[synapse_idx];
    packed_word[23] <= bram11[synapse_idx + INPUTS];
    
    packed_word[24] <= bram12[synapse_idx];
    packed_word[25] <= bram12[synapse_idx + INPUTS];
    
    packed_word[26] <= bram13[synapse_idx];
    packed_word[27] <= bram13[synapse_idx + INPUTS];
    
    packed_word[28] <= bram14[synapse_idx];
    packed_word[29] <= bram14[synapse_idx + INPUTS];
    
    packed_word[30] <= bram15[synapse_idx];
    packed_word[31] <= bram15[synapse_idx + INPUTS];
    
    packed_word[32] <= bram16[synapse_idx];
    packed_word[33] <= bram16[synapse_idx + INPUTS];
    
    packed_word[34] <= bram17[synapse_idx];
    packed_word[35] <= bram17[synapse_idx + INPUTS];
    
    packed_word[36] <= bram18[synapse_idx];
    packed_word[37] <= bram18[synapse_idx + INPUTS];
    
    packed_word[38] <= bram19[synapse_idx];
    packed_word[39] <= bram19[synapse_idx + INPUTS];
    
    packed_word[40] <= bram20[synapse_idx];
    packed_word[41] <= bram20[synapse_idx + INPUTS];
    
    packed_word[42] <= bram21[synapse_idx];
    packed_word[43] <= bram21[synapse_idx + INPUTS];
    
    packed_word[44] <= bram22[synapse_idx];
    packed_word[45] <= bram22[synapse_idx + INPUTS];
    
    packed_word[46] <= bram23[synapse_idx];
    packed_word[47] <= bram23[synapse_idx + INPUTS];
    
    packed_word[48] <= bram24[synapse_idx];
    packed_word[49] <= bram24[synapse_idx + INPUTS];
    
    packed_word[50] <= bram25[synapse_idx];
    packed_word[51] <= bram25[synapse_idx + INPUTS];
    
    packed_word[52] <= bram26[synapse_idx];
    packed_word[53] <= bram26[synapse_idx + INPUTS];
    
    packed_word[54] <= bram27[synapse_idx];
    packed_word[55] <= bram27[synapse_idx + INPUTS];
    
    packed_word[56] <= bram28[synapse_idx];
    packed_word[57] <= bram28[synapse_idx + INPUTS];
    
    packed_word[58] <= bram29[synapse_idx];
    packed_word[59] <= bram29[synapse_idx + INPUTS];
    
    packed_word[60] <= bram30[synapse_idx];
    packed_word[61] <= bram30[synapse_idx + INPUTS];
    
    packed_word[62] <= bram31[synapse_idx];
    packed_word[63] <= bram31[synapse_idx + INPUTS];
    
    packed_word[64] <= bram32[synapse_idx];
    packed_word[65] <= bram32[synapse_idx + INPUTS];
    
    packed_word[66] <= bram33[synapse_idx];
    packed_word[67] <= bram33[synapse_idx + INPUTS];
    
    packed_word[68] <= bram34[synapse_idx];
    packed_word[69] <= bram34[synapse_idx + INPUTS];
    
    packed_word[70] <= bram35[synapse_idx];
    packed_word[71] <= bram35[synapse_idx + INPUTS];
    
    packed_word[72] <= bram36[synapse_idx];
    packed_word[73] <= bram36[synapse_idx + INPUTS];
    
    packed_word[74] <= bram37[synapse_idx];
    packed_word[75] <= bram37[synapse_idx + INPUTS];
    
    packed_word[76] <= bram38[synapse_idx];
    packed_word[77] <= bram38[synapse_idx + INPUTS];
    
    packed_word[78] <= bram39[synapse_idx];
    packed_word[79] <= bram39[synapse_idx + INPUTS];
    
    packed_word[80] <= bram40[synapse_idx];
    packed_word[81] <= bram40[synapse_idx + INPUTS];
    
    packed_word[82] <= bram41[synapse_idx];
    packed_word[83] <= bram41[synapse_idx + INPUTS];
    
    packed_word[84] <= bram42[synapse_idx];
    packed_word[85] <= bram42[synapse_idx + INPUTS];
    
    packed_word[86] <= bram43[synapse_idx];
    packed_word[87] <= bram43[synapse_idx + INPUTS];
    
    packed_word[88] <= bram44[synapse_idx];
    packed_word[89] <= bram44[synapse_idx + INPUTS];
    
    packed_word[90] <= bram45[synapse_idx];
    packed_word[91] <= bram45[synapse_idx + INPUTS];
    
    packed_word[92] <= bram46[synapse_idx];
    packed_word[93] <= bram46[synapse_idx + INPUTS];
    
    packed_word[94] <= bram47[synapse_idx];
    packed_word[95] <= bram47[synapse_idx + INPUTS];
    
    packed_word[96] <= bram48[synapse_idx];
    packed_word[97] <= bram48[synapse_idx + INPUTS];
    
    packed_word[98] <= bram49[synapse_idx];
    packed_word[99] <= bram49[synapse_idx + INPUTS];

    
end



integer i;

always @(posedge clk) begin
    if (rst) begin
        weights_out <= 0;
        valid_out   <= 0;
    end
    else begin
        valid_out <= read_en_d;

        if (read_en_d) begin
            for (i = 0; i < NEURONS; i = i + 1) begin
                weights_out[i*W +: W] <=
                    packed_word[i/PACK][(i%PACK)*W +: W];
            end
        end
    end
end

endmodule