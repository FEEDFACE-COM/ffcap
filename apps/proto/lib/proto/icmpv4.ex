defmodule Proto.ICMPv4 do

    import Proto.Util    
    
#Destination Unreachable Message
#
#    0                   1                   2                   3
#    0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
#   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
#   |     Type      |     Code      |          Checksum             |
#   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
#   |                             unused                            |
#   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
#   |      Internet Header + 64 bits of Original Data Datagram      |
#   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def header(<< 
            0x03, code,checksum::size(16),
            unused::size(32),
            data::binary
        >>) do
        {err,ret} = case code do
            0 -> {:ok, "net unreachable" }
            1 -> {:ok, "host unreachable" }
            2 -> {:ok, "proto unreachable" }
            3 -> {:ok, "port unreachable" }
            4 -> {:ok, "fragmentation needed" }
            5 -> {:ok, "source route failed" }
            _ -> {:error, "unknown code 0x#{x code}" }
        end
        {err, ["icmp destination unreachable: " <> ret] }
    end
    

#Time Exceeded Message
#
#    0                   1                   2                   3
#    0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
#   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
#   |     Type      |     Code      |          Checksum             |
#   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
#   |                             unused                            |
#   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
#   |      Internet Header + 64 bits of Original Data Datagram      |
#   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def header(<< 
            0x0B, code, checksum::size(16),
            unused::size(32),
            data::binary
        >>) do
        msg = case code do
            0 -> "time to live exceeded in transit"
            1 -> "fragment reassembly time exceeded"
            _ -> "unknown code 0x#{x code}"
        end
        {err,ret} = Proto.IPv4.parse(data)
        {err, [msg | ret]}
    end
        

#Echo or Echo Reply Message
#
#    0                   1                   2                   3
#    0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
#   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
#   |     Type      |     Code      |          Checksum             |
#   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
#   |           Identifier          |        Sequence Number        |
#   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
#   |     Data ...
#   +-+-+-+-+-

    def header(<<0x00, code, checksum::size(16),
                identifier::size(16), sequence::size(16),
                data::binary
        >>) do
        {:ok, [ "echo id 0x#{x identifier} seq ##{sequence} reply" ] }
    end

    def header(<<0x08, code, checksum::size(16),
                identifier::size(16), sequence::size(16),
                data::binary
        >>) do
        {:ok, [ "echo id 0x#{x identifier} seq ##{sequence} " ] }
    end
    

    def header(<<type,code,data::binary>>) do
        {:ok, ["icmp type 0x#{x type} code 0x#{x code} data " <> hex data] }
    end


    def parse(<<data::binary>>) do
        header(data)
    end

end