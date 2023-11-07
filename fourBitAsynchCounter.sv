//assertion based verification of 4 bit asynchronous counter
//Design Module
module T_flipflop(input t,rst,clk,output bit q,output q_bar);
  always_ff@(posedge clk)
    begin
      if(rst)
        q<=1'b0;
      else
        begin
          if(t)
            q<=~q;
          else
            q<=q;
        end
    end
  assign q_bar=~q;
endmodule
module asynch_4bit_counter(input clk,rst,output [3:0]q,q_bar);
  T_flipflop t0(1'b1,rst,clk,q[0],q_bar[0]);
  T_flipflop t1(1'b1,1'b0,q[0],q[1],q_bar[1]);
  T_flipflop t2(1'b1,1'b0,q[1],q[2],q_bar[2]);
  T_flipflop t3(1'b1,1'b0,q[2],q[3],q_bar[3]);
endmodule

//Property Module
module propertyM(input clk,rst,input [3:0]q,q_bar);
  property p;
    @(posedge clk)
    (!rst&&q!=4'hf&&q!=0)|=>(q==$past(q)-1)
  endproperty
  rest:assert property(disable iff(rst)p)
    $info("passed at t=%0t",$time);
    init:assert property(disable iff(rst)@(posedge clk)q==0|=>q==4'hf)
      $info("passed at t=%0t",$time);
endmodule

//Testbench Module
module top;
  bit clk,rst;
  logic [3:0]q,q_bar;
  asynch_4bit_counter  dut(clk,rst, q,q_bar);
  bind asynch_4bit_counter propertyM ppt(.*);
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
