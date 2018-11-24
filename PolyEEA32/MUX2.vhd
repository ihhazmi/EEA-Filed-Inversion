----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:20:50 02/28/2015 
-- Design Name: 
-- Module Name:    MUX2 - Behavioral 
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MUX2 is
    Generic (n: integer);
    Port ( in0 : in  STD_LOGIC_VECTOR (n-1 downto 0);
           in1 : in  STD_LOGIC_VECTOR (n-1 downto 0);
           ctl : in  STD_LOGIC;
           result : out  STD_LOGIC_VECTOR (n-1 downto 0));
end MUX2;

architecture Behavioral of MUX2 is

begin

	process(in0,in1,ctl)
		begin
			case ctl is
				when '0' => result <= in0;
				when '1' => result <= in1;
				when others => result <= "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ";
			end case;
	end process;

end Behavioral;

