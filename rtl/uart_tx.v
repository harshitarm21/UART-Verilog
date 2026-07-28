//-----------------------------------------------------------------------------
// Module      : UART Transmitter
// File        : uart_tx.v
// Author      : Harshita R M
// Description :
//   UART Transmitter implemented in Verilog HDL.
//   Transmits 8-bit parallel data serially using UART protocol.
//   FSM States: IDLE -> START -> DATA -> STOP
//-----------------------------------------------------------------------------

module uart_tx(
    input  wire       clk,
    input  wire       rst,
    input  wire       tx_start,
    input  wire [7:0] tx_data,
    input  wire       baud_tick,

    output reg        tx,
    output reg        busy
);

    //--------------------------------------------------------------------------
    // State Encoding
    //--------------------------------------------------------------------------
    localparam IDLE  = 2'b00;   // Idle state
    localparam START = 2'b01;   // Transmit start bit
    localparam DATA  = 2'b10;   // Transmit data bits
    localparam STOP  = 2'b11;   // Transmit stop bit

    //--------------------------------------------------------------------------
    // Internal Registers
    //--------------------------------------------------------------------------
    reg [1:0] state;
    reg [7:0] data_reg;
    reg [2:0] bit_count;

    //--------------------------------------------------------------------------
    // UART Transmitter FSM
    //--------------------------------------------------------------------------
    always @(posedge clk)
    begin
        // Synchronous Reset
        if (rst)
        begin
            tx        <= 1'b1;
            busy      <= 1'b0;
            state     <= IDLE;
            data_reg  <= 8'd0;
            bit_count <= 3'd0;
        end

        else
        begin
            case (state)

                //--------------------------------------------------------------
                // Idle State
                //--------------------------------------------------------------
                IDLE:
                begin
                    tx   <= 1'b1;
                    busy <= 1'b0;

                    if (tx_start)
                    begin
                        data_reg  <= tx_data;
                        bit_count <= 3'd0;
                        busy      <= 1'b1;
                        state     <= START;
                    end
                end

                //--------------------------------------------------------------
                // Start Bit
                //--------------------------------------------------------------
                START:
                begin
                    tx   <= 1'b0;
                    busy <= 1'b1;

                    if (baud_tick)
                        state <= DATA;
                end

                //--------------------------------------------------------------
                // Data Transmission
                //--------------------------------------------------------------
                DATA:
                begin
                    busy <= 1'b1;

                    // Transmit current data bit (LSB first)
                    tx <= data_reg[bit_count];

                    if (baud_tick)
                    begin
                        if (bit_count == 3'd7)
                            state <= STOP;
                        else
                            bit_count <= bit_count + 1'b1;
                    end
                end

                //--------------------------------------------------------------
                // Stop Bit
                //--------------------------------------------------------------
                STOP:
                begin
                    tx   <= 1'b1;
                    busy <= 1'b1;

                    if (baud_tick)
                    begin
                        busy  <= 1'b0;
                        state <= IDLE;
                    end
                end

                //--------------------------------------------------------------
                // Default State
                //--------------------------------------------------------------
                default:
                begin
                    state <= IDLE;
                    tx    <= 1'b1;
                    busy  <= 1'b0;
                end

            endcase
        end
    end

endmodule
