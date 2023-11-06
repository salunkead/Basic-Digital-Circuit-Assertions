/*
Design a combinational circuit that converts 8421 to 2421
*/
//Design Module
module _8421to2421_codeConvertor(input [3:0]in,input enb,output reg [3:0]out);
  always_comb
    begin
      if(!enb)
        out=4'd0;
      else
        begin
          if(in<=4)
            out=in;
          else if(in>=5&&in<=9)
            out=in+6;
          else
            out=in-5;
        end
    end
endmodule

//Property Module
module propertyM(input [3:0]in,input enb,input[3:0]out);
  always_comb
    begin
      if(!enb)
        begin
          assert final(out==0)
            $info("passed at t=%0t",$time);
        end
      else
        begin
          if(in<=4)
            begin
              assert final(out==in)
                $info("passed at t=%0t",$time);
            end
          else if(in>=5&&in<=9)
            begin
              assert final(out==in+6)
                $info("passed at t=%0t",$time);
            end
          else
            begin
              assert final(out==in-5)
                $info("passed at t=%0t",$time);
            end
        end
    end
endmodule

//Testbench Module
module top;
  bit[3:0]in;
  bit enb;
  logic[3:0]out;
  _8421to2421_codeConvertor dut(in,enb,out);
  bind _8421to2421_codeConvertor propertyM ppt(.*);
  initial
    begin
      enb=0;
      #10;
      repeat(15)
        begin
          enb=1;
          in=$urandom;
          $strobe("in=%b out=%b",in,out);
          #10;
        end
    end
  initial
    begin
      $dumpfile("dump.vcd");
      $dumpvars(0,top.dut);
    end
endmodule
