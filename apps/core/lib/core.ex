defmodule Core do

    import Core.Util

    use Application
    
    
    def start(_type, args) do
        log "core start #{inspect args}"
        Core.Supervisor.start_link
    end
    
end
