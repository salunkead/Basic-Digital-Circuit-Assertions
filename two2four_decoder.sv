////2:4 decoder with assetion based verification
//Design Module
module two2four_decoder(input en,a,b,output reg y0,y1,y2,y3);
  always@(*)
    begin
      if(en)
      {y0,y1,y2,y3}=0;
      else
        begin
          case({a,b})
            2'd0:{y0,y1,y2,y3}=4'b1000;
            2'd1:{y0,y1,y2,y3}=4'b0100;
            2'd2:{y0,y1,y2,y3}=4'b0010;
            2'd3:{y0,y1,y2,y3}=4'b0001;
          endcase
        end
    end
endmodule

//Property Module
module propertyM(input en,a,b,y0,y1,y2,y3);
  always_comb
    begin
      case({a,b})
        2'd0:
          begin
            assert final(en==1'b0 && {y0,y1,y2,y3}==4'b1000)
              $info("passed at t=%0t",$time);
            else
              $error("failed at t=%0t",$time);
          end
        2'd1:
          begin
            assert final(en==1'b0 && {y0,y1,y2,y3}==4'b0100)
              $info("passed at t=%0t",$time);
            else
              $error("failed at t=%0t",$time);
          end
        2'd2:
          begin
            assert final(en==0 && {y0,y1,y2,y3}==4'b0010)
              $info("passed at t=%0t",$time);
            else
              $error("failed at t=%0t",$time);
          end
        2'd3:
          begin
            assert final(en==0 && {y0,y1,y2,y3}==4'b0001)
              $info("passed at t=%0t",$time);
            else
              $error("failed at t=%0t",$time);
          end
      endcase
    end
endmodule

///testbench for two to four decoder
module top;
  bit en,a,b;
  logic y0,y1,y2,y3;
  two2four_decoder dut(en,a,b,y0,y1,y2,y3);
  bind two2four_decoder propertyM ppt(.*);
  initial
    begin
      en=1;
      #10;
      en=0;
      for(int i=0;i<2**2;i++)
        begin
          {a,b}=i;
          #20;
        end
      #20;
      en=1;
    end
  initial
    begin
      $dumpfile("lab1.vcd");
      $dumpvars;
    end
endmodule
