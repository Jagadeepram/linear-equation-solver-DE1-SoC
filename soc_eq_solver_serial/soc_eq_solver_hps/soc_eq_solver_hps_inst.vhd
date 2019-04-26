	component soc_eq_solver_hps is
		port (
			clock_bridge_0_in_clk_clk          : in    std_logic                     := 'X';             -- clk
			fifo_hps_to_fpga_out_readdata      : out   std_logic_vector(31 downto 0);                    -- readdata
			fifo_hps_to_fpga_out_read          : in    std_logic                     := 'X';             -- read
			fifo_hps_to_fpga_out_waitrequest   : out   std_logic;                                        -- waitrequest
			fifo_hps_to_fpga_out_csr_address   : in    std_logic_vector(2 downto 0)  := (others => 'X'); -- address
			fifo_hps_to_fpga_out_csr_read      : in    std_logic                     := 'X';             -- read
			fifo_hps_to_fpga_out_csr_writedata : in    std_logic_vector(31 downto 0) := (others => 'X'); -- writedata
			fifo_hps_to_fpga_out_csr_write     : in    std_logic                     := 'X';             -- write
			fifo_hps_to_fpga_out_csr_readdata  : out   std_logic_vector(31 downto 0);                    -- readdata
			hps_io_hps_io_emac1_inst_TX_CLK    : out   std_logic;                                        -- hps_io_emac1_inst_TX_CLK
			hps_io_hps_io_emac1_inst_TXD0      : out   std_logic;                                        -- hps_io_emac1_inst_TXD0
			hps_io_hps_io_emac1_inst_TXD1      : out   std_logic;                                        -- hps_io_emac1_inst_TXD1
			hps_io_hps_io_emac1_inst_TXD2      : out   std_logic;                                        -- hps_io_emac1_inst_TXD2
			hps_io_hps_io_emac1_inst_TXD3      : out   std_logic;                                        -- hps_io_emac1_inst_TXD3
			hps_io_hps_io_emac1_inst_RXD0      : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RXD0
			hps_io_hps_io_emac1_inst_MDIO      : inout std_logic                     := 'X';             -- hps_io_emac1_inst_MDIO
			hps_io_hps_io_emac1_inst_MDC       : out   std_logic;                                        -- hps_io_emac1_inst_MDC
			hps_io_hps_io_emac1_inst_RX_CTL    : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RX_CTL
			hps_io_hps_io_emac1_inst_TX_CTL    : out   std_logic;                                        -- hps_io_emac1_inst_TX_CTL
			hps_io_hps_io_emac1_inst_RX_CLK    : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RX_CLK
			hps_io_hps_io_emac1_inst_RXD1      : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RXD1
			hps_io_hps_io_emac1_inst_RXD2      : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RXD2
			hps_io_hps_io_emac1_inst_RXD3      : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RXD3
			hps_io_hps_io_qspi_inst_IO0        : inout std_logic                     := 'X';             -- hps_io_qspi_inst_IO0
			hps_io_hps_io_qspi_inst_IO1        : inout std_logic                     := 'X';             -- hps_io_qspi_inst_IO1
			hps_io_hps_io_qspi_inst_IO2        : inout std_logic                     := 'X';             -- hps_io_qspi_inst_IO2
			hps_io_hps_io_qspi_inst_IO3        : inout std_logic                     := 'X';             -- hps_io_qspi_inst_IO3
			hps_io_hps_io_qspi_inst_SS0        : out   std_logic;                                        -- hps_io_qspi_inst_SS0
			hps_io_hps_io_qspi_inst_CLK        : out   std_logic;                                        -- hps_io_qspi_inst_CLK
			hps_io_hps_io_sdio_inst_CMD        : inout std_logic                     := 'X';             -- hps_io_sdio_inst_CMD
			hps_io_hps_io_sdio_inst_D0         : inout std_logic                     := 'X';             -- hps_io_sdio_inst_D0
			hps_io_hps_io_sdio_inst_D1         : inout std_logic                     := 'X';             -- hps_io_sdio_inst_D1
			hps_io_hps_io_sdio_inst_CLK        : out   std_logic;                                        -- hps_io_sdio_inst_CLK
			hps_io_hps_io_sdio_inst_D2         : inout std_logic                     := 'X';             -- hps_io_sdio_inst_D2
			hps_io_hps_io_sdio_inst_D3         : inout std_logic                     := 'X';             -- hps_io_sdio_inst_D3
			hps_io_hps_io_usb1_inst_D0         : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D0
			hps_io_hps_io_usb1_inst_D1         : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D1
			hps_io_hps_io_usb1_inst_D2         : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D2
			hps_io_hps_io_usb1_inst_D3         : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D3
			hps_io_hps_io_usb1_inst_D4         : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D4
			hps_io_hps_io_usb1_inst_D5         : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D5
			hps_io_hps_io_usb1_inst_D6         : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D6
			hps_io_hps_io_usb1_inst_D7         : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D7
			hps_io_hps_io_usb1_inst_CLK        : in    std_logic                     := 'X';             -- hps_io_usb1_inst_CLK
			hps_io_hps_io_usb1_inst_STP        : out   std_logic;                                        -- hps_io_usb1_inst_STP
			hps_io_hps_io_usb1_inst_DIR        : in    std_logic                     := 'X';             -- hps_io_usb1_inst_DIR
			hps_io_hps_io_usb1_inst_NXT        : in    std_logic                     := 'X';             -- hps_io_usb1_inst_NXT
			hps_io_hps_io_spim1_inst_CLK       : out   std_logic;                                        -- hps_io_spim1_inst_CLK
			hps_io_hps_io_spim1_inst_MOSI      : out   std_logic;                                        -- hps_io_spim1_inst_MOSI
			hps_io_hps_io_spim1_inst_MISO      : in    std_logic                     := 'X';             -- hps_io_spim1_inst_MISO
			hps_io_hps_io_spim1_inst_SS0       : out   std_logic;                                        -- hps_io_spim1_inst_SS0
			hps_io_hps_io_uart0_inst_RX        : in    std_logic                     := 'X';             -- hps_io_uart0_inst_RX
			hps_io_hps_io_uart0_inst_TX        : out   std_logic;                                        -- hps_io_uart0_inst_TX
			hps_io_hps_io_i2c0_inst_SDA        : inout std_logic                     := 'X';             -- hps_io_i2c0_inst_SDA
			hps_io_hps_io_i2c0_inst_SCL        : inout std_logic                     := 'X';             -- hps_io_i2c0_inst_SCL
			hps_io_hps_io_i2c1_inst_SDA        : inout std_logic                     := 'X';             -- hps_io_i2c1_inst_SDA
			hps_io_hps_io_i2c1_inst_SCL        : inout std_logic                     := 'X';             -- hps_io_i2c1_inst_SCL
			hps_io_hps_io_gpio_inst_GPIO09     : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO09
			hps_io_hps_io_gpio_inst_GPIO35     : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO35
			hps_io_hps_io_gpio_inst_GPIO40     : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO40
			hps_io_hps_io_gpio_inst_GPIO41     : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO41
			hps_io_hps_io_gpio_inst_GPIO48     : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO48
			hps_io_hps_io_gpio_inst_GPIO53     : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO53
			hps_io_hps_io_gpio_inst_GPIO54     : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO54
			hps_io_hps_io_gpio_inst_GPIO61     : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO61
			memory_mem_a                       : out   std_logic_vector(14 downto 0);                    -- mem_a
			memory_mem_ba                      : out   std_logic_vector(2 downto 0);                     -- mem_ba
			memory_mem_ck                      : out   std_logic;                                        -- mem_ck
			memory_mem_ck_n                    : out   std_logic;                                        -- mem_ck_n
			memory_mem_cke                     : out   std_logic;                                        -- mem_cke
			memory_mem_cs_n                    : out   std_logic;                                        -- mem_cs_n
			memory_mem_ras_n                   : out   std_logic;                                        -- mem_ras_n
			memory_mem_cas_n                   : out   std_logic;                                        -- mem_cas_n
			memory_mem_we_n                    : out   std_logic;                                        -- mem_we_n
			memory_mem_reset_n                 : out   std_logic;                                        -- mem_reset_n
			memory_mem_dq                      : inout std_logic_vector(31 downto 0) := (others => 'X'); -- mem_dq
			memory_mem_dqs                     : inout std_logic_vector(3 downto 0)  := (others => 'X'); -- mem_dqs
			memory_mem_dqs_n                   : inout std_logic_vector(3 downto 0)  := (others => 'X'); -- mem_dqs_n
			memory_mem_odt                     : out   std_logic;                                        -- mem_odt
			memory_mem_dm                      : out   std_logic_vector(3 downto 0);                     -- mem_dm
			memory_oct_rzqin                   : in    std_logic                     := 'X';             -- oct_rzqin
			onchip_sram_s1_address             : in    std_logic_vector(7 downto 0)  := (others => 'X'); -- address
			onchip_sram_s1_clken               : in    std_logic                     := 'X';             -- clken
			onchip_sram_s1_chipselect          : in    std_logic                     := 'X';             -- chipselect
			onchip_sram_s1_write               : in    std_logic                     := 'X';             -- write
			onchip_sram_s1_readdata            : out   std_logic_vector(31 downto 0);                    -- readdata
			onchip_sram_s1_writedata           : in    std_logic_vector(31 downto 0) := (others => 'X'); -- writedata
			onchip_sram_s1_byteenable          : in    std_logic_vector(3 downto 0)  := (others => 'X'); -- byteenable
			ready_external_connection_export   : out   std_logic;                                        -- export
			sdram_clk_clk                      : out   std_logic;                                        -- clk
			system_pll_ref_clk_clk             : in    std_logic                     := 'X';             -- clk
			system_pll_ref_reset_reset         : in    std_logic                     := 'X'              -- reset
		);
	end component soc_eq_solver_hps;

	u0 : component soc_eq_solver_hps
		port map (
			clock_bridge_0_in_clk_clk          => CONNECTED_TO_clock_bridge_0_in_clk_clk,          --     clock_bridge_0_in_clk.clk
			fifo_hps_to_fpga_out_readdata      => CONNECTED_TO_fifo_hps_to_fpga_out_readdata,      --      fifo_hps_to_fpga_out.readdata
			fifo_hps_to_fpga_out_read          => CONNECTED_TO_fifo_hps_to_fpga_out_read,          --                          .read
			fifo_hps_to_fpga_out_waitrequest   => CONNECTED_TO_fifo_hps_to_fpga_out_waitrequest,   --                          .waitrequest
			fifo_hps_to_fpga_out_csr_address   => CONNECTED_TO_fifo_hps_to_fpga_out_csr_address,   --  fifo_hps_to_fpga_out_csr.address
			fifo_hps_to_fpga_out_csr_read      => CONNECTED_TO_fifo_hps_to_fpga_out_csr_read,      --                          .read
			fifo_hps_to_fpga_out_csr_writedata => CONNECTED_TO_fifo_hps_to_fpga_out_csr_writedata, --                          .writedata
			fifo_hps_to_fpga_out_csr_write     => CONNECTED_TO_fifo_hps_to_fpga_out_csr_write,     --                          .write
			fifo_hps_to_fpga_out_csr_readdata  => CONNECTED_TO_fifo_hps_to_fpga_out_csr_readdata,  --                          .readdata
			hps_io_hps_io_emac1_inst_TX_CLK    => CONNECTED_TO_hps_io_hps_io_emac1_inst_TX_CLK,    --                    hps_io.hps_io_emac1_inst_TX_CLK
			hps_io_hps_io_emac1_inst_TXD0      => CONNECTED_TO_hps_io_hps_io_emac1_inst_TXD0,      --                          .hps_io_emac1_inst_TXD0
			hps_io_hps_io_emac1_inst_TXD1      => CONNECTED_TO_hps_io_hps_io_emac1_inst_TXD1,      --                          .hps_io_emac1_inst_TXD1
			hps_io_hps_io_emac1_inst_TXD2      => CONNECTED_TO_hps_io_hps_io_emac1_inst_TXD2,      --                          .hps_io_emac1_inst_TXD2
			hps_io_hps_io_emac1_inst_TXD3      => CONNECTED_TO_hps_io_hps_io_emac1_inst_TXD3,      --                          .hps_io_emac1_inst_TXD3
			hps_io_hps_io_emac1_inst_RXD0      => CONNECTED_TO_hps_io_hps_io_emac1_inst_RXD0,      --                          .hps_io_emac1_inst_RXD0
			hps_io_hps_io_emac1_inst_MDIO      => CONNECTED_TO_hps_io_hps_io_emac1_inst_MDIO,      --                          .hps_io_emac1_inst_MDIO
			hps_io_hps_io_emac1_inst_MDC       => CONNECTED_TO_hps_io_hps_io_emac1_inst_MDC,       --                          .hps_io_emac1_inst_MDC
			hps_io_hps_io_emac1_inst_RX_CTL    => CONNECTED_TO_hps_io_hps_io_emac1_inst_RX_CTL,    --                          .hps_io_emac1_inst_RX_CTL
			hps_io_hps_io_emac1_inst_TX_CTL    => CONNECTED_TO_hps_io_hps_io_emac1_inst_TX_CTL,    --                          .hps_io_emac1_inst_TX_CTL
			hps_io_hps_io_emac1_inst_RX_CLK    => CONNECTED_TO_hps_io_hps_io_emac1_inst_RX_CLK,    --                          .hps_io_emac1_inst_RX_CLK
			hps_io_hps_io_emac1_inst_RXD1      => CONNECTED_TO_hps_io_hps_io_emac1_inst_RXD1,      --                          .hps_io_emac1_inst_RXD1
			hps_io_hps_io_emac1_inst_RXD2      => CONNECTED_TO_hps_io_hps_io_emac1_inst_RXD2,      --                          .hps_io_emac1_inst_RXD2
			hps_io_hps_io_emac1_inst_RXD3      => CONNECTED_TO_hps_io_hps_io_emac1_inst_RXD3,      --                          .hps_io_emac1_inst_RXD3
			hps_io_hps_io_qspi_inst_IO0        => CONNECTED_TO_hps_io_hps_io_qspi_inst_IO0,        --                          .hps_io_qspi_inst_IO0
			hps_io_hps_io_qspi_inst_IO1        => CONNECTED_TO_hps_io_hps_io_qspi_inst_IO1,        --                          .hps_io_qspi_inst_IO1
			hps_io_hps_io_qspi_inst_IO2        => CONNECTED_TO_hps_io_hps_io_qspi_inst_IO2,        --                          .hps_io_qspi_inst_IO2
			hps_io_hps_io_qspi_inst_IO3        => CONNECTED_TO_hps_io_hps_io_qspi_inst_IO3,        --                          .hps_io_qspi_inst_IO3
			hps_io_hps_io_qspi_inst_SS0        => CONNECTED_TO_hps_io_hps_io_qspi_inst_SS0,        --                          .hps_io_qspi_inst_SS0
			hps_io_hps_io_qspi_inst_CLK        => CONNECTED_TO_hps_io_hps_io_qspi_inst_CLK,        --                          .hps_io_qspi_inst_CLK
			hps_io_hps_io_sdio_inst_CMD        => CONNECTED_TO_hps_io_hps_io_sdio_inst_CMD,        --                          .hps_io_sdio_inst_CMD
			hps_io_hps_io_sdio_inst_D0         => CONNECTED_TO_hps_io_hps_io_sdio_inst_D0,         --                          .hps_io_sdio_inst_D0
			hps_io_hps_io_sdio_inst_D1         => CONNECTED_TO_hps_io_hps_io_sdio_inst_D1,         --                          .hps_io_sdio_inst_D1
			hps_io_hps_io_sdio_inst_CLK        => CONNECTED_TO_hps_io_hps_io_sdio_inst_CLK,        --                          .hps_io_sdio_inst_CLK
			hps_io_hps_io_sdio_inst_D2         => CONNECTED_TO_hps_io_hps_io_sdio_inst_D2,         --                          .hps_io_sdio_inst_D2
			hps_io_hps_io_sdio_inst_D3         => CONNECTED_TO_hps_io_hps_io_sdio_inst_D3,         --                          .hps_io_sdio_inst_D3
			hps_io_hps_io_usb1_inst_D0         => CONNECTED_TO_hps_io_hps_io_usb1_inst_D0,         --                          .hps_io_usb1_inst_D0
			hps_io_hps_io_usb1_inst_D1         => CONNECTED_TO_hps_io_hps_io_usb1_inst_D1,         --                          .hps_io_usb1_inst_D1
			hps_io_hps_io_usb1_inst_D2         => CONNECTED_TO_hps_io_hps_io_usb1_inst_D2,         --                          .hps_io_usb1_inst_D2
			hps_io_hps_io_usb1_inst_D3         => CONNECTED_TO_hps_io_hps_io_usb1_inst_D3,         --                          .hps_io_usb1_inst_D3
			hps_io_hps_io_usb1_inst_D4         => CONNECTED_TO_hps_io_hps_io_usb1_inst_D4,         --                          .hps_io_usb1_inst_D4
			hps_io_hps_io_usb1_inst_D5         => CONNECTED_TO_hps_io_hps_io_usb1_inst_D5,         --                          .hps_io_usb1_inst_D5
			hps_io_hps_io_usb1_inst_D6         => CONNECTED_TO_hps_io_hps_io_usb1_inst_D6,         --                          .hps_io_usb1_inst_D6
			hps_io_hps_io_usb1_inst_D7         => CONNECTED_TO_hps_io_hps_io_usb1_inst_D7,         --                          .hps_io_usb1_inst_D7
			hps_io_hps_io_usb1_inst_CLK        => CONNECTED_TO_hps_io_hps_io_usb1_inst_CLK,        --                          .hps_io_usb1_inst_CLK
			hps_io_hps_io_usb1_inst_STP        => CONNECTED_TO_hps_io_hps_io_usb1_inst_STP,        --                          .hps_io_usb1_inst_STP
			hps_io_hps_io_usb1_inst_DIR        => CONNECTED_TO_hps_io_hps_io_usb1_inst_DIR,        --                          .hps_io_usb1_inst_DIR
			hps_io_hps_io_usb1_inst_NXT        => CONNECTED_TO_hps_io_hps_io_usb1_inst_NXT,        --                          .hps_io_usb1_inst_NXT
			hps_io_hps_io_spim1_inst_CLK       => CONNECTED_TO_hps_io_hps_io_spim1_inst_CLK,       --                          .hps_io_spim1_inst_CLK
			hps_io_hps_io_spim1_inst_MOSI      => CONNECTED_TO_hps_io_hps_io_spim1_inst_MOSI,      --                          .hps_io_spim1_inst_MOSI
			hps_io_hps_io_spim1_inst_MISO      => CONNECTED_TO_hps_io_hps_io_spim1_inst_MISO,      --                          .hps_io_spim1_inst_MISO
			hps_io_hps_io_spim1_inst_SS0       => CONNECTED_TO_hps_io_hps_io_spim1_inst_SS0,       --                          .hps_io_spim1_inst_SS0
			hps_io_hps_io_uart0_inst_RX        => CONNECTED_TO_hps_io_hps_io_uart0_inst_RX,        --                          .hps_io_uart0_inst_RX
			hps_io_hps_io_uart0_inst_TX        => CONNECTED_TO_hps_io_hps_io_uart0_inst_TX,        --                          .hps_io_uart0_inst_TX
			hps_io_hps_io_i2c0_inst_SDA        => CONNECTED_TO_hps_io_hps_io_i2c0_inst_SDA,        --                          .hps_io_i2c0_inst_SDA
			hps_io_hps_io_i2c0_inst_SCL        => CONNECTED_TO_hps_io_hps_io_i2c0_inst_SCL,        --                          .hps_io_i2c0_inst_SCL
			hps_io_hps_io_i2c1_inst_SDA        => CONNECTED_TO_hps_io_hps_io_i2c1_inst_SDA,        --                          .hps_io_i2c1_inst_SDA
			hps_io_hps_io_i2c1_inst_SCL        => CONNECTED_TO_hps_io_hps_io_i2c1_inst_SCL,        --                          .hps_io_i2c1_inst_SCL
			hps_io_hps_io_gpio_inst_GPIO09     => CONNECTED_TO_hps_io_hps_io_gpio_inst_GPIO09,     --                          .hps_io_gpio_inst_GPIO09
			hps_io_hps_io_gpio_inst_GPIO35     => CONNECTED_TO_hps_io_hps_io_gpio_inst_GPIO35,     --                          .hps_io_gpio_inst_GPIO35
			hps_io_hps_io_gpio_inst_GPIO40     => CONNECTED_TO_hps_io_hps_io_gpio_inst_GPIO40,     --                          .hps_io_gpio_inst_GPIO40
			hps_io_hps_io_gpio_inst_GPIO41     => CONNECTED_TO_hps_io_hps_io_gpio_inst_GPIO41,     --                          .hps_io_gpio_inst_GPIO41
			hps_io_hps_io_gpio_inst_GPIO48     => CONNECTED_TO_hps_io_hps_io_gpio_inst_GPIO48,     --                          .hps_io_gpio_inst_GPIO48
			hps_io_hps_io_gpio_inst_GPIO53     => CONNECTED_TO_hps_io_hps_io_gpio_inst_GPIO53,     --                          .hps_io_gpio_inst_GPIO53
			hps_io_hps_io_gpio_inst_GPIO54     => CONNECTED_TO_hps_io_hps_io_gpio_inst_GPIO54,     --                          .hps_io_gpio_inst_GPIO54
			hps_io_hps_io_gpio_inst_GPIO61     => CONNECTED_TO_hps_io_hps_io_gpio_inst_GPIO61,     --                          .hps_io_gpio_inst_GPIO61
			memory_mem_a                       => CONNECTED_TO_memory_mem_a,                       --                    memory.mem_a
			memory_mem_ba                      => CONNECTED_TO_memory_mem_ba,                      --                          .mem_ba
			memory_mem_ck                      => CONNECTED_TO_memory_mem_ck,                      --                          .mem_ck
			memory_mem_ck_n                    => CONNECTED_TO_memory_mem_ck_n,                    --                          .mem_ck_n
			memory_mem_cke                     => CONNECTED_TO_memory_mem_cke,                     --                          .mem_cke
			memory_mem_cs_n                    => CONNECTED_TO_memory_mem_cs_n,                    --                          .mem_cs_n
			memory_mem_ras_n                   => CONNECTED_TO_memory_mem_ras_n,                   --                          .mem_ras_n
			memory_mem_cas_n                   => CONNECTED_TO_memory_mem_cas_n,                   --                          .mem_cas_n
			memory_mem_we_n                    => CONNECTED_TO_memory_mem_we_n,                    --                          .mem_we_n
			memory_mem_reset_n                 => CONNECTED_TO_memory_mem_reset_n,                 --                          .mem_reset_n
			memory_mem_dq                      => CONNECTED_TO_memory_mem_dq,                      --                          .mem_dq
			memory_mem_dqs                     => CONNECTED_TO_memory_mem_dqs,                     --                          .mem_dqs
			memory_mem_dqs_n                   => CONNECTED_TO_memory_mem_dqs_n,                   --                          .mem_dqs_n
			memory_mem_odt                     => CONNECTED_TO_memory_mem_odt,                     --                          .mem_odt
			memory_mem_dm                      => CONNECTED_TO_memory_mem_dm,                      --                          .mem_dm
			memory_oct_rzqin                   => CONNECTED_TO_memory_oct_rzqin,                   --                          .oct_rzqin
			onchip_sram_s1_address             => CONNECTED_TO_onchip_sram_s1_address,             --            onchip_sram_s1.address
			onchip_sram_s1_clken               => CONNECTED_TO_onchip_sram_s1_clken,               --                          .clken
			onchip_sram_s1_chipselect          => CONNECTED_TO_onchip_sram_s1_chipselect,          --                          .chipselect
			onchip_sram_s1_write               => CONNECTED_TO_onchip_sram_s1_write,               --                          .write
			onchip_sram_s1_readdata            => CONNECTED_TO_onchip_sram_s1_readdata,            --                          .readdata
			onchip_sram_s1_writedata           => CONNECTED_TO_onchip_sram_s1_writedata,           --                          .writedata
			onchip_sram_s1_byteenable          => CONNECTED_TO_onchip_sram_s1_byteenable,          --                          .byteenable
			ready_external_connection_export   => CONNECTED_TO_ready_external_connection_export,   -- ready_external_connection.export
			sdram_clk_clk                      => CONNECTED_TO_sdram_clk_clk,                      --                 sdram_clk.clk
			system_pll_ref_clk_clk             => CONNECTED_TO_system_pll_ref_clk_clk,             --        system_pll_ref_clk.clk
			system_pll_ref_reset_reset         => CONNECTED_TO_system_pll_ref_reset_reset          --      system_pll_ref_reset.reset
		);

