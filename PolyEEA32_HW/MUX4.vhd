
----------------------------------------------------------------------------------
-- Company: UVIC  			  -----------------------------------------------------
-- Engineer: Ibrahim Hazmi   -----------------------------------------------------
-- Create Date: 08/28/2015   -----------------------------------------------------
-- VHDL Module for Mux 8x1   -----------------------------------------------------
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Mux4x1 is
	Generic (n: integer);
	Port (	s : in  STD_LOGIC_VECTOR (1 downto 0);
				ax, fx : out  STD_LOGIC_VECTOR (n-1 downto 0));
end Mux4x1;

architecture Behavioral of Mux4x1 is
-- Signal a, b, c, d: STD_LOGIC_VECTOR(n-1 downto 0);
begin
  process (s)
    begin
      case s is
			when "00" => ax <= x"00000002"; fx <= x"00000007"; -- a_inv = 00000003
			when "01" => ax <= x"00000005"; fx <= x"0000000d"; -- a_inv = 00000007
--			when "10" => ax <= x"0000000f"; fx <= x"00000015"; -- a_inv = 0000000f
			when "10" => ax <= x"000f0084"; fx <= x"00100021"; -- a_inv = 0000000f
			when "11" => ax <= x"00000053"; fx <= x"0000011b"; -- a_inv = 000000ca
			when others => 
				for i in 0 to n-1 loop
					ax(i) <= 'Z';
					fx(i) <= 'Z';
				end loop;
      end case;
  end process;
end Behavioral;

  -- 1- (x + 1) is a multiplicative inverse of ((x) mod(x^2 + x + 1)) 
  -- 0x:(00000003) is a multiplicative inverse of ((00000002) mod(00000007))
  -- 2- (x^2 + x + 1) is a multiplicative inverse of ((x^2 + 1) mod(x^3 + x^2 + 1))
  -- 0x:(00000007) is a multiplicative inverse of ((00000005) mod(0000000d))
  -- 3- (x^3 + x^2 + x + 1) is a multiplicative inverse of ((x^3 + x^2 + x + 1) mod(x^4 + x^2 + 1))
  -- 0x:(0000000f) is a multiplicative inverse of ((0000000f) mod(00000015))
  -- 4- (x^7 + x^6 + x^3 + x) is a multiplicative inverse of ((x^6 + x^4 + x + 1) mod(x^8 + x^4 + x^3 + x + 1))
  -- 0x:(000000ca) is a multiplicative inverse of ((00000053) mod(0000011b))
