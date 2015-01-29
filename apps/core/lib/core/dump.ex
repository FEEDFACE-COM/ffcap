defmodule Core.Dump do

    import Core.Util
    
    defmodule Context do
        defstruct(
            buffer: "",
            count: 0,
            time: 0
        )
    end
    
    
    def start_link() do
        context = %Context{}
        
        GenServer.start_link(__MODULE__,context, [])
    end
    

    def dump(msg) do
        IO.puts print(msg)
    end

    def dump(msg,buffer) when byte_size(buffer) >= 4000 do
        flush(buffer<>print msg)
    end
    
    def dump(msg,buffer) do
        buffer<>print(msg)
    end


    def flush(buffer) do
        IO.puts buffer
        ""
    end

    defp print(data) do
        print("", data)
    end

    defp print(_,[]) do "" end

    defp print(pre, [[ ] | rest]) do
        print(pre<>"  ", rest)
    end

    defp print(pre, [[h|r] | rest]) do
        "\n" <> pre <> h 
            <> print(pre,[ r | rest ])
    end
    
    defp print(pre,[head | rest]) do
        "\n" <> pre<>head 
            <> print(pre<>"  ", rest)
    end
    


    
end