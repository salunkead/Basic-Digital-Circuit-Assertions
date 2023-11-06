//assertion based verification of johnson counter
//Design Module
module D_flipflop(input d,rst,clk,output reg q,output q_bar);
  always@(posedge clk)
    begin
      if(rst)
        q<=1'b0;
      else
        q<=d;
    end
  assign q_bar=~q;
endmodule

module johnson_counter(input clk,rst,output q0,q1,q2,q3);
  wire w,w0,w1,w2;
  D_flipflop f0(.d(w),.rst(rst),.clk(clk),.q(q0),.q_bar(w0));
  D_flipflop f1(.d(q0),.rst(rst),.clk(clk),.q(q1),.q_bar(w1));
  D_flipflop f2(.d(q1),.rst(rst),.clk(clk),.q(q2),.q_bar(w2));
  D_flipflop f3(.d(q2),.rst(rst),.clk(clk),.q(q3),.q_bar(w));
endmodule

//Property Module
module propertyM(input clk,rst,q0,q1,q2,q3);
  reg [2:0]c;
  always_ff@(posedge clk)
    begin
      if($fell(rst))
        begin
          c=0;
          reset:assert final({q0,q1,q2,q3}==4'b0000)
            $info("passed at t=%0t",$time);
        end
      else if(!rst)
        begin
          case(c)
            0:
              begin
                c++;
                c1:assert final({q0,q1,q2,q3}==4'b1000)
                  $info("passed at t=%0t",$time);
              end
            1:
              begin
                c++;
                c2:assert final({q0,q1,q2,q3}==4'b1100)
                  $info("passed at t=%0t",$time);
              end
            2:
              begin
                c++;
                c3:assert final({q0,q1,q2,q3}==4'b1110)
                  $info("passed at t=%0t",$time);
              end
            3:
              begin
                c++;
                c4:assert final({q0,q1,q2,q3}==4'b1111)
                  $info("passed at t=%0t",$time);
              end
            4:
              begin
                c++;
                c5:assert final({q0,q1,q2,q3}==4'b0111)
                  $info("passed at t=%0t",$time);
              end
            5:
              begin
                c++;
                c6:assert final({q0,q1,q2,q3}==4'b0011)
                  $info("passed at t=%0t",$time);
              end
            6:
              begin
                c++;
                c7:assert final({q0,q1,q2,q3}==4'b0001)
                  $info("passed at t=%0t",$time);
              end
            7:
              begin
                c++;
                c8:assert final({q0,q1,q2,q3}==4'b0000)
                  $info("passed at t=%0t",$time);
              end
          endcase
        end
    end
endmodule

//Testbench Module
module top;
  bit clk,rst;
  logic q0,q1,q2,q3;
  johnson_counter dut(clk,rst,q0,q1,q2,q3);
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
