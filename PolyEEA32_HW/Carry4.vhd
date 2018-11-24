
----------------------------------------------------------------------------------
-- Company: UVIC  			  -----------------------------------------------------
-- Engineer: Ibrahim Hazmi   -----------------------------------------------------
-- Create Date: 08/28/2015   -----------------------------------------------------
-- VHDL Module for CARRY_4   -----------------------------------------------------
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
library UNISIM;
use UNISIM.VComponents.all;

entity CARRY_4 is
	Port (	S, DI : in  STD_LOGIC_VECTOR (3 downto 0);
				CI : in  STD_LOGIC;
--				CYINIT : in  STD_LOGIC;
				CO: inout  STD_LOGIC_VECTOR (3 downto 0);
				O: out  STD_LOGIC_VECTOR (3 downto 0));
end CARRY_4;

architecture Structural of CARRY_4 is
begin
MUXCY_0: MUXCY port map (O => CO(0), CI => CI, DI => DI(0), S => S(0));
XORCY_0: XORCY port map (O => O(0), CI => CI, LI => S(0)); -- O(0) <= S(0) xor CI;
MUXCY_1: MUXCY port map (O => CO(1), CI => CO(0), DI => DI(1), S => S(1));
XORCY_1: XORCY port map (O => O(1), CI => CO(0), LI => S(1)); -- O(1) <= S(1) xor CO(0);
MUXCY_2: MUXCY port map (O => CO(2), CI => CO(1), DI => DI(2), S => S(2));
XORCY_2: XORCY port map (O => O(2), CI => CO(1), LI => S(2)); -- O(2) <= S(2) xor CO(1);
MUXCY_3: MUXCY port map (O => CO(3), CI => CO(2), DI => DI(3), S => S(3));
XORCY_3: XORCY port map (O => O(3), CI => CO(2), LI => S(3)); -- O(3) <= S(3) xor CO(2);
end Structural;

--XORCY_0 : XORCY port map(O => O, CI => CI, LI => LI );
--MUXCY_0: MUXCY port map (O => O, CI => CI, DI => DI, S => S);
--CARRY4_A0 : CARRY4
--port map (
--CO => C1A(3 DOWNTO 0), -- 4-bit carry out
--O => SUBA(3 DOWNTO 0), -- 4-bit carry chain XOR data out
--CI => '1', -- 1-bit carry cascade input
--CYINIT => '0', -- 1-bit carry initialization
--DI => I1X(3 DOWNTO 0), -- 4-bit carry-MUX data in
--S => PA(3 DOWNTO 0) -- 4-bit carry-MUX select input
--);


