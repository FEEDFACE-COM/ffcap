defmodule Core.ParserTest do
    use ExUnit.Case
    
    setup do
        {:ok, registry} = Core.Registry.start_link
        {:ok, registry: registry}
    end
    
    test "can subscribe to registry" do
        assert 1+1 = 2
    end
    

end