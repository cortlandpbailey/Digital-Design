library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ram is
    generic (
        num_words : positive;
        word_width : positive;
        addr_width : positive
    );
    port (
        clk : in std_logic;
        wen : in std_logic;
        waddr : in std_logic_vector(addr_width-1 downto 0);
        wdata : in std_logic_vector(word_width-1 downto 0);
        raddr : in std_logic_vector(addr_width-1 downto 0);
        rdata : out std_logic_vector(word_width-1 downto 0)
    );
end entity ram;

architecture ASYNC_READ of ram is
    type memory_type is array (natural range <>) of std_logic_vector(word_width-1 downto 0);
    signal memory : memory_type(0 to num_words-1) := (others => (others => '0'));

begin
    process(clk)
    begin

        if (rising_edge(clk)) then 
            if (wen = '1') then
                memory(to_integer(unsigned(waddr))) <= wdata;
            end if;
        end if;
    end process;
    -- Any read address returns the data at the address
    rdata <= memory(to_integer(unsigned(raddr)));  
    
end architecture ASYNC_READ;



architecture SYNC_READ_DURING_WRITE of ram is
    type memory_type is array (natural range <>) of std_logic_vector(word_width-1 downto 0);
    signal memory : memory_type(0 to num_words-1) := (others => (others => '0'));
    signal raddr_r : std_logic_vector(addr_width-1 downto 0);
begin
    process(clk)
    begin

        if (rising_edge(clk)) then 
            if (wen = '1') then
                memory(to_integer(unsigned(waddr))) <= wdata;
            end if;
            raddr_r <= raddr;
        end if;
    end process;
    rdata <= memory(to_integer(unsigned(raddr_r)));  
    
end architecture SYNC_READ_DURING_WRITE;



architecture SYNC_READ of ram is
    type memory_type is array (natural range <>) of std_logic_vector(word_width-1 downto 0);
    signal memory : memory_type(0 to num_words-1) := (others => (others => '0'));
begin
    process(clk)
    begin

        if (rising_edge(clk)) then 
            if (wen = '1') then
                memory(to_integer(unsigned(waddr))) <= wdata;
            else
                rdata <= memory(to_integer(unsigned(raddr)));  
            end if;
        end if;
    end process; 
   
end architecture SYNC_READ;