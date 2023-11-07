////assertion based verification of 8 to 3 priority encoder
//Design Module
module eight2three_priority_encoder(input [7:0]in,
                                    output reg [2:0]out,output reg valid);
  always@(*)
    begin
      if(in[7])
        begin
          out=3'd7;
          valid=1;
        end
      else if(in[6])
        begin
          out=3'd6;
          valid=1;
        end
      else if(in[5])
        begin
          out=3'd5;
          valid=1;
        end
      else if(in[4])
        begin
          out=3'd4;
          valid=1;
        end
      else if(in[3])
        begin
          out=3'd3;
          valid=1;
        end
      else if(in[2])
        begin
          out=3'd2;
          valid=1;
        end
      else if(in[1])
        begin
          out=3'd1;
          valid=1;
        end
      else if(in[0])
        begin
          out=3'd0;
          valid=1;
        end
      else
        begin
          out=3'd0;
          valid=0;
        end
    end
endmodule

//Property Module
module priorityM(input [7:0]in,input [2:0]out,input valid);
  always_comb
    begin
      if(in[7])
        begin
          assert final(out==3'd7 && valid==1)
            $info("passed at t=%0t",$time);
          else
            $error("failed at t=%0t",$time);
        end
      else if(in[6])
        begin
          assert final(out==3'd6 && valid==1)
            $info("passed at t=%0t",$time);
          else
            $error("failed at t=%0t",$time);
        end
      else if(in[5])
        begin
          assert final(out==3'd5 && valid==1)
            $info("passed at t=%0t",$time);
          else
            $error("failed at t=%0t",$time);
        end
      else if(in[4])
        begin
          assert final(out==3'd4 && valid==1)
            $info("passed at t=%0t",$time);
          else
            $error("failed at t=%0t",$time);
        end
      else if(in[3])
        begin
          assert final(out==3'd3 && valid==1)
            $info("passed at t=%0t",$time);
          else
            $error("failed at t=%0t",$time);
        end
      else if(in[2])
        begin
          assert final(out==3'd2 && valid==1)
            $info("passed at t=%0t",$time);
          else
            $error("failed at t=%0t",$time);
        end
      else if(in[1])
        begin
          assert final(out==3'd1 && valid==1)
            $info("passed at t=%0t",$time);
          else
            $error("failed at t=%0t",$time);
        end
      else if(in[0])
        begin
          assert final(out==3'd0 && valid==1)
            $info("passed at t=%0t",$time);
          else
            $error("failed at t=%0t",$time);
        end
      else
        begin
          assert final(out==3'd0 && valid==0)
            $info("passed at t=%0t",$time);
          else
            $error("failed at t=%0t",$time);
        end
    end
  
endmodule

//////////testbench for eight to three priority endcoder
module top;
  bit [7:0]in;
  logic [2:0]out;
  logic valid;
  eight2three_priority_encoder dut(in,out,valid);
  bind eight2three_priority_encoder priorityM ppt(.*);
  initial
    begin
      in=0;
      #10;
      repeat(10)
        begin
          in=$urandom;
          #20;
        end
    end
  initial
    begin
      $dumpfile("lab1.vcd");
      $dumpvars(0,top.dut);
    end
endmodule
