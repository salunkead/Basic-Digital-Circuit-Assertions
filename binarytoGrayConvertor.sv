///assertion based verification of binary to gray code convertor
//Design Module
module binaryTogray(input [3:0]in,input enb,output reg [3:0]y);
  always_comb
    begin
      if(!enb)
        y=4'd0;
      else
        begin
          y[3]=in[3];
          y[2]=in[2]^in[3];
          y[1]=in[1]^in[2];
          y[0]=in[0]^in[1];
        end
    end
endmodule

//Property Module
module propertyM(input [3:0]in,input enb,input[3:0]y);
  always_comb
    begin
      if(!enb)
        begin
          assert final(y==0)
            $info("passed at t=%0t",$time);
        end
      else
        begin
          assert final(y=={in[3],in[2]^in[3],in[1]^in[2],in[0]^in[1]})
            $info("passed at t=%0t",$time);
        end
    end
endmodule

//Testbench Module
module top;
  bit[3:0]in;
  bit enb;
  logic [3:0]y;
  binaryTogray dut(in,enb,y);
  bind binaryTogray propertyM ppt(.*);
  initial
    begin
      enb=0;
      #10;
      repeat(20)
        begin
          enb=1;
          in=$urandom;
          $strobe("in=%0d and y=%b at t=%0t",in,y,$time);
          #10;
        end
    end
  initial
    begin
      $dumpfile("dump.vcd");
      $dumpvars(0,top.dut);
    end
endmodule
