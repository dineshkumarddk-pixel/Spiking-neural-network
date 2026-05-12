module layer_control_correct_L3 #(
    parameter DT_WIDTH = 8,
    parameter DECAY_MAX = 255   
)(
    input  wire clk,
    input  wire rst,

    
    input  wire [DT_WIDTH-1:0] delta_time_in,
    input  wire spike_valid_in,
    input  wire sorter_done,

    output reg load_dt,   
    output reg hold_dt,   

    
    output reg decay_enable,
    output reg accumulate_enable,
    output reg fire_enable,

    
    output reg layer_active,
    output reg layer_done,
    output reg event_done
);

    
    localparam IDLE        = 3'd0;
    localparam LOAD_EVENT  = 3'd1;
    localparam DECAY       = 3'd2;
    localparam ACCUMULATE  = 3'd3;
    localparam FIRE        = 3'd4;
    localparam CHECK_DONE  = 3'd5;
    localparam LAYER_DONE  = 3'd6;

    reg [2:0] state, next_state;

    
    reg [DT_WIDTH-1:0] dt_counter;

    
    always @(posedge clk or posedge rst) begin
        if (rst)
            state <= IDLE;
        else
            state <= next_state;
    end

    
    always @(posedge clk or posedge rst) begin
        if (rst)
            dt_counter <= 0;

        else if (state == LOAD_EVENT)
            dt_counter <= delta_time_in;

        else if (state == DECAY && dt_counter > 0)
            dt_counter <= dt_counter - 1;
    end

    
    always @(*) begin
        next_state = state;

        case (state)

            IDLE: begin
                if (spike_valid_in)
                    next_state = LOAD_EVENT;
            end

            LOAD_EVENT: begin
                if (delta_time_in == 0)
                    next_state = ACCUMULATE;
                else
                    next_state = DECAY;
            end

            DECAY: begin
                if (dt_counter == 0)
                    next_state = ACCUMULATE;
            end

            ACCUMULATE: begin
                next_state = FIRE;
            end

            FIRE: begin
                next_state = CHECK_DONE;
            end

            CHECK_DONE: begin
                if (sorter_done)
                    next_state = LAYER_DONE;
                else if (spike_valid_in)
                    next_state = LOAD_EVENT;
                else
                    next_state = IDLE;
            end

            LAYER_DONE: begin
                next_state = IDLE;
            end

            default: next_state = IDLE;

        endcase
    end

    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            load_dt           <= 0;
            hold_dt           <= 0;
            decay_enable      <= 0;
            accumulate_enable <= 0;
            fire_enable       <= 0;
            layer_active      <= 0;
            layer_done        <= 0;
            event_done        <= 0;
        end
        else begin

            load_dt           <= 0;
            hold_dt           <= 0;
            decay_enable      <= 0;
            accumulate_enable <= 0;
            fire_enable       <= 0;
            layer_done        <= 0;
            event_done        <= 0;

            case (state)

                IDLE: begin
                    layer_active <= 0;
                end

                LOAD_EVENT: begin
                    load_dt      <= 1;
                    hold_dt      <= 1;
                    layer_active <= 1;
                end

                DECAY: begin
                    hold_dt      <= 1;
                    decay_enable <= 1;
                    layer_active <= 1;
                end

                ACCUMULATE: begin
                    hold_dt           <= 1;
                    accumulate_enable <= 1;
                    layer_active      <= 1;
                end

                FIRE: begin
                    hold_dt     <= 1;
                    fire_enable <= 1;
                    layer_active <= 1;
                end

                CHECK_DONE: begin
                    hold_dt      <= 0;
                    layer_active <= 1;
                    event_done   <= 1;
                end

                LAYER_DONE: begin
                    layer_done   <= 1;
                    layer_active <= 0;
                end

            endcase
        end
    end

endmodule