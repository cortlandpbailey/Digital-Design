library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity memory is
    port (
        clk, en, rst    : in std_logic;
        MemWrite,Inport_sel : in std_logic;                         -- Write Enable
        Address         : in std_logic_vector(31 downto 0);     -- Address in From PC
        WrData          : in std_logic_vector(31 downto 0);     -- Data in from circuit         
        switch_in       : in std_logic_vector(31 downto 0);      -- Switch data in
        in_en           : in std_logic;      -- Button(1) in
        data          : out std_logic_vector(31 downto 0);    -- Data to circuit
        output            : out std_logic_vector(31 downto 0)     -- Output to LEDS 4 x 8
    );
end entity memory;


architecture STR of memory is
    signal ram_data                 : std_logic_vector(31 downto 0);
    signal WrEn, outportwren        : std_logic;
    signal read_sel, mux_sel        : std_logic_vector(1 downto 0);
    signal inPort0_en, inPort1_en   : std_logic;
    signal inport0, inport1         : std_logic_vector(31 downto 0);
    signal ram_address              : std_logic_vector(7 downto 0);
    
begin
    U_INPORT0 : entity work.reg
        generic map (width => 32)
        port map (
            input => switch_in,
            output => inport0,
            clk => clk,
            en => inPort0_en);

    U_INPORT1 : entity work.reg
        generic map (width => 32)
        port map (
            input => switch_in,
            output => inport1,
            clk => clk,
            en => inPort1_en);


    U_OUTPORT : entity work.reg
        generic map (width => 32)
        port map (
            input => WrData,
            output => output,
            clk => clk,
            rst => rst,
            en => outportwren);        

    U_RAM : entity work.TestCase7        --GCD_Assembly
        port map (
            clock  => clk,
            wren => WrEn,
            address => Address(9 downto 2),
            data => WrData,
            q => ram_data
        );
    
    U_LOGIC : entity work.mem_logic
        port map (
            address => Address,
            MemWrite => MemWrite,
            Write_en => WrEn,--signal to ram
            Outport_en => outportwren,
            Read_select => read_sel);--signal to mux

    U_DELAY : entity work.delay
        generic map (
            width => 2,
            cycles => 1
        )
        port map (
            clk => clk,
            en => '1',
            rst => rst,
            input => read_sel,
            output => mux_sel
        );


    U_READMUX : entity work.mux_3x1
        generic map (
            width => 32)
        port map (
            in1 => inport0,--Inport0
            in2 => inport1,--inport1
            in3 => ram_data,
            sel => mux_sel,
            output => data
        );


process(Inport_sel, in_en)
begin
    if (Inport_sel = '0' AND in_en = '1') then
        inPort0_en <= '0';
        inPort1_en <= '1';
    elsif(Inport_sel = '1' AND in_en = '1') then
        inPort0_en <= '1';
        inPort1_en <= '0';
    else
        inPort0_en <= '0';
        inPort1_en <= '0';
    end if;
    
end process;

end architecture STR;