module Ram4Kb(clk,rst,addr,wdata,write,valid,error,ready,rdata);
input clk,rst,write,valid;
input [15:0] addr;
input [15:0] wdata;
output reg [15:0] rdata;
output reg error,ready;

integer i;

reg [15:0] mem [2047:0]; //memory creation

always@(posedge clk) begin
	if(rst==1)begin  //rst=1  power off state
		for(i=0;i<=2047;i=i+1)begin
			mem[i]=0;
		end
		rdata=0;
		error=0;
		ready=0;
	end
	else begin
		if(addr<=2047)begin
			error=0;
			if(valid==1)begin //valid=1
				ready=1;
				if(write==1)begin //write=1
					mem[addr]=wdata;
				end
				else begin	 //write=0
					rdata=mem[addr];
				end
			end
			else begin //valid=0
				ready=0;
			end
		end
		else begin
			error=1;
		end
	end
end

endmodule

module tb;
reg clk,rst,write,valid;
reg [15:0] addr;
reg [15:0] wdata;
wire [15:0] rdata;
wire error,ready;

Ram4Kb dut(clk,rst,addr,wdata,write,valid,error,ready,rdata);

//clock generation
initial begin
	clk=0;
	forever #5 clk=~clk;
end

initial begin
	rst=1;
	#10;
	rst=0;
	#5;

	// write operation
	write=1;valid=1;addr=16'd1;wdata=16'd10;
	#10;
	write=1;valid=1;addr=16'd2;wdata=16'd20;
	#10;
	write=1;valid=1;addr=16'd2046;wdata=16'd30;
	#10;
	write=1;valid=1;addr=16'd2047;wdata=16'd40;
	#10;

	// read operation
	write=0;valid=1;addr=16'd1;wdata=16'd0;
	#10;
	write=0;valid=1;addr=16'd2;wdata=16'd0;
	#10;
	write=0;valid=1;addr=16'd2046;wdata=16'd0;
	#10;
	write=0;valid=1;addr=16'd2047;wdata=16'd0;
	#10

	// invalid inputs
	write=0;valid=1;addr=16'd2048;wdata=16'd0;  //exceeding addr
	#10;
	write=0;valid=0;addr=16'd1;wdata=16'd0;	   //valid = 0
	#10;
end
initial begin
	$monitor("rst=%d addr=%d valid=%d write=%d wdata=%d rdata=%d error=%d ready=%d",rst,addr,valid,write,wdata,rdata,error,ready);
	#150 $finish;
end
endmodule


