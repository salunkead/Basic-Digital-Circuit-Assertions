//assertion based verification of D flip flop
//Design Module
module D_flipflop(input d,rst,clk,output reg q,output q_bar);
  always@(posedge clk)
    begin
      if(rst)
        q<=1'b0;
      else
        q<=d;
    end
  assign q_bar=~q;
endmodule

//Property Module
module propertyM(input d,rst,clk,q,q_bar);
  default clocking@(posedge clk);
  endclocking
  ///reset
  assert property(rst |=>(q==0&&q_bar==1))
    $info("passed at t=%0t",$time);
  else
    $error("failed at t=%0t",$time);
  //d-input
    assert property(disable iff(rst) d|=>(q==1 && q_bar==0))
      $info("passed at t=%0t",$time);
    else
      $error("failed at t=%0t",$time);
      
  //
      assert property(disable iff(rst) !d|=>(q==0 && q_bar==1))
      $info("passed at t=%0t",$time);
    else
      $error("failed at t=%0t",$time);
endmodule


//testbench
`define c @(posedge clk)
module top;
  bit d,clk,rst;
  logic q,q_bar;
  D_flipflop dut(d,rst,clk,q,q_bar);
  bind D_flipflop propertyM ppt(.*);
  always #5 clk=~clk;
  initial
    begin
      rst=1;
      repeat(2)`c;
      rst=0;
      repeat(20)
        begin
          `c;
          d=$urandom;
        end
    end
  initial
    begin
      $dumpfile("lab4.vcd");
      $dumpvars(0,top.dut);
      #200 $finish;
    end
endmodule
