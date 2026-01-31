---------------------------------------------------------------------------------------------------------------
-- 	Luis Adrián Uribe Cruz
--    Roberto Carlos Pedraza Miranda
-- 	ITESM - Campus Querétaro
-- 	Invert SubBytes
---------------------------------------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity SubBytes is
    Port (
        sbIn   : in std_logic_vector(127 downto 0);
        start_DECSubBytes    : in std_logic;
        Clk      : in std_logic;
        reset      : in std_logic;
        finish_DECSubBytes   : out std_logic;
        sbOut  : out std_logic_vector(127 downto 0);
        -- Output port for indices
        IndicesOut : out std_logic_vector(7 downto 0)
    );
end SubBytes;

architecture Behavioral of SubBytes is

    -- Internal state variable
    type state_decS is array(0 to 3, 0 to 3) of std_logic_vector(7 downto 0);
    signal State : state_decS;

    -- Invert S-Box for DECSubBytes 
    type InvSBox_array is array (0 to 255) of std_logic_vector(7 downto 0);
    constant InvSBox : InvSBox_array := (
        x"52", x"09", x"6A", x"D5", x"30", x"36", x"A5", x"38", x"BF", x"40", x"A3", x"9E", x"81", x"F3", x"D7", x"FB",
        x"7C", x"E3", x"39", x"82", x"9B", x"2F", x"FF", x"87", x"34", x"8E", x"43", x"44", x"C4", x"DE", x"E9", x"CB",
        x"54", x"7B", x"94", x"32", x"A6", x"C2", x"23", x"3D", x"EE", x"4C", x"95", x"0B", x"42", x"FA", x"C3", x"4E",
        x"08", x"2E", x"A1", x"66", x"28", x"D9", x"24", x"B2", x"76", x"5B", x"A2", x"49", x"6D", x"8B", x"D1", x"25",
        x"72", x"F8", x"F6", x"64", x"86", x"68", x"98", x"16", x"D4", x"A4", x"5C", x"CC", x"5D", x"65", x"B6", x"92",
        x"6C", x"70", x"48", x"50", x"FD", x"ED", x"B9", x"DA", x"5E", x"15", x"46", x"57", x"A7", x"8D", x"9D", x"84",
        x"90", x"D8", x"AB", x"00", x"8C", x"BC", x"D3", x"0A", x"F7", x"E4", x"58", x"05", x"B8", x"B3", x"45", x"06",
        x"D0", x"2C", x"1E", x"8F", x"CA", x"3F", x"0F", x"02", x"C1", x"AF", x"BD", x"03", x"01", x"13", x"8A", x"6B",
        x"3A", x"91", x"11", x"41", x"4F", x"67", x"DC", x"EA", x"97", x"F2", x"CF", x"CE", x"F0", x"B4", x"E6", x"73",
        x"96", x"AC", x"74", x"22", x"E7", x"AD", x"35", x"85", x"E2", x"F9", x"37", x"E8", x"1C", x"75", x"DF", x"6E",
        x"47", x"F1", x"1A", x"71", x"1D", x"29", x"C5", x"89", x"6F", x"B7", x"62", x"0E", x"AA", x"18", x"BE", x"1B",
        x"FC", x"56", x"3E", x"4B", x"C6", x"D2", x"79", x"20", x"9A", x"DB", x"C0", x"FE", x"78", x"CD", x"5A", x"F4",
        x"1F", x"DD", x"A8", x"33", x"88", x"07", x"C7", x"31", x"B1", x"12", x"10", x"59", x"27", x"80", x"EC", x"5F",
        x"60", x"51", x"7F", x"A9", x"19", x"B5", x"4A", x"0D", x"2D", x"E5", x"7A", x"9F", x"93", x"C9", x"9C", x"EF",
        x"A0", x"E0", x"3B", x"4D", x"AE", x"2A", x"F5", x"B0", x"C8", x"EB", x"BB", x"3C", x"83", x"53", x"99", x"61",
        x"17", x"2B", x"04", x"7E", x"BA", x"77", x"D6", x"26", x"E1", x"69", x"14", x"63", x"55", x"21", x"0C", x"7D"
    );

begin

    process(Clk, reset)
    begin
        if reset = '1' then
            -- Reset logic
            finish_DECSubBytes <= '0';
        elsif rising_edge(Clk) then
            if start_DECSubBytes = '1' then
                -- Load input data into internal state
                State(0, 0) <= InvSBox(conv_integer(sbIn(127 downto 120)));
                State(0, 1) <= InvSBox(conv_integer(sbIn(119 downto 112)));
                State(0, 2) <= InvSBox(conv_integer(sbIn(111 downto 104)));
                State(0, 3) <= InvSBox(conv_integer(sbIn(103 downto 96)));
                State(1, 0) <= InvSBox(conv_integer(sbIn(95 downto 88)));
                State(1, 1) <= InvSBox(conv_integer(sbIn(87 downto 80)));
                State(1, 2) <= InvSBox(conv_integer(sbIn(79 downto 72)));
                State(1, 3) <= InvSBox(conv_integer(sbIn(71 downto 64)));
                State(2, 0) <= InvSBox(conv_integer(sbIn(63 downto 56)));
                State(2, 1) <= InvSBox(conv_integer(sbIn(55 downto 48)));
                State(2, 2) <= InvSBox(conv_integer(sbIn(47 downto 40)));
                State(2, 3) <= InvSBox(conv_integer(sbIn(39 downto 32)));
                State(3, 0) <= InvSBox(conv_integer(sbIn(31 downto 24)));
                State(3, 1) <= InvSBox(conv_integer(sbIn(23 downto 16)));
                State(3, 2) <= InvSBox(conv_integer(sbIn(15 downto 8)));
                State(3, 3) <= InvSBox(conv_integer(sbIn(7 downto 0)));

                -- Write result to sbOut
                sbOut <= State(0, 0) & State(0, 1) & State(0, 2) & State(0, 3) &
                           State(1, 0) & State(1, 1) & State(1, 2) & State(1, 3) &
                           State(2, 0) & State(2, 1) & State(2, 2) & State(2, 3) &
                           State(3, 0) & State(3, 1) & State(3, 2) & State(3, 3);

                -- Generate indices
			IndicesOut <= (others => '0'); -- Initialize all bits to '0'
					for i in 0 to 255 loop
						for j in 0 to 7 loop
							if InvSBox(i)(j) = '1' then
            IndicesOut(j) <= '1';
        end if;
    end loop;
end loop;


                finish_DECSubBytes <= '1'; -- Indicate operation completion
            else
                finish_DECSubBytes <= '0';
            end if;
        end if;
    end process;

end Behavioral;









