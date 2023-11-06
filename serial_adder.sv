//assertion based verification of serial adder
//Design Module
module serial_adder(input x,y,clk,rst,output reg sum,carry);
  enum bit{s0,s1}state;
  bit cin;
  always@(posedge clk)
    begin
      if(rst)
        begin
          state=s0;
          sum=1'b0;
          carry=1'b0;
          cin=1'b0;
        end
      else
        begin
          case(state)
            1'b0:
              begin
                {carry,sum}=x+y+cin;
                cin=carry;
                state=s1;
              end
            1'b1:
              begin
                {carry,sum}=x+y+cin;
                cin=carry;
                state=s0;
              end
            default:state=s0;
          endcase
        end
    end
endmodule

//Property Module
module propertyM(input x,y,clk,rst,sum,carry);
  property p;
    bit a,b,c;
    (!rst,a=x,b=y,c=carry)|=>({carry,sum}==a+b+c);
  endproperty
  assert property(@(posedge clk)!rst|=>p)
    $info("passed at t=%0t",$time);
endmodule

//Testbench Module
module top;
  bit x,y,clk,rst;
  logic sum,carry;
  serial_adder dut(x,y,clk,rst,sum,carry);
  bind serial_adder propertyM ppt(.*);
  always #5 clk=~clk;
  initial
    begin
      rst=1;
      {x,y}=2'b00;
      repeat(2)@(negedge clk);
      rst=0;
      repeat(20)
        begin
          @(negedge clk);
          {x,y}=$urandom_range(0,3);
        end
    end
  initial
    begin
      $dumpfile("dump.vcd");
      $dumpvars(0,top.dut);
      #200 $finish;
    end
endmodule
