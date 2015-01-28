defmodule Core.Capture do

    import Core.Util
    
    defmodule Context do
        defstruct(
            registry: nil,
            cmd: "",
            port: nil,
            proto: nil,
            count: 0,
            time: 0,
            byte: 0,
        )
    end
    
    
    def start_link(regnode,args) do
        context = %Context{
            registry: {:registry, regnode}, 
            cmd: "./ei/capture "<>to_string(args)
        }
        GenServer.start_link(__MODULE__,context,[])
    end



    defp send_capture(context,capture) do
        [time: time, size: size, data: data] = capture
        context = %Context{context | 
            count: context.count+1,
            byte: context.byte+size            
        }
        parser = Core.Registry.get_parser(context.registry)
        
        if parser != nil do
            Core.Parser.parse(parser, context.proto ++ [time: time, size: size, data: <<0x0>>] )
        end
        context
    end


#    def handle_info({port,{:exit_status, status}},context) do
#        {:stop, :ok, context} 
#    end

    def handle_info({port,{:data,raw}}, context) do
        msg = :erlang.binary_to_term(raw)
        case msg do
            [link_type: link_type] ->
                {:noreply, %Context{context| proto: protocol(link_type) }}
            [capture: cap] ->
                {:noreply, send_capture(context, cap)}
        end
    end

    def handle_info([stat: t0, count: count],context) do
        if count == 0 or context.count != t0.count do
            log "capture stats " <> print_stats context, t0
        end
        Process.send_after self, [stat: %Context{context | time: timeofday}, count: rem(count+1,1)], 1000
        {:noreply, context}
    end


    def handle_info(msg, context) do
        log "capture msg #{inspect msg}"
        {:noreply,context}
    end


    def terminate(reason, contest) do
        log "capture terminate"
    end



    def init(context) do
        log "capture initialize #{inspect self} #{context.cmd}"
        port = :erlang.open_port({:spawn,context.cmd}, [{:packet, 2}, :binary, :exit_status] )
        Process.send_after self, [stat: %Context{time: timeofday}, count: 0], 1000
        {:ok, %Context{context | port: port, time: timeofday}}
    end
    
    
    defp protocol(0) do [protocol: ExCap.Proto.Null] end       # DLT_NULL
    defp protocol(1) do [protocol: ExCap.Proto.Ethernet] end   # DLT_EN10MB
    defp protocol(_) do [] end

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
    end





end