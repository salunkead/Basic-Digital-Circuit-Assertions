////assertion based verification of 4 to 1 mux 
//Design Module
module four2one_mux(input [3:0]in,input [1:0]s,output reg y);
  always@(*)
    begin
      case(s)
        2'd0:y=in[0];
        2'd1:y=in[1];
        2'd2:y=in[2];
        2'd3:y=in[3];
      endcase
    end
endmodule

//Property Module
module propertyM(input [3:0]in,input [1:0]s,input y);
  always_comb
    begin
      case(s)
        2'd0:
          begin
            assert final(y==in[0])
              $info("passed at t=%0t",$time);
            else
              $error("failed at t=%0t",$time);
          end
        2'd1:begin
          assert final(y==in[1])
              $info("passed at t=%0t",$time);
            else
              $error("failed at t=%0t",$time);
        end
        2'd2:
          begin
            assert final(y==in[2])
              $info("passed at t=%0t",$time);
            else
              $error("failed at t=%0t",$time);
          end
        2'd3:
          begin
            assert final(y==in[3])
              $info("passed at t=%0t",$time);
            else
              $error("failed at t=%0t",$time);
          end
      endcase
    end
endmodule

//testbench for four to one mux
module top;
  bit [3:0]in;
  bit[1:0]s;
  logic y;
  four2one_mux dut(in,s,y);
  bind four2one_mux propertyM ppt(.*);
  initial
    begin
      repeat(20)
        begin
          in=$urandom;
          s=$urandom;
          #20;
        end
    end
  initial
    begin
      $dumpfile("lab1.vcd");
      $dumpvars(0,top.dut);
    end
endmodule
