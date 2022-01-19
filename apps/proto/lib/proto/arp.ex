defmodule Proto.ARP do
    
    import Proto.Util    
   
    def parse(<<
            data::binary
        >>) do
        msg = "arp \n" <> dump data
        {:ok, [msg]}
    end
end