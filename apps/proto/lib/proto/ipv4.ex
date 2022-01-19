defmodule Proto.IPv4 do

    import Proto.Util    

#    def address(addr) do
#        Proto.Util.ip_address addr
#    end

    def address(<<a0,a1,a2,a3>>) do
        "#{a0}.#{a1}.#{a2}.#{a3}"
    end

    def address(addr) do
        address(<<addr::size(32)>>)
    end


    defmodule Header do
        defstruct(
            source: 0x0,
            destination: 0x0,
            length: 0x0,
            protocol: 0x0
        )
        

#    0                   1                   2                   3   
#    0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 
#   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
#   |Version|  IHL  |Type of Service|          Total Length         |
#   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
#   |         Identification        |Flags|      Fragment Offset    |
#   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
#   |  Time to Live |    Protocol   |         Header Checksum       |
#   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
#   |                       Source Address                          |
#   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
#   |                    Destination Address                        |
#   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
#   |                    Options                    |    Padding    |
#   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
#

        def parse(<<
                0x4::size(4), ihl::size(4),type::size(8),length::size(16),
                identification::size(16), reserved::size(1), df::size(1), mf::size(1), offset::size(13),
                ttl::size(8), protocol::size(8), checksum::size(16),
                source::size(32),
                destination::size(32),
                data::binary 
            >>) do
            case ihl do
                5 -> next = data
                6 -> <<options::size(24),padding::size(8),next::binary>> = data
            end
            {
                %Header{source: source, destination: destination, length: length, protocol: protocol},
                next
            }
        end

    end        
    
    def parse(<<pdu::binary>>) do
        
        {header, sdu} = Header.parse(pdu)
        {err,ret} = case header.protocol do
            0x01 -> Proto.ICMPv4.parse(sdu)
            0x06 -> Proto.TCP.parse [meta: {header.source,header.destination}, data: sdu]
            0x11 -> Proto.UDP.parse(sdu)
            _    -> { :error, ["protocol 0x"<>Integer.to_string(header.protocol,16)] }
        end
                
        msg = "ipv4 "
            <>address(header.source)<>" to "<>address(header.destination)
            <>" type "<>Integer.to_string(header.protocol,16)
            <>" length "<>Integer.to_string(header.length)<>" byte"
            
        {err, [msg | ret]}
    end
    

end