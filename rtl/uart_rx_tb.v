//-----------------------------------------------------------------------------
// Module      : UART Receiver Testbench
// File        : tb_uart_rx.v
// Author      : Harshita R M
// Description :
//   Testbench for UART Receiver.
//   Generates a complete UART frame and verifies correct reception
//   through RTL simulation.
//-----------------------------------------------------------------------------

module uart_rx_tb;

    //--------------------------------------------------------------------------
    // Testbench Signals
    //--------------------------------------------------------------------------
    reg        clk;
    reg        rst;
    reg        rx;

    wire [7:0] rx_data;
    wire       rx_done;

    //--------------------------------------------------------------------------
    // DUT Instantiation
    //--------------------------------------------------------------------------
    uart_rx uut
    (
        .clk     (clk),
        .rst     (rst),
        .rx      (rx),
        .rx_data (rx_data),
        .rx_done (rx_done)
    );

    //--------------------------------------------------------------------------
    // Clock Generation (100 MHz)
    //--------------------------------------------------------------------------
    initial
        clk = 1'b0;

    always
        #5 clk = ~clk;

    //--------------------------------------------------------------------------
    // Test Sequence
    //--------------------------------------------------------------------------
    initial
    begin
        // Initialize signals
        rst = 1'b1;
        rx  = 1'b1;     // UART line is idle high

        // Release reset
        #20;
        rst = 1'b0;

        // Start bit
        #104170;
        rx = 1'b0;

        // Data bits (LSB first)
        #104170; rx = 1'b0;
        #104170; rx = 1'b1;
        #104170; rx = 1'b1;
        #104170; rx = 1'b0;
        #104170; rx = 1'b1;
        #104170; rx = 1'b0;
        #104170; rx = 1'b1;
        #104170; rx = 1'b1;

        // Stop bit
        #104170;
        rx = 1'b1;

        // Wait for reception to complete
        #200000;

        $finish;
    end

endmodule
