module rd_ptr #(parameter SIZE  = 3) (
    input   wire                rd_clk      ,
    input   wire                rd_rstn     ,
    input   wire                rd_en       ,
    
    input   wire    [SIZE:0]    gr_wr_ptr   ,
    
    output  reg     [SIZE:0]    gr_rd_ptr   ,
    output  reg                 empty       ,
  	output  reg     [SIZE:0]  bi_rd_ptr   

   );

    wire    [SIZE:0]   gr_rd_ptr_nxt    ;
    wire    [SIZE:0]   bi_rd_ptr_nxt    ;

    wire               r_empty          ;

  assign bi_rd_ptr_nxt = bi_rd_ptr + (rd_en & !empty)        ;	
  assign gr_rd_ptr_nxt = (bi_rd_ptr_nxt >> 1) ^ bi_rd_ptr_nxt ;
  assign r_empty  =  (gr_wr_ptr == gr_rd_ptr_nxt) ;

        always @(posedge rd_clk or negedge rd_rstn) begin

            if (!rd_rstn) begin 
                bi_rd_ptr   <=  0   ;
                gr_rd_ptr   <=  0   ;
            end
            
          else  begin
                bi_rd_ptr   <=  bi_rd_ptr_nxt   ;
                gr_rd_ptr   <=  gr_rd_ptr_nxt   ;
            end

        end

        always @(posedge rd_clk or negedge rd_rstn) begin 

              if(!rd_rstn) begin 
                  empty     <=      1'b1    ;
              end
              else begin 
                  empty     <=     r_empty  ;
              end

         end
    
  		
  
endmodule
    
