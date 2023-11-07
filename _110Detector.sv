//Assertion based verification of 110 detector
//Design Module
module fsm_110(input clk,rst,in,output out);
  typedef enum bit[1:0]{idle,s0,s1,s2}state_type;
  state_type state,nxt_state;
  always@(posedge clk)
    begin
      if(rst)
        state<=idle;
      else
        state<=nxt_state;
    end
  always@(*)
    begin
      case(state)
        idle:
          begin
            if(in)
              nxt_state=s0;
            else
              nxt_state=idle;
          end
        s0:
          begin
             if(in)
              nxt_state=s1;
            else
              nxt_state=idle;
          end
        s1:
          begin
             if(in)
              nxt_state=s1;
            else
              nxt_state=s2;
          end
        s2:
          begin
             if(in)
              nxt_state=s0;
            else
              nxt_state=idle;
          end
        default:
          begin
            nxt_state=idle;
          end
      endcase
    end
  assign out=state==s2?1:0;
endmodule

//Testbench Module with assertions
module tb;
  bit clk,rst,in;
  logic out;
  logic [1:0]state;
  fsm_110 dut(clk,rst,in,out);
  always #5 clk=~clk;
  task reset;
    rst=1;
    in=0;
    repeat(3)@(negedge clk);
    rst=0;
  endtask
  task inputs;
    in=$random;
    @(negedge clk);
  endtask
  
  initial
    begin
      reset;
      repeat(30)inputs;
    end
  
  //Assertions
  //check reset
  property check_reset;
    @(posedge clk)rst|->(dut.state==dut.idle && out==0);
  endproperty
  checkReset:assert property(check_reset)
    $info("passed at t=%t",$time);
  
  ///2.if reset deasserted system transit to correct state based on input
  property idletoidle;
      @(posedge clk) disable iff(rst)(dut.state==dut.idle && in==0)|=>dut.state==dut.idle;
    endproperty
    idle_to_idle:assert property(idletoidle)
      $info("passed at t=%t",$time);
      
      ///////////////
  property idletos0;
        @(posedge clk) disable iff(rst)(dut.state==dut.idle && in)|=>dut.state==dut.s0;
  endproperty
  idle_to_s0:assert property(idletos0)
        $info("passed at t=%t",$time);
   ///////////////////////////////////
  property s0;
          @(posedge clk) dut.state==dut.s0 |=> if($past(in,1))
                                              dut.state==dut.s1
                                               else
                                                 dut.state==dut.idle;
  endproperty
  S0:assert property(s0)
      $info("passed at t=%t",$time);
  //////////////////////////
  property s1;
            @(posedge clk) dut.state==dut.s1|=>if($past(in,1))
                                                 dut.state==dut.s1
                                               else
                                                 dut.state==dut.s2;
  endproperty
  S1:assert property(s1)
            $info("passed at t=%t",$time);
            
//////////////////////////////
property s2;
            @(posedge clk) dut.state==dut.s2 |=> if($past(in))
                                                    dut.state==dut.s0
                                                    else
                                                      dut.state==dut.idle;
endproperty
S2:assert property(s2)
          $info("passed at t=%t",$time);
  ///////////////////////////////////////
//zero output
property zero_op;
          @(posedge clk) (dut.state==dut.idle||dut.state==dut.s0||dut.state==dut.s1)|->!out;
endproperty
output0:assert property(zero_op)
          $info("passed at t=%t",$time);

//////////
//output 1
property one_op;
         @(posedge clk) dut.state==dut.s2|->out;
endproperty
output1:assert property(one_op)
         $info("passed at t=%t",$time);
  
  initial
    begin
      $dumpfile("110.vcd");
      $dumpvars(0,tb.dut);
      $assertvacuousoff(0);
      #300 $finish;
    end
endmodule
