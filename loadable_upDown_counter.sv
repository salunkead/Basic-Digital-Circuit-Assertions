///assertion based verification of loadable up-down counter
//Design Module
module loadable_upDown_counter(input rst,clk,load,mode,input [3:0]din,
                           output reg[3:0]out);
  always_ff@(posedge clk)
    begin
      if(rst)
        out<=0;
      else
        begin
          if(load)
            out<=din;
          else if(mode)
            out<=out+1;
          else
            out<=out-1;
        end
    end
endmodule

//Property Module
module propertyM(input rst,clk,load,mode,input [3:0]din,out);
  default clocking@(posedge clk);
  endclocking
  //reset property
  reset:assert property(rst|=>!out)
    $info("passed at t=%0t",$time);
  //////////////////////////
  property ppt1;
    (!load&&out!=4'hf&&mode)|=>(out==$past(out)+1);
  endproperty
  property ppt2;
    (!load&&out!=4'h0&&!mode)|=>(out==$past(out)-1);
  endproperty
    up:assert property(disable iff(rst)ppt1)
    $info("passed at t=%0t",$time);
    
    down:assert property(disable iff(rst)ppt2)
      $info("passed at t=%0t",$time);
endmodule

//testbench
module top;
  bit rst,clk,load,mode;
  bit [3:0]din;
  logic [3:0]out;
  loadable_upDown_counter dut(rst,clk,load,mode,din,out);
  bind  loadable_upDown_counter propertyM p(.*);
  always #5 clk=~clk;
  initial
    begin
      rst=1;
      load=0;
      din=0;
      repeat(2)@(negedge clk);
      rst=0;
      load=1;
      mode=1;
      din=$urandom_range(0,5);
      @(negedge clk);
      load=0;
      ///////////////
      repeat(10)@(negedge clk);
      load=1;
      mode=0;
      din=$urandom_range(10,15);
      @(negedge clk);
      load=0;
    end
  initial
    begin
      $dumpfile("dump.vcd");
      $dumpvars(0,top.dut);
      #200 $finish;
    end
endmodule
