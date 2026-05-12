module spike_fifo_L3 #(
    parameter DT_WIDTH   = 8,
    parameter INPUTS     = 512,  
    parameter DEPTH      = 1024,
    parameter IDX_WIDTH  = $clog2(INPUTS),
    parameter DATA_WIDTH = DT_WIDTH + IDX_WIDTH,
    parameter ADDR_WIDTH = $clog2(DEPTH)
)(
    input  wire clk,
    input  wire rst,

    input  wire                   wr_en,
    input  wire [DT_WIDTH-1:0]    delta_in,
    input  wire [IDX_WIDTH-1:0]   index_in,
    output wire                   full,

    
    input  wire                   rd_en,
    output reg  [DT_WIDTH-1:0]    delta_out,
    output reg  [IDX_WIDTH-1:0]   index_out,
    output wire                   empty,

    
    output reg  [ADDR_WIDTH:0]    count
);

    
    (* ram_style = "block" *)
    reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];

    reg [ADDR_WIDTH-1:0] wr_ptr;
    reg [ADDR_WIDTH-1:0] rd_ptr;

    assign full  = (count == DEPTH);
    assign empty = (count == 0);
    
    
    always @(posedge clk) begin
        if (rst) begin
            wr_ptr <= 0;
        end
        else if (wr_en && !full) begin
            mem[wr_ptr] <= {delta_in, index_in};
            wr_ptr <= wr_ptr + 1'b1;
        end
    end
    
    
    always @(posedge clk) begin
        if (rst) begin
            rd_ptr    <= 0;
            delta_out <= 0;
            index_out <= 0;
        end
        else if (rd_en && !empty) begin
            {delta_out, index_out} <= mem[rd_ptr];
            rd_ptr <= rd_ptr + 1'b1;
        end
    end

    
    always @(posedge clk) begin
        if (rst) begin
            count <= 0;
        end
        else begin
            case ({wr_en && !full, rd_en && !empty})
                2'b10: count <= count + 1'b1;
                2'b01: count <= count - 1'b1;
                2'b11: count <= count;   // simultaneous read/write
                default: count <= count;
            endcase
        end
    end

endmodule