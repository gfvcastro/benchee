defmodule Benchee.Output.BenchmarkPrinter do
  @moduledoc false

  alias Benchee.{Conversion.Duration, Benchmark}

  @doc """
  Shown when you try to define a benchmark with the same name twice.

  How would you want to discern those anyhow?
  """
  def duplicate_benchmark_warning(name) do
    IO.puts "You already have a job defined with the name \"#{name}\", you can't add two jobs with the same name!"
  end

  @doc """
  Prints general information such as system information and estimated
  benchmarking time.
  """
  def configuration_information(%{configuration: %{print: %{configuration: false}}}) do
    nil
  end
  def configuration_information(%{scenarios: scenarios, system: sys, configuration: config}) do
    system_information(sys)
    suite_information(scenarios, config)
  end

  defp system_information(%{erlang: erlang_version,
                            elixir: elixir_version,
                            os: os,
                            num_cores: num_cores,
                            cpu_speed: cpu_speed,
                            available_memory: available_memory}) do
    IO.puts "Operating System: #{os}"
    IO.puts "CPU Information: #{cpu_speed}"
    IO.puts "Number of Available Cores: #{num_cores}"
    IO.puts "Available memory: #{available_memory}"
    IO.puts "Elixir #{elixir_version}"
    IO.puts "Erlang #{erlang_version}"
  end

  defp suite_information(scenarios, %{parallel: parallel,
                                 time:     time,
                                 warmup:   warmup,
                                 inputs:   inputs}) do
    scenario_count = length(scenarios)
    exec_time      = warmup + time
    total_time     = scenario_count * exec_time

    IO.puts """
    Benchmark suite executing with the following configuration:
    warmup: #{Duration.format(warmup)}
    time: #{Duration.format(time)}
    parallel: #{parallel}
    inputs: #{inputs_out(inputs)}
    Estimated total run time: #{Duration.format(total_time)}

    """
  end

  defp inputs_out(nil), do: "none specified"
  defp inputs_out(inputs) do
    inputs
    |> Map.keys
    |> Enum.join(", ")
  end

  @doc """
  Prints a notice which job is currently being benchmarked.
  """
  def benchmarking(_, _, %{print: %{benchmarking: false}}), do: nil
  def benchmarking(name, input_name, _config) do
    IO.puts "Benchmarking #{name}#{input_information(input_name)}..."
  end

  @no_input Benchmark.no_input
  defp input_information(@no_input),  do: ""
  defp input_information(input_name), do: " with input #{input_name}"

  @doc """
  Prints a warning about accuracy of benchmarks when the function is super fast.
  """
  def fast_warning do
    IO.puts """
    Warning: The function you are trying to benchmark is super fast, making measures more unreliable! See: https://github.com/PragTob/benchee/wiki/Benchee-Warnings#fast-execution-warning

    You may disable this warning by passing print: [fast_warning: false] as configuration options.
    """
  end
end
