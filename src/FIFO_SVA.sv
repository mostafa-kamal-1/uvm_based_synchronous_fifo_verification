module FIFO_SVA(FIFO_if.DUT f_if);

// reset asseration 
always_comb begin
if(!f_if.rst_n) begin
reset_assert: assert final(!DUT.wr_ptr && !DUT.rd_ptr && !DUT.count);
reset_cover: cover final(!DUT.wr_ptr && !DUT.rd_ptr && !DUT.count);
end
end
//immediate asserations
always_comb begin
//full
if(f_if.rst_n && (DUT.count== f_if.FIFO_DEPTH)) begin
full_flag_assert: assert final(f_if.full && !f_if.empty && !f_if.almostempty && !f_if.almostfull);
full_flag_cover: cover final(f_if.full && !f_if.empty && !f_if.almostempty && !f_if.almostfull);
end
//almostfull
if(f_if.rst_n && (DUT.count== f_if.FIFO_DEPTH-1)) begin
almostfull_flag_assert: assert final(f_if.almostfull && !f_if.empty && !f_if.almostempty && !f_if.full);  
almostfull_flag_cover: cover final(f_if.almostfull && !f_if.empty && !f_if.almostempty && !f_if.full);
end
//empty
if(f_if.rst_n && (DUT.count== 0)) begin
empty_flag_assert: assert final(f_if.empty && !f_if.almostempty && !f_if.full && !f_if.almostfull);
empty_flag_acover: cover final(f_if.empty && !f_if.almostempty && !f_if.full && !f_if.almostfull);
end
//almostempty
if(f_if.rst_n && (DUT.count== 1)) begin
almostempty_flag_assert: assert final(f_if.almostempty && !f_if.empty && !f_if.full && !f_if.almostfull);
almostempty_flag_cover: cover final(f_if.almostempty && !f_if.empty && !f_if.full && !f_if.almostfull);
end
end

//concurrent assertions
//overflow
 property overflow_flag;
 @(posedge f_if.clk) disable iff(!f_if.rst_n) (f_if.full && f_if.wr_en) |=> f_if.overflow;
 endproperty
 overflow_flag_assert: assert property(overflow_flag);
 overflow_flag_cover: cover property(overflow_flag);
//underflow
 property underflow_flag;
 @(posedge f_if.clk) disable iff(!f_if.rst_n) (f_if.empty && f_if.rd_en) |=> f_if.underflow;
 endproperty
 underflow_flag_assert: assert property(underflow_flag);
 underflow_flag_cover: cover property(underflow_flag);
//wr_ack_high
 property wr_ack_high;
 @(posedge f_if.clk) disable iff(!f_if.rst_n) (f_if.wr_en && DUT.count< f_if.FIFO_DEPTH) |=> f_if.wr_ack;
 endproperty
 wr_ack_high_flag_assert: assert property(wr_ack_high);
 wr_ack_high_flag_cover: cover property(wr_ack_high);
//wr_ack_high
 property wr_ack_low;
 @(posedge f_if.clk) disable iff(!f_if.rst_n) (f_if.wr_en && f_if.full) |=> !f_if.wr_ack;
 endproperty
 wr_ack_low_flag_assert: assert property(wr_ack_low);
 wr_ack_low_flag_cover: cover property(wr_ack_low);
//write
 property write_op;
 @(posedge f_if.clk) disable iff(!f_if.rst_n) (f_if.wr_en && !f_if.rd_en && !f_if.full) |=> $past(DUT.count+ 1'b1);
 endproperty
 write_op_assert: assert property(write_op);
 write_op_cover: cover property(write_op);
//read
 property read_op;
 @(posedge f_if.clk) disable iff(!f_if.rst_n) (!f_if.wr_en && f_if.rd_en && !f_if.empty) |=> (DUT.count+ 1'b1);
 endproperty
 read_op_assert: assert property(read_op);
 read_op_cover: cover property(read_op);
//write priority
 property write_pri;
 @(posedge f_if.clk) disable iff(!f_if.rst_n) (f_if.wr_en && f_if.rd_en && f_if.full) |=> (DUT.count+ 1'b1);
 endproperty
 write_pri_assert: assert property(write_pri);
 write_pri_cover: cover property(write_pri);
//read priority
 property read_pri;
 @(posedge f_if.clk) disable iff(!f_if.rst_n) (f_if.wr_en && f_if.rd_en && f_if.empty) |=> $past(DUT.count+ 1'b1);
 endproperty
 read_pri_assert: assert property(read_pri);
 read_pri_cover: cover property(read_pri);
// read pointer
 property read_ptr;
 @(posedge f_if.clk) disable iff (!f_if.rst_n) (f_if.rd_en && (DUT.count != 0)) |=> (DUT.rd_ptr == ($past(DUT.rd_ptr) + 1) % f_if.FIFO_DEPTH);
 endproperty
 read_ptr_assert: assert property(read_ptr);
 read_ptr_cover: cover property(read_ptr);
// write pointer
 property write_ptr;
 @(posedge f_if.clk) disable iff (!f_if.rst_n) (f_if.wr_en && (DUT.count < f_if.FIFO_DEPTH)) |=> (DUT.wr_ptr == ($past(DUT.wr_ptr) + 1) % f_if.FIFO_DEPTH);
 endproperty
 write_ptr_assert: assert property(write_ptr);
 write_ptr_cover: cover property(write_ptr);

endmodule

