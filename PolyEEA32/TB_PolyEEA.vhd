--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   03:02:54 07/28/2015
-- Design Name:   
-- Module Name:   M:/Desktop/Euclidean_Alg/PolyGCD32/TB_PolyGCD.vhd
-- Project Name:  PolyGCD32
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: PolyGCD
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY TB_PolyGCD IS
END TB_PolyGCD;
 
ARCHITECTURE behavior OF TB_PolyGCD IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT PolyGCD
    PORT(
         ax : IN  std_logic_vector(31 downto 0);
         fx : IN  std_logic_vector(31 downto 0);
         clock : IN  std_logic;
         reset : IN  std_logic;
         Start : IN  std_logic;
         GCD : OUT  std_logic_vector(31 downto 0);
         q : OUT  std_logic_vector(31 downto 0);
         Finish : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal ax : std_logic_vector(31 downto 0) := (others => '0');
   signal fx : std_logic_vector(31 downto 0) := (others => '0');
   signal clock : std_logic := '0';
   signal reset : std_logic := '0';
   signal Start : std_logic := '0';

 	--Outputs
   signal GCD : std_logic_vector(31 downto 0);
   signal q : std_logic_vector(31 downto 0);
   signal Finish : std_logic;

   -- Clock period definitions
   constant clock_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: PolyGCD PORT MAP (
          ax => ax,
          fx => fx,
          clock => clock,
          reset => reset,
          Start => Start,
          GCD => GCD,
          q => q,
          Finish => Finish
        );

   -- Clock process definitions
   clock_process :process
   begin
		clock <= '0';
		wait for clock_period/2;
		clock <= '1';
		wait for clock_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

		reset <= '1';

      wait for clock_period*8;
		reset <= '0';
		Start <= '1';

      ax <= x"00000105";
      fx <= x"0000AA66";

      wait for clock_period*21;
		reset <= '1';
      wait for clock_period;
		reset <= '0';
		
      ax <= x"00000007"; -- WE HAVE A PROBLEM TO SOLVE SUCH NUMBERS WITH SMALL NUMBERS
      fx <= x"0000000F"; -- IT SHOULD GIVE R=1 WHICH IT DOES AND Q=2 WCHIT DOESN'T IT GIVES (8) INSTEAD

      wait for clock_period*8;
		reset <= '1';
      wait for clock_period;
		reset <= '0';
		
      ax <= x"00000205";
      fx <= x"0000E21A";


      wait for clock_period*23;
		reset <= '1';
      wait for clock_period;
		reset <= '0';
		
      ax <= x"00000317";
      fx <= x"0000D3F4";


      wait;
   end process;

END;
