//assertion based verification of shift registers
//Design Module
module SISO(input in,clk,rst,output reg out);
  reg [3:0]reg1;
  always_ff@(posedge clk)
    begin
      if(rst)
        begin
          reg1=0;
          out=0;
        end
      else
        begin
          reg1=reg1>>1;
          out=reg1[0];
          reg1[3]=in;
        end
    end
endmodule

//Property Module
module propertyM(input in,clk,rst,out);
  bit [1:0]c;
  reg[3:0]reg1;
  initial
    begin
      repeat(4)@(negedge clk);
      for(int i=0;i<4;i++)
        begin
          @(posedge clk);
          reg1[i]=in;
        end
      $display("reg1=%b at t=%0t",reg1,$time);
    end
endmodule

//Testbench
module top;
  bit clk,rst,in;
  logic out;
  reg [3:0]r;
  SISO dut(in,clk,rst,out);
  bind SISO propertyM ppt(.*);
  always #5 clk=~clk;
  initial
    begin
      rst=1;
      in=0;
      repeat(2)@(negedge clk);
      rst=0;
      r=4'b1101;
      for(int i=0;i<$size(r);i++)
        begin
          @(negedge clk);
          in=r[i];
        end
      @(negedge clk);
      in=0;
    end
  initial
    begin
      $dumpfile("dump.vcd");
      $dumpvars(0,top.dut);
      #200 $finish;
    end
endmodule
