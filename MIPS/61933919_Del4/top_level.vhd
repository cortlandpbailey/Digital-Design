library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity top_level is 
    port (
        LEDS : out std_logic_vector(31 downto 0);
        switches : in std_logic_vector(9 downto 0);
        buttons: in std_logic_vector(1 downto 0);
        clk : in std_logic
    );
end top_level;

architecture STR of top_level is
    signal irwrite, IorD                   : std_logic;
    signal memwrite                        : std_logic;
    signal MemtoReg, regwrite              : std_logic;
    signal IsSigned, JumpandLink, ALUsrcA  : std_logic;
    signal RegDST, PCWrite                 : std_logic;
    signal is_mult                         : std_logic;
    signal ALU_OP                          : std_logic_vector(2 downto 0);
    signal ALUsrcB, PCSource               : std_logic_vector(1 downto 0);
    signal IR_OUT                          : std_logic_vector(5 downto 0);
    signal BR_OUT                          : std_logic_vector(4 downto 0);

begin
    
    DP : entity work.datapath
        port map (
        --I/O:
        switches => switches,
        buttons => buttons,
        LEDS => LEDS,
        clk => clk,
        rst => buttons(1),
        -- Controller Signals:
        irwrite => irwrite,
        IorD => IorD,
        memwrite =>  memwrite,
        MemtoReg =>  MemtoReg,
        regwrite => regwrite,
        IsSigned =>  IsSigned,
        JumpandLink => JumpandLink,
        ALUsrcA => ALUsrcA,
        RegDST => RegDST,
        PCWrite => PCWrite,
        is_mult  => is_mult,
        ALU_OP   => ALU_OP,
        ALUsrcB => ALUsrcB,
        PCSource => PCSource,
        IR_OUT  => IR_OUT,
        BR_OUT   => BR_OUT
        );

    FSM : entity work.controller
        port map (
            clk => clk,
            rst => buttons(1),
            is_mult => is_mult,
            irwrite => irwrite,
            IorD => IorD,
            memwrite => memwrite,
            MemtoReg=> MemtoReg,
            regwrite => regwrite,
            IsSigned=> IsSigned,
            JumpandLink=> JumpandLink,
            ALUsrcA => ALUsrcA,
            RegDST=> RegDST,
            PCWrite => PCWrite,
            ALU_OP => ALU_OP,
            ALUsrcB=> ALUsrcB,
            PCSource => PCSource,
            IR_IN  => IR_OUT,
            BR_IN => BR_OUT
        );
    
end architecture STR;