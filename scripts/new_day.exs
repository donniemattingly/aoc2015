# foo.exs
defmodule NewDay do
  def generate_files do
    day = System.argv()
          |> List.first()
    generate_files_for_day(day)
  end

  def generate_files_for_day(day) do
    generate_file(day)
    generate_test_file(day)
  end

  def generate_file(day) do
    new_path = File.cwd!()
               |> Path.join("lib/day#{day}.ex")

    updated_file = File.cwd!()
                   |> Path.join("lib/day0.ex")
                   |> File.read!()
                   |> String.replace("Day0", "Day#{day}")

    File.write(new_path, updated_file)
  end

  def generate_test_file(day) do
    new_path = File.cwd!()
               |> Path.join("test/day#{day}_test.exs")

    updated_file = File.cwd!()
                   |> Path.join("test/day0_test.exs")
                   |> File.read!()
                   |> String.replace("Day0", "Day#{day}")

    File.write(new_path, updated_file)
  end
end

NewDay.generate_files()