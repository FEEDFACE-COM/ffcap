defmodule Proto.UDP do

    import Proto.Util
    
    
    defmodule Header do
        defstruct(
            source: 0x0, 
            destination: 0x0, 
            length: 0x0 
        )
        
#  0      7 8     15 16    23 24    31  
# +--------+--------+--------+--------+ 
# |     Source      |   Destination   | 
# |      Port       |      Port       | 
# +--------+--------+--------+--------+ 
# |                 |                 | 
# |     Length      |    Checksum     | 
# +--------+--------+--------+--------+ 
# |                                     
# |          data octets ...            
# +---------------- ...                 
#
#      User Datagram Header Format
#

        def parse(<<
                source_port::size(16), destination_port::size(16),
                length::size(16), checksum::size(16),
                data::binary
            >>) do
            {
                %Header{source: source_port, destination: destination_port, length: length},
                data
            }
        end

    end
    


    def parse(<<pdu::binary>>) do

        {header, sdu} = Header.parse pdu

        {err, ret} = case {header.source,header.destination} do
            {_,53} -> Proto.DNS.parse sdu
            {53,_} -> Proto.DNS.parse sdu
            {5353,_} -> Proto.MDNS.parse sdu
            {_,5353} -> Proto.MDNS.parse sdu
            _      -> {:error, ["unknown protocol"] }
        end

        {err, ["udp :#{header.source} to :#{header.destination} length #{header.length} byte" | ret] }
    end

end