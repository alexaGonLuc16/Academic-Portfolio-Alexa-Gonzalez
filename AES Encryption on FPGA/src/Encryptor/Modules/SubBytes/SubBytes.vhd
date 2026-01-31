----------------------------------------------------------------------------------
-- Company:             ITESM - IRS 2024
-- Engineer:       	   Daniel De Regules Gamboa
-- Create Date:         18/04/2024
-- Design Name:         Sub Bytes
-- Module Name:         Sub Bytes Module
-- Target Devices:      DE10-Lite
-- Description:         Sub Bytes Module
--
-- Version 1.1.4
-- Additional Comments: 
--
----------------------------------------------------------------------------------

-- Commonly used libraries
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Entity declaration
entity SubBytes is
    Port (
        -- Input ports
        TxtIn   : in std_logic_vector(127 downto 0);
        Start    : in std_logic;
        Clk      : in std_logic;
        Rst      : in std_logic;
        -- Output ports
        Finish   : out std_logic;
        TxtOut  : out std_logic_vector(127 downto 0)
    );
end SubBytes;

-- Architecture definition
architecture Behavioral of SubBytes is

    -- Internal state variable
    type state_array is array(0 to 3, 0 to 3) of std_logic_vector(7 downto 0);
    signal State : state_array;

    -- S-Box for SubBytes transformation
    type SBox_array is array (0 to 255) of std_logic_vector(7 downto 0);
    constant SBox : SBox_array := (
        x"63", x"7C", x"77", x"7B", x"F2", x"6B", x"6F", x"C5", x"30", x"01", x"67", x"2B", x"FE", x"D7", x"AB", x"76",
        x"CA", x"82", x"C9", x"7D", x"FA", x"59", x"47", x"F0", x"AD", x"D4", x"A2", x"AF", x"9C", x"A4", x"72", x"C0",
        x"B7", x"FD", x"93", x"26", x"36", x"3F", x"F7", x"CC", x"34", x"A5", x"E5", x"F1", x"71", x"D8", x"31", x"15",
        x"04", x"C7", x"23", x"C3", x"18", x"96", x"05", x"9A", x"07", x"12", x"80", x"E2", x"EB", x"27", x"B2", x"75",
        x"09", x"83", x"2C", x"1A", x"1B", x"6E", x"5A", x"A0", x"52", x"3B", x"D6", x"B3", x"29", x"E3", x"2F", x"84",
        x"53", x"D1", x"00", x"ED", x"20", x"FC", x"B1", x"5B", x"6A", x"CB", x"BE", x"39", x"4A", x"4C", x"58", x"CF",
        x"D0", x"EF", x"AA", x"FB", x"43", x"4D", x"33", x"85", x"45", x"F9", x"02", x"7F", x"50", x"3C", x"9F", x"A8",
        x"51", x"A3", x"40", x"8F", x"92", x"9D", x"38", x"F5", x"BC", x"B6", x"DA", x"21", x"10", x"FF", x"F3", x"D2",
        x"CD", x"0C", x"13", x"EC", x"5F", x"97", x"44", x"17", x"C4", x"A7", x"7E", x"3D", x"64", x"5D", x"19", x"73",
        x"60", x"81", x"4F", x"DC", x"22", x"2A", x"90", x"88", x"46", x"EE", x"B8", x"14", x"DE", x"5E", x"0B", x"DB",
        x"E0", x"32", x"3A", x"0A", x"49", x"06", x"24", x"5C", x"C2", x"D3", x"AC", x"62", x"91", x"95", x"E4", x"79",
        x"E7", x"C8", x"37", x"6D", x"8D", x"D5", x"4E", x"A9", x"6C", x"56", x"F4", x"EA", x"65", x"7A", x"AE", x"08",
        x"BA", x"78", x"25", x"2E", x"1C", x"A6", x"B4", x"C6", x"E8", x"DD", x"74", x"1F", x"4B", x"BD", x"8B", x"8A",
        x"70", x"3E", x"B5", x"66", x"48", x"03", x"F6", x"0E", x"61", x"35", x"57", x"B9", x"86", x"C1", x"1D", x"9E",
        x"E1", x"F8", x"98", x"11", x"69", x"D9", x"8E", x"94", x"9B", x"1E", x"87", x"E9", x"CE", x"55", x"28", x"DF",
        x"8C", x"A1", x"89", x"0D", x"BF", x"E6", x"42", x"68", x"41", x"99", x"2D", x"0F", x"B0", x"54", x"BB", x"16"
    );

begin

    process(Clk, Rst)
    begin
        if Rst = '1' then
            -- Reset logic
            Finish <= '0';
        elsif rising_edge(Clk) then
            if Start = '1' then
                -- Load input data into internal state
                State(0, 0) <= SBox(conv_integer(TxtIn(127 downto 120)));
                State(0, 1) <= SBox(conv_integer(TxtIn(119 downto 112)));
                State(0, 2) <= SBox(conv_integer(TxtIn(111 downto 104)));
                State(0, 3) <= SBox(conv_integer(TxtIn(103 downto 96)));
                State(1, 0) <= SBox(conv_integer(TxtIn(95 downto 88)));
                State(1, 1) <= SBox(conv_integer(TxtIn(87 downto 80)));
                State(1, 2) <= SBox(conv_integer(TxtIn(79 downto 72)));
                State(1, 3) <= SBox(conv_integer(TxtIn(71 downto 64)));
                State(2, 0) <= SBox(conv_integer(TxtIn(63 downto 56)));
                State(2, 1) <= SBox(conv_integer(TxtIn(55 downto 48)));
                State(2, 2) <= SBox(conv_integer(TxtIn(47 downto 40)));
                State(2, 3) <= SBox(conv_integer(TxtIn(39 downto 32)));
                State(3, 0) <= SBox(conv_integer(TxtIn(31 downto 24)));
                State(3, 1) <= SBox(conv_integer(TxtIn(23 downto 16)));
                State(3, 2) <= SBox(conv_integer(TxtIn(15 downto 8)));
                State(3, 3) <= SBox(conv_integer(TxtIn(7 downto 0)));

                -- Write result to TxtOut
                TxtOut <= State(0, 0) & State(0, 1) & State(0, 2) & State(0, 3) &
                           State(1, 0) & State(1, 1) & State(1, 2) & State(1, 3) &
                           State(2, 0) & State(2, 1) & State(2, 2) & State(2, 3) &
                           State(3, 0) & State(3, 1) & State(3, 2) & State(3, 3);

                Finish <= '1'; -- Indicate operation completion
            else
                Finish <= '0';
            end if;
        end if;
    end process;

end Behavioral;
