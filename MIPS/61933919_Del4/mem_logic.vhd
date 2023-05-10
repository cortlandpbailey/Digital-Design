library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity mem_logic is
    port (
        address : in std_logic_vector(31 downto 0);
        MemWrite : in std_logic;
        Write_en : out std_logic;
        Outport_en : out std_logic;
        Read_select : out std_logic_vector(1 downto 0));
end mem_logic;


architecture BHV of mem_logic is
    
begin
    
   process(address, MemWrite)
   begin
        Write_en <= '0';
        Outport_en <= '0';

        if (unsigned(address) < 1024) then
            Read_select <= "10";        -- If address corresponds to RAM memory, switch the mux to the ram data
            if (MemWrite = '1') then
                Write_en <= '1';
            end if;
        elsif (unsigned(address) = "00000000000000001111111111111000") then
            Read_select <= "00";        -- Select INPORT 0
        elsif (unsigned(address) = "00000000000000001111111111111100") then
            Read_select <= "01";        -- Select INPORT 1 or OUTPORT
            if (MemWrite = '1') then
                Outport_en <= '1';      -- Write out to the outport
            end if;
        end if;
   end process;     
end architecture BHV;