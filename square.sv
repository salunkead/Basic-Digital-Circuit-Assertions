/*
Design a combinational circuit with three inputs and six outputs. The output binary num-
ber should be the square of the input binary number.
*/
//Design Module
module squre(input [2:0]in,input enb,output reg [5:0]out);
  always_comb
    begin
      if(!enb)
        out=6'd0;
      else
        out=in**2;
    end
endmodule

//Property Module
module propertyM(input [2:0]in,input enb,input[5:0]out);
  always_comb
    begin
      if(!enb)
        begin
          assert final(out==0)
            $info("passed at t=%0t",$time);
        end
      else
        begin
          assert final(out==in**2)
            $info("passed at t=%0t",$time);
        end
    end
endmodule

///Testbench Module
module top;
  bit [2:0]in;
  bit enb;
  logic[5:0]out;
  squre dut(in,enb,out);
  bind squre propertyM ppt(.*);
  initial
    begin
      enb=0;
      #10;
      repeat(10)
        begin
          in=$urandom;
          enb=1;
          #10;
        end
    end
  initial
    begin
      $dumpfile("dump.vcd");
      $dumpvars(0,top.dut);
    end
endmodule
