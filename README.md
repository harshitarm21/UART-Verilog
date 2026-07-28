# UART Transmitter & Receiver (Verilog HDL)

A Universal Asynchronous Receiver Transmitter (UART) implemented in **Verilog HDL** for FPGA-based serial communication. The project includes both UART Transmitter (TX) and Receiver (RX) modules designed using a **Finite State Machine (FSM)** architecture and verified through RTL simulation in **AMD Vivado**.

---

## Features

- UART Transmitter (TX)
- UART Receiver (RX)
- FSM-based architecture
- Configurable baud-rate generation
- RTL simulation and functional verification
- Verilog HDL implementation

---

## Tools Used

- Verilog HDL
- AMD Vivado
- RTL Simulation

---

## Project Structure

```text
UART-Verilog
│
├── rtl/
│   ├── uart_tx.v
│   ├── uart_rx.v
│   
│
├── tb/
│   ├── tb_uart_tx.v
│   └── tb_uart_rx.v
│
├── waveforms/
│   ├── uart_tx_waveform.png
│   └── uart_rx_waveform.png
│
├── docs/
│   ├── uart_architecture.png
│   ├── uart_tx_fsm.png
│   └── uart_rx_fsm.png
│
└── README.md
```

---

## UART Frame Format

```text
| Start | D0 | D1 | D2 | D3 | D4 | D5 | D6 | D7 | Stop |
```

- 1 Start Bit
- 8 Data Bits
- 1 Stop Bit
- No Parity

---

## UART Transmitter

The transmitter converts 8-bit parallel data into a serial bit stream by transmitting:

- Start bit
- 8 data bits (LSB first)
- Stop bit

---

## UART Receiver

The receiver samples incoming serial data, reconstructs the transmitted byte, and asserts a receive-complete signal after successful reception.

---

## Simulation

The design has been functionally verified using RTL simulation in AMD Vivado.

Simulation verifies:

- UART frame generation
- Start bit detection
- Data transmission and reception
- Stop bit generation
- Baud-rate timing

---

## Applications

- FPGA Development
- Digital Communication Systems
- Embedded Systems
- RTL Design Practice
- FPGA Learning

---

## Future Improvements

- Configurable parity bit
- Variable data width
- FIFO buffering
- Parameterized UART module

---

## Author

**Harshita R M**

Electronics & Communication Engineering Student  
Interested in FPGA Design, RTL Design, Digital Design, and VLSI.
