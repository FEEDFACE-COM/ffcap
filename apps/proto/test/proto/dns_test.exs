defmodule Proto.DNSTest do

    use ExUnit.Case
    
    alias Proto.DNS, as: DNS
    

    test "simple query" do
        data = <<28,125,1,0,0,1,0,0,0,0,0,0,11,110,101,117,114,111,109,97,110,99,101,114,8,102,101,101,100,102,97,99,101,3,99,111,109,0,0,1,0,1,>>
        {err,ret} = DNS.parse(data)
        assert err == :ok
    end


    test "simple response" do
        data = <<28,125,129,128,0,1,0,1,0,2,0,4,11,110,101,117,114,111,109,97,110,99,101,114,8,102,101,101,100,102,97,99,101,3,99,111,109,0,0,1,0,1,192,12,0,1,0,1,0,0,1,44,0,4,85,199,135,98,192,24,0,2,0,1,0,0,1,44,0,6,3,110,115,48,192,24,192,24,0,2,0,1,0,0,1,44,0,6,3,110,115,49,192,24,192,70,0,1,0,1,0,1,81,122,0,4,85,199,135,79,192,70,0,28,0,1,0,1,81,122,0,16,32,1,26,80,0,7,0,1,0,0,0,0,0,0,0,121,192,88,0,1,0,1,0,1,81,122,0,4,85,199,135,80,192,88,0,28,0,1,0,1,81,122,0,16,32,1,26,80,0,7,0,1,0,0,0,0,0,0,0,128,>>
        {err,ret} = DNS.parse(data)
        assert err == :ok
    end


    test "cname query" do
        data = <<103,44,1,0,0,1,0,0,0,0,0,0,2,109,120,8,102,101,101,100,102,97,99,101,3,99,111,109,0,0,5,0,1,>>
        {err,ret} = DNS.parse(data)
        assert err == :ok
    end

    test "cname response" do
        data = <<103,44,129,128,0,1,0,1,0,2,0,4,2,109,120,8,102,101,101,100,102,97,99,101,3,99,111,109,0,0,5,0,1,192,12,0,5,0,1,0,0,1,44,0,6,3,109,120,49,192,15,192,15,0,2,0,1,0,0,1,44,0,6,3,110,115,48,192,15,192,15,0,2,0,1,0,0,1,44,0,6,3,110,115,49,192,15,192,63,0,1,0,1,0,1,81,128,0,4,85,199,135,79,192,63,0,28,0,1,0,1,81,128,0,16,32,1,26,80,0,7,0,1,0,0,0,0,0,0,0,121,192,81,0,1,0,1,0,1,81,128,0,4,85,199,135,80,192,81,0,28,0,1,0,1,81,128,0,16,32,1,26,80,0,7,0,1,0,0,0,0,0,0,0,128,>>
        {err,ret} = DNS.parse(data)
        assert err == :ok
    end

    test "query" do
        data = <<34,68,1,0,0,1,0,0,0,0,0,0,8,102,101,101,100,102,97,99,101,3,99,111,109,0,0,15,0,1,>>
        {err,ret} = DNS.parse(data)
        assert err == :ok
    end
    
    test "does not crash" do
        data = <<84,42,129,128,0,1,0,1,0,8,0,10,1,97,12,103,116,108,100,45,115,101,114,118,101,114,115,3,110,101,116,0,0,1,0,1,192,12,0,1,0,1,0,0,161,255,0,4,192,5,6,30,192,14,0,2,0,1,0,0,161,255,0,5,2,65,50,192,14,192,14,0,2,0,1,0,0,161,255,0,5,2,67,50,192,14,192,14,0,2,0,1,0,0,161,255,0,5,2,68,50,192,14,192,14,0,2,0,1,0,0,161,255,0,5,2,69,50,192,14,192,14,0,2,0,1,0,0,161,255,0,5,2,70,50,192,14,192,14,0,2,0,1,0,0,161,255,0,5,2,71,50,192,14,192,14,0,2,0,1,0,0,161,255,0,5,2,72,50,192,14,192,14,0,2,0,1,0,0,161,255,0,5,2,76,50,192,14,2,97,50,192,14,0,1,0,1,0,0,161,255,0,4,192,5,6,31,192,188,0,28,0,1,0,0,199,128,0,16,32,1,5,3,168,62,0,0,0,0,0,0,0,2,0,49,2,99,50,192,14,0,1,0,1,0,0,161,255,0,4,192,26,92,31,192,235,0,28,0,1,0,0,161,255,0,16,32,1,5,3,131,235,0,0,0,0,0,0,0,2,0,49,2,100,50,192,14,0,1,0,1,0,0,199,88,0,4,192,31,80,31,2,101,50,192,14,0,1,0,1,0,0,236,15,0,4,192,12,94,31,2,102,50,192,14,0,1,0,1,0,0,213,234,0,4,192,35,51,31,2,103,50,192,14,0,1,0,1,0,0,163,234,0,4,192,42,93,31,2,104,50,192,14,0,1,0,1,0,0,205,147,0,4,192,54,112,31,2,108,50,192,14,0,1,0,1,0,0,199,128,0,4,192,41,162,31,>>
        {err,ret} = DNS.parse(data)
        assert err == :ok
    end
            
    
    
    test "queries" do
        data = [
            <<34,68,129,128,0,1,0,2,0,2,0,8,8,102,101,101,100,102,97,99,101,3,99,111,109,0,0,15,0,1,192,12,0,15,0,1,0,0,1,44,0,8,0,20,3,109,120,48,192,12,192,12,0,15,0,1,0,0,1,44,0,8,0,10,3,109,120,49,192,12,192,12,0,2,0,1,0,0,1,26,0,6,3,110,115,48,192,12,192,12,0,2,0,1,0,0,1,26,0,6,3,110,115,49,192,12,192,64,0,1,0,1,0,0,1,44,0,4,85,199,135,113,192,64,0,28,0,1,0,0,1,44,0,16,32,1,26,80,0,7,0,1,0,0,0,0,0,0,1,19,192,44,0,1,0,1,0,0,1,44,0,4,85,199,135,112,192,44,0,28,0,1,0,0,1,44,0,16,32,1,26,80,0,7,0,1,0,0,0,0,0,0,1,18,192,82,0,1,0,1,0,1,81,104,0,4,85,199,135,79,192,82,0,28,0,1,0,1,81,104,0,16,32,1,26,80,0,7,0,1,0,0,0,0,0,0,0,121,192,100,0,1,0,1,0,1,81,104,0,4,85,199,135,80,192,100,0,28,0,1,0,1,81,104,0,16,32,1,26,80,0,7,0,1,0,0,0,0,0,0,0,128,>>,
            <<23,150,1,0,0,1,0,0,0,0,0,0,2,97,120,6,105,116,117,110,101,115,5,97,112,112,108,101,3,99,111,109,0,0,1,0,1,>>,
            <<23,150,129,128,0,1,0,4,0,8,0,8,2,97,120,6,105,116,117,110,101,115,5,97,112,112,108,101,3,99,111,109,0,0,1,0,1,192,12,0,5,0,1,0,0,8,176,0,35,2,97,120,6,105,116,117,110,101,115,5,97,112,112,108,101,3,99,111,109,9,101,100,103,101,115,117,105,116,101,3,110,101,116,0,192,49,0,5,0,1,0,0,75,215,0,19,5,97,49,49,48,56,3,100,97,49,6,97,107,97,109,97,105,192,79,192,96,0,1,0,1,0,0,0,11,0,4,219,76,10,59,192,96,0,1,0,1,0,0,0,11,0,4,219,76,10,42,192,102,0,2,0,1,0,0,9,196,0,8,5,110,48,100,97,49,192,106,192,102,0,2,0,1,0,0,9,196,0,8,5,110,49,100,97,49,192,106,192,102,0,2,0,1,0,0,9,196,0,8,5,110,50,100,97,49,192,106,192,102,0,2,0,1,0,0,9,196,0,8,5,110,51,100,97,49,192,106,192,102,0,2,0,1,0,0,9,196,0,8,5,110,52,100,97,49,192,106,192,102,0,2,0,1,0,0,9,196,0,8,5,110,53,100,97,49,192,106,192,102,0,2,0,1,0,0,9,196,0,8,5,110,54,100,97,49,192,106,192,102,0,2,0,1,0,0,9,196,0,8,5,110,55,100,97,49,192,106,192,159,0,1,0,1,0,0,13,118,0,4,88,221,81,193,192,179,0,1,0,1,0,0,7,106,0,4,219,76,10,167,192,199,0,1,0,1,0,0,25,100,0,4,23,76,204,220,192,219,0,1,0,1,0,0,10,217,0,4,23,76,204,215,192,239,0,1,0,1,0,0,1,236,0,4,219,76,10,172,193,3,0,1,0,1,0,0,29,189,0,4,219,76,10,174,193,23,0,1,0,1,0,0,13,118,0,4,219,76,10,166,193,43,0,1,0,1,0,0,16,235,0,4,219,76,10,164,>>,
            <<216,15,0,0,0,1,0,0,0,0,0,0,0,0,2,0,1,>>,
            <<216,15,128,128,0,1,0,13,0,0,0,13,0,0,2,0,1,0,0,2,0,1,0,0,159,132,0,20,1,104,12,114,111,111,116,45,115,101,114,118,101,114,115,3,110,101,116,0,0,0,2,0,1,0,0,159,132,0,4,1,105,192,30,0,0,2,0,1,0,0,159,132,0,4,1,106,192,30,0,0,2,0,1,0,0,159,132,0,4,1,107,192,30,0,0,2,0,1,0,0,159,132,0,4,1,108,192,30,0,0,2,0,1,0,0,159,132,0,4,1,109,192,30,0,0,2,0,1,0,0,159,132,0,4,1,97,192,30,0,0,2,0,1,0,0,159,132,0,4,1,98,192,30,0,0,2,0,1,0,0,159,132,0,4,1,99,192,30,0,0,2,0,1,0,0,159,132,0,4,1,100,192,30,0,0,2,0,1,0,0,159,132,0,4,1,101,192,30,0,0,2,0,1,0,0,159,132,0,4,1,102,192,30,0,0,2,0,1,0,0,159,132,0,4,1,103,192,30,192,134,0,1,0,1,0,0,159,132,0,4,198,41,0,4,192,134,0,28,0,1,0,0,221,201,0,16,32,1,5,3,186,62,0,0,0,0,0,0,0,2,0,48,192,149,0,1,0,1,0,0,159,132,0,4,192,228,79,201,192,149,0,28,0,1,0,0,159,132,0,16,32,1,5,0,0,132,0,0,0,0,0,0,0,0,0,11,192,164,0,1,0,1,0,0,159,132,0,4,192,33,4,12,192,164,0,28,0,1,0,0,159,132,0,16,32,1,5,0,0,2,0,0,0,0,0,0,0,0,0,12,192,179,0,1,0,1,0,0,159,132,0,4,199,7,91,13,192,179,0,28,0,1,0,0,159,132,0,16,32,1,5,0,0,45,0,0,0,0,0,0,0,0,0,13,192,194,0,1,0,1,0,0,159,132,0,4,192,203,230,10,192,209,0,1,0,1,0,0,159,132,0,4,192,5,5,241,192,209,0,28,0,1,0,0,159,132,0,16,32,1,5,0,0,47,0,0,0,0,0,0,0,0,0,15,192,224,0,1,0,1,0,0,159,132,0,4,192,112,36,4,192,28,0,1,0,1,0,0,159,132,0,4,128,63,2,53,>>,
            <<18,115,1,0,0,1,0,0,0,0,0,0,1,104,12,114,111,111,116,45,115,101,114,118,101,114,115,3,110,101,116,0,0,1,0,1,>>,
            <<18,115,129,128,0,1,0,1,0,13,0,12,1,104,12,114,111,111,116,45,115,101,114,118,101,114,115,3,110,101,116,0,0,1,0,1,192,12,0,1,0,1,0,1,81,128,0,4,128,63,2,53,192,14,0,2,0,1,0,0,183,54,0,4,1,99,192,14,192,14,0,2,0,1,0,0,183,54,0,4,1,100,192,14,192,14,0,2,0,1,0,0,183,54,0,4,1,101,192,14,192,14,0,2,0,1,0,0,183,54,0,4,1,102,192,14,192,14,0,2,0,1,0,0,183,54,0,4,1,103,192,14,192,14,0,2,0,1,0,0,183,54,0,2,192,12,192,14,0,2,0,1,0,0,183,54,0,4,1,105,192,14,192,14,0,2,0,1,0,0,183,54,0,4,1,106,192,14,192,14,0,2,0,1,0,0,183,54,0,4,1,107,192,14,192,14,0,2,0,1,0,0,183,54,0,4,1,108,192,14,192,14,0,2,0,1,0,0,183,54,0,4,1,109,192,14,192,14,0,2,0,1,0,0,183,54,0,4,1,97,192,14,192,14,0,2,0,1,0,0,183,54,0,4,1,98,192,14,192,238,0,1,0,1,0,0,183,54,0,4,198,41,0,4,192,238,0,28,0,1,0,0,54,77,0,16,32,1,5,3,186,62,0,0,0,0,0,0,0,2,0,48,192,254,0,1,0,1,0,0,183,54,0,4,192,228,79,201,192,254,0,28,0,1,0,0,183,54,0,16,32,1,5,0,0,132,0,0,0,0,0,0,0,0,0,11,192,64,0,1,0,1,0,0,183,54,0,4,192,33,4,12,192,64,0,28,0,1,0,1,44,131,0,16,32,1,5,0,0,2,0,0,0,0,0,0,0,0,0,12,192,80,0,1,0,1,0,0,183,54,0,4,199,7,91,13,192,80,0,28,0,1,0,0,183,54,0,16,32,1,5,0,0,45,0,0,0,0,0,0,0,0,0,13,192,96,0,1,0,1,0,0,183,54,0,4,192,203,230,10,192,112,0,1,0,1,0,0,183,54,0,4,192,5,5,241,192,112,0,28,0,1,0,0,183,54,0,16,32,1,5,0,0,47,0,0,0,0,0,0,0,0,0,15,192,128,0,1,0,1,0,0,183,54,0,4,192,112,36,4,>>,
            <<117,106,1,0,0,1,0,0,0,0,0,0,1,105,12,114,111,111,116,45,115,101,114,118,101,114,115,3,110,101,116,0,0,1,0,1,>>,
            <<117,106,129,128,0,1,0,1,0,13,0,12,1,105,12,114,111,111,116,45,115,101,114,118,101,114,115,3,110,101,116,0,0,1,0,1,192,12,0,1,0,1,0,1,81,128,0,4,192,36,148,17,192,14,0,2,0,1,0,0,159,133,0,4,1,106,192,14,192,14,0,2,0,1,0,0,159,133,0,4,1,107,192,14,192,14,0,2,0,1,0,0,159,133,0,4,1,108,192,14,192,14,0,2,0,1,0,0,159,133,0,4,1,109,192,14,192,14,0,2,0,1,0,0,159,133,0,4,1,97,192,14,192,14,0,2,0,1,0,0,159,133,0,4,1,98,192,14,192,14,0,2,0,1,0,0,159,133,0,4,1,99,192,14,192,14,0,2,0,1,0,0,159,133,0,4,1,100,192,14,192,14,0,2,0,1,0,0,159,133,0,4,1,101,192,14,192,14,0,2,0,1,0,0,159,133,0,4,1,102,192,14,192,14,0,2,0,1,0,0,159,133,0,4,1,103,192,14,192,14,0,2,0,1,0,0,159,133,0,4,1,104,192,14,192,14,0,2,0,1,0,0,159,133,0,2,192,12,192,128,0,1,0,1,0,0,159,133,0,4,198,41,0,4,192,128,0,28,0,1,0,0,222,235,0,16,32,1,5,3,186,62,0,0,0,0,0,0,0,2,0,48,192,144,0,1,0,1,0,0,159,133,0,4,192,228,79,201,192,144,0,28,0,1,0,0,159,133,0,16,32,1,5,0,0,132,0,0,0,0,0,0,0,0,0,11,192,160,0,1,0,1,0,0,159,133,0,4,192,33,4,12,192,160,0,28,0,1,0,0,159,133,0,16,32,1,5,0,0,2,0,0,0,0,0,0,0,0,0,12,192,176,0,1,0,1,0,0,159,133,0,4,199,7,91,13,192,176,0,28,0,1,0,0,159,133,0,16,32,1,5,0,0,45,0,0,0,0,0,0,0,0,0,13,192,192,0,1,0,1,0,0,182,177,0,4,192,203,230,10,192,208,0,1,0,1,0,0,159,133,0,4,192,5,5,241,192,208,0,28,0,1,0,0,159,133,0,16,32,1,5,0,0,47,0,0,0,0,0,0,0,0,0,15,192,224,0,1,0,1,0,0,159,133,0,4,192,112,36,4,>>,
            <<141,108,1,0,0,1,0,0,0,0,0,0,1,106,12,114,111,111,116,45,115,101,114,118,101,114,115,3,110,101,116,0,0,1,0,1,>>,
            <<141,108,129,128,0,1,0,1,0,13,0,12,1,106,12,114,111,111,116,45,115,101,114,118,101,114,115,3,110,101,116,0,0,1,0,1,192,12,0,1,0,1,0,1,81,128,0,4,192,58,128,30,192,14,0,2,0,1,0,0,159,133,0,4,1,105,192,14,192,14,0,2,0,1,0,0,159,133,0,2,192,12,192,14,0,2,0,1,0,0,159,133,0,4,1,107,192,14,192,14,0,2,0,1,0,0,159,133,0,4,1,108,192,14,192,14,0,2,0,1,0,0,159,133,0,4,1,109,192,14,192,14,0,2,0,1,0,0,159,133,0,4,1,97,192,14,192,14,0,2,0,1,0,0,159,133,0,4,1,98,192,14,192,14,0,2,0,1,0,0,159,133,0,4,1,99,192,14,192,14,0,2,0,1,0,0,159,133,0,4,1,100,192,14,192,14,0,2,0,1,0,0,159,133,0,4,1,101,192,14,192,14,0,2,0,1,0,0,159,133,0,4,1,102,192,14,192,14,0,2,0,1,0,0,159,133,0,4,1,103,192,14,192,14,0,2,0,1,0,0,159,133,0,4,1,104,192,14,192,142,0,1,0,1,0,0,159,133,0,4,198,41,0,4,192,142,0,28,0,1,0,0,222,235,0,16,32,1,5,3,186,62,0,0,0,0,0,0,0,2,0,48,192,158,0,1,0,1,0,0,159,133,0,4,192,228,79,201,192,158,0,28,0,1,0,0,159,133,0,16,32,1,5,0,0,132,0,0,0,0,0,0,0,0,0,11,192,174,0,1,0,1,0,0,159,133,0,4,192,33,4,12,192,174,0,28,0,1,0,0,159,133,0,16,32,1,5,0,0,2,0,0,0,0,0,0,0,0,0,12,192,190,0,1,0,1,0,0,159,133,0,4,199,7,91,13,192,190,0,28,0,1,0,0,159,133,0,16,32,1,5,0,0,45,0,0,0,0,0,0,0,0,0,13,192,206,0,1,0,1,0,0,182,177,0,4,192,203,230,10,192,222,0,1,0,1,0,0,159,133,0,4,192,5,5,241,192,222,0,28,0,1,0,0,159,133,0,16,32,1,5,0,0,47,0,0,0,0,0,0,0,0,0,15,192,238,0,1,0,1,0,0,159,133,0,4,192,112,36,4,>>,
            <<129,87,1,0,0,1,0,0,0,0,0,0,1,107,12,114,111,111,116,45,115,101,114,118,101,114,115,3,110,101,116,0,0,1,0,1,>>,
            <<129,87,129,128,0,1,0,1,0,13,0,12,1,107,12,114,111,111,116,45,115,101,114,118,101,114,115,3,110,101,116,0,0,1,0,1,192,12,0,1,0,1,0,1,72,164,0,4,193,0,14,129,192,14,0,2,0,1,0,0,159,132,0,4,1,105,192,14,192,14,0,2,0,1,0,0,159,132,0,4,1,106,192,14,192,14,0,2,0,1,0,0,159,132,0,2,192,12,192,14,0,2,0,1,0,0,159,132,0,4,1,108,192,14,192,14,0,2,0,1,0,0,159,132,0,4,1,109,192,14,192,14,0,2,0,1,0,0,159,132,0,4,1,97,192,14,192,14,0,2,0,1,0,0,159,132,0,4,1,98,192,14,192,14,0,2,0,1,0,0,159,132,0,4,1,99,192,14,192,14,0,2,0,1,0,0,159,132,0,4,1,100,192,14,192,14,0,2,0,1,0,0,159,132,0,4,1,101,192,14,192,14,0,2,0,1,0,0,159,132,0,4,1,102,192,14,192,14,0,2,0,1,0,0,159,132,0,4,1,103,192,14,192,14,0,2,0,1,0,0,159,132,0,4,1,104,192,14,192,142,0,1,0,1,0,0,159,132,0,4,198,41,0,4,192,142,0,28,0,1,0,0,221,201,0,16,32,1,5,3,186,62,0,0,0,0,0,0,0,2,0,48,192,158,0,1,0,1,0,0,159,132,0,4,192,228,79,201,192,158,0,28,0,1,0,0,159,132,0,16,32,1,5,0,0,132,0,0,0,0,0,0,0,0,0,11,192,174,0,1,0,1,0,0,159,132,0,4,192,33,4,12,192,174,0,28,0,1,0,0,159,132,0,16,32,1,5,0,0,2,0,0,0,0,0,0,0,0,0,12,192,190,0,1,0,1,0,0,159,132,0,4,199,7,91,13,192,190,0,28,0,1,0,0,159,132,0,16,32,1,5,0,0,45,0,0,0,0,0,0,0,0,0,13,192,206,0,1,0,1,0,0,159,132,0,4,192,203,230,10,192,222,0,1,0,1,0,0,159,132,0,4,192,5,5,241,192,222,0,28,0,1,0,0,159,132,0,16,32,1,5,0,0,47,0,0,0,0,0,0,0,0,0,15,192,238,0,1,0,1,0,0,159,132,0,4,192,112,36,4,>>,
            <<1,143,1,0,0,1,0,0,0,0,0,0,1,108,12,114,111,111,116,45,115,101,114,118,101,114,115,3,110,101,116,0,0,1,0,1,>>,
            <<1,143,129,128,0,1,0,1,0,13,0,12,1,108,12,114,111,111,116,45,115,101,114,118,101,114,115,3,110,101,116,0,0,1,0,1,192,12,0,1,0,1,0,1,81,128,0,4,199,7,83,42,192,14,0,2,0,1,0,0,159,133,0,4,1,106,192,14,192,14,0,2,0,1,0,0,159,133,0,4,1,107,192,14,192,14,0,2,0,1,0,0,159,133,0,2,192,12,192,14,0,2,0,1,0,0,159,133,0,4,1,109,192,14,192,14,0,2,0,1,0,0,159,133,0,4,1,97,192,14,192,14,0,2,0,1,0,0,159,133,0,4,1,98,192,14,192,14,0,2,0,1,0,0,159,133,0,4,1,99,192,14,192,14,0,2,0,1,0,0,159,133,0,4,1,100,192,14,192,14,0,2,0,1,0,0,159,133,0,4,1,101,192,14,192,14,0,2,0,1,0,0,159,133,0,4,1,102,192,14,192,14,0,2,0,1,0,0,159,133,0,4,1,103,192,14,192,14,0,2,0,1,0,0,159,133,0,4,1,104,192,14,192,14,0,2,0,1,0,0,159,133,0,4,1,105,192,14,192,126,0,1,0,1,0,0,159,133,0,4,198,41,0,4,192,126,0,28,0,1,0,0,222,235,0,16,32,1,5,3,186,62,0,0,0,0,0,0,0,2,0,48,192,142,0,1,0,1,0,0,159,133,0,4,192,228,79,201,192,142,0,28,0,1,0,0,159,133,0,16,32,1,5,0,0,132,0,0,0,0,0,0,0,0,0,11,192,158,0,1,0,1,0,0,159,133,0,4,192,33,4,12,192,158,0,28,0,1,0,0,159,133,0,16,32,1,5,0,0,2,0,0,0,0,0,0,0,0,0,12,192,174,0,1,0,1,0,0,159,133,0,4,199,7,91,13,192,174,0,28,0,1,0,0,159,133,0,16,32,1,5,0,0,45,0,0,0,0,0,0,0,0,0,13,192,190,0,1,0,1,0,0,182,177,0,4,192,203,230,10,192,206,0,1,0,1,0,0,159,133,0,4,192,5,5,241,192,206,0,28,0,1,0,0,159,133,0,16,32,1,5,0,0,47,0,0,0,0,0,0,0,0,0,15,192,222,0,1,0,1,0,0,159,133,0,4,192,112,36,4,>>,
            <<194,226,1,0,0,1,0,0,0,0,0,0,1,109,12,114,111,111,116,45,115,101,114,118,101,114,115,3,110,101,116,0,0,1,0,1,>>,
            <<194,226,129,128,0,1,0,1,0,13,0,12,1,109,12,114,111,111,116,45,115,101,114,118,101,114,115,3,110,101,116,0,0,1,0,1,192,12,0,1,0,1,0,0,160,122,0,4,202,12,27,33,192,14,0,2,0,1,0,0,159,132,0,4,1,106,192,14,192,14,0,2,0,1,0,0,159,132,0,4,1,107,192,14,192,14,0,2,0,1,0,0,159,132,0,4,1,108,192,14,192,14,0,2,0,1,0,0,159,132,0,2,192,12,192,14,0,2,0,1,0,0,159,132,0,4,1,97,192,14,192,14,0,2,0,1,0,0,159,132,0,4,1,98,192,14,192,14,0,2,0,1,0,0,159,132,0,4,1,99,192,14,192,14,0,2,0,1,0,0,159,132,0,4,1,100,192,14,192,14,0,2,0,1,0,0,159,132,0,4,1,101,192,14,192,14,0,2,0,1,0,0,159,132,0,4,1,102,192,14,192,14,0,2,0,1,0,0,159,132,0,4,1,103,192,14,192,14,0,2,0,1,0,0,159,132,0,4,1,104,192,14,192,14,0,2,0,1,0,0,159,132,0,4,1,105,192,14,192,126,0,1,0,1,0,0,159,132,0,4,198,41,0,4,192,126,0,28,0,1,0,0,221,201,0,16,32,1,5,3,186,62,0,0,0,0,0,0,0,2,0,48,192,142,0,1,0,1,0,0,159,132,0,4,192,228,79,201,192,142,0,28,0,1,0,0,159,132,0,16,32,1,5,0,0,132,0,0,0,0,0,0,0,0,0,11,192,158,0,1,0,1,0,0,159,132,0,4,192,33,4,12,192,158,0,28,0,1,0,0,159,132,0,16,32,1,5,0,0,2,0,0,0,0,0,0,0,0,0,12,192,174,0,1,0,1,0,0,159,132,0,4,199,7,91,13,192,174,0,28,0,1,0,0,159,132,0,16,32,1,5,0,0,45,0,0,0,0,0,0,0,0,0,13,192,190,0,1,0,1,0,0,159,132,0,4,192,203,230,10,192,206,0,1,0,1,0,0,159,132,0,4,192,5,5,241,192,206,0,28,0,1,0,0,159,132,0,16,32,1,5,0,0,47,0,0,0,0,0,0,0,0,0,15,192,222,0,1,0,1,0,0,159,132,0,4,192,112,36,4,>>,
            <<29,209,0,0,0,1,0,0,0,0,0,0,11,110,101,117,114,111,109,97,110,99,101,114,8,102,101,101,100,102,97,99,101,3,99,111,109,0,0,1,0,1,>>,
            <<29,209,0,0,0,1,0,0,0,0,0,0,11,110,101,117,114,111,109,97,110,99,101,114,8,102,101,101,100,102,97,99,101,3,99,111,109,0,0,1,0,1,>>,
            <<29,209,128,0,0,1,0,0,0,13,0,14,11,110,101,117,114,111,109,97,110,99,101,114,8,102,101,101,100,102,97,99,101,3,99,111,109,0,0,1,0,1,192,33,0,2,0,1,0,2,163,0,0,20,1,97,12,103,116,108,100,45,115,101,114,118,101,114,115,3,110,101,116,0,192,33,0,2,0,1,0,2,163,0,0,4,1,98,192,56,192,33,0,2,0,1,0,2,163,0,0,4,1,99,192,56,192,33,0,2,0,1,0,2,163,0,0,4,1,100,192,56,192,33,0,2,0,1,0,2,163,0,0,4,1,101,192,56,192,33,0,2,0,1,0,2,163,0,0,4,1,102,192,56,192,33,0,2,0,1,0,2,163,0,0,4,1,103,192,56,192,33,0,2,0,1,0,2,163,0,0,4,1,104,192,56,192,33,0,2,0,1,0,2,163,0,0,4,1,105,192,56,192,33,0,2,0,1,0,2,163,0,0,4,1,106,192,56,192,33,0,2,0,1,0,2,163,0,0,4,1,107,192,56,192,33,0,2,0,1,0,2,163,0,0,4,1,108,192,56,192,33,0,2,0,1,0,2,163,0,0,4,1,109,192,56,192,54,0,1,0,1,0,2,163,0,0,4,192,5,6,30,192,86,0,1,0,1,0,2,163,0,0,4,192,33,14,30,192,102,0,1,0,1,0,2,163,0,0,4,192,26,92,30,192,118,0,1,0,1,0,2,163,0,0,4,192,31,80,30,192,134,0,1,0,1,0,2,163,0,0,4,192,12,94,30,192,150,0,1,0,1,0,2,163,0,0,4,192,35,51,30,192,166,0,1,0,1,0,2,163,0,0,4,192,42,93,30,192,182,0,1,0,1,0,2,163,0,0,4,192,54,112,30,192,198,0,1,0,1,0,2,163,0,0,4,192,43,172,30,192,214,0,1,0,1,0,2,163,0,0,4,192,48,79,30,192,230,0,1,0,1,0,2,163,0,0,4,192,52,178,30,192,246,0,1,0,1,0,2,163,0,0,4,192,41,162,30,193,6,0,1,0,1,0,2,163,0,0,4,192,55,83,30,192,54,0,28,0,1,0,2,163,0,0,16,32,1,5,3,168,62,0,0,0,0,0,0,0,2,0,48,>>,
            <<84,42,1,0,0,1,0,0,0,0,0,0,1,97,12,103,116,108,100,45,115,101,114,118,101,114,115,3,110,101,116,0,0,1,0,1,>>,
            <<73,153,1,0,0,1,0,0,0,0,0,0,1,98,12,103,116,108,100,45,115,101,114,118,101,114,115,3,110,101,116,0,0,1,0,1,>>,
            <<73,153,129,128,0,1,0,1,0,8,0,10,1,98,12,103,116,108,100,45,115,101,114,118,101,114,115,3,110,101,116,0,0,1,0,1,192,12,0,1,0,1,0,0,37,145,0,4,192,33,14,30,192,14,0,2,0,1,0,0,185,235,0,5,2,69,50,192,14,192,14,0,2,0,1,0,0,185,235,0,5,2,70,50,192,14,192,14,0,2,0,1,0,0,185,235,0,5,2,71,50,192,14,192,14,0,2,0,1,0,0,185,235,0,5,2,72,50,192,14,192,14,0,2,0,1,0,0,185,235,0,5,2,76,50,192,14,192,14,0,2,0,1,0,0,185,235,0,5,2,65,50,192,14,192,14,0,2,0,1,0,0,185,235,0,5,2,67,50,192,14,192,14,0,2,0,1,0,0,185,235,0,5,2,68,50,192,14,2,97,50,192,14,0,1,0,1,0,0,185,235,0,4,192,5,6,31,192,188,0,28,0,1,0,0,185,235,0,16,32,1,5,3,168,62,0,0,0,0,0,0,0,2,0,49,2,99,50,192,14,0,1,0,1,0,0,199,128,0,4,192,26,92,31,192,235,0,28,0,1,0,0,221,97,0,16,32,1,5,3,131,235,0,0,0,0,0,0,0,2,0,49,2,100,50,192,14,0,1,0,1,0,0,210,132,0,4,192,31,80,31,192,64,0,1,0,1,0,0,219,175,0,4,192,12,94,31,2,102,50,192,14,0,1,0,1,0,0,10,241,0,4,192,35,51,31,2,103,50,192,14,0,1,0,1,0,0,221,97,0,4,192,42,93,31,2,104,50,192,14,0,1,0,1,0,0,209,210,0,4,192,54,112,31,192,132,0,1,0,1,0,0,255,147,0,4,192,41,162,31,>>,
            <<143,93,1,0,0,1,0,0,0,0,0,0,1,99,12,103,116,108,100,45,115,101,114,118,101,114,115,3,110,101,116,0,0,1,0,1,>>,
            <<143,93,129,128,0,1,0,1,0,8,0,10,1,99,12,103,116,108,100,45,115,101,114,118,101,114,115,3,110,101,116,0,0,1,0,1,192,12,0,1,0,1,0,1,40,39,0,4,192,26,92,30,192,14,0,2,0,1,0,0,185,234,0,5,2,70,50,192,14,192,14,0,2,0,1,0,0,185,234,0,5,2,71,50,192,14,192,14,0,2,0,1,0,0,185,234,0,5,2,72,50,192,14,192,14,0,2,0,1,0,0,185,234,0,5,2,76,50,192,14,192,14,0,2,0,1,0,0,185,234,0,5,2,65,50,192,14,192,14,0,2,0,1,0,0,185,234,0,5,2,67,50,192,14,192,14,0,2,0,1,0,0,185,234,0,5,2,68,50,192,14,192,14,0,2,0,1,0,0,185,234,0,5,2,69,50,192,14,2,97,50,192,14,0,1,0,1,0,0,185,234,0,4,192,5,6,31,192,188,0,28,0,1,0,0,185,234,0,16,32,1,5,3,168,62,0,0,0,0,0,0,0,2,0,49,2,99,50,192,14,0,1,0,1,0,0,199,127,0,4,192,26,92,31,192,235,0,28,0,1,0,0,221,96,0,16,32,1,5,3,131,235,0,0,0,0,0,0,0,2,0,49,2,100,50,192,14,0,1,0,1,0,0,210,131,0,4,192,31,80,31,192,183,0,1,0,1,0,0,219,174,0,4,192,12,94,31,2,102,50,192,14,0,1,0,1,0,0,10,240,0,4,192,35,51,31,2,103,50,192,14,0,1,0,1,0,0,221,96,0,4,192,42,93,31,2,104,50,192,14,0,1,0,1,0,0,209,209,0,4,192,54,112,31,192,115,0,1,0,1,0,0,255,146,0,4,192,41,162,31,>>,
            <<140,144,1,0,0,1,0,0,0,0,0,0,1,100,12,103,116,108,100,45,115,101,114,118,101,114,115,3,110,101,116,0,0,1,0,1,>>,
            <<140,144,129,128,0,1,0,1,0,8,0,10,1,100,12,103,116,108,100,45,115,101,114,118,101,114,115,3,110,101,116,0,0,1,0,1,192,12,0,1,0,1,0,0,221,96,0,4,192,31,80,30,192,14,0,2,0,1,0,0,185,234,0,5,2,71,50,192,14,192,14,0,2,0,1,0,0,185,234,0,5,2,72,50,192,14,192,14,0,2,0,1,0,0,185,234,0,5,2,76,50,192,14,192,14,0,2,0,1,0,0,185,234,0,5,2,65,50,192,14,192,14,0,2,0,1,0,0,185,234,0,5,2,67,50,192,14,192,14,0,2,0,1,0,0,185,234,0,5,2,68,50,192,14,192,14,0,2,0,1,0,0,185,234,0,5,2,69,50,192,14,192,14,0,2,0,1,0,0,185,234,0,5,2,70,50,192,14,2,97,50,192,14,0,1,0,1,0,0,185,234,0,4,192,5,6,31,192,188,0,28,0,1,0,0,185,234,0,16,32,1,5,3,168,62,0,0,0,0,0,0,0,2,0,49,2,99,50,192,14,0,1,0,1,0,0,199,127,0,4,192,26,92,31,192,235,0,28,0,1,0,0,221,96,0,16,32,1,5,3,131,235,0,0,0,0,0,0,0,2,0,49,2,100,50,192,14,0,1,0,1,0,0,210,131,0,4,192,31,80,31,192,166,0,1,0,1,0,0,219,174,0,4,192,12,94,31,2,102,50,192,14,0,1,0,1,0,0,10,240,0,4,192,35,51,31,2,103,50,192,14,0,1,0,1,0,0,221,96,0,4,192,42,93,31,2,104,50,192,14,0,1,0,1,0,0,209,209,0,4,192,54,112,31,192,98,0,1,0,1,0,0,255,146,0,4,192,41,162,31,>>,
            <<27,227,1,0,0,1,0,0,0,0,0,0,1,101,12,103,116,108,100,45,115,101,114,118,101,114,115,3,110,101,116,0,0,1,0,1,>>,
            <<27,227,129,128,0,1,0,1,0,8,0,10,1,101,12,103,116,108,100,45,115,101,114,118,101,114,115,3,110,101,116,0,0,1,0,1,192,12,0,1,0,1,0,0,193,177,0,4,192,12,94,30,192,14,0,2,0,1,0,0,161,254,0,5,2,76,50,192,14,192,14,0,2,0,1,0,0,161,254,0,5,2,65,50,192,14,192,14,0,2,0,1,0,0,161,254,0,5,2,67,50,192,14,192,14,0,2,0,1,0,0,161,254,0,5,2,68,50,192,14,192,14,0,2,0,1,0,0,161,254,0,5,2,69,50,192,14,192,14,0,2,0,1,0,0,161,254,0,5,2,70,50,192,14,192,14,0,2,0,1,0,0,161,254,0,5,2,71,50,192,14,192,14,0,2,0,1,0,0,161,254,0,5,2,72,50,192,14,2,97,50,192,14,0,1,0,1,0,0,161,254,0,4,192,5,6,31,192,188,0,28,0,1,0,0,199,127,0,16,32,1,5,3,168,62,0,0,0,0,0,0,0,2,0,49,2,99,50,192,14,0,1,0,1,0,0,161,254,0,4,192,26,92,31,192,235,0,28,0,1,0,0,161,254,0,16,32,1,5,3,131,235,0,0,0,0,0,0,0,2,0,49,2,100,50,192,14,0,1,0,1,0,0,199,87,0,4,192,31,80,31,2,101,50,192,14,0,1,0,1,0,0,236,14,0,4,192,12,94,31,2,102,50,192,14,0,1,0,1,0,0,213,233,0,4,192,35,51,31,2,103,50,192,14,0,1,0,1,0,0,163,233,0,4,192,42,93,31,2,104,50,192,14,0,1,0,1,0,0,205,146,0,4,192,54,112,31,2,108,50,192,14,0,1,0,1,0,0,199,127,0,4,192,41,162,31,>>,
            <<53,191,1,0,0,1,0,0,0,0,0,0,1,102,12,103,116,108,100,45,115,101,114,118,101,114,115,3,110,101,116,0,0,1,0,1,>>,
            <<53,191,129,128,0,1,0,1,0,8,0,10,1,102,12,103,116,108,100,45,115,101,114,118,101,114,115,3,110,101,116,0,0,1,0,1,192,12,0,1,0,1,0,0,131,197,0,4,192,35,51,30,192,14,0,2,0,1,0,0,185,234,0,5,2,72,50,192,14,192,14,0,2,0,1,0,0,185,234,0,5,2,76,50,192,14,192,14,0,2,0,1,0,0,185,234,0,5,2,65,50,192,14,192,14,0,2,0,1,0,0,185,234,0,5,2,67,50,192,14,192,14,0,2,0,1,0,0,185,234,0,5,2,68,50,192,14,192,14,0,2,0,1,0,0,185,234,0,5,2,69,50,192,14,192,14,0,2,0,1,0,0,185,234,0,5,2,70,50,192,14,192,14,0,2,0,1,0,0,185,234,0,5,2,71,50,192,14,2,97,50,192,14,0,1,0,1,0,0,185,234,0,4,192,5,6,31,192,188,0,28,0,1,0,0,185,234,0,16,32,1,5,3,168,62,0,0,0,0,0,0,0,2,0,49,2,99,50,192,14,0,1,0,1,0,0,199,127,0,4,192,26,92,31,192,235,0,28,0,1,0,0,221,96,0,16,32,1,5,3,131,235,0,0,0,0,0,0,0,2,0,49,2,100,50,192,14,0,1,0,1,0,0,210,131,0,4,192,31,80,31,192,149,0,1,0,1,0,0,219,174,0,4,192,12,94,31,2,102,50,192,14,0,1,0,1,0,0,10,240,0,4,192,35,51,31,2,103,50,192,14,0,1,0,1,0,0,221,96,0,4,192,42,93,31,2,104,50,192,14,0,1,0,1,0,0,209,209,0,4,192,54,112,31,192,81,0,1,0,1,0,0,255,146,0,4,192,41,162,31,>>,
            <<201,91,1,0,0,1,0,0,0,0,0,0,1,103,12,103,116,108,100,45,115,101,114,118,101,114,115,3,110,101,116,0,0,1,0,1,>>,
            <<201,91,129,128,0,1,0,1,0,8,0,10,1,103,12,103,116,108,100,45,115,101,114,118,101,114,115,3,110,101,116,0,0,1,0,1,192,12,0,1,0,1,0,1,81,128,0,4,192,42,93,30,192,14,0,2,0,1,0,0,185,234,0,5,2,72,50,192,14,192,14,0,2,0,1,0,0,185,234,0,5,2,76,50,192,14,192,14,0,2,0,1,0,0,185,234,0,5,2,65,50,192,14,192,14,0,2,0,1,0,0,185,234,0,5,2,67,50,192,14,192,14,0,2,0,1,0,0,185,234,0,5,2,68,50,192,14,192,14,0,2,0,1,0,0,185,234,0,5,2,69,50,192,14,192,14,0,2,0,1,0,0,185,234,0,5,2,70,50,192,14,192,14,0,2,0,1,0,0,185,234,0,5,2,71,50,192,14,2,97,50,192,14,0,1,0,1,0,0,185,234,0,4,192,5,6,31,192,188,0,28,0,1,0,0,185,234,0,16,32,1,5,3,168,62,0,0,0,0,0,0,0,2,0,49,2,99,50,192,14,0,1,0,1,0,0,199,127,0,4,192,26,92,31,192,235,0,28,0,1,0,0,221,96,0,16,32,1,5,3,131,235,0,0,0,0,0,0,0,2,0,49,2,100,50,192,14,0,1,0,1,0,0,210,131,0,4,192,31,80,31,192,149,0,1,0,1,0,0,219,174,0,4,192,12,94,31,2,102,50,192,14,0,1,0,1,0,0,10,240,0,4,192,35,51,31,2,103,50,192,14,0,1,0,1,0,0,221,96,0,4,192,42,93,31,2,104,50,192,14,0,1,0,1,0,0,209,209,0,4,192,54,112,31,192,81,0,1,0,1,0,0,255,146,0,4,192,41,162,31,>>,
            <<163,70,1,0,0,1,0,0,0,0,0,0,1,104,12,103,116,108,100,45,115,101,114,118,101,114,115,3,110,101,116,0,0,1,0,1,>>,
            <<163,70,129,128,0,1,0,1,0,8,0,10,1,104,12,103,116,108,100,45,115,101,114,118,101,114,115,3,110,101,116,0,0,1,0,1,192,12,0,1,0,1,0,0,235,88,0,4,192,54,112,30,192,14,0,2,0,1,0,0,187,103,0,5,2,71,50,192,14,192,14,0,2,0,1,0,0,187,103,0,5,2,72,50,192,14,192,14,0,2,0,1,0,0,187,103,0,5,2,76,50,192,14,192,14,0,2,0,1,0,0,187,103,0,5,2,65,50,192,14,192,14,0,2,0,1,0,0,187,103,0,5,2,67,50,192,14,192,14,0,2,0,1,0,0,187,103,0,5,2,68,50,192,14,192,14,0,2,0,1,0,0,187,103,0,5,2,69,50,192,14,192,14,0,2,0,1,0,0,187,103,0,5,2,70,50,192,14,2,97,50,192,14,0,1,0,1,0,0,136,226,0,4,192,5,6,31,192,188,0,28,0,1,0,0,182,68,0,16,32,1,5,3,168,62,0,0,0,0,0,0,0,2,0,49,2,99,50,192,14,0,1,0,1,0,0,187,103,0,4,192,26,92,31,192,235,0,28,0,1,0,0,187,103,0,16,32,1,5,3,131,235,0,0,0,0,0,0,0,2,0,49,2,100,50,192,14,0,1,0,1,0,0,210,131,0,4,192,31,80,31,2,101,50,192,14,0,1,0,1,0,0,250,72,0,4,192,12,94,31,192,183,0,1,0,1,0,0,90,19,0,4,192,35,51,31,2,103,50,192,14,0,1,0,1,0,0,136,222,0,4,192,42,93,31,2,104,50,192,14,0,1,0,1,0,0,196,108,0,4,192,54,112,31,192,98,0,1,0,1,0,1,68,33,0,4,192,41,162,31,>>,
            <<131,169,1,0,0,1,0,0,0,0,0,0,1,105,12,103,116,108,100,45,115,101,114,118,101,114,115,3,110,101,116,0,0,1,0,1,>>,
            <<131,169,129,128,0,1,0,1,0,8,0,10,1,105,12,103,116,108,100,45,115,101,114,118,101,114,115,3,110,101,116,0,0,1,0,1,192,12,0,1,0,1,0,0,199,125,0,4,192,43,172,30,192,14,0,2,0,1,0,0,185,234,0,5,2,76,50,192,14,192,14,0,2,0,1,0,0,185,234,0,5,2,65,50,192,14,192,14,0,2,0,1,0,0,185,234,0,5,2,67,50,192,14,192,14,0,2,0,1,0,0,185,234,0,5,2,68,50,192,14,192,14,0,2,0,1,0,0,185,234,0,5,2,69,50,192,14,192,14,0,2,0,1,0,0,185,234,0,5,2,70,50,192,14,192,14,0,2,0,1,0,0,185,234,0,5,2,71,50,192,14,192,14,0,2,0,1,0,0,185,234,0,5,2,72,50,192,14,2,97,50,192,14,0,1,0,1,0,0,185,234,0,4,192,5,6,31,192,188,0,28,0,1,0,0,185,234,0,16,32,1,5,3,168,62,0,0,0,0,0,0,0,2,0,49,2,99,50,192,14,0,1,0,1,0,0,199,127,0,4,192,26,92,31,192,235,0,28,0,1,0,0,221,96,0,16,32,1,5,3,131,235,0,0,0,0,0,0,0,2,0,49,2,100,50,192,14,0,1,0,1,0,0,210,131,0,4,192,31,80,31,192,132,0,1,0,1,0,0,219,174,0,4,192,12,94,31,2,102,50,192,14,0,1,0,1,0,0,10,240,0,4,192,35,51,31,2,103,50,192,14,0,1,0,1,0,0,221,96,0,4,192,42,93,31,2,104,50,192,14,0,1,0,1,0,0,209,209,0,4,192,54,112,31,192,64,0,1,0,1,0,0,255,146,0,4,192,41,162,31,>>,
            <<100,11,1,0,0,1,0,0,0,0,0,0,1,106,12,103,116,108,100,45,115,101,114,118,101,114,115,3,110,101,116,0,0,1,0,1,>>,
            <<100,11,129,128,0,1,0,1,0,8,0,10,1,106,12,103,116,108,100,45,115,101,114,118,101,114,115,3,110,101,116,0,0,1,0,1,192,12,0,1,0,1,0,0,105,4,0,4,192,48,79,30,192,14,0,2,0,1,0,0,187,103,0,5,2,65,50,192,14,192,14,0,2,0,1,0,0,187,103,0,5,2,67,50,192,14,192,14,0,2,0,1,0,0,187,103,0,5,2,68,50,192,14,192,14,0,2,0,1,0,0,187,103,0,5,2,69,50,192,14,192,14,0,2,0,1,0,0,187,103,0,5,2,70,50,192,14,192,14,0,2,0,1,0,0,187,103,0,5,2,71,50,192,14,192,14,0,2,0,1,0,0,187,103,0,5,2,72,50,192,14,192,14,0,2,0,1,0,0,187,103,0,5,2,76,50,192,14,2,97,50,192,14,0,1,0,1,0,0,136,226,0,4,192,5,6,31,192,188,0,28,0,1,0,0,182,68,0,16,32,1,5,3,168,62,0,0,0,0,0,0,0,2,0,49,2,99,50,192,14,0,1,0,1,0,0,187,103,0,4,192,26,92,31,192,235,0,28,0,1,0,0,187,103,0,16,32,1,5,3,131,235,0,0,0,0,0,0,0,2,0,49,2,100,50,192,14,0,1,0,1,0,0,210,131,0,4,192,31,80,31,2,101,50,192,14,0,1,0,1,0,0,250,72,0,4,192,12,94,31,192,132,0,1,0,1,0,0,90,19,0,4,192,35,51,31,2,103,50,192,14,0,1,0,1,0,0,136,222,0,4,192,42,93,31,2,104,50,192,14,0,1,0,1,0,0,196,108,0,4,192,54,112,31,192,183,0,1,0,1,0,1,68,33,0,4,192,41,162,31,>>,
            <<241,100,1,0,0,1,0,0,0,0,0,0,1,107,12,103,116,108,100,45,115,101,114,118,101,114,115,3,110,101,116,0,0,1,0,1,>>,
            <<241,100,129,128,0,1,0,1,0,8,0,10,1,107,12,103,116,108,100,45,115,101,114,118,101,114,115,3,110,101,116,0,0,1,0,1,192,12,0,1,0,1,0,0,242,89,0,4,192,52,178,30,192,14,0,2,0,1,0,0,185,234,0,5,2,65,50,192,14,192,14,0,2,0,1,0,0,185,234,0,5,2,67,50,192,14,192,14,0,2,0,1,0,0,185,234,0,5,2,68,50,192,14,192,14,0,2,0,1,0,0,185,234,0,5,2,69,50,192,14,192,14,0,2,0,1,0,0,185,234,0,5,2,70,50,192,14,192,14,0,2,0,1,0,0,185,234,0,5,2,71,50,192,14,192,14,0,2,0,1,0,0,185,234,0,5,2,72,50,192,14,192,14,0,2,0,1,0,0,185,234,0,5,2,76,50,192,14,2,97,50,192,14,0,1,0,1,0,0,185,234,0,4,192,5,6,31,192,188,0,28,0,1,0,0,185,234,0,16,32,1,5,3,168,62,0,0,0,0,0,0,0,2,0,49,2,99,50,192,14,0,1,0,1,0,0,199,127,0,4,192,26,92,31,192,235,0,28,0,1,0,0,221,96,0,16,32,1,5,3,131,235,0,0,0,0,0,0,0,2,0,49,2,100,50,192,14,0,1,0,1,0,0,210,131,0,4,192,31,80,31,192,115,0,1,0,1,0,0,219,174,0,4,192,12,94,31,2,102,50,192,14,0,1,0,1,0,0,10,240,0,4,192,35,51,31,2,103,50,192,14,0,1,0,1,0,0,221,96,0,4,192,42,93,31,2,104,50,192,14,0,1,0,1,0,0,209,209,0,4,192,54,112,31,192,183,0,1,0,1,0,0,255,146,0,4,192,41,162,31,>>,
            <<157,166,1,0,0,1,0,0,0,0,0,0,1,108,12,103,116,108,100,45,115,101,114,118,101,114,115,3,110,101,116,0,0,1,0,1,>>,
            <<157,166,129,128,0,1,0,1,0,8,0,10,1,108,12,103,116,108,100,45,115,101,114,118,101,114,115,3,110,101,116,0,0,1,0,1,192,12,0,1,0,1,0,0,202,70,0,4,192,41,162,30,192,14,0,2,0,1,0,0,161,254,0,5,2,70,50,192,14,192,14,0,2,0,1,0,0,161,254,0,5,2,71,50,192,14,192,14,0,2,0,1,0,0,161,254,0,5,2,72,50,192,14,192,14,0,2,0,1,0,0,161,254,0,5,2,76,50,192,14,192,14,0,2,0,1,0,0,161,254,0,5,2,65,50,192,14,192,14,0,2,0,1,0,0,161,254,0,5,2,67,50,192,14,192,14,0,2,0,1,0,0,161,254,0,5,2,68,50,192,14,192,14,0,2,0,1,0,0,161,254,0,5,2,69,50,192,14,2,97,50,192,14,0,1,0,1,0,0,161,254,0,4,192,5,6,31,192,188,0,28,0,1,0,0,199,127,0,16,32,1,5,3,168,62,0,0,0,0,0,0,0,2,0,49,2,99,50,192,14,0,1,0,1,0,0,161,254,0,4,192,26,92,31,192,235,0,28,0,1,0,0,161,254,0,16,32,1,5,3,131,235,0,0,0,0,0,0,0,2,0,49,2,100,50,192,14,0,1,0,1,0,0,199,87,0,4,192,31,80,31,2,101,50,192,14,0,1,0,1,0,0,236,14,0,4,192,12,94,31,2,102,50,192,14,0,1,0,1,0,0,213,233,0,4,192,35,51,31,2,103,50,192,14,0,1,0,1,0,0,163,233,0,4,192,42,93,31,2,104,50,192,14,0,1,0,1,0,0,205,146,0,4,192,54,112,31,2,108,50,192,14,0,1,0,1,0,0,199,127,0,4,192,41,162,31,>>,
            <<136,168,1,0,0,1,0,0,0,0,0,0,1,109,12,103,116,108,100,45,115,101,114,118,101,114,115,3,110,101,116,0,0,1,0,1,>>,
            <<136,168,129,128,0,1,0,1,0,8,0,10,1,109,12,103,116,108,100,45,115,101,114,118,101,114,115,3,110,101,116,0,0,1,0,1,192,12,0,1,0,1,0,0,185,235,0,4,192,55,83,30,192,14,0,2,0,1,0,0,185,234,0,5,2,67,50,192,14,192,14,0,2,0,1,0,0,185,234,0,5,2,68,50,192,14,192,14,0,2,0,1,0,0,185,234,0,5,2,69,50,192,14,192,14,0,2,0,1,0,0,185,234,0,5,2,70,50,192,14,192,14,0,2,0,1,0,0,185,234,0,5,2,71,50,192,14,192,14,0,2,0,1,0,0,185,234,0,5,2,72,50,192,14,192,14,0,2,0,1,0,0,185,234,0,5,2,76,50,192,14,192,14,0,2,0,1,0,0,185,234,0,5,2,65,50,192,14,2,97,50,192,14,0,1,0,1,0,0,185,234,0,4,192,5,6,31,192,188,0,28,0,1,0,0,185,234,0,16,32,1,5,3,168,62,0,0,0,0,0,0,0,2,0,49,2,99,50,192,14,0,1,0,1,0,0,199,127,0,4,192,26,92,31,192,235,0,28,0,1,0,0,221,96,0,16,32,1,5,3,131,235,0,0,0,0,0,0,0,2,0,49,2,100,50,192,14,0,1,0,1,0,0,210,131,0,4,192,31,80,31,192,98,0,1,0,1,0,0,219,174,0,4,192,12,94,31,2,102,50,192,14,0,1,0,1,0,0,10,240,0,4,192,35,51,31,2,103,50,192,14,0,1,0,1,0,0,221,96,0,4,192,42,93,31,2,104,50,192,14,0,1,0,1,0,0,209,209,0,4,192,54,112,31,192,166,0,1,0,1,0,0,255,146,0,4,192,41,162,31,>>,
            <<196,136,0,0,0,1,0,0,0,0,0,0,11,110,101,117,114,111,109,97,110,99,101,114,8,102,101,101,100,102,97,99,101,3,99,111,109,0,0,1,0,1,>>,
            <<196,136,128,0,0,1,0,0,0,2,0,4,11,110,101,117,114,111,109,97,110,99,101,114,8,102,101,101,100,102,97,99,101,3,99,111,109,0,0,1,0,1,192,24,0,2,0,1,0,2,163,0,0,6,3,110,115,48,192,24,192,24,0,2,0,1,0,2,163,0,0,6,3,110,115,49,192,24,192,54,0,28,0,1,0,2,163,0,0,16,32,1,26,80,0,7,0,1,0,0,0,0,0,0,0,121,192,54,0,1,0,1,0,2,163,0,0,4,85,199,135,79,192,72,0,28,0,1,0,2,163,0,0,16,32,1,26,80,0,7,0,1,0,0,0,0,0,0,0,128,192,72,0,1,0,1,0,2,163,0,0,4,85,199,135,80,>>,
            <<116,141,0,0,0,1,0,0,0,0,0,0,11,110,101,117,114,111,109,97,110,99,101,114,8,102,101,101,100,102,97,99,101,3,99,111,109,0,0,1,0,1,>>,
            <<116,141,132,0,0,1,0,1,0,2,0,4,11,110,101,117,114,111,109,97,110,99,101,114,8,102,101,101,100,102,97,99,101,3,99,111,109,0,0,1,0,1,192,12,0,1,0,1,0,0,1,44,0,4,85,199,135,98,192,24,0,2,0,1,0,0,1,44,0,6,3,110,115,48,192,24,192,24,0,2,0,1,0,0,1,44,0,6,3,110,115,49,192,24,192,70,0,1,0,1,0,0,1,44,0,4,85,199,135,79,192,70,0,28,0,1,0,0,1,44,0,16,32,1,26,80,0,7,0,1,0,0,0,0,0,0,0,121,192,88,0,1,0,1,0,0,1,44,0,4,85,199,135,80,192,88,0,28,0,1,0,0,1,44,0,16,32,1,26,80,0,7,0,1,0,0,0,0,0,0,0,128,>>,
            <<12,117,1,0,0,1,0,0,0,0,0,0,8,102,101,101,100,102,97,99,101,3,99,111,109,0,0,16,0,1,>>,
            <<12,117,129,128,0,1,0,2,0,2,0,4,8,102,101,101,100,102,97,99,101,3,99,111,109,0,0,16,0,1,192,12,0,16,0,1,0,0,1,44,0,70,69,107,101,121,98,97,115,101,45,115,105,116,101,45,118,101,114,105,102,105,99,97,116,105,111,110,61,67,120,122,78,122,51,90,68,56,82,81,81,114,103,53,111,108,65,97,85,116,72,57,90,79,87,118,104,76,120,112,75,71,111,49,112,55,45,122,67,110,76,52,192,12,0,16,0,1,0,0,1,44,0,10,9,70,69,69,68,58,70,65,67,69,192,12,0,2,0,1,0,0,1,19,0,6,3,110,115,48,192,12,192,12,0,2,0,1,0,0,1,19,0,6,3,110,115,49,192,12,192,146,0,1,0,1,0,1,81,103,0,4,85,199,135,79,192,146,0,28,0,1,0,1,81,103,0,16,32,1,26,80,0,7,0,1,0,0,0,0,0,0,0,121,192,164,0,1,0,1,0,1,81,103,0,4,85,199,135,80,192,164,0,28,0,1,0,1,81,103,0,16,32,1,26,80,0,7,0,1,0,0,0,0,0,0,0,128,>>,
            <<81,214,1,0,0,1,0,0,0,0,0,0,8,102,101,101,100,102,97,99,101,3,99,111,109,0,0,2,0,1,>>,
            <<81,214,129,128,0,1,0,2,0,0,0,4,8,102,101,101,100,102,97,99,101,3,99,111,109,0,0,2,0,1,192,12,0,2,0,1,0,0,1,44,0,6,3,110,115,48,192,12,192,12,0,2,0,1,0,0,1,44,0,6,3,110,115,49,192,12,192,42,0,1,0,1,0,0,29,204,0,4,85,199,135,79,192,42,0,28,0,1,0,0,29,204,0,16,32,1,26,80,0,7,0,1,0,0,0,0,0,0,0,121,192,60,0,1,0,1,0,0,29,204,0,4,85,199,135,80,192,60,0,28,0,1,0,0,29,204,0,16,32,1,26,80,0,7,0,1,0,0,0,0,0,0,0,128,>>,
            <<177,60,1,0,0,1,0,0,0,0,0,0,1,57,1,55,1,48,1,48,1,48,1,48,1,48,1,48,1,48,1,48,1,48,1,48,1,48,1,48,1,48,1,48,1,49,1,48,1,48,1,48,1,55,1,48,1,48,1,48,1,48,1,53,1,97,1,49,1,49,1,48,1,48,1,50,3,105,112,54,4,97,114,112,97,0,0,12,0,1,>>,
            <<177,60,129,128,0,1,0,1,0,2,0,4,1,57,1,55,1,48,1,48,1,48,1,48,1,48,1,48,1,48,1,48,1,48,1,48,1,48,1,48,1,48,1,48,1,49,1,48,1,48,1,48,1,55,1,48,1,48,1,48,1,48,1,53,1,97,1,49,1,49,1,48,1,48,1,50,3,105,112,54,4,97,114,112,97,0,0,12,0,1,192,12,0,12,0,1,0,0,14,16,0,18,3,110,115,48,8,102,101,101,100,102,97,99,101,3,99,111,109,0,192,52,0,2,0,1,0,0,14,16,0,6,3,110,115,49,192,106,192,52,0,2,0,1,0,0,14,16,0,2,192,102,192,102,0,1,0,1,0,0,29,190,0,4,85,199,135,79,192,102,0,28,0,1,0,0,29,190,0,16,32,1,26,80,0,7,0,1,0,0,0,0,0,0,0,121,192,132,0,1,0,1,0,0,29,190,0,4,85,199,135,80,192,132,0,28,0,1,0,0,29,190,0,16,32,1,26,80,0,7,0,1,0,0,0,0,0,0,0,128,>>,
        ]
        for d <- data do
            {err,ret} = DNS.parse(d)
            assert err == :ok
        end
    end

end