defmodule Core.RegistryTest do
    use ExUnit.Case
    
    setup do
        {:ok, registry} = start_registry()
        {:ok, registry: registry}
    end
    
    defp start_registry() do
        {:ok, registry} = Core.Registry.start_link
    end
  
    test "can receive msgs", %{registry: registry} do
        r = Core.Registry.stat(registry)
        Core.Registry.msg(registry)
        assert Core.Registry.stat(registry) > r
        :timer.sleep 3000
    end  
    
    test "can msg to atom" do
        r = Core.Registry.stat(Core.Registry)
        Core.Registry.msg(Core.Registry)
        assert Core.Registry.stat(Core.Registry) > r
        :timer.sleep 3000
    end  

    test "can do ready msg" do
        Core.Registry.ready(Core.Registry, node)
        Core.Registry.msg(Core.Registry)
        :timer.sleep 100
    end

end
