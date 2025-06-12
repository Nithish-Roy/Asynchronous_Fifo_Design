///*----------------------------------------------------
//TWO_FLIPFLOP_SYNCHRONIZER
//*-----------------------------------------------------*\
//
////INPUTS CLK , RST, DATA_IN
////OUTPUT DATA_OUT
//// the output is assigned after two clock cycles reduces the metastablity
////just using 2 flipflops to pass the output to the desired clock domain 




module synchronizer #(parameter SIZE = 3) (
            
    input   wire                    clk         ,
    input   wire                    rst_n       ,
    input   wire     [SIZE:0]     	data_in     , 

    output  reg      [SIZE:0]     	data_out    

    );

        reg [SIZE:0] syn_reg ;

  always @(posedge clk) begin

    if(!rst_n) begin
                        syn_reg 	<= 	0	;
                        data_out 	<= 	0	;
                end
                else begin
                     syn_reg    <= data_in	;
                     data_out   <= syn_reg	;   
                end

            end

endmodule
