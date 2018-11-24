----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Ibrahim Hazmi 
-- Create Date:    14:18:54 11/25/2014 
-- Design Name: 
-- Module Name:    CLAAdd - Behavioral 
-- Project Name: 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library UNISIM;
use UNISIM.VComponents.all;

entity CLASUB is
    Port ( 	I1, I2 : in  STD_LOGIC_VECTOR (7 downto 0);
				GNA : out  STD_LOGIC;
				SUBA : out  STD_LOGIC_VECTOR (7 downto 0)
				);
end CLASUB;
architecture Behavioral of CLASUB is

--SIGNALS DECLARARION;
Signal NI2, PA, CA : STD_LOGIC_VECTOR(7 downto 0);

-- SUBA
-- CARRY4 LOCATIONS ATTRIBUTES
 attribute LOC: string;
 attribute LOC of CARRY4_A0 : label is "SLICE_X2Y8";
 attribute LOC of CARRY4_A1 : label is "SLICE_X2Y9";
-- XOR  LOCATIONS ATTRIBUTES
 attribute LOC of XOR_A40 : label is "SLICE_X2Y8";
 attribute LOC of XOR_A41 : label is "SLICE_X2Y9";

begin
NI2 <= NOT I2;
-- PROPAGATION XORS
XOR_A40: entity work.XORN Port Map (O => PA(3 DOWNTO 0), A => I1(3 DOWNTO 0), B => NI2(3 DOWNTO 0));
XOR_A41: entity work.XORN Port Map (O => PA(7 DOWNTO 4), A => I1(7 DOWNTO 4), B => NI2(7 DOWNTO 4));
--  GNA
GNA <= CA(7);
-- CARRY4 Prot Mapping
CARRY4_A0 : CARRY4
port map (
CO => CA(3 DOWNTO 0), -- 4-bit carry out
O => SUBA(3 DOWNTO 0), -- 4-bit carry chain XOR data out
CI => '1', -- 1-bit carry cascade input
CYINIT => '0', -- 1-bit carry initialization
DI => I1(3 DOWNTO 0), -- 4-bit carry-MUX data in
S => PA(3 DOWNTO 0) -- 4-bit carry-MUX select input
);
CARRY4_A1 : CARRY4 port map (CO => CA(7 DOWNTO 4), O 	=> SUBA(7 DOWNTO 4), CI => CA(3), CYINIT => '0', 
									  DI => I1(7 DOWNTO 4), S 	=> PA(7 DOWNTO 4));

end Behavioral;


