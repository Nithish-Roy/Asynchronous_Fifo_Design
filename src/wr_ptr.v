module wr_ptr #(parameter SIZE=3) (
    input   wire                    wr_clk      ,       //write clock
    input   wire                    wr_rstn     ,       //write domain reset negedge
    input   wire                    wr_en       ,       //write enable    
    input   wire    [SIZE:0]        gr_rd_ptr   ,       //input gray read_pointer

    
    output  reg     [SIZE:0]        gr_wr_ptr   ,       //output gray write_pointer
    output  reg                     full        ,       //output full
    output  reg     [SIZE:0]      bi_wr_ptr           //output binary read_pointer
);        

      wire   [SIZE:0] gr_wr_ptr_nxt           ;       //temp to compute gray write pointer
      wire   [SIZE:0] bi_wr_ptr_nxt           ;       //temp to compute binary write pointer
      wire              w_full                  ;       //temp to store write full

  assign  bi_wr_ptr_nxt = bi_wr_ptr + (wr_en & !full)          ;       //next pointer to increment binary pointer
     assign  gr_wr_ptr_nxt = (bi_wr_ptr_nxt >> 1) ^ bi_wr_ptr_nxt  ;       //next pointer to compute the gray using the binary 

        always @(posedge wr_clk or negedge wr_rstn) begin 
            
            if(!wr_rstn) begin                                               //on reset set all the pointers to zero
                bi_wr_ptr   <=   0      ;
                gr_wr_ptr   <=   0      ; 
            end

            else begin                                                      //else assign the next computed pointers to the output 
                gr_wr_ptr   <=  gr_wr_ptr_nxt   ;                          
                bi_wr_ptr   <=  bi_wr_ptr_nxt   ; 
            end

        end
         
        always @(posedge wr_clk or negedge wr_rstn) begin

          if (!wr_rstn) begin                                             //on reset assert full to zero  
                full    <=     0           ; 
            end
            else begin									//else assign the computed full logic to full output
                full    <=     w_full      ;
            end

        end
         
  assign  w_full     =   (gr_wr_ptr_nxt == {(~gr_rd_ptr[SIZE:SIZE-1]), gr_rd_ptr[SIZE-2:0]});     //since gray code is used to get the full condition it is written accordingly

endmodule
