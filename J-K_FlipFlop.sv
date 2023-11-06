///assertion based verification of j-k flip flop
//Design Module
module jk_ff(input j,k,clk,rst,output reg q,output q_bar);
  always@(posedge clk)
    begin
      if(rst)
        q<=1'b0;
      else
        begin
          case({j,k})
            2'b00:q<=q;
            2'b01:q<=1'b0;
            2'b10:q<=1'b1;
            2'b11:q<=~q;
          endcase
        end
    end
  assign q_bar=~q;
endmodule

//Property Module
module propertyM(input j,k,clk,rst,q,q_bar);
  default clocking@(posedge clk);
  endclocking
  //for rst
  reset:assert property(rst|=>!q&&q_bar)
      $info("passed at t=%0t",$time);
    else
      $error("failed at t=%0t",$time);
  //hold previous state
    hold:assert property(disable iff(rst){j,k}==2'b00|=>(q==$past(q)&&q_bar==~q))
      $info("passed at t=%0t",$time);
      else
        $error("failed at t=%0t",$time);
   //reset state
      reset_state:assert property(disable iff(rst){j,k}==2'b01|=>(q==0 && q_bar==~q))
        $info("passed at t=%0t",$time);
        else
          $error("failed at t=%0t",$time);
        
   //set state
        set_state:assert property(disable iff(rst){j,k}==2'b10|=>(q==1 && q_bar==~q))
        $info("passed at t=%0t",$time);
        else
          $error("failed at t=%0t",$time);
        
          
     ///toggel state
          
          toggle_state:assert property(disable iff(rst){j,k}==2'b11|=>(q==~$past(q) && q_bar==~q))
        $info("passed at t=%0t",$time);
        else
          $error("failed at t=%0t",$time);
        
endmodule

///testbench for j-k flip flop
`define c @(posedge clk)
module top;
  bit j,k,clk,rst;
  logic q,q_bar;
  jk_ff dut(j,k,clk,rst,q,q_bar);
  bind jk_ff propertyM ppt(.*);
  always #5 clk=~clk;
  initial
    begin
      rst=1;
      repeat(2)`c;
      rst=0;
      repeat(20)
        begin
          `c;
          {j,k}=$urandom_range(0,3);
        end
    end
  initial
    begin
      $dumpfile("lab4.vcd");
      $dumpvars(0,top.dut);
      #200 $finish;
    end
endmodule
