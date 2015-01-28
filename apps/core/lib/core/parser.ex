defmodule Core.Parser do
    import Core.Util
    
    @timeout 500
    
    defmodule Context do
        defstruct(
            registry: nil,
            worker: 0,
            count: 0,
            byte: 0,
            time: 0,
        )
    end
    
    
    
    def start_link(regnode) do
        context = %Context{
            registry: {:registry,regnode}
        }
        GenServer.start_link(__MODULE__,context,[name: :parser])
    end

#        send {:registry, regnode}, {:ready, me}
#        Node.spawn_link regnode, fn -> Core.Registry.ready(:registry,me) end


    def parse(parser,data) do
        pid = Node.spawn_link(parser, fn -> Core.Parser.parse(data) end)
        GenServer.cast({:parser, parser}, [monitor: pid])
    end
    
    
    def result(parser,size) do
        GenServer.cast(parser,[result: size])
    end
    
    
#    def monitor(parser, pid) do
#        GenServer.cast(parser, [monitor: pid])        
#    end
    






    def parse([protocol: protocol, time: time, size: size, data: data]) do
        msg = "capture "
            <>"time "<>time(time)<>" size "<>byte(size)
            
#        log msg
        :timer.sleep 100
        
        result(:parser, size)
        
            
#        {err,ret} = 
#            case protocol do
#                ExCap.Proto.Null ->
#                    ExCap.Proto.Null.parse data
#                ExCap.Proto.Ethernet -> 
#                    ExCap.Proto.Ethernet.parse data
#                _ when is_nil(protocol) ->
#                    {:error, ["unspecified protocol"]}
#                foo -> 
#                    {:error, ["unknown protocol #{protocol}"]}
#            end
#        {err, [msg | ret]}
    end

















    def init(context) do
        log "parser initialize"
        Core.Registry.ready(context.registry,node)
        Process.send_after self, [stat: %Context{time: timeofday}], 1000
        {:ok, %Context{context | time: timeofday}, @timeout}
    end

    def handle_cast([monitor: pid],context) do
        ref = Process.monitor(pid)
        {:noreply, %Context{context| worker: context.worker + 1}, @timeout }
    end

    def handle_info([stat: t0],context) do
        log "parser stats " <> print_stats context, t0
        Process.send_after self, [stat: %Context{context | time: timeofday}], 1000
        {:noreply, context, @timeout}
    end
    
    def handle_info(:timeout, context) do
#        log "parser timeout"
        Core.Registry.ready(context.registry,node)
        {:noreply, context, @timeout}
    end

    def handle_cast([result: size],context) do
        context = %Context{context| 
            count: context.count+1,
            byte: context.byte+size
        }
        {:noreply, context}
    end

    def handle_info({:DOWN, ref, :process, pid, reason},context) do
        {:noreply, %Context{ context | worker: context.worker-1}, @timeout}
    end

    def handle_info(msg, context) do
        log "parser info #{inspect msg}"
        {:noreply,context, @timeout}
    end
    
    def handle_call(call, _from, context) do
        log "parser call #{inspect call}"
        {:reply, :ok, context, @timeout}
    end
    
    def terminate(reason, contest) do
        log "registry terminate"
    end

    defp print_stats(stat,last) do
        delta = %Context{ 
            time: timeofday - last.time,
            count: stat.count - last.count, 
            byte: stat.byte - last.byte,
        }
        "#{Core.Util.time(timeofday - stat.time)}  "
            <> if stat.count > 0 do "#{Core.Util.count stat.count}msgs  " else "" end
            <> if delta.count > 0 do "#{Core.Util.rate delta.count, delta.time}mps  " else "" end 
            <> if stat.byte > 0 do "#{Core.Util.byte stat.byte}  " else "" end
            <> if delta.byte > 0 do "#{Core.Util.bps delta.byte, delta.time}  " else "" end 
            <> if stat.worker != 0 do "#{stat.worker} worker  " else "" end
    end

end