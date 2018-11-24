----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:40:45 12/19/2014 
-- Design Name: 
-- Module Name:    XORN - Behavioral 
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

--use IEEE.NUMERIC_STD.ALL;

library UNISIM;
use UNISIM.VComponents.all;

entity XORN is
--	generic (N : integer);
	PORT(
				A, B	: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
				O	: OUT STD_LOGIC_VECTOR(3 DOWNTO 0) 
			);

end XORN;

architecture STR_XORN of XORN is

-- XOR  LOCATIONS ATTRIBUTES
-- attribute LOC: string;
-- attribute LOC of XOR_0 : label is "SLICE_X12Y8";
-- attribute LOC of XOR_1 : label is "SLICE_X12Y8";
-- attribute LOC of XOR_2 : label is "SLICE_X12Y8";
-- attribute LOC of XOR_3 : label is "SLICE_X12Y8";
--

begin

-- PROPAGATION XORS
XOR_0: LUT2 generic map (INIT => X"6")
				 port map (O => O(0), I0 => A(0), I1 => B(0));
XOR_1: LUT2 generic map (INIT => X"6")
				 port map (O => O(1), I0 => A(1), I1 => B(1));
XOR_2: LUT2 generic map (INIT => X"6")
				 port map (O => O(2), I0 => A(2), I1 => B(2));
XOR_3: LUT2 generic map (INIT => X"6")
				 port map (O => O(3), I0 => A(3), I1 => B(3));

end STR_XORN;

