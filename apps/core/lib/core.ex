defmodule Core do

    use Application
    
    def start(_type, _args) do
        Core.Supervisor.start_link
    end
    
end
