defmodule Proto.IPv6 do

    import Proto.Util

    def xx(s) do
        String.downcase(Integer.to_string(s,16))
    end
    
        

    
    def head(<<0x0::size(112),r::binary>>) do "::" <> rest r end
    def head(<<0x0::size(96), r::binary>>) do ":"  <> rest r end
    def head(<<0x0::size(80), r::binary>>) do ":"  <> rest r end
    def head(<<0x0::size(64), r::binary>>) do ":"  <> rest r end
    def head(<<0x0::size(48), r::binary>>) do ":"  <> rest r end
    def head(<<0x0::size(32), r::binary>>) do ":"  <> rest r end
    def head(<<0x0::size(16), r::binary>>) do ":"  <> rest r end
    def head(<<a::size(16)>>) do "#{xx a}" end
    def head(<<a::size(16),r::binary>>) do "#{xx a}:" <> head r end
    
    def rest(<<a::size(16)>>) do "#{xx a}" end
    def rest(<<a::size(16),r::binary>>) do "#{xx a}:" <> rest r end

    

    def address(<<addr::size(128)>>) do
        head <<addr::size(128)>>
    end

    def address(addr) do
        address <<addr::size(128)>>
    end


#   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
#   |Version| Prio. |                   Flow Label                  |
#   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
#   |         Payload Length        |  Next Header  |   Hop Limit   |
#   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
#   |                                                               |
#   +                                                               +
#   |                                                               |
#   +                         Source Address                        +
#   |                                                               |
#   +                                                               +
#   |                                                               |
#   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
#   |                                                               |
#   +                                                               +
#   |                                                               |
#   +                      Destination Address                      +
#   |                                                               |
#   +                                                               +
#   |                                                               |
#   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+


    def parse(<<
            version::size(4), priority::size(4), label::size(24),
            length::size(16), nextheader::size(8), hoplimit::size(8),
            source::size(128),
            destination::size(128),
            data::binary
        >>) do
        msg = "ipv6 #{address source} to #{address destination}"
        {err,ret} = case nextheader do
            _ -> {:error, ["nextheader 0x#{x nextheader}"]}
        end
        {err, [msg | ret]}
    end

end