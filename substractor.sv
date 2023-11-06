///assertion based verification of substractor
//Design Module
module substractor(input [3:0]a,b,input clk,rst,output reg [4:0]y);
  always_ff@(posedge clk)
    begin
      if(rst)
        y<=8'd0;
      else
        begin
          y<=a-b;
        end
    end
endmodule

//Property Module
module propertyM(input [3:0]a,b,input clk,rst,input [4:0]y);
  property p;
    bit [3:0]a1,b1;
    (!rst,a1=a,b1=b)|=>(y==a1-b1);
  endproperty
  assert property(@(posedge clk)p)
    $info("passed at t=%0t",$time);
endmodule

//Testbench Module
module top;
  bit clk,rst;
  bit [3:0]a,b;
  logic [4:0]y;
  substractor dut(a,b,clk,rst,y);
  bind substractor propertyM ppt(.*);
  always #5 clk=~clk;
  initial
    begin
      rst=1;
      repeat(2)@(negedge clk);
      rst=0;
      repeat(10)
        begin
          @(negedge clk);
          a=$urandom_range(20,31);
          b=$urandom_range(0,19);
        end
    end
  initial
    begin
      $dumpfile("dump.vcd");
      $dumpvars(0,top.dut);
      #200 $finish;
    end
endmodule
