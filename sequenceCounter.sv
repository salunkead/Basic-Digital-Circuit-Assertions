/*
Design a counter with the following repeated binary sequence: 0,1,3,7,6,4
*/
//0,1,3,7,6,4

//Design Module
module counter(input clk,rst,output reg [2:0]out);
  typedef enum bit[2:0]{s0,s1,s3,s7,s6,s4}state_type;
  state_type present_state,next_state;
  always_ff@(posedge clk)
    begin
      if(rst)
        begin
          present_state<=s0;
        end
      else
        present_state<=next_state;
    end
  always_comb
    begin
      case(present_state)
        s0:
          begin
            out=3'd0;
            next_state=s1;
          end
        s1:
          begin
            out=3'd1;
            next_state=s3;
          end
        s3:
          begin
            out=3'd3;
            next_state=s7;
          end
        s7:
          begin
            out=3'd7;
            next_state=s6;
          end
        s6:
          begin
            out=3'd6;
            next_state=s4;
          end
        s4:
          begin
            out=3'd4;
            next_state=s0;
          end
        default:
          begin
            out=3'd0;
            next_state=s0;
          end
      endcase
    end
endmodule

//Assertion Module
module propertyM(input clk,rst,input [2:0]out);
  int states[6]='{0,1,3,7,6,4};
  int i;
  always_ff@(posedge clk)
    begin
      if(rst)
        begin
          reset:assert final(out==3'd0)
            $info("passed at t=%0t",$time);
        end
      else
        begin
          if(i<=5)
            begin
              state:assert final(out==states[i])
                $info("passed at t=%0t",$time);
              i++;
              if(i==6)
                i=0;
            end
        end
    end
endmodule

//Testbench Module
module top;
  bit clk,rst;
  logic [2:0]out;
  counter dut(clk,rst,out);
  always #5 clk=~clk;
  initial
    begin
      rst=1;
      @(negedge clk);
      rst=0;
    end
  initial
    begin
      $dumpfile("dump.vcd");
      $dumpvars(0,top.dut);
      #200 $finish;
    end
endmodule
