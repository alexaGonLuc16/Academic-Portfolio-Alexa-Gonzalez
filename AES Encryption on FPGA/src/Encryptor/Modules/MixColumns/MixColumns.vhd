-- Company:         ITESM - Campus Qro.
-- Engineers:       Zoé and Helena
-- 
-- Create Date:     19/04/2024 
-- Design Name:     MixColumns
-- Module Name:     Mix Columns - Behavioral 
-- Project Name:    AES (Encryptor)
-- Target Devices:  DE10-Lite (Terasic.com)
-- Tool versions:   Altera Quartus Lite v21.2 build 842
-- Description:     Implementation of Mix Columns Module for AES
--
-- Version: 2.0
---------------------------------------------------------------------------------- 

-- Commonly used libraries
library IEEE;                        -- VHDL standard library
use IEEE.STD_LOGIC_1164.ALL;         -- Package providing basic data types and logic operations
use IEEE.STD_LOGIC_UNSIGNED.ALL;    -- Package providing unsigned arithmetic

-- Entity declaration
entity MixColumns is
    Port (
        -- Input ports
        Clk     : in STD_LOGIC;       -- Clock input
        Rst     : in STD_LOGIC;       -- Reset input
        Start   : in STD_LOGIC;       -- Start signal input
        TxtIn   : in STD_LOGIC_VECTOR (127 downto 0);  -- Text input, 128-bit vector
        -- Output ports
        Finish  : out STD_LOGIC;      -- Finish signal output
        TxtOut  : out STD_LOGIC_VECTOR (127 downto 0)  -- Text output, 128-bit vector
    );
end MixColumns;

-- Architecture definition
architecture Behavioral of MixColumns is

    -- Embedded signals declarations
    signal state_reg : STD_LOGIC_VECTOR (127 downto 0);  -- Internal register to hold state
    signal process_done: STD_LOGIC := '0';                -- Signal to indicate process completion


    -- Function to perform modulo operation
    function Modulo(NumA : STD_LOGIC_VECTOR; NumB : STD_LOGIC_VECTOR) return STD_LOGIC_VECTOR is
        variable a      : STD_LOGIC_VECTOR(7 downto 0);  -- Local variable for NumA
        variable b      : STD_LOGIC_VECTOR(7 downto 0);  -- Local variable for NumB
        variable p      : STD_LOGIC_VECTOR(7 downto 0);  -- Product variable
        variable aux    : STD_LOGIC_VECTOR(7 downto 0);  -- Auxiliary variable
        variable hi_bit : STD_LOGIC_VECTOR(7 downto 0);  -- Highest bit variable
    begin
        a := NumA;                                      -- Copy of first number
        b := NumB;                                      -- Copy of second number
        p := "00000000";                                -- Initialize product
        for i in 0 to 7 loop                            -- Loop for 8 bits
            aux := b and "00000001";                    -- Check LSB of b
            if(aux = "00000001") then                   -- If LSB of b is 1
                p := p xor a;                           -- XOR product with a
            end if;
            hi_bit := a and "10000000";                -- Check MSB of a
            a := a(6 downto 0) & '0';                  -- Shift left a by one bit
            if(hi_bit = "10000000") then               -- If MSB of a is set
                a := a xor "00011011";                 -- XOR a with 0x1B (an irreducible polynomial)
            end if;
            b := '0' & b(7 downto 1);                  -- Shift right b by one bit
        end loop;
        return p;                                      -- Return product
    end Modulo;
  
    -- Function to perform modulo operation on a vector
    function Modulo ( Cadena : STD_LOGIC_VECTOR ) return STD_LOGIC_VECTOR is
    
        variable D0  : STD_LOGIC_VECTOR(7 downto 0); variable D1  : STD_LOGIC_VECTOR(7 downto 0);  -- Local variables for slicing the input vector
        variable D2  : STD_LOGIC_VECTOR(7 downto 0); variable D3  : STD_LOGIC_VECTOR(7 downto 0);
        variable D4  : STD_LOGIC_VECTOR(7 downto 0); variable D5  : STD_LOGIC_VECTOR(7 downto 0);
        variable D6  : STD_LOGIC_VECTOR(7 downto 0); variable D7  : STD_LOGIC_VECTOR(7 downto 0);
        variable D8  : STD_LOGIC_VECTOR(7 downto 0); variable D9  : STD_LOGIC_VECTOR(7 downto 0);
        variable D10 : STD_LOGIC_VECTOR(7 downto 0); variable D11 : STD_LOGIC_VECTOR(7 downto 0);
        variable D12 : STD_LOGIC_VECTOR(7 downto 0); variable D13 : STD_LOGIC_VECTOR(7 downto 0);
        variable D14 : STD_LOGIC_VECTOR(7 downto 0); variable D15 : STD_LOGIC_VECTOR(7 downto 0);
        variable Output : STD_LOGIC_VECTOR(127 downto 0);  -- Output vector
    
    begin
        
        -- Slice the input vector into 16 8-bit vectors
        D0  := Cadena(127 downto 120);
        D4  := Cadena(119 downto 112);
        D8  := Cadena(111 downto 104);
        D12 := Cadena(103 downto 96);
        D1  := Cadena(95 downto 88);
        D5  := Cadena(87 downto 80);
        D9  := Cadena(79 downto 72);
        D13 := Cadena(71 downto 64);
        D2  := Cadena(63 downto 56);
        D6  := Cadena(55 downto 48);
        D10 := Cadena(47 downto 40);
        D14 := Cadena(39 downto 32);
        D3  := Cadena(31 downto 24);
        D7  := Cadena(23 downto 16);
        D11 := Cadena(15 downto 8);
        D15 := Cadena(7 downto 0);
    
        -- Calculate final matrix values
        Output(127 downto 120) := Modulo(D0,X"02") xor Modulo(D1,X"03") xor D2 xor D3;     -- X000
        Output(119 downto 112) := D0 xor Modulo(D1,X"02") xor Modulo(D2,X"03") xor D3;     -- X000
        Output(111 downto 104) := Modulo(D2,X"02") xor Modulo(D3,X"03") xor D0 xor D1;     -- X000
        Output(103 downto 96)  := Modulo(D0,X"03") xor Modulo(D3,X"02") xor D1 xor D2;     -- X000
    
        Output(95 downto 88)   := Modulo(D4,X"02") xor Modulo(D5,X"03") xor D6 xor D7;     -- 0X00
        Output(87 downto 80)   := Modulo(D5,X"02") xor Modulo(D6,X"03") xor D4 xor D7;     -- 0X00
        Output(79 downto 72)   := Modulo(D6,X"02") xor Modulo(D7,X"03") xor D4 xor D5;     -- 0X00
        Output(71 downto 64)   := Modulo(D4,X"03") xor Modulo(D7,X"02") xor D5 xor D6;     -- 0X00
         
        Output(63 downto 56)   := Modulo(D8,X"02") xor Modulo(D9,X"03") xor D10 xor D11;   -- 00X0
        Output(55 downto 48)   := Modulo(D9,X"02") xor Modulo(D10,X"03") xor D8 xor D11;   -- 00X0
        Output(47 downto 40)   := Modulo(D10,X"02") xor Modulo(D11,X"03") xor D8 xor D9;   -- 00X0
        Output(39 downto 32)   := Modulo(D8,X"03") xor Modulo(D11,X"02") xor D9 xor D10;   -- 00X0
    
        Output(31 downto 24)   := Modulo(D12,X"02") xor Modulo(D13,X"03") xor D14 xor D15; -- 000X
        Output(23 downto 16)   := Modulo(D13,X"02") xor Modulo(D14,X"03") xor D12 xor D15; -- 000X
        Output(15 downto 8)    := Modulo(D14,X"02") xor Modulo(D15,X"03") xor D12 xor D13; -- 000X
        Output(7 downto 0)     := Modulo(D12,X"03") xor Modulo(D15,X"02") xor D13 xor D14; -- 000X
    
        return Output;  -- Return final output vector
    end Modulo;

     
    -- Define states for the state machine
    type state_type is (idle, processing, finished);  -- State machine types
    signal state : state_type := idle;                -- Initial state

begin
    -- State machine to manage processing states
    process(Clk,Rst)
    begin
        if Rst = '1' then
            state <= idle;          -- Reset to idle state
            state_reg <= (others => '0');
            process_done <= '0';
        elsif rising_edge(Clk) then
            case state is
                when idle =>
                    if Start = '1' then
                        state <= processing;  -- Start processing on enable
                    end if;

                when processing =>
                    state_reg <= Modulo(TxtIn);  -- Process input
                    state <= finished;           -- Move to finished state

                when finished =>
                    process_done <= '1';         -- Indicate processing is done
                    if Start = '0' then
                        state <= idle;            -- Reset to idle when enable is low
                        process_done <= '0';
                    end if;
            end case;
        end if;
    end process;

    TxtOut <= state_reg;     -- Assign state register to output
    Finish <= process_done;  -- Assign process done signal to output

end Behavioral;
