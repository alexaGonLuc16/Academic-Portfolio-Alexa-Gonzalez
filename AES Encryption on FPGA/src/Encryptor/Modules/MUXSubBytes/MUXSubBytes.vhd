----------------------------------------------------------------------------------
-- Company:				ITESM - IRS 2024
-- Author:           Ricard Catalá
-- Create Date: 		30/04/2024
-- Design Name: 		MUXSubBytes
-- Module Name:		MUXSubBytes Module
-- Target Devices: 	DE10-Lite
-- Description: 		MUXSubBytes Module
--
-- Version 1.0 - Implementation MUX 2x1
----------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity MUXSubBytes is
    Port (
        -- Input ports
        IntA : in std_logic_vector(127 downto 0);
        IntB : in std_logic_vector(127 downto 0);
		  Sel : in std_logic;
        -- Output ports
        MuxOut: out std_logic_vector(127 downto 0)
		  );
end MUXSubBytes;

architecture Behavioral of MUXSubBytes is
begin
	-- with select mux 2x1
	with sel select MuxOut <=
		IntA when '0',
		IntB when '1';
		
end architecture Behavioral;