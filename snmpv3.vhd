----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:32:08 05/03/2019 
-- Design Name: 
-- Module Name:    snmpv3 - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity snmpv3 is
	port(
		--input 
		service_number : in std_logic_vector(2 downto 0);
		clk : in std_logic;
		--output
		result_out : out std_logic;
		latency : out std_logic_vector(7 downto 0);
		throughput : out std_logic_vector(7 downto 0);
		packets_dropped : out std_logic_vector(7 downto 0);
		
		--debug
		cstate : out std_logic_vector(2 downto 0)
	);
end snmpv3;


architecture Behavioral of snmpv3 is

	component snmp_agent
	port(
		recv_packet : in std_logic;
		send_packet : out std_logic;
		in_packet : in std_logic_vector(274 downto 0);
		out_packet : out std_logic_vector(274 downto 0)
	);
	end component;
	
	component snmp_agent1
	port(
		recv_packet : in std_logic;
		send_packet : out std_logic;
		in_packet : in std_logic_vector(274 downto 0);
		out_packet : out std_logic_vector(274 downto 0)
	);
	end component;
	
	component snmp_agent2
	port(
		recv_packet : in std_logic;
		send_packet : out std_logic;
		in_packet : in std_logic_vector(274 downto 0);
		out_packet : out std_logic_vector(274 downto 0)
	);
	end component;

--main snmp application layer message
type logic_array is array(0 to 2) of std_logic;
type packets_array is array(0 to 2) of std_logic_vector(274 downto 0);
signal snmp_message_sent,snmp_message_received : packets_array;
signal recv_packet,send_packet : logic_array;

--state definitions
type statetype is (idle,send,recv);
signal pstate  :statetype:= idle;


begin
	uut0 : snmp_agent 
	port map(
		recv_packet => send_packet(0),
		in_packet => snmp_message_sent(0),
		send_packet => recv_packet(0),
		out_packet => snmp_message_received(0)
	);
	
	uut1 : snmp_agent1 
	port map(
		recv_packet => send_packet(1),
		in_packet => snmp_message_sent(1),
		send_packet => recv_packet(1),
		out_packet => snmp_message_received(1)
	);
	
	uut2 : snmp_agent2 
	port map(
		recv_packet => send_packet(2),
		in_packet => snmp_message_sent(2),
		send_packet => recv_packet(2),
		out_packet => snmp_message_received(2)
	);
	
	main: process(clk)
			variable id : integer ;
			variable tmp : std_logic_vector(274 downto 0);
	begin
		if(rising_edge(clk))then 
			
			case pstate is 
				when idle =>
					cstate <= "001";
					result_out <= '0';
					send_packet <= ('0','0','0');
					latency <= (others => '0');
					throughput <= (others => '0');
					packets_dropped <= (others => '0');
					
					if(service_number="000")then
						pstate <= idle;
					else
						-- service required goto send state
						pstate <= send;
						id := to_integer(unsigned(service_number));
					end if;
					
				when send =>
					cstate <= "010";
					result_out <= '0';
					--prepare the snmp message packet to send
					
					tmp(274 downto 272) := "001";
					tmp(271 downto 264) := (others => '1');
					tmp(263 downto 261) := "010";
					tmp(260 downto 253) := (others => '1');
					tmp(252 downto 245) := (others => '1');
					tmp(244 downto 242) := "011";
					tmp(241 downto 234) := (others => '1');
					tmp(233 downto 226) := (others => '1');
					--get req
					tmp(225 downto 223) := "100";
					tmp(222 downto 215) := (others => '1');
					--req id
					tmp(214 downto 212) := "010";
					tmp(211 downto 204) := (others => '1');
					tmp(203 downto 196) := "00000" & service_number;
					
					--error
					tmp(195 downto 193) := "010";
					tmp(192 downto 185) := (others => '1');
					tmp(184 downto 177) := (others => '0');
					
					--error index
					tmp(176 downto 174) := "010";
					tmp(173 downto 166) := (others => '1');
					tmp(165 downto 158) := (others => '0');
					
					--varlist 
					
					tmp(157 downto 155) := "001";
					tmp(154 downto 147) := (others => '1');
					
					--lat
					tmp(146 downto 144) := "001";
					tmp(143 downto 136) := (others => '1');
					
					
					tmp(135 downto 133) := "110";
					tmp(132 downto 125) := (others => '1');
					tmp(124 downto 117) := (others => '1');
					
					
					tmp(116 downto 114) := "010";
					tmp(113 downto 106) := (others => '1');
					tmp(105 downto 98) := (others => '1');
					
					--- lat ends
					
					--thr
					tmp(97 downto 95) := "001";
					tmp(94 downto 87) := (others => '1');
					
					
					tmp(86 downto 84) := "110";
					tmp(83 downto 76) := (others => '1');
					tmp(75 downto 68) := (others => '1');
					
					
					tmp(67 downto 65) := "010";
					tmp(64 downto 57) := (others => '1');
					tmp(56 downto 49) := (others => '1');
					
					--- thr ends
					
					--pd
					tmp(48 downto 46) := "001";
					tmp(45 downto 38) := (others => '1');
					
					
					tmp(37 downto 35) := "110";
					tmp(34 downto 27) := (others => '1');
					tmp(26 downto 19) := (others => '1');
					
					
					tmp(18 downto 16) := "010";
					tmp(15 downto 8) := (others => '1');
					tmp(7 downto 0) := (others => '1');
					
					--- pd ends
					
					
					snmp_message_sent(id-1) <= tmp;
					---preparation ends here
					send_packet(id-1) <= '1';
					pstate <= recv;
					
				when recv =>
					cstate <= "011";
					if(recv_packet(id-1)='0')then
						result_out <= '0';
						pstate <= recv;
					else
						result_out <= '1';
						--process message to get values
						latency <= snmp_message_received(id-1)(105 downto 98);
						throughput <= snmp_message_received(id-1)(56 downto 49);
						packets_dropped <= snmp_message_received(id-1)(7 downto 0);
						---processing ends here
						pstate <= idle;
					end if;
			
			end case ;
			
		end if;
	end process main;
	
end Behavioral;