defmodule Core.Capture do

    import Core.Util
    
    @timeout 500
    
    defmodule Context do
        defstruct(
            registry: nil,
            parser: nil,
            cmd: "",
            port: nil,
            proto: nil,
            buffer: "",
            count: 0,
            time: 0,
            byte: 0,
        )
    end
    
    
    def main(args) do
        {:ok, pid} = Core.Capture.start_link args, nil, nil
        _ref = Process.monitor pid
        receive do
            {:DOWN, _ref, :process, _pid, _reason} ->
                :ok
        end
    end
    
    def start_link(args,registry,parser) do 
        context = %Context{
            registry: registry,
            parser: parser,
            cmd: "./ei/capture " <> to_string(args),
        }
        GenServer.start_link(__MODULE__,context,[]) 
    end
    




    defp send_capture(context,capture) do
#        log "send #{inspect context}"
        [time: time, size: size, data: data] = capture
        
        parser = context.parser
        
        if parser == nil && context.registry != nil, do:
            parser = Core.Registry.get_parser(context.registry)
        
        if parser != nil do
            Core.Parser.parse_and_notify(parser, context.proto ++ [time: time, size: size, data: <<0x0>>] )
            context = %Context{context | 
                count: context.count+1,
                byte: context.byte+size            
            }
        end
        context
    end
    
    

    defp process_capture(context, capture) do
        [time: time, size: size, data: data] = capture
    
        msg = Core.Parser.parse(context.proto ++ capture)
        buffer = Core.Dump.dump msg, context.buffer

        %Context{context | 
            buffer: buffer,
            count: context.count+1,
            byte: context.byte+size            
        }
    end


    def handle_info({port,{:exit_status, status}},context) do
        {:stop, :normal, %Context{ context | port: nil }}
    end

    def handle_info({port,{:data,raw}}, context) do
        msg = :erlang.binary_to_term(raw)
        case msg do
            [link_type: link_type] ->
                {:noreply, %Context{context| proto: protocol(link_type)}, @timeout}
            [capture: cap] ->
                if context.registry != nil or context.parser != nil do
                    {:noreply, send_capture(context, cap), @timeout}
                else
                    {:noreply, process_capture(context, cap), @timeout}
                end
        end
    end

    def handle_info([stat: t0, count: count],context) do
        if true or count == 0 or context.count != t0.count do
            log "capture stats " <> print_stats context, t0
        end
        Process.send_after self, [stat: %Context{context | time: timeofday}, count: rem(count+1,1)], 1000
        {:noreply, context, @timeout}
    end


    def handle_info(msg, context) do
        log "capture msg #{inspect msg}"
        {:noreply,context, @timeout}
    end


    def terminate(reason, context) do
        if context.port, do:
            Port.close context.port
        log "capture terminate"
        :ok
    end



    def init(context) do
        log "capture init #{context.cmd}"
        port = :erlang.open_port({:spawn,context.cmd}, [{:packet, 2}, :binary, :exit_status] )
        Process.send_after self, [stat: %Context{time: timeofday}, count: 0], 1000
        {:ok, %Context{context | port: port, time: timeofday}, @timeout}
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