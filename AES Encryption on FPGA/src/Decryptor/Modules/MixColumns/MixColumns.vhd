------------------------------------------------------------------------------------
---- Company:             ITESM - IRS 2024
---- 
---- Create Date:         17/04/2024
---- Design Name:         INV Mix Column
---- Module Name:         Inv Mix Column Module
---- Target Devices:      DE10-Lite
---- Description:         Inv Mix Column Module
----
---- Version 0.0 - File Creation
---- Additional Comments: 
---- Authors: Edgar Roann and Santiago Aguilar
------------------------------------------------------------------------------------ 
library IEEE;
use IEEE.STD_LOGIC_1164.ALL; -- Standard library for logic elements
use IEEE.NUMERIC_STD.ALL; -- Standard library for numeric operations

-- Entity definition for AES_InvMixColumns
entity MixColumns is
    Port (
        clk : in STD_LOGIC; -- Clock signal
        rst : in STD_LOGIC; -- Reset signal
        enable : in STD_LOGIC; -- Enable signal for starting the operation
        state_in : in STD_LOGIC_VECTOR (127 downto 0); -- Input state for AES decryption
        state_out : out STD_LOGIC_VECTOR (127 downto 0); -- Output state after processing
        finish : out STD_LOGIC -- Signal to indicate completion of processing
    );
end MixColumns;

architecture Behavioral of MixColumns is
    signal state_reg : STD_LOGIC_VECTOR (127 downto 0); -- Intermediate register to hold state
    signal process_done : STD_LOGIC := '0'; -- Flag to indicate the end of processing

    -- Function to perform modular multiplication using a polynomial defined in AES
    function InvModulo(NumA : STD_LOGIC_VECTOR; NumB : STD_LOGIC_VECTOR) return STD_LOGIC_VECTOR is
        variable a      : STD_LOGIC_VECTOR(7 downto 0);
        variable b      : STD_LOGIC_VECTOR(7 downto 0);
        variable p      : STD_LOGIC_VECTOR(7 downto 0);
        variable aux    : STD_LOGIC_VECTOR(7 downto 0);
        variable hi_bit : STD_LOGIC_VECTOR(7 downto 0);
    begin
        a := NumA;
        b := NumB;
        p := "00000000";
        for i in 0 to 7 loop
            aux := b and "00000001"; -- Check the lowest bit
            if (aux = "00000001") then
                p := p xor a; -- Conditional XOR based on the bit's value
            end if;
            hi_bit := a and "10000000"; -- Check the highest bit
            a := a(6 downto 0) & '0'; -- Left shift and introduce 0
            if (hi_bit = "10000000") then
                a := a xor "00011011"; -- XOR with the irreducible polynomial 0x1B
            end if;
            b := '0' & b(7 downto 1); -- Right shift b
        end loop;
        return p;
    end InvModulo;

    -- Function to compute the inverse MixColumns operation for AES decryption
    function InvMixColumn(Cadena : STD_LOGIC_VECTOR) return STD_LOGIC_VECTOR is
        variable D0  : STD_LOGIC_VECTOR(7 downto 0);
        variable D1  : STD_LOGIC_VECTOR(7 downto 0);
        variable D2  : STD_LOGIC_VECTOR(7 downto 0);
        variable D3  : STD_LOGIC_VECTOR(7 downto 0);
        variable D4  : STD_LOGIC_VECTOR(7 downto 0);
        variable D5  : STD_LOGIC_VECTOR(7 downto 0);
        variable D6  : STD_LOGIC_VECTOR(7 downto 0);
        variable D7  : STD_LOGIC_VECTOR(7 downto 0);
        variable D8  : STD_LOGIC_VECTOR(7 downto 0);
        variable D9  : STD_LOGIC_VECTOR(7 downto 0);
        variable D10 : STD_LOGIC_VECTOR(7 downto 0);
        variable D11 : STD_LOGIC_VECTOR(7 downto 0);
        variable D12 : STD_LOGIC_VECTOR(7 downto 0);
        variable D13 : STD_LOGIC_VECTOR(7 downto 0);
        variable D14 : STD_LOGIC_VECTOR(7 downto 0);
        variable D15 : STD_LOGIC_VECTOR(7 downto 0);
        variable Output : STD_LOGIC_VECTOR(127 downto 0);
    begin
        -- Splitting input vector into bytes
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

        -- Applying InvMixColumns by recalculating each byte through InvModulo
         Output(127 downto 120)  := InvModulo(D0, X"0E") xor InvModulo(D1, X"0B") xor InvModulo(D2, X"0D") xor InvModulo(D3, X"09");
        Output(119 downto 112)  := InvModulo(D0, X"09") xor InvModulo(D1, X"0E") xor InvModulo(D2, X"0B") xor InvModulo(D3, X"0D");     
		  Output(111 downto 104)  := InvModulo(D0, X"0D") xor InvModulo(D1, X"09") xor InvModulo(D2, X"0E") xor InvModulo(D3, X"0B");
		  Output(103 downto 96)   := InvModulo(D0, X"0B") xor InvModulo(D1, X"0D") xor InvModulo(D2, X"09") xor InvModulo(D3, X"0E");

        Output(95 downto 88)    := InvModulo(D4, X"0E") xor InvModulo(D5, X"0B") xor InvModulo(D6, X"0D") xor InvModulo(D7, X"09");
        Output(87 downto 80)    := InvModulo(D4, X"09") xor InvModulo(D5, X"0E") xor InvModulo(D6, X"0B") xor InvModulo(D7, X"0D");
        Output(79 downto 72)    := InvModulo(D4, X"0D") xor InvModulo(D5, X"09") xor InvModulo(D6, X"0E") xor InvModulo(D7, X"0B");
        Output(71 downto 64)    := InvModulo(D4, X"0B") xor InvModulo(D5, X"0D") xor InvModulo(D6, X"09") xor InvModulo(D7, X"0E");

		  Output(63 downto 56)    := InvModulo(D8, X"0E") xor InvModulo(D9, X"0B") xor InvModulo(D10, X"0D") xor InvModulo(D11, X"09");
		  Output(55 downto 48)    := InvModulo(D8, X"09") xor InvModulo(D9, X"0E") xor InvModulo(D10, X"0B") xor InvModulo(D11, X"0D");
		  Output(47 downto 40)    := InvModulo(D8, X"0D") xor InvModulo(D9, X"09") xor InvModulo(D10, X"0E") xor InvModulo(D11, X"0B");
		  Output(39 downto 32)    := InvModulo(D8, X"0B") xor InvModulo(D9, X"0D") xor InvModulo(D10, X"09") xor InvModulo(D11, X"0E");

		  Output(31 downto 24)    := InvModulo(D12, X"0E") xor InvModulo(D13, X"0B") xor InvModulo(D14, X"0D") xor InvModulo(D15, X"09");
		  Output(23 downto 16)    := InvModulo(D12, X"09") xor InvModulo(D13, X"0E") xor InvModulo(D14, X"0B") xor InvModulo(D15, X"0D");
		  Output(15 downto 8)     := InvModulo(D12, X"0D") xor InvModulo(D13, X"09") xor InvModulo(D14, X"0E") xor InvModulo(D15, X"0B");
		  Output(7 downto 0)      := InvModulo(D12, X"0B") xor InvModulo(D13, X"0D") xor InvModulo(D14, X"09") xor InvModulo(D15, X"0E");

        return Output;
    end InvMixColumn;

    type state_type is (idle, processing, finished); -- State machine types
    signal state : state_type := idle; -- Initial state

begin
    -- State machine to manage processing states
    process(clk, rst)
    begin
        if rst = '1' then
            state <= idle; -- Reset to idle state
            state_reg <= (others => '0');
            process_done <= '0';
        elsif rising_edge(clk) then
            case state is
                when idle =>
                    if enable = '1' then
                        state <= processing; -- Start processing on enable
                    end if;

                when processing =>
                    state_reg <= InvMixColumn(state_in); -- Process input
                    state <= finished; -- Move to finished state

                when finished =>
                    process_done <= '1'; -- Indicate processing is done
                    if enable = '0' then
                        state <= idle; -- Reset to idle when enable is low
                        process_done <= '0';
                    end if;
            end case;
        end if;
    end process;

    -- Output assignments
    state_out <= state_reg;
    finish <= process_done; -- Output the completion signal
    
end Behavioral;


       