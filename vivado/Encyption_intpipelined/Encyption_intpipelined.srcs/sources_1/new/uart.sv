    module uart #(
      parameter CLKS_PER_BIT = 434 // For 115200 baud rate with 50 MHz clock
    )(
      input  logic       clk,
      input  logic       rst_n,
      input  logic       rx,
      output logic       tx,
      input  logic [7:0] tx_data,
      input  logic       tx_start,
      output logic       tx_done,
      output logic [7:0] rx_data,
      output logic       rx_done
    );
    
      // UART Receiver
      logic [3:0] rx_state;
      logic [8:0] rx_clk_count;
      logic [2:0] rx_bit_index;
      logic [7:0] rx_buffer;
    
      always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
          rx_state <= 4'd0;
          rx_clk_count <= 9'd0;
          rx_bit_index <= 3'd0;
          rx_buffer <= 8'd0;
          rx_done <= 1'b0;
          rx_data <= 8'd0;
        end else begin
          case (rx_state)
            4'd0: begin // Idle
              rx_done <= 1'b0;
              if (rx == 1'b0) begin // Start bit detected
                rx_state <= 4'd1;
                rx_clk_count <= 9'd0;
              end
            end
            4'd1: begin // Start bit
              if (rx_clk_count == CLKS_PER_BIT/2) begin
                rx_state <= 4'd2;
                rx_clk_count <= 9'd0;
              end else begin
                rx_clk_count <= rx_clk_count + 1;
              end
            end
            4'd2: begin // Data bits
              if (rx_clk_count == CLKS_PER_BIT-1) begin
                rx_clk_count <= 9'd0;
                rx_buffer[rx_bit_index] <= rx;
                if (rx_bit_index == 3'd7) begin
                  rx_state <= 4'd3;
                end else begin
                  rx_bit_index <= rx_bit_index + 1;
                end
              end else begin
                rx_clk_count <= rx_clk_count + 1;
              end
            end
            4'd3: begin // Stop bit
              if (rx_clk_count == CLKS_PER_BIT-1) begin
                rx_state <= 4'd0;
                rx_done <= 1'b1;
                rx_data <= rx_buffer;
              end else begin
                rx_clk_count <= rx_clk_count + 1;
              end
            end
            default: rx_state <= 4'd0;
          endcase
        end
      end
    
      // UART Transmitter
      logic [3:0] tx_state;
      logic [8:0] tx_clk_count;
      logic [2:0] tx_bit_index;
      logic [7:0] tx_buffer;
    
      always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
          tx_state <= 4'd0;
          tx_clk_count <= 9'd0;
          tx_bit_index <= 3'd0;
          tx_buffer <= 8'd0;
          tx <= 1'b1;
          tx_done <= 1'b0;
        end else begin
          case (tx_state)
            4'd0: begin // Idle
              tx <= 1'b1;
              tx_done <= 1'b0;
              if (tx_start) begin
                tx_state <= 4'd1;
                tx_buffer <= tx_data;
              end
            end
            4'd1: begin // Start bit
              tx <= 1'b0;
              if (tx_clk_count == CLKS_PER_BIT-1) begin
                tx_state <= 4'd2;
                tx_clk_count <= 9'd0;
              end else begin
                tx_clk_count <= tx_clk_count + 1;
              end
            end
            4'd2: begin // Data bits
              tx <= tx_buffer[tx_bit_index];
              if (tx_clk_count == CLKS_PER_BIT-1) begin
                tx_clk_count <= 9'd0;
                if (tx_bit_index == 3'd7) begin
                  tx_state <= 4'd3;
                end else begin
                  tx_bit_index <= tx_bit_index + 1;
                end
              end else begin
                tx_clk_count <= tx_clk_count + 1;
              end
            end
            4'd3: begin // Stop bit
              tx <= 1'b1;
              if (tx_clk_count == CLKS_PER_BIT-1) begin
                tx_state <= 4'd0;
                tx_done <= 1'b1;
              end else begin
                tx_clk_count <= tx_clk_count + 1;
              end
            end
            default: tx_state <= 4'd0;
          endcase
        end
      end
    
    endmodule
