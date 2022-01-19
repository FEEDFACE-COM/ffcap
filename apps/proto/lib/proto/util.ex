defmodule Proto.Util do

    def log(s) do
        IO.puts(:stderr, "> "<>s)
    end


    def x(n) when is_integer(n) and n >= 0 and n <= 0x0f do "0" <> Integer.to_string(n,16) end
    def x(n) when is_integer(n) and n >= 0x10 and n <= 0xff do Integer.to_string(n,16) end
    def x(n) when is_integer(n) and n >= 0x100 do x(div(n,0x100)) <> x(rem(n,0x100)) end
    def x(_) do "XX" end

    def hex([]) do "" end
    def hex([e]) do "#{x e}" end
    def hex([e|r]) do "#{x e}:" <> hex r end

    
    def hex(<<>>) do "" end
    def hex(<<b>>) do "#{x b}" end
    def hex(<<b,r::binary>>) do "#{x b}:" <> hex r end    
    
    
    def hex(n) when is_integer(n) and n >= 0 and n <= 0xff do "#{x n}" end
    def hex(n) when is_integer(n) and n >= 0x100 do hex( div(n,0x100) ) <> ":#{x rem(n,0x100)}" end

    
    def hex(_) do "XX"end


    def chr(c) when c >= 0x30 and c <= 0x7f do
        <<c>>
    end
    
    def chr(c) do
        "."
    end


    def dump_row(<<>>, _) do
        { "", "" }
    end
    
    def dump_row(<<head>>, _) do
        { "#{x head}", "#{chr head}" }
    end
    
    def dump_row(<<head,data::binary>>, d) do
        {hex, chr} = dump_row(data, d+1)
        {d0,d1} = case rem(d,4) do 
            3 -> {" ", " "}
            _ -> {":", ""}
        end
        { "#{x head}" <> d0 <> hex, "#{chr head}" <> d1 <> chr }
    end

    def dump(<<>>) do
        ""
    end

    def dump(<<row::size(128),data::binary>>) do
        { hex, chr } = dump_row(<<row::size(128)>>, 0)
        hex <> "  " <> chr <> "\n" <> dump(data)
    end

    def dump(data) do
        { hex, chr } = dump_row(data, 0)
        d0 = for i <- byte_size(hex)..48, into: "" do " " end
        hex <> d0 <> chr <> "\n"
    end


end
