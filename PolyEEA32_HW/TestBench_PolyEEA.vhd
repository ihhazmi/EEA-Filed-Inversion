--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:11:31 07/31/2015
-- Design Name:   
-- Module Name:   M:/Desktop/Euclidean_Alg/PolyEEA32/TestBench_PolyEEA.vhd
-- Project Name:  PolyEEA32
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: PolyEEA
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
 
ENTITY TestBench_PolyEEA IS
END TestBench_PolyEEA;
 
ARCHITECTURE behavior OF TestBench_PolyEEA IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT PolyEEA
    PORT(
         ax : IN  std_logic_vector(31 downto 0);
         fx : IN  std_logic_vector(31 downto 0);
         clock : IN  std_logic;
         reset : IN  std_logic;
         Start : IN  std_logic;
         GCD : OUT  std_logic_vector(31 downto 0);
         a_inv : OUT  std_logic_vector(31 downto 0);
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
   signal a_inv : std_logic_vector(31 downto 0);
   signal Finish : std_logic;

   -- Clock period definitions
   constant clock_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: PolyEEA PORT MAP (
          ax => ax,
          fx => fx,
          clock => clock,
          reset => reset,
          Start => Start,
          GCD => GCD,
          a_inv => a_inv,
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

      ax <= x"00000053"; -- ax^-1 = x"ca"
      fx <= x"0000011b";

      wait for clock_period*16;
		reset <= '1';
      wait for clock_period;
		reset <= '0';

      ax <= x"0000000f"; -- ax^-1 = x"f"
      fx <= x"00000015";

      wait for clock_period*18;
		reset <= '1';
      wait for clock_period;
		reset <= '0';
		
      ax <= x"00000002"; -- ax^-1 = x"3"
      fx <= x"00000007"; 
		
      wait for clock_period*8;
		reset <= '1';
      wait for clock_period;
		reset <= '0';
		
      ax <= x"00000005"; -- ax^-1 = x"7"
      fx <= x"0000000d";


      wait for clock_period*14;
		reset <= '1';
      wait for clock_period;
		reset <= '0';
		
      ax <= x"00000317";
      fx <= x"0000D3F4";



      wait;
   end process;

END;
