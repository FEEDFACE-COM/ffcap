
import Core.Util

log "capture start"

{:ok, pid} = Core.Capture.start_link System.argv, nil, :parser
_ref = Process.monitor pid

receive do
    {:DOWN,_ref,:process,_pid,_reason} ->
        :ok
end


