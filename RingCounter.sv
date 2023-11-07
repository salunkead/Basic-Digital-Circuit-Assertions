//assertion based verification of ring counter
//Design Module
module RingCounter(input rst,clk,preset,output reg [3:0]out);
  reg [3:0]reg1;
  reg temp;
  always_ff@(posedge clk)
    begin
      if(rst)
        begin
          out=4'd0;
          reg1=4'd0;
        end
      else
        begin
          if(preset)
            begin
              reg1[0]=1'b1;
              out=reg1;
            end
          else
            begin
              temp=reg1[0];
              reg1=reg1>>1;
              reg1[3]=temp;
              out=reg1;
            end
        end
    end
endmodule

//Property Module
module propertyM(input rst,clk,preset,input [3:0]out);
  always_ff@(posedge clk)
    begin
      if($fell(preset)&&!rst)
        begin
          prset:assert final(out[0]==1'b1)$info("passed at t=%0t",$time);
        end
      else if(!preset&&!rst&&out!=8)
        begin
          work:assert  final(out==$past(out)>>1)$info("passed at t=%0t",$time);
        end
    end
endmodule

//testbench 
module top;
  bit rst,clk,preset;
  logic [3:0]out;
  RingCounter dut(rst,clk,preset,out);
  bind RingCounter propertyM ppt(.*);
  always #5 clk=~clk;
  initial
    begin
      rst=1;
      repeat(2)@(negedge clk);
      rst=0;
      preset=1;
      @(negedge clk);
      preset=0;
    end
  initial
    begin
      $dumpfile("dump.vcd");
      $dumpvars;
      #100 $finish;
    end
endmodule
