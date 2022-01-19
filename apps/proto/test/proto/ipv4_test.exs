defmodule Proto.IPv4Test do

    use ExUnit.Case, async: true
    
    alias Proto.IPv4, as: IPv4

    test "simple address" do
        <<addr::size(32)>> = <<0x7f,0x00,0x00,0x01>>
        assert IPv4.address(addr) == "127.0.0.1"
    end

end