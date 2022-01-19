defmodule Proto.Ethernet do

    import Proto.Util
    
    def address(addr) do
        to_string(addr)
    end
    
    
    
    def parse(<<
            destination::size(48),
            source::size(48),
            type::size(16),
            data::binary
        >>) do
        msg = "ethernet "
            <>address(source)<>" to "<>address(destination)<>" type 0x"<>Integer.to_string(type,16)
       
        {err,ret} = case type do
            0x0806 -> Proto.ARP.parse(data)
            0x0800 -> Proto.IPv4.parse(data)
            0x86dd -> Proto.IPv6.parse(data)
            _ -> {:error, ["unknown ethertype 0x"<>Integer.to_string(type,16)] }
       end
       [msg|ret]

    end
    
    def parse(<<data::binary>>) do
        ["invalid ethernet frame"]
    end
    
    def parse([]) do
        ["empty ethernet frame"]
    end
    
end