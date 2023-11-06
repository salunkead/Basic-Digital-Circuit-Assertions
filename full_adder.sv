//assertion based full adder verification

//Design Module
module full_adder(input a,b,cin,output reg y,cout);
  always@(a,b,cin)
    begin
      {cout,y}=a+b+cin;
    end
endmodule

//Property module
module propertyM(a,b,cin,y,cout);
  input a,b,cin,y,cout;
  always_comb
    begin
      assert final({cout,y}==a+b+cin)
        $info("passed at t=%0t",$time);
      else
        $error("failed at t=%0t",$time);
      $strobe("ppt ","{a,b,cin}=%b y=%b cout=%b at t=%0t",{a,b,cin},y,cout,$time);
    end
endmodule

///testbench
module top;
  bit a,b,cin;
  logic y,cout;
  full_adder dut(a,b,cin,y,cout);
  bind full_adder propertyM ppt(a,b,cin,y,cout);
  initial
    begin
      for(int i=0;i<2**3;i++)
        begin
          {a,b,cin}=i;
          $strobe("{a,b,cin}=%b y=%b cout=%b at t=%0t",{a,b,cin},y,cout,$time);
          #20;
        end
    end
  initial
    begin
      $dumpfile("lab1.vcd");
      $dumpvars;
    end
endmodule
