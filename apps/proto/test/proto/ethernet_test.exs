defmodule Proto.EthernetTest do

    use ExUnit.Case, async: true
    
    alias Proto.Ethernet, as: Ethernet
    
    test "simple address" do
        <<addr::size(48)>> = <<0x00,0x11,0x22,0x33,0x44,0x55>>
        assert Ethernet.address(addr) == "00:11:22:33:44:55"
    end

    test "next address" do
        assert Ethernet.address(<<0x00,0x11,0x22,0x33,0x44,0x55>>) == "00:11:22:33:44:55"
    end
end