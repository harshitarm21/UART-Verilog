module uart_tx(
    input wire clk,
    input wire rst,
    input wire tx_start,
    input wire [7:0]tx_data,
    input wire baud_tick,
    
    output reg tx,
    output reg busy
    );
    
    localparam IDLE = 2'b00;
    localparam START = 2'b01;
    localparam DATA = 2'b10;
    localparam STOP = 2'b11;
    
    reg[1:0]state;
    reg[7:0]data_reg;
    reg[2:0]bit_count;
    
    always@(posedge clk) begin
    if(rst) begin
    tx<= 1'b1;
    data_reg <= 8'd0;
    busy<=1'b0;
    bit_count <= 3'b000;
    state <= IDLE;
    end
    
    else begin
    case(state)
    
    IDLE : begin
    tx <= 1'b1;
    busy <= 1'b0;
     if(tx_start) begin
        data_reg<= tx_data;
        busy <= 1'b1; //busy
        state <= START;
        bit_count <= 3'b000;
     end
    end
    
    START : begin
        tx <= 1'b0;
        busy <= 1'b1;
        if(baud_tick) begin
            state <= DATA;
        end
    end 
    
    DATA : begin
      busy <= 1'b1; 
      tx <= data_reg[bit_count];
      if(baud_tick) begin
        if(bit_count == 3'b111) begin
        state <= STOP;
        end
        else begin
        bit_count <= bit_count+1'b1 ;
        end
        end 
     end
     
    STOP : begin
        tx <= 1'b1;
        busy <= 1'b1;
        if(baud_tick) begin
            busy<=1'b0;
            state <= IDLE;
        end
    end
    default: begin
    state <= IDLE;
    end
    endcase
    end
    end
    
endmodule
