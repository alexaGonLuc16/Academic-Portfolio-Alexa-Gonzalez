----------------------------------------------------------------------------------
-- Company:				ITESM - IRS 2024
-- Engineers:        Emanuel Vega, Ricard Catalá
-- Create Date: 		16/04/2024
-- Design Name: 		Encriptador
-- Module Name:		Top Module
-- Project Name: 		Encriptador AES
-- Target Devices: 	DE10-Lite
-- Description: 		Encriptador basaso en el AES
--
-- Version 0.0 - File Creation
-- Additional Comments: 
--
----------------------------------------------------------------------------------

-- Commonly used libraries
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

-- Entity declaration
entity Top is
    Port (
        -- Input ports
        TxtIn : in std_logic_vector(127 Downto 0);
        Clk : in std_logic;
		  Rst : in std_logic;
        -- Output ports
        CypherTxt : out std_logic_vector(127 Downto 0)
    );
end Top;

-- Architecture definition
architecture Behavioral of Top is
	 --Component declaration
	 component KeySchedule is
		port(
			Start : in std_logic;
			Clk : in std_logic;
			Rst : in std_logic;
			KeySel : in std_logic_vector (3 Downto 0);
			KeyOut : out std_logic_vector(127 Downto 0);
			Finish : out std_logic
			);
	 end component;
			
	 component MUXSubBytes is
		port(
			IntA : in std_logic_vector(127 Downto 0);
			IntB : in std_logic_vector(127 Downto 0);
			Sel : in std_logic;
			MuxOut : in std_logic_vector(127 Downto 0)
			);
	 end component;
			
	 component AddRoundKey is 
		port(
			TxtIn : in std_logic_vector(127 Downto 0);
			KeyIn : in std_logic_vector(127 Downto 0);
			Start : in std_logic;
			Clk : in std_logic;
			Rst : in std_logic;
			TxtOut : out std_logic_vector(127 Downto 0);
			Finish : out std_logic
			);
	 end component;
			
	 component SubBytes is 
		port(
			TxtIn : in std_logic_vector(127 Downto 0);
			Start : in std_logic;
			Clk : in std_logic;
			Rst : in std_logic;
			TxtOut : out std_logic_vector(127 Downto 0);
			Finish : out std_logic
			);
	 end component;
		
	 component  ShiftRows is 
		port(
			TxtIn : in std_logic_vector(127 Downto 0);
			Start : in std_logic;
			Clk : in std_logic;
			Rst : in std_logic;
			TxtOut : out std_logic_vector(127 Downto 0);
			Finish : out std_logic
			);
	 end component;
			
	 component MixColumns is 
		port(
			TxtIn : in std_logic_vector(127 Downto 0);
			Start : in std_logic;
			Clk : in std_logic;
			Rst : in std_logic;
			TxtOut : out std_logic_vector(127 Downto 0);
			Finish : out std_logic
			);
	 end component;
			
	 component StateMachine is
		port(
			Start_AddRound0 : out std_logic;
			Finish_AddRound0 : in std_logic;
			
			Start_SubBytes_loop : out std_logic;
			Finish_SubBytes_loop : in std_logic;
			
			Start_ShiftRow_loop : out std_logic;
			Finish_ShiftRow_loop : in std_logic;
			
			Start_MixColumns_loop : out std_logic;
			Finish_MixColumns_loop : in std_logic;
			
			Start_AddRoundKey_loop : out std_logic;
			Finish_AddRoundKey_loop : in std_logic;
			
			Start_SubBytes_final : out std_logic;
			Finish_SubBytes_final : in std_logic;
			
			Start_ShiftRow_final : out std_logic;
			Finish_ShiftRow_final : in std_logic;
			
			Start_AddRoundKey_final : out std_logic;
			Finish_AddRoundKey_final : in std_logic;
			
			Start_Key : out std_logic;
			Finish_Key : in std_logic;
			KeySel : out std_logic_vector(3 Downto 0);
			
			MuxSel : out std_logic;
			Clk : in std_logic;
			Rst : in std_logic
			
			);	
	 end component;

    -- Internal signals
	 --u1
    signal FinishAdd0_emb : std_logic;
	 signal TxtOutAdd0_emb : std_logic_vector(127 Downto 0);
	 
	 --u2
	 signal FinishSub0_emb : std_logic;
	 signal TxtOutSub0_emb : std_logic_vector(127 Downto 0);
	 
	 --u3
	 signal FinishShift0_emb : std_logic;
	 signal TxtOutShift0_emb : std_logic_vector(127 Downto 0);
	 
	 --u4
	 signal FinishMix_emb : std_logic;
	 signal TxtOutMix_emb : std_logic_vector(127 Downto 0);
	 
	 --u5
	 signal FinishAdd1_emb : std_logic;
	 signal TxtOutAdd1_emb : std_logic_vector(127 Downto 0);
	 
	 --u6
	 signal FinishSub1_emb : std_logic;
	 signal TxtOutSub1_emb : std_logic_vector(127 Downto 0);
	 
	 --u7
	 signal FinishShift1_emb : std_logic;
	 signal TxtOutShift1_emb : std_logic_vector(127 Downto 0);
	 
	 --u8
	 signal FinishAdd2_emb : std_logic;
	 signal TxtOutAdd2_emb : std_logic_vector(127 Downto 0);
	 
	 --u9 Mux
	 signal MuxOut_emb : std_logic_vector(127 Downto 0);
	 
	 --u10 keyschedule
	 signal FinishKey_emb : std_logic;
	 signal KeyOut_emb : std_logic_vector(127 Downto 0);
	 
	 --u11 state machine
	 signal Start_AddRound0_emb : std_logic;
	 signal Start_SubBytes_loop_emb : std_logic;
	 signal Start_ShiftRow_loop_emb : std_logic;
	 signal Start_MixColumns_loop_emb : std_logic;
	 signal Start_Key_emb : std_logic;
	 signal KeySel_emb : std_logic_vector(3 Downto 0);
	 
	 signal Start_AddRoundKey_loop_emb : std_logic;
	 signal Start_SubBytes_final_emb : std_logic;
	 signal Start_ShiftRow_final_emb : std_logic;
	 signal Start_AddRoundKey_final_emb : std_logic;
	 signal MuxSel_emb : std_logic;

begin
    u1: AddRoundKey	
		port map(
			TxtIn => TxtIn,
			KeyIn => KeyOut_emb,
			Start => Start_AddRound0_emb,
			Clk => Clk,
			Rst => Rst,
			TxtOut => TxtOutAdd0_emb,
			Finish => FinishAdd0_emb
			);
		
	 u2: SubBytes
		port map(
			TxtIn => MuxOut_emb,
			Start => Start_SubBytes_loop_emb,
			Clk => Clk,
			Rst => Rst,
			TxtOut => TxtOutSub0_emb,
			Finish => FinishSub0_emb
			);
			
	 u3: ShiftRows
		port map(
			TxtIn => TxtOutSub0_emb,
			Start => Start_ShiftRow_loop_emb,
			Clk => Clk,
			Rst => Rst,
			TxtOut => TxtOutShift0_emb,
			Finish => FinishShift0_emb
			);
			
	 u4: MixColumns
		port map(
			TxtIn => TxtOutShift0_emb,
			Start => Start_MixColumns_loop_emb,
			Clk => Clk,
			Rst => Rst,
			TxtOut => TxtOutMix_emb,
			Finish => FinishMix_emb
			);
			
	 u5: AddRoundKey
		port map(
			TxtIn => TxtOutMix_emb,
			KeyIn => KeyOut_emb,
			Start => Start_AddRoundKey_loop_emb,
			Clk => Clk,
			Rst => Rst,
			TxtOut => TxtOutAdd1_emb,
			Finish => FinishAdd1_emb
			);
			
	 u6: SubBytes
		port map(
			TxtIn => TxtOutAdd1_emb,
			Start => Start_SubBytes_final_emb,
			Clk => Clk,
			Rst => Rst,
			TxtOut => TxtOutSub1_emb,
			Finish => FinishSub1_emb
			);
			
	 u7: ShiftRows
		port map(
			TxtIn => TxtOutSub1_emb,
			Start => Start_ShiftRow_final_emb,
			Clk => Clk,
			Rst => Rst,
			TxtOut => TxtOutShift1_emb,
			Finish => FinishShift1_emb
			);
			
	 u8: AddRoundKey
		port map(
			TxtIn => TxtOutShift1_emb,
			KeyIn => KeyOut_emb,
			Start => Start_AddRoundKey_final_emb,
			Clk => Clk,
			Rst => Rst,
			TxtOut => CypherTxt,
			Finish => FinishAdd2_emb
			);
		
	 u9: MUXSubBytes
		port map(
			IntA => TxtOutAdd0_emb,
			IntB => TxtOutAdd1_emb,
			Sel => MuxSel_emb,
			MuxOut => MuxOut_emb
			);
	
	 u10: KeySchedule
		port map(
			Start => Start_key_emb,
			Clk => Clk,
			Rst => Rst,
			KeySel => KeySel_emb,
			KeyOut => KeyOut_emb,
			Finish => FinishKey_emb
			);
			
	 u11: StateMachine
		 port map(
			Start_AddRound0 => Start_AddRound0_emb,
			Finish_AddRound0 => FinishAdd0_emb,
			
			Start_SubBytes_loop => Start_SubBytes_loop_emb,
			Finish_SubBytes_loop => FinishSub0_emb,
			
			Start_ShiftRow_loop => Start_ShiftRow_loop_emb,
			Finish_ShiftRow_loop => FinishShift0_emb,
			
			Start_MixColumns_loop => Start_MixColumns_loop_emb,
			Finish_MixColumns_loop => FinishMix_emb,
			
			Start_AddRoundKey_loop => Start_AddRoundKey_loop_emb,
			Finish_AddRoundKey_loop => FinishAdd1_emb,
			
			Start_SubBytes_final => Start_SubBytes_final_emb,
			Finish_SubBytes_final => FinishSub1_emb,
			
			Start_ShiftRow_final => Start_ShiftRow_final_emb,
			Finish_ShiftRow_final => FinishShift1_emb,
			
			Start_AddRoundKey_final => Start_AddRoundKey_final_emb,
			Finish_AddRoundKey_final => FinishAdd2_emb,
			
			Start_Key => Start_Key_emb,
			Finish_Key => FinishKey_emb,
			KeySel => KeySel_emb,
			
			MuxSel => MuxSel_emb,
			Clk => Clk,
			Rst => Rst
			);
end Behavioral;