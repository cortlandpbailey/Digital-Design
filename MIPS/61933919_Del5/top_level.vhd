library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity top_level is 
    port (
        led0     : out std_logic_vector(6 downto 0);
        led0_dp  : out std_logic;
        led1     : out std_logic_vector(6 downto 0);
        led1_dp  : out std_logic;
        led2     : out std_logic_vector(6 downto 0);
        led2_dp  : out std_logic;
        led3     : out std_logic_vector(6 downto 0);
        led3_dp  : out std_logic;
        led4     : out std_logic_vector(6 downto 0);
        led4_dp  : out std_logic;
        led5     : out std_logic_vector(6 downto 0);
        led5_dp  : out std_logic;
        switches : in std_logic_vector(9 downto 0);
        button  : in std_logic_vector(1 downto 0);
        clk      : in std_logic
    );
end top_level;

architecture STR of top_level is
    signal irwrite, IorD, jr               : std_logic;
    signal rst, in_en                      : std_logic;
    signal memwrite, branch_taken          : std_logic;
    signal MemtoReg, regwrite              : std_logic;
    signal IsSigned, JumpandLink, ALUsrcA  : std_logic;
    signal RegDST, PCWrite                 : std_logic;
    signal is_mult                         : std_logic;
    signal ALU_OP                          : std_logic_vector(3  downto 0);
    signal ALUsrcB, PCSource               : std_logic_vector(1 downto 0);
    signal IR_OUT                          : std_logic_vector(5 downto 0);
    signal BR_OUT                          : std_logic_vector(4 downto 0);
    signal LEDS                            : std_logic_vector(31 downto 0);

    component decoder7seg
        port (
            input  : in  std_logic_vector(3 downto 0);
            output : out std_logic_vector(6 downto 0));
    end component;

    component controller is
        port (
            clk, rst, is_mult, branch_taken : in std_logic;
            irwrite, IorD                   : out std_logic;
            memwrite                        : out std_logic;
            MemtoReg, regwrite              : out std_logic;
            IsSigned, JumpandLink, ALUsrcA  : out std_logic;
            RegDST, PCWrite                 : out std_logic;
            jr                              : in std_logic;
            ALU_OP                          : out std_logic_vector(3 downto 0);
            ALUsrcB, PCSource               : out std_logic_vector(1 downto 0);
            IR_IN                           : in std_logic_vector(5 downto 0);
            BR_IN                           : in std_logic_vector(4 downto 0)
        );
    end component;

    component datapath is
        port (
            --I/O:
            input                           : in std_logic_vector(9 downto 0);
            in_en                           : in std_logic;
            output                          : out std_logic_vector(31 downto 0);
            clk, rst                        : in std_logic;
            -- Controller Signals:
            irwrite, IorD                   : in std_logic;
            memwrite                        : in std_logic;
            MemtoReg, regwrite              : in std_logic;
            IsSigned, JumpandLink, ALUsrcA  : in std_logic;
            RegDST, PCWrite                 : in std_logic;
            is_mult, branch_taken, jr       : out std_logic;
            ALU_OP                          : in std_logic_vector(3 downto 0);
            ALUsrcB, PCSource               : in std_logic_vector(1 downto 0);
            IR_OUT                          : out std_logic_vector(5 downto 0);
            BR_OUT                          : out std_logic_vector(4 downto 0)
        );
    
    end component;

begin
    
    DP : datapath
        port map (
        --I/O:
        input => switches,
        in_en => in_en,
        output => LEDS,
        clk => clk,
        rst => rst,
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
        BR_OUT   => BR_OUT,
        jr  => jr,
        branch_taken => branch_taken
        );

    FSM : controller
        port map (
            clk => clk,
            jr => jr,
            rst => rst,
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
            BR_IN => BR_OUT,
            branch_taken => branch_taken
            );

    U_LED5 : decoder7seg port map (
            input  => LEDS(23 downto 20),
            output => led5);
        
    U_LED4 : decoder7seg port map (
            input  => LEDS(19 downto 16),
            output => led4);
        
            -- all other LEDs should display 0
    U_LED3 : decoder7seg port map (
            input  => LEDS(15 downto 12),
            output => led3);
        
    U_LED2 : decoder7seg port map (
            input  => LEDS(11 downto 8),
            output => led2);
            
    U_LED1 : decoder7seg port map (
            input  => LEDS(7 downto 4),
            output => led1);
        
    U_LED0 : decoder7seg port map (
            input  => LEDS(3 downto 0),
            output => led0);
        
    --Set unuseddecimal points
    led5_dp <= '1'; 
    led3_dp <= '1';
    led2_dp <= '1';
    led1_dp <= '1';
    led0_dp <= '1';
    rst <= not button(1);
    in_en <= not button(0); 
    
end architecture STR;