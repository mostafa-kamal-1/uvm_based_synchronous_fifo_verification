# 🚀 uvm_based_synchronous_fifo_verification
A UVM-based verification environment for a configurable Synchronous FIFO, featuring comprehensive functional and code coverage, detailed test sequences, and assertions.

Welcome to the **UVM Synchronous FIFO** project! This project enhances a traditional Synchronous FIFO design by incorporating the power of the **Universal Verification Methodology (UVM)**. Whether you’re a verification expert or new to digital design, this repository showcases the journey of building, testing, and verifying a highly configurable FIFO module.

## 🌟 Project Overview
This project extends a standard **Synchronous FIFO** module with a full-fledged UVM-based verification environment. The goal is to achieve **100% functional, code, and sequential coverage** through well-structured test sequences, assertions, and constrained random stimulus generation.

We don’t just test the FIFO—we put it through its paces, ensuring it performs flawlessly in all scenarios!

## 📁 Directory Structure

```plaintext
/project_root
│
├── /src                
│   ├── FIFO.sv
│   ├── Original_FIFO_Before_Bugs_Detection.sv
│   ├── FIFO_SVA.sv
│   └── FIFO_if.sv
│
├── /UVM Testbench              
│   ├── FIFO_env.sv
│   ├── FIFO_agent.sv
│   ├── FIFO_driver.sv
│   ├── FIFO_seq_item.sv
│   ├── FIFO_monitor.sv
│   ├── FIFO_scoreboard.sv
│   ├── FIFO_coverage.sv
│   ├── FIFO_sequencer.sv
│   ├── FIFO_config.sv
│   ├── FIFO_test.sv
│   └── FIFO_top.sv
│
├── /sequences          
│   ├── FIFO_reset_sequence.sv
│   ├── FIFO_write_read_sequence.sv
│   ├── FIFO_write_then_read_sequence.sv
│   ├── FIFO_write_only_sequence.sv
│   ├── FIFO_read_only_sequence.sv
│   ├── FIFO_full_sequence.sv
│   └── FIFO_empty_sequence.sv
│
│
├── /docs              
│   ├── README.md
│   ├── UVM FIFO Project.pdf
│   ├── sim.txt
│   └── FIFO verification Plan.pdf
│
├── /scripts            
│   ├── run.do
│   └── file_list.txt
│
└── /reports            
    └── FIFO_coverage_rpt.log
```

## 🔧 Parameters
- **FIFO_WIDTH**: The width of the data input/output bus, defaulting to 16 bits.
- **FIFO_DEPTH**: The depth of the memory array, defaulting to 8 words.

These parameters make the FIFO highly flexible for different system requirements.

## 📚 Ports and Signals
Our FIFO design is equipped with the following ports:

| Port Name    | Direction | Description                                                                                             |
|--------------|-----------|---------------------------------------------------------------------------------------------------------|
| `data_in`    | Input     | Data input bus for writing to the FIFO.                                                                  |
| `wr_en`      | Input     | Write Enable: Writes data to the FIFO if it’s not full.                                                   |
| `rd_en`      | Input     | Read Enable: Reads data from the FIFO if it’s not empty.                                                  |
| `clk`        | Input     | Clock signal to synchronize operations.                                                                  |
| `rst_n`      | Input     | Asynchronous reset (active low).                                                                         |
| `data_out`   | Output    | Data output bus for reading from the FIFO.                                                               |
| `full`       | Output    | Full flag: Asserted when the FIFO is full, preventing further writes.                                     |
| `almostfull` | Output    | Almost full flag: Warning that only one more write can be performed before the FIFO is full.              |
| `empty`      | Output    | Empty flag: Asserted when the FIFO is empty, preventing further reads.                                    |
| `almostempty`| Output    | Warning that only one more read can be performed before the FIFO is empty.                                |
| `overflow`   | Output    | Indicates an attempt to write when the FIFO is full.                                                      |
| `underflow`  | Output    | Indicates an attempt to read when the FIFO is empty.                                                      |
| `wr_ack`     | Output    | Write Acknowledge: Asserted when a write operation is successfully performed.                             |

## ⚙️ UVM Testbench Magic
Our UVM environment isn’t just any testbench—it’s a **verification powerhouse**. With modular components, constrained random stimulus generation, and automatic coverage tracking, we leave no stone unturned. Here's what you'll find:

### 🚀 Sequences to Push the Limits:
We’ve divided our tests into specialized sequences, each designed to stress-test the FIFO:
- **write_only_sequence**: Tests continuous writes to the FIFO, ensuring the `full` condition is handled.
- **read_only_sequence**: Drains the FIFO with continuous read operations, testing the `empty` condition.
- **write_read_sequence**: Performs simultaneous writes and reads to validate the core FIFO functionality.
- **write_then_read_sequence**: Forces the FIFO into the full state then Drains the FIFO with continuous read operations.
- **full_sequence**: Forces the FIFO into the full state and validates `overflow` behavior.
- **empty_sequence**: Empties the FIFO and checks the handling of the `underflow` condition.

### 🛠 Constraints and Assertions:
- **Constrained Randomization**: Our UVM testbench adds constraints to ensure meaningful test scenarios.
- **Assertions**: We’ve added various assertions to catch design misbehavior. Example:
  ```systemverilog
  // Ensure overflow is asserted when the FIFO is full and wr_en is high
  @(posedge f_if.clk) disable iff(!f_if.rst_n) (f_if.full && f_if.wr_en) |=> f_if.overflow;
  ```

### 📊 Coverage Like a Pro:
We aren’t just checking functionality—we’re ensuring exhaustive coverage:
- **Functional Coverage**: We cross `wr_en`, `rd_en`, and other FIFO control signals to ensure all combinations are covered.
- **Code Coverage**: Aiming for 100% RTL code coverage.
- **Sequential Domain Coverage**: Our assertions also ensure that no sequential logic bugs slip through.

## 🔍 Understanding the UVM Flow
Here’s a quick overview of how the UVM environment operates:
1. **Top-level UVM Test**: Generates sequences and manages the test flow.
2. **Driver**: Drives input stimuli into the FIFO design.
3. **Monitor**: Observes the interface signals and passes them to the scoreboard and coverage blocks.
4. **Scoreboard**: Compares actual vs. expected outputs.
5. **Coverage Collector**: Tracks functional coverage and ensures all test scenarios are exercised.

## 🛠 How to Run the Simulation
Running the simulation is simple! Use the provided `Do file` to run the tests in QuestaSim. The script will:
- Compile the design and testbench.
- Run the simulation.
- Generate the coverage reports and simulation logs.

## 🚨 Bug Tracking and Reports
The project includes detailed reports on:
- **Bugs**: Any issues found during verification.
- **Coverage**: Reports on code coverage, functional coverage, and assertion coverage.
- **Results**: Summaries of test cases and their pass/fail status.



