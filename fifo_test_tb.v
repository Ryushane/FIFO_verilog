`timescale  1ns / 1ps

module tb_fifo;

// fifo Parameters
parameter PERIOD      = 10;
parameter FIFO_WIDTH  = 14;
parameter FIFO_DEPTH  = 64;

// fifo Inputs
reg   clk                                = 0 ;
reg   rst_n                                = 0 ;
reg   wr_en                                = 0 ;
reg   [FIFO_WIDTH-1:0]  wr_data            = 0 ;
reg   rd_en                                = 0 ;

// fifo Outputs
wire  fifo_full                            ;
wire  [$clog2(FIFO_DEPTH)-1:0] fifo_count                 ;
wire  [FIFO_WIDTH-1:0]                       rd_data       ;
wire  fifo_empty                          ;
wire  fifo_almst_empty                     ;

reg [FIFO_WIDTH-1 :0] test_vec;

initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

initial
begin
    clk = 1'b0;
    rst_n = 1'b0;
    wr_en = 1'b0;
    wr_data = 16'b0;
    rd_en = 1'b0;

    #(PERIOD*2) rst_n  =  1;
end

always begin
    #(PERIOD*2)
    for(test_vec=0; test_vec < 17; test_vec = test_vec + 1)
        begin
            #(PERIOD) 
            wr_en = 1'b 1;
            wr_data = test_vec;
            #(PERIOD) 
            wr_en = 1'b 0;		
        end
    
    // read from fifo					
    for(test_vec=0; test_vec < 17; test_vec = test_vec + 1)
        begin
            #(PERIOD) 
            rd_en = 1'b 1;
            #(PERIOD) 
            rd_en = 1'b 0;		
        end	
    
    // write to fifo			
    for(test_vec=0; test_vec < 15; test_vec = test_vec + 1)
        begin
            #(PERIOD) 
            wr_en = 1'b 1;
            wr_data = test_vec;
            #(PERIOD) 
            wr_en = 1'b 0;		
        end		
    
    // read from fifo					
    for(test_vec=0; test_vec < 11; test_vec = test_vec + 1)
        begin
            #(PERIOD) 
            rd_en = 1'b 1;
            #(PERIOD) 
            rd_en = 1'b 0;		
        end			

    // read and write to fifo			
    for(test_vec=0; test_vec < 11; test_vec = test_vec + 1)
        begin
            #(PERIOD) 
            rd_en = 1'b 1;
            wr_en = 1'b 1;
            wr_data = test_vec;
            #(PERIOD) 
            rd_en = 1'b 0;
            wr_en = 1'b 0;					
        end					
    
    // read from fifo			
    for(test_vec=0; test_vec < 7; test_vec = test_vec + 1)
        begin
            #(PERIOD) 
            rd_en = 1'b 1;
            #(PERIOD) 
            rd_en = 1'b 0;		
        end				
    
    // write to fifo
    for(test_vec=0; test_vec < 13; test_vec = test_vec + 1)
        begin
            #(PERIOD) 
            wr_en = 1'b 1;
            wr_data = test_vec;
            #(PERIOD) 
            wr_en = 1'b 0;		
        end
        
    #10	
    rst_n = 1'b 1;
end



fifo u_fifo (
    .clk                           ( clk                                            ),
    .rst_n                           ( rst_n                                            ),
    .wr_en                           ( wr_en                                            ),
    .wr_data                         ( wr_data),
    .rd_en                           ( rd_en                                            ),

    .fifo_full                       ( fifo_full                                        ),
    .fifo_count                      ( fifo_count                    ),
    .rd_data                         (rd_data                   ),
    .fifo_empty                     ( fifo_empty                                      ),
    .fifo_almst_empty                ( fifo_almst_empty                                 )
);





initial
begin

    $finish;
end

endmodule