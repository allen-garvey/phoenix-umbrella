#run task with 'mix distill.site'
defmodule Mix.Tasks.Distill.Site do
  use Mix.Task

  @shortdoc "Convenience task to run distill.html and distill.static together"
  def run(_args) do
    #start html task
    Mix.Task.run "distill.html", []
    #start static task
    Mix.Task.run "distill.static", []
  end
end