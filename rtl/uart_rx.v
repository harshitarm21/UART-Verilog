//-----------------------------------------------------------------------------
// Module      : UART Receiver
// File        : uart_rx.v
// Author      : Harshita R M
// Description :
//   UART Receiver implemented in Verilog HDL.
//   Receives serial UART data and reconstructs the original 8-bit byte.
//   Data is sampled at the centre of each bit period.
//   FSM States: IDLE -> START -> DATA -> STOP
//-----------------------------------------------------------------------------

module uart_rx
(
    input  wire       clk,
    input  wire       rst,
    input  wire       rx,

    output reg [7:0]  rx_data,
    output reg        rx_done
);

    //--------------------------------------------------------------------------
    // State Encoding
    //--------------------------------------------------------------------------
    localparam IDLE  = 2'b00;
    localparam START = 2'b01;
    localparam DATA  = 2'b10;
    localparam STOP  = 2'b11;

    //--------------------------------------------------------------------------
    // Internal Registers
    //--------------------------------------------------------------------------
    reg [1:0]  state;
    reg [7:0]  data_reg;
    reg [2:0]  bit_count;
    reg [15:0] baud_counter;

    //--------------------------------------------------------------------------
    // UART Receiver FSM
    //--------------------------------------------------------------------------
    always @(posedge clk)
    begin
        if (rst)
        begin
            state        <= IDLE;
            data_reg     <= 8'd0;
            bit_count    <= 3'd0;
            baud_counter <= 16'd0;
            rx_data      <= 8'd0;
            rx_done      <= 1'b0;
        end

        else
        begin
            case (state)

                //--------------------------------------------------------------
                // Idle State
                //--------------------------------------------------------------
                IDLE:
                begin
                    rx_done <= 1'b0;

                    // Detect start bit
                    if (rx == 1'b0)
                    begin
                        baud_counter <= 16'd0;
                        bit_count    <= 3'd0;
                        state        <= START;
                    end
                end

                //--------------------------------------------------------------
                // Start Bit Validation
                //--------------------------------------------------------------
                START:
                begin
                    baud_counter <= baud_counter + 16'd1;

                    // Sample at middle of start bit
                    if (baud_counter == 16'd5208)
                    begin
                        if (rx == 1'b0)
                        begin
                            baud_counter <= 16'd0;
                            state <= DATA;
                        end
                        else
                        begin
                            baud_counter <= 16'd0;
                            state <= IDLE;
                        end
                    end
                end

                //--------------------------------------------------------------
                // Data Reception
                //--------------------------------------------------------------
                DATA:
                begin
                    baud_counter <= baud_counter + 16'd1;

                    if (baud_counter >= 16'd10417)
                    begin
                        // Sample current data bit
                        data_reg[bit_count] <= rx;

                        baud_counter <= 16'd0;

                        if (bit_count == 3'd7)
                        begin
                            bit_count <= 3'd0;
                            state <= STOP;
                        end
                        else
                        begin
                            bit_count <= bit_count + 3'd1;
                        end
                    end
                end

                //--------------------------------------------------------------
                // Stop Bit
                //--------------------------------------------------------------
                STOP:
                begin
                    baud_counter <= baud_counter + 16'd1;

                    if (baud_counter >= 16'd10417)
                    begin
                        if (rx == 1'b1)
                        begin
                            rx_data <= data_reg;
                            rx_done <= 1'b1;
                        end

                        baud_counter <= 16'd0;
                        state <= IDLE;
                    end
                end

                //--------------------------------------------------------------
                // Default State
                //--------------------------------------------------------------
                default:
                begin
                    state   <= IDLE;
                    rx_done <= 1'b0;
                end

            endcase
        end
    end

endmodule
