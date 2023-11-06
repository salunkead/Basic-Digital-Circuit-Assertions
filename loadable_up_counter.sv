///loadable up counter
//Design Module
module loadable_up_counter(input rst,clk,load,input [3:0]din,
                           output reg[3:0]out);
  always_ff@(posedge clk)
    begin
      if(rst)
        out<=0;
      else
        begin
          if(load)
            out<=din;
          else
            out<=out+1;
        end
    end
endmodule

//Proeprty Module
module propertyM(input rst,clk,load,input [3:0]din,out);
  default clocking@(posedge clk);
  endclocking
  //reset property
  reset:assert property(rst|=>!out)
    $info("passed at t=%0t",$time);
  //assertion for up counter
  property ppt;
    (!load&&out!=4'hf)|=>(out==$past(out)+1);
  endproperty
  op:assert property(disable iff(rst)ppt)
    $info("passed at t=%0t",$time);
endmodule

//testbench
module top;
  bit rst,clk,load;
  bit [3:0]din;
  logic [3:0]out;
  loadable_up_counter dut(rst,clk,load,din,out);
  bind  loadable_up_counter propertyM p(.*);
  always #5 clk=~clk;
  initial
    begin
      rst=1;
      load=0;
      din=0;
      repeat(2)@(negedge clk);
      rst=0;
      load=1;
      din=$urandom_range(0,5);
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
