module dp_ram #(parameter DEPTH = 8, WIDTH = 8, SIZE = 3) (
    
        input          wire                 wr_clk       ,
        input          wire                 wr_rstn      ,
        input          wire                 wr_en        ,
        input          wire     [SIZE:0]  wr_addr      ,        
       	input		   wire					full		 ,
        input          wire                 rd_clk       ,
        input          wire                 rd_rstn      ,
        input          wire                 rd_en        ,
        input          wire     [SIZE:0]  rd_addr      ,
  		input		   wire					empty		 ,
       
        input          wire     [WIDTH-1:0] data_in      ,

        output         reg      [WIDTH-1:0] data_out     

    );
            integer i   ;

            reg [WIDTH-1:0] memory [DEPTH-1:0]  ;

            always @(posedge wr_clk or negedge wr_rstn) begin 
                if(!wr_rstn) begin 
                   // for(integer i = 0; i<=DEPTH-1; i = i + 1)begin 
                   //         memory[i] <= {WIDTH{1'b0}};
                   // end
                end
              else if(wr_en && !full) begin 
                memory[wr_addr[SIZE-1:0]] <= data_in;
                end
            end

            always @(posedge rd_clk or negedge rd_rstn) begin 
                if (!rd_rstn) begin 
                    data_out <= {WIDTH{1'b0}};
                end
              else if(rd_en && !empty) begin 
                data_out <= memory[rd_addr[SIZE-1:0]];
                end
            end
  
//   assign data_out = memory[rd_addr];

endmodule
