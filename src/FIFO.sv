module FIFO(FIFO_if.DUT f_if);
  localparam max_fifo_addr = $clog2(f_if.FIFO_DEPTH);

  reg [f_if.FIFO_WIDTH-1:0] mem [f_if.FIFO_DEPTH-1:0];
  reg [max_fifo_addr-1:0] wr_ptr, rd_ptr;
  reg [max_fifo_addr:0] count;

  //write operation
  always @(posedge f_if.clk or negedge f_if.rst_n) begin
    if (!f_if.rst_n) begin
      wr_ptr <= 0;
      f_if.overflow <= 0; // reset overflow signal
      f_if.wr_ack <= 0; // reset wr_ack signal
    end
    else if (f_if.wr_en && count < f_if.FIFO_DEPTH) begin
      mem[wr_ptr] <= f_if.data_in;
      f_if.wr_ack <= 1;
      wr_ptr <= wr_ptr + 1;
    end
    else begin 
      f_if.wr_ack <= 0;
      if (f_if.full && f_if.wr_en)
        f_if.overflow <= 1;
      else
        f_if.overflow <= 0;
    end
  end
  
  //read operation
  always @(posedge f_if.clk or negedge f_if.rst_n) begin
    if (!f_if.rst_n) begin
      rd_ptr <= 0; 
      f_if.underflow <= 0; // reset underflow signal
    end
    else if (f_if.rd_en && count != 0) begin
      f_if.data_out <= mem[rd_ptr];
      rd_ptr <= rd_ptr + 1;
    end
    else begin
      if (f_if.empty && f_if.rd_en)  // make underflow signal sequential
        f_if.underflow <= 1;
      else
        f_if.underflow <= 0;
    end
  end
  // count operations
  always @(posedge f_if.clk or negedge f_if.rst_n) begin
    if (!f_if.rst_n) begin
      count <= 0;
    end
    else begin
      if ({f_if.wr_en, f_if.rd_en} == 2'b10 && !f_if.full) 
        count <= count + 1;
      else if ({f_if.wr_en, f_if.rd_en} == 2'b01 && !f_if.empty)
        count <= count - 1;
      else if ({f_if.wr_en, f_if.rd_en} == 2'b11 && f_if.full) // add unhandled case
        count <= count - 1;
      else if ({f_if.wr_en, f_if.rd_en} == 2'b11 && f_if.empty) // add unhandled case
        count <= count + 1;
    end
  end
  // flags operations
  assign f_if.full = (count == f_if.FIFO_DEPTH) ? 1 : 0;
  assign f_if.empty = (count == 0) ? 1 : 0;
  assign f_if.almostfull = (count == f_if.FIFO_DEPTH-1) ? 1 : 0; // modify the almostfull signal to match design specs
  assign f_if.almostempty = (count == 1) ? 1 : 0;
  
endmodule
