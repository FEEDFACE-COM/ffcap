defmodule Proto.MDNS do

    import Proto.Util    
    
    def parse(<<data::binary>>) do
        {:ok, ["mdns \n" <> dump data]}
    end

end