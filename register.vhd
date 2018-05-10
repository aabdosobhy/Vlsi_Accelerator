library ieee;
use ieee.std_logic_1164.all;

entity my_register_file is
  port(port1_sel, port2_sel, write_sel: in std_logic_vector(1 downto 0);
    clk,rst,write_en : in std_logic;
    write_val : in std_logic_vector(7 downto 0);
    port1_data, port2_data: out std_logic_vector(7 downto 0)
  );
end my_register_file;

architecture a_my_register_file of my_register_file is
  component small_register is
    generic (n:integer :=8);
  port( clk, rst, e : in std_logic;
        d: in std_logic_vector(n-1 downto 0);
        q: out std_logic_vector(n-1 downto 0)
      );
    end component;
    signal dataIn_1,dataIn_2,dataIn_3,dataIn_4,dataOut_1,dataOut_2,dataOut_3,dataOut_4 : std_logic_vector (7 downto 0);
    signal en : std_logic_vector (3 downto 0);
begin
     reg1: small_register generic map(n=>8) port map (clk=>clk,rst=>rst, e=>en(3), d=>dataIn_1,q=>dataOut_1);
     reg2: small_register generic map(n=>8) port map (clk=>clk,rst=>rst, e=>en(2), d=>dataIn_2,q=>dataOut_2);
     reg3: small_register generic map(n=>8) port map (clk=>clk,rst=>rst, e=>en(1), d=>dataIn_3,q=>dataOut_3);
     reg4: small_register generic map(n=>8) port map (clk=>clk,rst=>rst, e=>en(0), d=>dataIn_4,q=>dataOut_4);  
       
     process (clk, rst, port1_sel, port2_sel, write_sel, write_en, write_val, dataOut_1, dataOut_2, dataOut_3, dataOut_4) 
      begin
        if write_en = '0' then
          case port1_sel is 
          when "00" => port1_data<=dataOut_1;
          when "01" => port1_data<=dataOut_2;
          when "10" => port1_data<=dataOut_3;
          when others => port1_data<=dataOut_4;
          end case;
          
          case port2_sel is 
          when "00" => port2_data<=dataOut_1;
          when "01" => port2_data<=dataOut_2;
          when "10" => port2_data<=dataOut_3;
          when others => port2_data<=dataOut_4;
          end case;
        else
          case write_sel is
          when "00" => dataIn_1<=write_val;
          when "01" => dataIn_2<=write_val;
          when "10" => dataIn_3<=write_val;
          when others => dataIn_4<=write_val;
          end case;
          
          case write_sel is
          when "00" => en <= "1000";
          when "01" => en <= "0100";
          when "10" => en <= "0010";
          when others => en <= "0001";
          end case;
          
          end if;
      end process;
  
end a_my_register_file; 