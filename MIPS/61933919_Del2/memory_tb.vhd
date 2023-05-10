library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity memory_tb is
end memory_tb;

architecture TB of memory_tb is
    signal clk, en, rst    : std_logic := '0';
    signal MemWrite        :  std_logic;                         -- Write Enable
    signal In0_en          :  std_logic;
    signal Address         :  std_logic_vector(31 downto 0);     -- Address in From PC
    signal WrData          :  std_logic_vector(31 downto 0);     -- Data in from circuit         
    signal switches        :  std_logic_vector(31 downto 0);      -- Switch data in
    signal buttons         :  std_logic_vector(1 downto 0);      -- Buttons in
    signal Output          :  std_logic_vector(31 downto 0);    -- Data to circuit
    signal LEDs            :  std_logic_vector(31 downto 0);     -- Output to LEDS 4 x 8
begin
    UUT : entity work.memory
        port map (
            clk => clk,
            en => en,        
            rst => rst,
            Inport_sel => In0_en,
            MemWrite => MemWrite,
            Address => Address,
            WrData  => WrData,
            switch_in => switches, 
            buttons => buttons,
            Output => Output,
            LEDs => LEDs
        );

    clk <= not clk after 10 ns;
    en <= '1';
    

    process
    begin
        --Initialitze all signals
       
        In0_en <= '0';
        switches <= (others => '0');
        buttons <= (others => '1');
        Address <= std_logic_vector(to_unsigned(0,32));
        MemWrite <= '1';
        WrData <= "00001010000010100000101000001010";       -- Write in the first value to the ram
        rst <= '1';
        wait for 40 ns;
        rst <= '0';

        wait for 20 ns;
        MemWrite <= '0';
        wait for 20 ns;

        Address <= std_logic_vector(to_unsigned(4,32));
        MemWrite <= '1';                                -- Write the 2nd value to the next address
        WrData <= "00001111000011110000111100001111";
        wait for 20 ns;
        MemWrite <= '0';
        wait for 20 ns;

        -- Read from RAM at locations to demonstrate proper architecture
        Address <= std_logic_vector(to_unsigned(0,32));
        wait for 20 ns;
        Address <= std_logic_vector(to_unsigned(1,32));
        wait for 20 ns;
        Address <= std_logic_vector(to_unsigned(4,32));
        wait for 20 ns;
        Address <= std_logic_vector(to_unsigned(5,32));
        wait for 20 ns;

        -- Write out to address port, first store value to ram then send it out. 
        Address <= std_logic_vector(to_unsigned(8,32));
        MemWrite <= '1';
        WrData <= "00000000000000000001000100010001";
        wait for 20 ns;
        Address <= "00000000000000001111111111111100";
        wait for 20 ns;

        -- Load from in-ports:
        Address <= "00000000000000001111111111111000";  -- Select inport 0 address
        switches <= "00000000000000010000000000000000"; -- load data on input 
        In0_en <= '0';                                  -- select enable (switch 9 on the board set to 0)
        buttons <= "10";                                -- Push load button
        wait for 20 ns;
        buttons <= "11";                            -- Depress buttons
        wait for 20 ns;
        Address <= "00000000000000001111111111111100";  -- Select inport 1 address
        switches <= "00000000000000000000000000000001"; -- load data on input
        In0_en <= '1';                                  -- select the inport reg 1
        buttons <= "10";                                -- push button
        wait for 20 ns;
        buttons <= "11";                            -- depress buttons
        wait for 20 ns;

        -- Read from Inports directly to outport:
        -- inport 0
        Address <= "00000000000000001111111111111000";
        wait for 20 ns;


        --Inport 1
        Address <= "00000000000000001111111111111100";

        wait;

    end process;     

end architecture TB;