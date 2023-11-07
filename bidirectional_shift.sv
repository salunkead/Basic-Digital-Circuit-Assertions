//assertion based verification of bidirectional shift register
//Design Module
module bidirectional_shift(input in,clk,rst,mode,output reg out);
  reg [3:0]reg1;
  always_ff@(posedge clk)
    begin
      if(rst)
        begin
          out=1'b0;
          reg1=4'd0;
        end
      else
        begin
          if(mode)
            begin
              out=reg1[0];
              reg1=reg1>>1;
              reg1[3]=in;
            end
          else
            begin
              out=reg1[3];
              reg1=reg1<<1;
              reg1[0]=in;
            end
        end
    end
endmodule

//testbench module with assertions
module top;
  bit clk,rst,mode,in;
  logic out;
  bidirectional_shift dut(in,clk,rst,mode,out);
  always #5 clk=~clk;
  initial
    begin
      bit [3:0]r;
      r=4'b1011;
      rst=1;
      mode=0;
      in=0;
      repeat(2)@(negedge clk);
      rst=0;
      for(int i=0;i<4;i++)
        begin
          @(negedge clk);
          in=r[i];
          mode=1;
        end
      @(negedge clk);
      in=0;
      repeat(4)@(negedge clk);
      mode=0;
      for(int i=0;i<4;i++)
        begin
          @(negedge clk);
          in=r[i];
        end
      @(negedge clk);
      in=0;
    end
  /////assertions 
  property p1;
    bit [2:0]a;
    bit in1;
    (mode,a=dut.reg1[3:1],in1=in)|=>
    (dut.reg1[3]==in1&&dut.reg1[2:0]==a);
  endproperty
  property p2;
    bit [2:0]a;
    bit in1;
    (!mode,a=dut.reg1[2:0],in1=in)|=>
    (dut.reg1[3:1]==a&&dut.reg1[0]==in1)
  endproperty
  property out1;
    mode|=>$past(dut.reg1[0])==out;
  endproperty
  property out2;
    !mode|=>$past(dut.reg1[3])==out;
  endproperty
//////////////////
  right_shift:assert property(@(posedge clk)disable iff(rst)p1)
    $info("passed at t=%0t",$time);
    //////////////////////////////////////
  left_shift:assert property(@(posedge clk)disable iff(rst)p2)
      $info("passed at t=%0t",$time);
  ///////////////////////////////////////////
   outR:assert property(@(posedge clk)disable iff(rst)out1)
      $info("passed at t=%0t",$time);
      
   outL:assert property(@(posedge clk)disable iff(rst)out2)
        $info("passed at t=%0t",$time);
    
  initial
    begin
      $dumpfile("dump.vcd");
      $dumpvars(0,top.dut);
      #220 $finish;
    end
endmodule
