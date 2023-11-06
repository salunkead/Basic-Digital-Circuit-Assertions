///assertion based verification of majority function 
//Design Module
module even_parity_detector(input [3:0]in,input enb,output reg y);
  int no_1,no_0;
  always_comb
    begin
      if(!enb)
        y=0;
      else
        begin
          for(int i=0;i<$size(in);i++)
            begin
              if(in[i])
                no_1++;
              else
                no_0++;
            end
          if(no_1>no_0)
              y=1;
          else
              y=0;
          no_1=0;
          no_0=0;
        end
    end
endmodule

//Property Module
module propertyM(input [3:0]in,input enb,y);
  always_comb
    begin
      if(!enb)
        begin
          assert final(y==0)$info("passed at t=%0t",$time);
        end
      else
        begin
          if($countbits(in,1'b1)>$countbits(in,1'b0))
            begin
              op1:assert final(y==1)
                $info("passed at t=%0t",$time);
            end
          else
            op0:assert final(y==0)$info("passed at t=%0t",$time);
        end
    end
endmodule

//Testbench Module
module top;
  bit [3:0]in;
  bit enb;
  logic y;
  even_parity_detector dut(in,enb,y);
  bind even_parity_detector propertyM ppt(.*);
  initial
    begin
      enb=0;
      #10;
      repeat(20)
        begin
          enb=1;
          in=$urandom;
          $strobe("in=%b and y=%b at t=%0t",in,y,$time);
          #10;
        end
    end
  initial
    begin
      $dumpfile("dump.vcd");
      $dumpvars(0,top.dut);
    end
endmodule
