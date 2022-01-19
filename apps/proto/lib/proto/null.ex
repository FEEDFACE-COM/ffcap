defmodule Proto.Null do

    import Proto.Util    
    
    def parse(<<
            t0,t1,t2,t3,
            data::binary
        >>) do
        <<type::size(32)>> = <<t3,t2,t1,t0>>
        msg = "null type 0x#{x type}"
        {err,ret} = case type do
            0x02 -> Proto.IPv4.parse(data)
            0x1E -> Proto.IPv6.parse(data)
            _ -> {:error, ["nulltype 0x#{x type} #{hex data}"] }
        end
        [msg | ret]
    end
    
    def parse(<<data::binary>>) do
        ["invalid null frame"]
    end
    
    def parse([]) do
        ["empty null frame"]
    end
    
end