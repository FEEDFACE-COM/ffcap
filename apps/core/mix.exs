defmodule Core.Mixfile do
  use Mix.Project

  def project do
    [app: :core,
     version: "0.0.1",
     deps_path: "../../deps",
     lockfile: "../../mix.lock",
     elixir: "~> 1.0",
     escript: capture,
     deps: deps]
  end

  def application do
    [
        applications: [],
        mod: {Core, []}
    ]
  end


  def capture do
    [main_module: Core.Capture, embeded_elixir: true, app: nil, name: :capture]  
  end


  defp deps do
    [
        {:proto, in_umbrella: true},
    ]
  end
end
