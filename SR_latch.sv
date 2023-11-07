//assertion based verification of sr latch
//Design Module
module SR_latch(input s,r,clock_pulse,output reg q,q_bar);
  always_latch
    begin
      if(clock_pulse&&!s&&r)
        begin
          q=1'b0;
          q_bar=1'b1;
        end
      else if(clock_pulse&&s&&!r)
        begin
          q=1'b1;
          q_bar=1'b0;
        end
      else if(clock_pulse&&s&&r)
        begin
          q=1'bx;
          q_bar=1'bx;
        end
    end
endmodule

//Property Module
module propertyM(input s,r,clock_pulse,input q,q_bar);
  reg t1,t2;
  always_latch
    begin
      if(!clock_pulse)
        begin
          t1=q;
          h0:assert final(q==t2&&q_bar==!q)
            $info("passed at t=%0t",$time);
        end
      else
        begin
          case({s,r})
            2'b00:
              begin
                h1:assert final(q==t1&&q_bar==!q)
                  $info("passed at t=%0t",$time);
              end
            2'b01:
              begin
                reset:assert final(q==1'b0&&q_bar==!q)
                  $info("passed at t=%0t",$time);
              end
            2'b10:
              begin
                set:assert final(q==1'b1&&q_bar==!q)
                  $info("passed at t=%0t",$time);
              end
            2'b11:
              begin
                unknown:assert final($isunknown(q)&&$isunknown(q_bar))
                  $info("passed at t=%0t",$time);
              end
          endcase
          t2=q;
        end
    end
endmodule

//Testbench Module
module top;
  bit s,r,clock_pulse;
  logic q,q_bar;
  SR_latch dut(s,r,clock_pulse,q,q_bar);
  bind SR_latch propertyM ppt(.*);
  always #5 clock_pulse=~clock_pulse;
  initial
    begin
      repeat(20)
        begin
          s=$random;
          r=$random;
          #10;
        end
    end
  initial
    begin
      $dumpfile("dump.vcd");
      $dumpvars(0,top.dut);
      #200 $finish;
    end
endmodule
