defmodule Core.Registry do
    import Core.Util


    defmodule Context do
        defstruct(
            parsers: [],
            count: 0,
            time: 0,
        )
    end




    def start_link(opts \\ []) do
        GenServer.start_link(__MODULE__,:ok,[name: :registry])
    end
    
    def stop(registry) do
        GenServer.call(registry, :stop)
    end
    
    def msg(registry) do
        GenServer.call(registry, :msg)
    end
    
    def crash(registry) do
        GenServer.call(registry, :crash)
    end
    
    def stat(registry) do
        GenServer.call(registry, :stat)
    end
    
    def ready(registry,parser) do
        GenServer.call(registry, {:ready, parser})
    end
    
    
    def get_parser(registry) do
        GenServer.call(registry, :get_parser)
    end
    
    
    
    
    
    
    
    def init(:ok) do
        log "registry initialize"
        Process.send_after self, [stat: %Context{time: timeofday}, count: 0], 1000
        {:ok, %Context{time: timeofday}}
    end
    
    def handle_call(:get_parser, _from, context) do
        context = %Context{context| count: context.count+1}
        case context.parsers do
            [first | rest] ->
                {:reply, first, %Context{context| parsers: rest++[first] }}
            [] ->
                {:reply, nil, context}
        end
    end
        
    def handle_call(:crash, _from, context) do
        3 = 1 + 1 #no match
    end
    
    def handle_call(:stop, _from, context) do
        {:stop, :normal, :ok, context}
    end
    
    defp insert(new,[]) do [new] end
    defp insert(new,[new|rest]) do [new] ++ rest end
    defp insert(new,[head|rest]) do [head] ++ insert(new, rest) end
    
    
    def handle_call({:ready, parser}, _from, context) do
#        log "READY CALL #{inspect parser}"
        {:reply, :ok, %Context{context | parsers: insert(parser, context.parsers) } }
    end


    def handle_info({:ready, parser}, context) do
#        log "READY MSG #{inspect parser}"
        {:noreply, %Context{context | parsers: [parser]++context.parsers } }
    end
    
    def handle_info([stat: t0, count: count],context) do
        if count == 0 or context.count != t0.count or context.parsers != t0.parsers do
            log "registry stats " <> print_stats context, t0
        end
        Process.send_after self, [stat: %Context{context | time: timeofday}, count: rem(count+1,5)], 1000
        {:noreply, context}
    end

    def handle_info(msg, context) do
        log "registry msg #{inspect msg}"
        {:noreply,context}
    end
    
    def handle_call(call, _from, context) do
        log "call #{inspect call}"
        {:reply, :ok, context}
    end
    
    def terminate(reason, contest) do
        log "registry terminate"
    end
    
    defp print_parsers([]) do "" end
    defp print_parsers([h|r]) do " #{inspect h}" <> print_parsers(r) end

    defp print_stats(stat,last) do
        delta = %Context{ 
            time: timeofday - last.time,
            count: stat.count - last.count, 
        }
        "#{Core.Util.time(timeofday - stat.time)}  "
            <> if stat.count > 0 do "#{Core.Util.count stat.count}query  " else "" end
            <> if delta.count > 0 do "#{Core.Util.rate delta.count, delta.time}qps  " else "" end 
#            <> if length(stat.parsers) > 0 do "#{length stat.parsers} parsers  " else "" end
            <> if length(stat.parsers) > 0 do print_parsers(stat.parsers) else "" end
    end
    

end