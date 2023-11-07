module andt (input clk, rst, up, load,input [7:0] loadin,output reg [7:0] y); 
  always@(posedge clk)
    begin
    if(rst == 1'b1)
      y <= 8'b00000000;
    else if (load == 1'b1)
      y <= loadin;
    else begin
      if(up == 1'b1)
        y <= y + 1;
     else
      y <= y - 1;
    end
    end
endmodule

///testbench Module with coverage and assertion
module tb;
  bit clk,rst,up,load;
  bit [7:0]loadin;
  bit control;
  logic [7:0]y;
  andt dut(clk, rst, up, load,loadin,y);
  always #5 clk=~clk;
  task reset;
    rst=1;
    up=0;
    load=0;
    loadin=0;
    repeat(3)@(negedge clk);
    rst=0;
  endtask
  task incr(bit control=0);
    if(control)
      begin
        load=1;
        loadin=$urandom;
        @(negedge clk);
        load=0;
        up=1;
      end
    else
      up=1;
  endtask
  task decr(bit control=0);
    if(control)
      begin
        load=1;
        loadin=$urandom;
        @(negedge clk);
        load=0;
        up=0;
      end
    else
      begin
        up=0;
      end
  endtask

  //
  covergroup cg@(posedge clk);
    option.per_instance=1;
    option.name="counter Coverage";
    coverpoint loadin{
      option.auto_bin_max=3;
    }
    coverpoint rst{
      bins rstlow={0};
      bins rsthigh={1};
    }
    cross loadin,rst{
      ignore_bins rst1=binsof(rst) intersect {1};
    }
  endgroup
  cg c;
  initial
    begin
      c=new();
      reset;
      incr;
      repeat(10)@(negedge clk);
      decr();
      repeat(15)@(negedge clk);
      decr(1);
      repeat(20)@(negedge clk);
      incr();
    end
    
  
  //behaviour on rst is asserted
  property reset1;
    @(posedge clk) ##1 rst|->y==0;
  endproperty
  Rset:assert property(reset1)
    $info("passed at t=%t",$time);
 
    //up behaviour
  property Up;
    @(posedge clk) disable iff(rst) (up && y!=8'hff)|=> y==($past(y,1)+1);
  endproperty
    UP:assert property(Up)
      $info("passed at t=%t",$time);
  property corner;
    @(posedge clk) disable iff(rst) (up && y==8'hff)|=>y==0;
  endproperty
      Corner:assert property(corner)
        $info("passed at t=%t",$time);
        
    //down behaviour
        property down;
          @(posedge clk) disable iff(rst)(!up && y!=0 && !load)|=>(y==$past(y,1)-1);
        endproperty
        Down:assert property(down)
          $info("passed at t=%t",$time);
          
    //load
     property Load;
       @(posedge clk) disable iff(rst) load|=>y==loadin;
     endproperty
          LOAD:assert property(Load)
            $info("passed at t=%t",$time);
  

  initial
    begin
      $dumpfile("counter.vcd");
      $dumpvars(0,tb.dut);
      $assertvacuousoff(0);
      #1000 $finish;
    end
endmodule
