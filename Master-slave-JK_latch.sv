///assertion based verification of matster and slave configuration of j-k latch
//Design Module
module JK_latch(input j,k,cp,output reg q,q_bar);
  reg t1,t2;
  always_latch
    begin
      if(!cp)
        begin
          q=t2;
          t1=q;
        end
      else
        begin
          case({j,k})
            2'b00:q=t1; 
            2'b01:q=1'b0;
            2'b10:q=1'b1;
            2'b11:q=~t1;
          endcase
          t2=q;
        end
    end
  assign q_bar=~q;
endmodule

//master-slave configuration
module Master_Slave_config(input j,k,clk,output reg q,q_bar);
  wire wq,wq_bar,wclk;
  assign wclk=~clk;
  JK_latch master(j,k,clk,wq,wq_bar);
  JK_latch slave(wq,wq_bar,wclk,q,q_bar);
endmodule

//Property Module
module propertyM(input j,k,clk,q,q_bar);
  default clocking@(negedge clk);
  endclocking
  //hold previous state
    hold:assert property({j,k}==2'b00|=>(q==$past(q)&&q_bar==~q))
      $info("passed at t=%0t",$time);
      else
        $error("failed at t=%0t",$time);
   //reset state
      reset_state:assert property({j,k}==2'b01|=>(q==0 && q_bar==~q))
        $info("passed at t=%0t",$time);
        else
          $error("failed at t=%0t",$time);
        
   //set state
        set_state:assert property({j,k}==2'b10|=>(q==1 && q_bar==~q))
        $info("passed at t=%0t",$time);
        else
          $error("failed at t=%0t",$time);
        
          
     ///toggel state
          
          toggle_state:assert property({j,k}==2'b11|=>(q==~$past(q) && q_bar==~q))
        $info("passed at t=%0t",$time);
        else
          $error("failed at t=%0t",$time);
        
endmodule

//Testbench Module
module top;
  bit j,k,clk;
  logic q,q_bar;
  always #5 clk=~clk;
  Master_Slave_config dut(j,k,clk,q,q_bar);
  bind Master_Slave_config propertyM ppt(.*);
  initial
    begin
      @(posedge clk);
      {j,k}=2'b10;
      repeat(20)
        begin
          @(posedge clk);
          {j,k}=$urandom_range(0,3);
        end
    end
  initial
    begin
      $dumpfile("dump.vcd");
      $dumpvars(0,top.dut);
      #200 $finish;
    end
endmodule
