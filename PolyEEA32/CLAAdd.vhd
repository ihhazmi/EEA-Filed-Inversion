----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Ibrahim Hazmi
-- Create Date:    14:18:54 11/25/2014 
-- Module Name:    CLAAdd - Behavioral 
-- Revision 0.01 - File Created
-- Additional Comments: 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library UNISIM;
use UNISIM.VComponents.all;

entity SAD is
	generic (N : integer := 8);
    Port ( 	I1, I2 : in  STD_LOGIC_VECTOR (N-1 downto 0);
				GNA : INout  STD_LOGIC;
				SUBA : out  STD_LOGIC_VECTOR (N-1 downto 0)
				);
end SAD;
architecture Behavioral of SAD is


--SIGNALS DECLARARION;
Signal NI2, GA, PA, C1A, I1X : STD_LOGIC_VECTOR(N-1 downto 0);
Signal GB4A, PB4A : STD_LOGIC_VECTOR(N/4 downto 1);
Signal NGNA : STD_LOGIC;
begin

NI2 <= NOT I2;

--SUBA PORTMAPPING
-- PROPAGATION XORS
XOR_A40:  entity work.XORN port map(O => PA(3 DOWNTO 0), A => I1(3 DOWNTO 0), B => NI2(3 DOWNTO 0));
XOR_A41:  entity work.XORN port map(O => PA(7 DOWNTO 4), A => I1(7 DOWNTO 4), B => NI2(7 DOWNTO 4));
--GENERATION ANDS
AND_A40: entity work.ANDN port map(O => GA(3 DOWNTO 0), A => I1(3 DOWNTO 0), B => NI2(3 DOWNTO 0));
AND_A41: entity work.ANDN port map(O => GA(7 DOWNTO 4), A => I1(7 DOWNTO 4), B => NI2(7 DOWNTO 4));

-- A BLOCKS FOR GNA, CnA
-- GP_LOCKS
AGPBLOCK: FOR i IN 1 TO (N/4) generate
PB4A(i) <= PA(4*i-1) AND PA(4*i-2) AND PA(4*i-3)AND PA(4*i-4);
GB4A(i) <= GA(4*i-1) OR (GA(4*i-2) AND PA(4*i-1)) OR 
								(GA(4*i-3) AND PA(4*i-1) AND PA(4*i-2)) OR
								(GA(4*i-4) AND PA(4*i-1) AND PA(4*i-2) AND PA(4*i-3)); 
END Generate AGPBLOCK;

-- GN_SUPBLOCK to descide IF A>B!
GNA <= GB4A(2) OR (GB4A(1) AND PB4A(2)); 

--
NGNA <= NOT GNA;
-- THE ABSOLUTE SUBTRACTION PROPAGATION XORS
XOR_A400: entity work.XORN port map(O => I1X(3 DOWNTO 0), A => I1(3 DOWNTO 0), B(3) => NGNA, B(2) => NGNA, B(1) => NGNA, B(0) => NGNA);
XOR_A410: entity work.XORN port map(O => I1X(7 DOWNTO 4), A => I1(7 DOWNTO 4), B(3) => NGNA, B(2) => NGNA, B(1) => NGNA, B(0) => NGNA);


-- CARRY4 Prot Mapping
-- SUBA
CARRY4_A0 : CARRY4
port map (
CO => C1A(3 DOWNTO 0), -- 4-bit carry out
O => SUBA(3 DOWNTO 0), -- 4-bit carry chain XOR data out
CI => '1', -- 1-bit carry cascade input
CYINIT => '0', -- 1-bit carry initialization
DI => I1X(3 DOWNTO 0), -- 4-bit carry-MUX data in
S => PA(3 DOWNTO 0) -- 4-bit carry-MUX select input
);

CARRY4_A1 : CARRY4
port map (
CO => C1A(7 DOWNTO 4), 
O 	=> SUBA(7 DOWNTO 4), 
CI => C1A(3), 
CYINIT => '0', 
DI => I1X(7 DOWNTO 4), 
S 	=> PA(7 DOWNTO 4) 
);

end Behavioral;


