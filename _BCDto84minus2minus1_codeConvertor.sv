//Design a combinational circuit that converts BCD to 84-2-1'

//Design Module
module _BCDto84minus2minus1_codeConvertor(input [3:0]in,input enb,output reg [3:0]out);
  always_comb
    begin
      if(!enb)
        out=4'd0;
      else
        begin
          if(in==0)
            out=4'd0;
          else if(in>=1&&in<=4)
            out=8-in;
          else if(in>=5&&in<=8)
            out=16-in;
          else
            out=15;
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
          if(in==0)
            begin
              assert final(out==0)
                $info("passed at t=%0t",$time);
            end
          else if(in>=1&&in<=4)
            begin
              assert final(out==8-in)
                $info("passed at t=%0t",$time);
            end
          else if(in>=5&&in<=8)
            begin
              assert final(out==16-in)
                $info("passed at t=%0t",$time);
            end
          else
            begin
              assert final(out==15)
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
  _BCDto84minus2minus1_codeConvertor dut(in,enb,out);
  bind  _BCDto84minus2minus1_codeConvertor propertyM ppt(.*);
  initial
    begin
      enb=0;
      #10;
      repeat(15)
        begin
          enb=1;
          in=$urandom_range(0,9);
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
