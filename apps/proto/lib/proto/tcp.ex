defmodule Proto.TCP do

    import Proto.Util

    defmodule Socket do
        defstruct(
            address:       0x0,
            port:          0x0,
            segment_count: 0x0,
            byte_count:    0x0,
            seqno:         0x0,
            ackno:         0x0,
        )
        
        def print(socket) do
            "#{Proto.IPv4.address socket.address}:#{socket.port}"
        end
        
        
        def match(s1, s2) do
            s1.address == s2.address and s1.port == s2.port
        end
    end

    defmodule Connection do
        defstruct(
            client: %Socket{},
            server: %Socket{},
        )
        
        def print(connection) do
            "#{Socket.print connection.client} to #{Socket.print connection.server}"
        end
        
        def parse(context, {source,destination}, <<
                source_port::size(16),destination_port::size(16),
                data::binary
            >>) do
            
            log "#{Proto.IPv4.address source}:#{source_port}" <>
                 " -> #{Proto.IPv4.address destination}:#{destination_port}"
                 
            src = %Socket{address: source, port: source_port}
            dst = %Socket{address: destination, port: destination_port }
            
            
            conn = %Connection{client: src, server: dst}
            

            
            {context ++ [conn], :ok, ["tcp :#{source_port} to :#{destination_port}"]}
        end
    end



    defmodule Header do
        
    
#    0                   1                   2                   3   
#    0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 
#   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
#   |          Source Port          |       Destination Port        |
#   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
#   |                        Sequence Number                        |
#   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
#   |                    Acknowledgment Number                      |
#   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
#   |  Data |           |U|A|P|R|S|F|                               |
#   | Offset| Reserved  |R|C|S|S|Y|I|            Window             |
#   |       |           |G|K|H|T|N|N|                               |
#   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
#   |           Checksum            |         Urgent Pointer        |
#   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
#   |                    Options                    |    Padding    |
#   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
#   |                             data                              |
#   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
#
#                            TCP Header Format

    
            
        def parse(context,<<
            source_port::size(16), destination_port::size(16),
            sequence_number::size(32),
            acknowledgement_number::size(32),
            data_offset::size(4),reserved::size(6),flags::size(6),window::size(16),
            checksum::size(16),urgent_pointer::size(16),
            options::size(24),padding::size(8),
            data::binary
        >>) do
            <<urg::size(1),ack::size(1),psh::size(1),rst::size(1),syn::size(1),fin::size(1)>> = <<flags::size(6)>>
            
            ret = [
                    "data #{data_offset} "
                    <> if syn == 1 do " syn" else "  " end
                    <> if ack == 1 do " ack" else "  " end
                    <> if fin == 1 do " fin" else "  " end
                    <> if urg == 1 do " urg" else "  " end
                    <> if psh == 1 do " psh" else "  " end
                    <> if rst == 1 do " rst" else "  " end
                    <> "window #{window} urgent #{urgent_pointer}",
                "seq ##{sequence_number} ##{context.seqno}",
                "ack ##{acknowledgement_number} ##{context.ackno}"
            ]

                
#            context = %{context | 
#                    count: context.count + byte_size data
#            }            
            
            ret = ret ++ [            
                "size #{byte_size data} total #{context.count} byte"
#                "header:\n#{dump data}"
                ]
            {context, :ok, ["tcp :#{source_port} to :#{destination_port}", ret]}
        end
        
        def parse(_,data) do
            {:error, ["tcp header invalid"]}
        end
    
    
    end    



    def parse meta: _meta, data: <<source_port::size(16),destination_port::size(16),data::binary>> do
        msg = "tcp "
            <>Integer.to_string(source_port)<>" to :"<>Integer.to_string(destination_port)
        {:ok, [msg]}
    end

    def parse meta: meta, data: data do
        send :tcp, [parse: self(), meta: meta, data: data]
        receive do
            {:result,err,ret} -> {err, ret}
        end
    end



    
    
    defmodule Parser do
    
        
        def new do
            %HashDict{}
        end
        
        
        def connection_get context, src, dst do
            case HashDict.fetch context, key(src,dst) do
                {ok,conn} -> 
                    {HashDict.delete(context, key(src,dst)), conn}
                :error ->
                    case HashDict.fetch context, key(dst,src) do
                        {:ok, conn} ->
                            {HashDict.delete(context, key(dst,src)), conn}
                        :error ->
                            {context, %Connection{client: src, server: dst} }
                    end
            end 
        end
        
        
        def connection_add context, connection do
            HashDict.put context, key(connection.client, connection.server), connection
        end
        
        def key a, b do
            {a.address,a.port,b.address,b.port}
        end
        
        def connection_count context do
            HashDict.size context 
        end



        def status context do
            log "connection count #{Dict.size context}"        
            for {k,v} <- HashDict.to_list context do
                log "  #{Connection.print v}"
            end
        end        
        
        
        
        def parse socket, <<
            source_port::size(16), destination_port::size(16),
            sequence_number::size(32),
            acknowledgement_number::size(32),
            data_offset::size(4),reserved::size(6),flags::size(6),window::size(16),
            checksum::size(16),urgent_pointer::size(16),
            options::size(24),padding::size(8),
            data::binary
        >> do
            <<urg::size(1),ack::size(1),psh::size(1),rst::size(1),syn::size(1),fin::size(1)>> = <<flags::size(6)>>
            msg = [ 
                    "tcp :#{source_port} to :#{destination_port}"
                    <> " window #{window}"
                    <> if urgent_pointer > 0 do " urgent #{urgent_pointer}" else "" end
                    <> if data_offset > 8 do " offset #{data_offset}" else "" end
                    <> " seq# #{sequence_number}"
                    <> " ack# #{acknowledgement_number}"
                    <> if syn == 1 do " syn" else "" end
                    <> if ack == 1 do " ack" else "" end
                    <> if fin == 1 do " fin" else "" end
                    <> if urg == 1 do " urg" else "" end
                    <> if psh == 1 do " psh" else "" end
                    <> if rst == 1 do " rst" else "" end 
            ]

            length = if socket.seqno == 0 do 0 else sequence_number - socket.seqno end
            

            socket = %Socket{ socket | 
                seqno: sequence_number,
                ackno: acknowledgement_number,
                segment_count: socket.segment_count + 1,
                byte_count: socket.byte_count + length
            }
            

            ret = [
                "segment ##{socket.segment_count}"
                <> if length > 0 do " size #{length} byte" else "" end
                <> " total #{socket.byte_count} byte" 
            ]
            
            if length > 0 do
                ret = ret ++ ["#{length} byte data"] 
            end
            {socket, :ok, [msg | ret] }
        
        end
        
        
    
        
        def parse(context, {source, destination}, data) when byte_size(data) >= 32 do

            <<source_port::size(16), destination_port::size(16),_::binary>> = data

            src = %Socket{address: source, port: source_port}
            dst = %Socket{address: destination, port: destination_port}

            {context, conn} = connection_get context, src, dst
            
            if Socket.match src, conn.client do
                {sock, err, ret} = parse conn.client, data
                context = connection_add context, %Connection{client: sock, server: conn.server}
            else
                {sock, err, ret} = parse conn.server, data
                context = connection_add context, %Connection{client: conn.client, server: sock}
            end
            
            {context, err, ret}
        
        end
        
        
        def parse context, _meta, _data do
            {context, :error, ["tcp invalid src/dst port"]}
        end
        
        
        
        def listen context do
            receive do
                :shutdown ->
                    log "tcp parser shutdown"

                :status ->
                    log "tcp parser status"
                    status context
                    listen context

                count: sender ->
                    send sender, count: connection_count(context)
                    listen context

                parse: sender, meta: meta, data: data ->
                    {context, err, ret} = parse context, meta, data
                    send sender, {:result, err, ret}
                    listen context

            end
        end
        

        def init() do
            log "tcp parser init"
            Process.register self(), :tcp
            listen(new)
            log "tcp parser exit"
        end
        
        def start() do
            spawn_link Proto.TCP.Parser, :init, []
        end
        
        def stop(pid) do
            send pid, :shutdown
            :ok
        end
    
    end

end