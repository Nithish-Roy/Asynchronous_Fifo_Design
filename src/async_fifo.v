module asyn_fifo #(parameter DEPTH = 16, WIDTH = 8) (
   
   input        wire                 wr_clk      ,
   input        wire                 wr_rstn     ,
   input        wire                 wr_en       ,

   input        wire                 rd_clk      ,
   input        wire                 rd_rstn     , 
   input        wire                 rd_en       ,

   input        wire    [WIDTH-1:0]  data_in     ,

   output       wire                 full        ,
   output       wire                 empty       ,
   output       wire    [WIDTH-1:0]  data_out     

    );
    
  localparam PTR_WIDTH = $clog2(DEPTH);

    wire        [PTR_WIDTH:0]   gr_wr_ptr   	;
 	wire        [PTR_WIDTH:0] 	bi_wr_ptr   	;	//2:0
    wire      	[PTR_WIDTH:0]   gr_rd_ptr   	;
  	wire      	[PTR_WIDTH:0]	bi_rd_ptr   	;  	//2:0
  	wire        [PTR_WIDTH:0]   gr_rd_ptr_sync	;
    wire        [PTR_WIDTH:0]   gr_wr_ptr_sync	;    
  

wr_ptr #(PTR_WIDTH) wr_pointer_handler (
  .wr_clk   ( wr_clk             )   ,       //write clock
  .wr_rstn  ( wr_rstn            )   ,       //write domain reset negedge
  .wr_en    ( wr_en              )   ,       //write enable    

  .gr_rd_ptr( gr_rd_ptr_sync     )   ,       //input gray read_pointer from synchronizer

  .gr_wr_ptr( gr_wr_ptr          )   ,       //output gray write_pointer to be given to synchronizer 
  .full     ( full               )   ,       //output full
  .bi_wr_ptr( bi_wr_ptr          )           //output binary write_pointer to be given to dp ram
); 


  


rd_ptr  #(PTR_WIDTH) rd_pointer_handler (
  .rd_clk   ( rd_clk             )   ,		 //read clock
  .rd_rstn  ( rd_rstn            )   ,		 //read domain reset negedge 
  .rd_en    ( rd_en              )   ,		 //read enable
              
  .gr_wr_ptr( gr_wr_ptr_sync     )   ,		 //input gray write pointer from synchronizer
              
  .gr_rd_ptr( gr_rd_ptr          )   ,		 //output gray read_pointer to synchronizer
  .empty    ( empty              )   ,		 //output empty
  .bi_rd_ptr( bi_rd_ptr          )   		 //output binary read_pointer given to dp ram

   );



  synchronizer #(PTR_WIDTH) sync_wr (
            
  .clk     (wr_clk               )    ,	 	//write clock
  .rst_n   (wr_rstn              )    ,		//write reset negedge 
  .data_in (gr_rd_ptr            )    ,  	//gray_rd_ptr from rd_ptr_cal

  .data_out(gr_rd_ptr_sync       )    		//gray_rd_ptr to wr_ptr_cal

    );



  synchronizer #(PTR_WIDTH) sync_rd (
            
  .clk     (rd_clk               )    ,		//read clock	
  .rst_n   (rd_rstn              )    ,		//read reset negedge 
  .data_in (gr_wr_ptr            )    , 	//gray wr_ptr from wr_ptr_cal

  .data_out(gr_wr_ptr_sync       )    		//gray_wr_ptr to  rd_ptr_cal

    );

dp_ram #(DEPTH, WIDTH , PTR_WIDTH) dp_ram_memory (
    
       .wr_clk  (wr_clk          )     ,
       .wr_rstn (wr_rstn         )     ,
       .wr_en   (wr_en           )     ,
       .wr_addr (bi_wr_ptr       )     ,        
       .full	(full			 )	   ,
       .rd_clk  (rd_clk          )     ,
       .rd_rstn (rd_rstn         )     ,
       .rd_en   (rd_en           )     ,
       .rd_addr (bi_rd_ptr       )     ,        
  	   .empty	(empty			 )	    ,
       .data_in (data_in         )     ,
                         
       .data_out(data_out        )     
 
    );
        
endmodule
