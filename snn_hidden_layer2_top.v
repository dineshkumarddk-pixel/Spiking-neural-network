module snn_hidden_layer2_top #(
    parameter INPUTS     = 800,
    parameter NEURONS    = 512,
    parameter W          = 8,
    parameter FIFO_DEPTH = 1024
)(
    input  wire clk,
    input  wire rst,

    
    input  wire [W-1:0] delta_in,
    input  wire [$clog2(INPUTS)-1:0] index_in,
    input  wire spike_valid,

    input  wire layer1_done,

    
    output wire [W-1:0] dout_delta,
    output wire [$clog2(NEURONS)-1:0] lopd_index,
    output wire lopd_valid,

    output wire layer_active,
    output wire layer_done
);

    

    wire fifo_full;
    wire fifo_empty;
    wire fifo_wr_en;
    wire fifo_rd_en;

    wire [W-1:0] fifo_delta_out;
    wire [$clog2(INPUTS)-1:0] fifo_index_out;

    wire load_dt;
    wire hold_dt;
    wire decay_enable;
    wire accumulate_enable;
    wire fire_enable;

    wire event_done;

    wire [NEURONS-1:0] fire_vector;

    wire [NEURONS-1:0] lopd_fifo_dout;
    wire lopd_fifo_valid;
    wire lopd_fifo_empty;
    wire lopd_fifo_full;
    wire lopd_done;

    

    assign fifo_wr_en = spike_valid && !fifo_full;

    spike_fifo_L2 #(
        .DT_WIDTH(W),
        .INPUTS(INPUTS),
        .DEPTH(FIFO_DEPTH)
    ) event_fifo (
        .clk(clk),
        .rst(rst),

        .wr_en(fifo_wr_en),
        .delta_in(delta_in),
        .index_in(index_in),
        .full(fifo_full),

        .rd_en(fifo_rd_en),
        .delta_out(fifo_delta_out),
        .index_out(fifo_index_out),
        .empty(fifo_empty),

        .count()
    );

    

    layer_control_correct_L2 control_unit (
        .clk(clk),
        .rst(rst),

        .delta_time_in(fifo_delta_out),
        .spike_valid_in(!fifo_empty),
        .sorter_done(layer1_done && fifo_empty),

        .load_dt(load_dt),
        .hold_dt(hold_dt),

        .decay_enable(decay_enable),
        .accumulate_enable(accumulate_enable),
        .fire_enable(fire_enable),

        .layer_active(layer_active),
        .layer_done(layer_done),
        .event_done(event_done)
    );

    assign fifo_rd_en = load_dt && !fifo_empty;

    

    delay_block_L2 #(
        .DT_WIDTH(W)
    ) delay_unit (
        .clk(clk),
        .rst(rst),

        .load_dt(load_dt),
        .hold_dt(hold_dt),

        .delta_time_in(fifo_delta_out),
        .delta_time_out(dout_delta)
    );

    

    reg [$clog2(NEURONS)-1:0] neuron_scan;

    always @(posedge clk or posedge rst) begin
        if(rst)
            neuron_scan <= 0;
        else if(load_dt)
            neuron_scan <= 0;
        else if(accumulate_enable)
            neuron_scan <= neuron_scan + 1;
    end

    wire signed [W-1:0] weight_serial;

    weights_memory_snn_L2 #(
        .INPUTS(INPUTS),
        .NEURONS(NEURONS),
        .W(W)
    ) weight_mem (
        .clk(clk),
        .rst(rst),
        .read_en(accumulate_enable),

        .synapse_idx(fifo_index_out),
        .neuron_idx(neuron_scan),

        .weight_out(weight_serial)
    );

    

    genvar i;

    generate
        for (i = 0; i < NEURONS; i = i + 1) begin : NEURON_ARRAY

            neuron_core_L2 neuron_inst (
                .clk(clk),
                .reset(rst),

                .decay_enable(decay_enable),
                .accumulate_enable(accumulate_enable && (neuron_scan==i)),
                .fire_enable(fire_enable),

                .w(weight_serial),
                .theta(8'sd5),

                .fire(fire_vector[i])
            );

        end
    endgenerate

    

    reg fire_enable_d;

    always @(posedge clk or posedge rst) begin
        if (rst)
            fire_enable_d <= 0;
        else
            fire_enable_d <= fire_enable;
    end

    wire fire_vector_wr_en = fire_enable & ~fire_enable_d;

    

    lopd_fifo_L2 #(
        .DATA_WIDTH(NEURONS),
        .DEPTH(FIFO_DEPTH)
    ) fire_event_fifo (
        .clk(clk),
        .rst(rst),

        .wr_en(fire_vector_wr_en),
        .din(fire_vector),
        .full(lopd_fifo_full),

        .rd_en(lopd_done),
        .dout(lopd_fifo_dout),
        .empty(lopd_fifo_empty),
        .valid_out(lopd_fifo_valid),

        .count(),
        .wr_ptr(),
        .rd_ptr()
    );

    

    lopd_index_generator_L2 #(
        .N(NEURONS),
        .IDX_W($clog2(NEURONS))
    ) lopd_unit (
        .clk(clk),
        .rst(rst),

        .load(lopd_fifo_valid),
        .spike_in(lopd_fifo_dout),

        .synapse_idx(lopd_index),
        .valid(lopd_valid),
        .done(lopd_done)
    );

endmodule