//assertion based verification of 1 by 4 demultiplexer
module Demultiplexer(input din,s1,s0,output reg y0,y1,y2,y3);
  always_comb
    begin
      case({s1,s0})
        2'd0:
          begin
            y0=din;
            {y1,y2,y3}=3'b000;
          end
        2'd1:
          begin
            y1=din;
            {y0,y2,y3}=3'b000;
          end
        2'd2:
          begin
            y2=din;
            {y0,y1,y3}=3'b000;
          end
        2'd3:
          begin
            y3=din;
            {y0,y1,y2}=3'b000;
          end
        default:{y0,y1,y2,y3}=0;
      endcase
    end
endmodule

//assertion module
module propertyM(input din,s1,s0,y0,y1,y2,y3);
  always_comb
    begin
      case({s1,s0})
        2'd0:
          begin
            assert final(y0==din&&{y1,y2,y3}==0)
              $info("passed at t=%0t",$time);
          end
        2'd1:
          begin
            assert final(y1==din&&{y0,y2,y3}==0)
              $info("passed at t=%0t",$time);
          end
        2'd2:
          begin
            assert final(y2==din&&{y0,y1,y3}==0)
              $info("passed at t=%0t",$time);
          end
        2'd3:
          begin
            assert final(y3==din&&{y0,y1,y2}==0)
              $info("passed at t=%0t",$time);
          end
      endcase
    end
endmodule

//testbench module
module top;
  bit din,s1,s0;
  logic y0,y1,y2,y3;
  Demultiplexer dut(din,s1,s0,y0,y1,y2,y3);
  bind Demultiplexer propertyM p(.*);
  initial
    begin
      repeat(20)
        begin
          {s1,s0}=$urandom;
          din=$random;
          #20;
        end
    end
  initial
    begin
      $dumpfile("dump.vcd");
      $dumpvars(0,top.dut);
    end
endmodule
