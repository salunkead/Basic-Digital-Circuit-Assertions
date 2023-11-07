//assertion based verification of adder-substractor circuit
//Design Module
module adder_substractor(input [3:0]a,b,input mode,output reg[4:0]out);
  always_comb
    begin
      if(!mode)
        out=a+b;
      else
        out=a-b;
    end
endmodule

//Property Module
module propertyM(input [3:0]a,b,input mode,input[4:0]out);
  always_comb
    begin
      if(!mode)
        begin
          assert final(out==a+b)
            $info("passed at t=%0t",$time);
        end
      else
        begin
          assert final(out==a-b)
            $info("passed at t=%0t",$time);
        end
    end
endmodule

//testbench module
module top;
  bit [3:0]a,b;
  bit mode;
  logic [4:0]out;
  adder_substractor dut(a,b,mode,out);
  bind adder_substractor propertyM ppt(.*);
  initial
    begin
      repeat(10)
        begin
          a=$urandom;
          b=$urandom;
          mode=$random;
          #10;
        end
    end
  initial
    begin
      $dumpfile("dump.vcd");
      $dumpvars(0,top.dut);
    end
endmodule
