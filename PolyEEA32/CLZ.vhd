----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:40:57 07/08/2015 
-- Design Name: 
-- Module Name:    CLZ - Behavioral 
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
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity CLZ is
	generic (N : integer:=32);
    Port ( Input : in  STD_LOGIC_VECTOR (N-1 downto 0);
           Degree : out  STD_LOGIC_VECTOR (7 downto 0)); -- (Log N downto 0)
end CLZ;

architecture Behavioral of CLZ is

begin
PROCESS (Input)
BEGIN
for i in Input'range loop
  if (Input(i) = '1') then
    Degree <= std_logic_vector(to_unsigned(i,8));
    exit;
  end if;
end loop;
end PROCESS;
--int clz(unsigned int x) // parallel computation of CLZ
--{  static const unsigned int bval[] =
--    {0,1,2,2,3,3,3,3,4,4,4,4,4,4,4,4};
--    unsigned int r = 0;
--    if (x & 0xFFFF0000) { r += 16/1; x >>= 16/1; } //16-1 works
--    if (x & 0x0000FF00) { r += 16/2; x >>= 16/2; }
--    if (x & 0x000000F0) { r += 16/4; x >>= 16/4; }
--    
--    return 32-(r + bval[(x & 0x0000F000)]+ bval[(x & 0x00000F00)]
--    + bval[(x & 0x000000F0)]+ bval[(x & 0x0000000F)]);}  //Should be for each digit of x!
--
--Degree <= r + bval[x(15 downto 12)]+ bval[x(11 downto 8)]
-- + bval[x(7 downto 4)]+ bval[x(3 downto 0)];}  //Should be for each digit of x!*/
--Degree <= Input(7 downto 0);
end Behavioral;

