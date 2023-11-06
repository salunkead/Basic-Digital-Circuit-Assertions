//assertion based verification of excess-3 code
//Design Module
module BCDtoExcess3(input [3:0]in,input enb,output reg [3:0]out);
  always_comb
    begin
      if(!enb)
        out=4'd0;
      else
        out=in+3;
    end
endmodule

//Property Module
module propertyM(input [3:0]in,input enb,input [3:0]out);
  always_comb
    begin
      if(!enb)
        begin
          assert final(out==0)
            $info("passed at t=%0t",$time);
        end
      else
        begin
          assert final(out==in+3)
            $info("passed at t=%0t",$time);
        end
    end
endmodule

//Testbench Module
module top;
  bit[3:0]in;
  bit enb;
  logic [3:0]out;
  BCDtoExcess3 dut(in,enb,out);
  bind BCDtoExcess3 propertyM ppt(.*);
  initial
    begin
      enb=0;
      #10;
      repeat(20)
        begin
          enb=1;
          in=$urandom_range(0,9);
          $strobe("in=%b and out=%b at t=%0t",in,out,$time);
          #10;
        end
    end
  initial
    begin
      $dumpfile("dump.vcd");
      $dumpvars(0,top.dut);
    end
endmodule
