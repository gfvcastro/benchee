defmodule Benchee do
  @doc """
  Returns the initial benchmark configuration for Benhee, composed of defauls
  and an optional custom confiuration.
  Configuration times are given in seconds, but are converted to microseconds.

  Possible options:
  * time - total run time of a single benchmark (determines how often it is
           executed)

  iex> Benchee.init
  %{config: %{time: 5_000_000}, jobs: []}

  iex> Benchee.init %{time: 1}
  %{config: %{time: 1_000_000}, jobs: []}
  """
  def init(config \\ %{}) do
    Benchee.Config.init(config)
  end

  @doc """
  Runs the given benchmark for the configured time and returns a suite with
  the benchmarking results added to jobs..
  """
  def benchmark(suite, name, function) do
    Benchee.Benchmark.benchmark(suite, name, function)
  end
end
