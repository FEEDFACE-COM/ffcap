defmodule Core.Util do
    
    def log(s) do
        IO.puts(:stderr, "> "<>s)
    end
    
    def timeofday() do
        {ms,s,us} = :erlang.now
        ((ms*1000*1000) + s)*1000*1000 + us
    end
    
    def bps(bytes,delta) do 
        bps = (bytes * 8 ) / ( delta / (1000 * 1000) )
        {value,suffix} = cond do 
            bps >= (10 * 1024 * 1024 * 1024 * 1024) -> { (bps / (1024*1024*1024*1024)), " tbps"}
            bps >= (10 * 1024 * 1024 * 1024) -> { (bps / (1024*1024*1024)), " gbps"}
            bps >= (10 * 1024 * 1024) -> { (bps / (1024*1024)), " mbps"}
            bps >= (10 * 1024) -> { (bps / (1024)), " kbps"}
            true -> {bps/1, " bps"}
        end
        Float.to_string(value, decimals: 2) <> suffix
    end


    def byte(x) do
        {value,suffix} = cond do
            x > 8 * 0x400*0x400*0x400*0x400 -> { div(x,0x400*0x400*0x400*0x400) , " tbyte" }
            x > 8 * 0x400*0x400*0x400 -> { div(x,0x400*0x400*0x400) , " gbyte" }
            x > 8 * 0x400*0x400 -> { div(x,0x400*0x400) , " mbyte" }
            x > 8 * 0x400 -> { div(x,0x400) , " kbyte" }
            true -> { x , " byte" }
        end
        Integer.to_string(value)<>suffix
    end
    
        
    def time(x) do 
        s = (1000*1000)
        {value, suffix} = cond do
            x >= 4 * 24*60*60*s -> { x/(24*60*60*s) , "d" }
            x >= 5*60*60*s -> { x/(60*60*s) , "h" }
            x >= 5 * 60*s -> { x/(60*s) , "m" }
            x >= s -> { x/(s) , "s" }
            x >= 10 * 1000 -> { x/1000, "ms" }
            true -> {x/1, "us" }
        end
        Float.to_string( value, [decimals: 1] ) <> suffix
    end

    def count(x) do
        {value,suffix} = cond do
            x >= (10*1000*1000*1000*1000) -> { x / (1000*1000*1000*1000) , " t" }
            x >= (10*1000*1000*1000) -> { x / (1000*1000*1000) , " g" }
            x >= (10*1000*1000) -> { x / (1000*1000) , " m" }
            x >= (10*1000) -> { x / (1000) , " k" }
            true -> { x / 1 , " " }
        end
        Float.to_string( value, [decimals: 2] ) <> suffix
    end

    def rate(num,delta) do
        count( num / ( delta / ( 1000*1000) ) )
    end
        
        
end

