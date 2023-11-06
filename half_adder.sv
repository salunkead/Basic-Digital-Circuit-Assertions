//Assertion based verification of Half-Adder
//Design Module
module half_adder(input a,b,output y,cout);
  assign y=a^b;
  assign cout=a&b;
endmodule

//property module
module propertyM(a,b,y,cout);
  input a,b,y,cout;
  always@(a,b)
    begin
      assert #0({cout,y}==a+b)
        $info("passed at t=%0t",$time);
      else
        $error("failed at t=%0t",$time);
    end
endmodule

//testbench with assertion module binded
module top;
  bit a,b;
  logic y,cout;
  half_adder dut(a,b,y,cout);
  bind half_adder propertyM ppt(a,b,y,cout);
  initial
    begin
      repeat(20)
        begin
          {a,b}=$urandom;
          #20;
        end
    end
  initial
    begin
      $dumpfile("lab1.vcd");
      $dumpvars;
    end
endmodule
