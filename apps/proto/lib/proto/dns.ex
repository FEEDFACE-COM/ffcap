defmodule Proto.DNS do

    import Proto.Util
    
    
    def ns_record   (data) do hex data end
    def soa_record  (data) do hex data end
    def ptr_record  (data) do hex data end
    def mx_record   (data) do hex data end

    def cname_record(data) do 
        <<size,tmp::binary>> = data
        <<cname::size(size)-binary,rest::binary>> = tmp
        {foo,offset} = name(rest,<<>>,"")
        cname <> " offset " <> hex offset
        
    end


    def txt_record(data) do 
        <<size,tmp::binary>> = data
        <<txt::size(size)-binary,rest::binary>> = tmp
        txt
    end


    def rdata(data,type) do 
        {typ,val} = case type do
            1  -> { "    a", Proto.IPv4.address data }
            2  -> { "   ns", ns_record data }
            5  -> { "cname", cname_record data }
            6  -> { "  soa", soa_record data }
            12 -> { "  ptr", ptr_record data }
            15 -> { "   mx", mx_record data }
            16 -> { "  txt", txt_record data }
            28 -> { " aaaa", Proto.IPv6.address data }
            _  -> {"#{type}", hex data }
        end
        "#{typ} #{val}"
    end


#    +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
#    | 1  1|                OFFSET                   |
#    +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+

    def pointer(head,offset) do
        case head do
            <<skip::size(offset)-binary,tmp::binary>> ->
                "***"
            _ ->
                log "no match for offset #{offset} in #{byte_size head} bytes head"
                ""
        end
    end

    def name(<<0x0,data::binary>>,head,str) do
        {data,str}
    end

    def name(<<0x3::size(2),offset::size(14),data::binary>>,head,str) do
        {data, str <> pointer(head,offset)}
    end

#    def name(<<0x0::size(2),length::size(6),data::binary>>,head,str) do
#        size = length*8
#        <<label::size(size)-binary,next::binary>> = data
#        name(next,head,str)
#    end
    
    def name(<<length,data::binary>>,head,str) do
        size = length*8
        case data do
            <<label::size(size)-binary,next::binary>> ->
                name(next,head,str)
            _ -> 
                {<<>>,str<>"!!!"}
        end
    end
    

    def name(<<>>,head,str) do 
        { <<>>, str } 
    end


            


#                                    1  1  1  1  1  1
#      0  1  2  3  4  5  6  7  8  9  0  1  2  3  4  5
#    +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
#    |                                               |
#    /                                               /
#    /                      NAME                     /
#    |                                               |
#    +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
#    |                      TYPE                     |
#    +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
#    |                     CLASS                     |
#    +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
#    |                      TTL                      |
#    |                                               |
#    +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
#    |                   RDLENGTH                    |
#    +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--|
#    /                     RDATA                     /
#    /                                               /
#    +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
#


    def resource_record(data,str,head) do
        {data,s} = name data,head,""
        case data do
            <<type::size(16),class::size(16),ttl::size(32),rdlength::size(16),rest::binary>> -> 
                case rest do
                    <<rdata::size(rdlength)-binary,next::binary>> -> {next, str <> rdata rdata, type}
                _ -> {<<>>, str <> "???" }    
                end        
            _ -> {<<>>, str <> "???" }
        end
    end


    
    def records_section(0,data,_,__) do
        {data,[]}        
    end
    
    def records_section(n,data,str,head) do
        {next,msg} = resource_record(data,str,head)
        {next,ret} = records_section(n-1,next,str,head)
        {next,ret ++ [msg]}
    end        
        
#                                    1  1  1  1  1  1
#      0  1  2  3  4  5  6  7  8  9  0  1  2  3  4  5
#    +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
#    |                                               |
#    /                     QNAME                     /
#    /                                               /
#    +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
#    |                     QTYPE                     |
#    +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
#    |                     QCLASS                    |
#    +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+


    def question_entry(<<0x0,qtype::size(16),qclass::size(16),data::binary>>,str) do
        {data,[str]}
    end

    def question_entry(<<len,data::binary>>,str) do
        size = len * 8
        <<label::size(size),next::binary>> = data
        question_entry(next,str<><<label::size(size)>><>".")
    end
    

    def question_section(n,data) do
        question_entry(data,"question ")
    end

    def question_section(0,data) do
        {[],data}
    end


#
#                                    1  1  1  1  1  1
#      0  1  2  3  4  5  6  7  8  9  0  1  2  3  4  5
#    +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
#    |                      ID                       |
#    +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
#    |QR|   Opcode  |AA|TC|RD|RA|   Z    |   RCODE   |
#    +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
#    |                    QDCOUNT                    |
#    +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
#    |                    ANCOUNT                    |
#    +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
#    |                    NSCOUNT                    |
#    +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
#    |                    ARCOUNT                    |
#    +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
#



    def header(<<
            id::size(16),
            qr::size(1),opcode::size(4),aa::size(1),tc::size(1),rd::size(1),
            ra::size(1),z::size(3),rcode::size(4),
            qdcount::size(16),
            ancount::size(16),
            nscount::size(16),
            arcount::size(16),
            data::binary
    >>,head) do
        msg = "dns " 
        <> if qr == 0 do "query " else "response " end 
        <> if qr == 1 do "authoritative answer " else "" end
#        <> "#{qdcount} questions #{ancount} answers #{nscount} authoritative #{arcount} additional"

        ret = []
        {next,r} = question_section qdcount, data
        ret = ret ++ r
        
        
        {next,r} = records_section ancount, next, "answer     ", head
        ret = ret ++ r

        {next,r} = records_section nscount, next, "authority  ", head
        ret = ret ++ r

        {next,r} = records_section arcount, next, "additional ", head
        ret = ret ++ r
                
        {:ok , [msg | [ret] ], next }
    end

        
    def parse(<<data::binary>>) do
        {err,ret,next} = header data, data
#        {:ok, ["#{bytes data}"]}
        if next != <<>> do log "next #{dump next}" end
#        {err,ret ++ [ "\n"<>dump next]}
        {err,ret}
    end





    def opcode(code) do
        case code do 
            0 -> "standard"
            1 -> "inverse" 
            2 -> "status"
            _ -> "unknown opcode"
        end
    end
    
    def rcode(code) do
        case code do 
            0 -> ""
            1 -> "format error"
            2 -> "server failure"
            3 -> "name error"
            4 -> "not implemented"
            5 -> "refused"
            _ -> "unknown rcode"
        end
    end

end
