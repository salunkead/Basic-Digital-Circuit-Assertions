///assertion based verification of single port ram
//8x16 single port ram
module single_port_ram(input wr,clk,rst,input [7:0]din,input [3:0]addr,
                       output reg[7:0]dout);
  reg [7:0]mem[16];
  always_ff@(posedge clk)
    begin
      if(rst)
        begin
          dout<=0;
          for(int i=0;i<16;i++)
            mem[i]<=0;
        end
      else
        begin
          if(wr)
            mem[addr]<=din;
          else
            dout<=mem[addr];
        end
    end
endmodule

//assertion module
module propertyM(input wr,clk,rst,input[7:0]din,input[3:0]addr,input[7:0]dout);
  //reset operation
  reset_op:assert property(@(posedge clk)rst|=>dout==0) $info("passed at t=%0t",$time);
  ///ram operation
  property p;
    reg [7:0]mem[16];
    bit [3:0]a;
    (wr,a=addr,mem[a]=din)|->##[1:$](!wr&&a==addr)##1(mem[a]==dout);
  endproperty
  ram_op:assert property(@(posedge clk)p)
    $info("passed at t=%0t",$time);
endmodule

//testbench for single port ram
`define c @(negedge clk)
module top;
  bit clk,rst,wr;
  bit [7:0]din;
  bit [3:0]addr;
  logic [7:0]dout;
  event e,e1;
  single_port_ram dut(wr,clk,rst,din,addr,dout);
  bind single_port_ram propertym p(.*);
  always #5 clk=~clk;
  initial
    begin:reset
      rst=1;
      wr=0;
      din=0;
      addr=0;
      repeat(2)`c;
      rst=0;
      ->e;
    end
  initial
    begin:write
      wait(e.triggered)
      for(int i=0;i<16;i++)
        begin
          `c;
          wr=1;
          addr=i;
          din=$urandom;
        end
      ->e1;
    end
  initial
    begin
      wait(e1.triggered)
       for(int i=0;i<16;i++)
        begin
          `c;
          wr=0;
          addr=i;
        end
    end
  initial
    begin
      $dumpfile("dump.vcd");
      $dumpvars(0,top.dut);
      #500 $finish;
    end
endmodule
