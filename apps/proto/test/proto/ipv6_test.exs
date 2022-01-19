defmodule Proto.IPv6Test do

    use ExUnit.Case, async: true
    
    alias Proto.IPv6, as: IPv6

    test "localhost address" do
        data = <<0x00::size(0x70),0x01::size(0x10)>>
        assert IPv6.address(data) == "::1"
    end

    test "inet6 address" do
        data = <<0x2001::size(16),0x1a50::size(16),0x7::size(16),0x1::size(16),0x0::size(48),0x98::size(16)>>
        assert IPv6.address(data) == "2001:1a50:7:1::98"
    end
    
    test "link local address" do
        data = <<0xfe80::size(16),0x0::size(48),0xc62c::size(16),0x3ff::size(16),0xfe0c::size(16),0xfecd::size(16)>>
        assert IPv6.address(data) == "fe80::c62c:3ff:fe0c:fecd"
    end
    
    test "no double shortening" do
        <<data::binary>> = <<0x1111::size(16),0x0::size(32),0x22223333::size(32),0x0::size(32),0x4444::size(16)>>
        ret= case IPv6.address(data) do
            "1111::2222:3333:0:0:4444" -> true
            "1111:0:0:2222:3333::4444" -> true
            _ -> false
        end
        assert ret
    end
end