defmodule Proto.TCPTest do

    use ExUnit.Case, async: true
    
    alias Proto.TCP, as: TCP
    
    
    setup do 
        s1 = %TCP.Socket{address: 0x0b0b0b0b, port: 1111}
        s2 = %TCP.Socket{address: 0x16161616, port: 2222}
        s3 = %TCP.Socket{address: 0x21212121, port: 3333}
    
        s1s2 = %TCP.Connection{client: s1, server: s2}
        s1s3 = %TCP.Connection{client: s1, server: s3}
        s2s1 = %TCP.Connection{client: s2, server: s1}
        s2s3 = %TCP.Connection{client: s2, server: s3}
        s3s1 = %TCP.Connection{client: s3, server: s1}
        s3s2 = %TCP.Connection{client: s3, server: s2}
            
        {:ok, socks: {s1,s2,s3}, conns: {s1s2,s1s3,s2s1,s2s3,s3s1,s3s2} }
    end


    test "can print socket", %{socks: {s1,s2,s3}} do
        assert TCP.Socket.print(s1) == "11.11.11.11:1111" 
        assert TCP.Socket.print(s2) == "22.22.22.22:2222" 
        assert TCP.Socket.print(s3) == "33.33.33.33:3333" 
    end
    
    test "can print connections", %{conns: {s1s2,s1s3,s2s1,s2s3,s3s1,s3s2}} do
        assert TCP.Connection.print(s1s2) == "11.11.11.11:1111 to 22.22.22.22:2222"
        assert TCP.Connection.print(s1s3) == "11.11.11.11:1111 to 33.33.33.33:3333"
        assert TCP.Connection.print(s2s1) == "22.22.22.22:2222 to 11.11.11.11:1111"
        assert TCP.Connection.print(s2s3) == "22.22.22.22:2222 to 33.33.33.33:3333"
        assert TCP.Connection.print(s3s1) == "33.33.33.33:3333 to 11.11.11.11:1111"
        assert TCP.Connection.print(s3s2) == "33.33.33.33:3333 to 22.22.22.22:2222"
    end


    test "can store connection in context", %{socks: {s1, s2, s3}, conns: {s1s2,s1s3,s2s1,s2s3,s3s1,s3s2}} do
        context = TCP.Parser.connection_add TCP.Parser.new, s1s2
        assert TCP.Parser.connection_count(context) == 1
        {context, conn} = TCP.Parser.connection_get context, s1, s2
        assert TCP.Parser.connection_count(context) == 0
        assert conn.client == s1 and conn.server == s2
    end        
        
    test "can lookup connection with reversed src/dst", %{socks: {s1, s2, s3}, conns: {s1s2,s1s3,s2s1,s2s3,s3s1,s3s2}} do
        context = TCP.Parser.connection_add TCP.Parser.new, s1s2
        assert TCP.Parser.connection_count(context) == 1
        {context, conn} = TCP.Parser.connection_get context, s2, s1
        assert TCP.Parser.connection_count(context) == 0
        assert conn.client == s1 and conn.server == s2
    end        

    test "can find connection in context", %{socks: {s1, s2, s3}, conns: {s1s2,s1s3,s2s1,s2s3,s3s1,s3s2}} do
        context = TCP.Parser.new
        context = TCP.Parser.connection_add context, s1s2
        context = TCP.Parser.connection_add context, s1s3
        context = TCP.Parser.connection_add context, s2s3
        assert TCP.Parser.connection_count(context) == 3
        
        {context, conn} = TCP.Parser.connection_get context, s3, s1
        assert TCP.Parser.connection_count(context) == 2
        assert conn.client == s1 and conn.server == s3

        {context, conn} = TCP.Parser.connection_get context, s3, s1
        assert TCP.Parser.connection_count(context) == 2
        assert conn.client == s3 and conn.server == s1
        
        TCP.Parser.status context

    end        

    
    test "can start/stop parser" do
        pid = TCP.Parser.start
        :timer.sleep 100
        assert :ok == TCP.Parser.stop pid
    end

end
