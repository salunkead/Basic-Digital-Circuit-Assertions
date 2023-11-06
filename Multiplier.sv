//assertion based verification of multiplier
module multilpier(input [3:0]a,b,input clk,rst,output reg [7:0]y);
  always_ff@(posedge clk)
    begin
      if(rst)
        y<=8'd0;
      else
        begin
          y<=a*b;
        end
    end
endmodule

module propertyM(input [3:0]a,b,input clk,rst,input [7:0]y);
  property p;
    bit [3:0]a1,b1;
    (!rst,a1=a,b1=b)|=>(y==a1+b1);
  endproperty
  assert property(@(posedge clk)p)
    $info("passed at t=%0t",$time);
endmodule

//testbench
module top;
  bit clk,rst;
  bit [3:0]a,b;
  logic [7:0]y;
  multilpier dut(a,b,clk,rst,y);
  bind multilpier propertyM ppt(.*);
  always #5 clk=~clk;
  initial
    begin
      rst=1;
      repeat(2)@(negedge clk);
      rst=0;
      repeat(10)
        begin
          @(negedge clk);
          a=$urandom;
          b=$urandom;
        end
    end
  initial
    begin
      $dumpfile("dump.vcd");
      $dumpvars(0,top.dut);
      #200 $finish;
    end
endmodule
