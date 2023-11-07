///assertion based verification of t flip flop
//Design Module
module T_flipflop(input t,rst,clk,output reg q,output q_bar);
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

//Property Module
module propertyM(input t,rst,clk,q,q_bar);
  ///reset
  reset:assert property(@(posedge clk)rst |=>(q==0&&q_bar==1))
    $info("passed at t=%0t",$time);
  else
    $error("failed at t=%0t",$time);
    
    hold:assert property(@(posedge clk)(!t&&!rst)|=>(q==$past(q)&&q_bar==~q))
      $info("passed at t=%0t",$time);
      
      toggle:assert property(@(posedge clk)(t&&!rst)|=>(q==~$past(q)&&q_bar==~q))
        $info("passed at t=%0t",$time);
endmodule

//testbench
`define c @(posedge clk)
module top;
  reg t,clk,rst;
  wire q,q_bar;
  T_flipflop dut(t,rst,clk,q,q_bar);
  bind T_flipflop propertyM ppt(.*);
  initial clk=0;
  always #5 clk=~clk;
  initial
    begin
      rst=1;
      repeat(2)`c;
      rst=0;
      repeat(20)
        begin
          `c;
          t=$random;
        end
    end
  
  initial
    begin
      $dumpfile("lab4.vcd");
      $dumpvars(0,top.dut);
      #200 $finish;
    end
endmodule
