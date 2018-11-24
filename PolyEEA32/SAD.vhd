----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:16:17 11/29/2014 
-- Design Name: 
-- Module Name:    SAD - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity SAD is
	generic (N : integer := 16);
    Port ( A : in  STD_LOGIC_VECTOR (N-1 downto 0);
           B : in  STD_LOGIC_VECTOR (N-1 downto 0);
           GN : inout  STD_LOGIC;
           ABSD : OUT  STD_LOGIC_VECTOR (N-1 downto 0)); -- ABSD = ABS since ABS is preserved word in VHDL	!
end SAD;

architecture Behavioral of SAD is


-- attribute LOC: string;
-- attribute LOC of CBLOCK_0_CARRY4_i : label is "SLICE_X0Y186";
-- attribute LOC of CBLOCK_1_CARRY4_i : label is "SLICE_X0Y186";

Signal G, P, AX, BX, BN : STD_LOGIC_VECTOR(N-1 downto 0);
--Signal ABSD_US : UNSIGNED(N-1 downto 0);
Signal G4, P4 : STD_LOGIC_VECTOR(N/4 downto 1);
SIGNAL CI: STD_LOGIC;

Begin
BN <= NOT B;
P <= A xor BN;
G <= A AND BN;

GP4: FOR i IN 1 TO (N/4) Generate -- 4-BIT BLOCK
P4(i) <= P(4*i-1) AND (P(4*i-2) AND P(4*i-3)AND P(4*i-4));
G4(i) <= G(4*i-1) OR  (G(4*i-2) AND P(4*i-1)) OR 
							 (G(4*i-3) AND P(4*i-1) AND P(4*i-2)) OR
							 (G(4*i-4) AND P(4*i-1) AND P(4*i-2) AND P(4*i-3)); 
END Generate GP4;

-- 16-BIT BLOCK
GN	<= G4(4) OR (G4(3) AND P4(4)) OR
					(G4(2) AND P4(4) AND P4(3)) OR
					(G4(1) AND P4(4) AND P4(3) AND P4(2));
-- GN = '1', WHEN A>B!

ABXOR: FOR i IN 0 TO N-1 Generate
	AX(i) <= A(i) XNOR GN;
	BX(i) <= B(i) XOR GN;
END Generate ABXOR;


--ABSD_US <= UNSIGNED (AX) + UNSIGNED (BX) + "0000000000000001"; -- CARRY IN <= '1'; IN THE 16 BIT ADDER!
--ABSD <= STD_LOGIC_VECTOR(ABSD_US);
CI 	<= '1';
ABSD  <= conv_std_logic_vector((conv_integer(AX) + conv_integer(BX) + conv_integer(CI)),16);
 

end Behavioral;