defmodule GenReport do
  alias GenReport.Parser

  @months %{
    "janeiro" => 0,
    "fevereiro" => 0,
    "março" => 0,
    "abril" => 0,
    "maio" => 0,
    "junho" => 0,
    "julho" => 0,
    "agosto" => 0,
    "setembro" => 0,
    "outubro" => 0,
    "novembro" => 0,
    "dezembro" => 0
  }

  @years %{
    2016 => 0,
    2017 => 0,
    2018 => 0,
    2019 => 0,
    2020 => 0
  }

  @users [
    "cleiton",
    "daniele",
    "danilo",
    "diego",
    "giuliano",
    "jakeliny",
    "joseph",
    "mayk",
    "rafael",
    "vinicius"
  ]

  def build(filename) do
    filename
    |> Parser.parse_file()
    |> Enum.reduce(report_acc(), fn line, report -> sum_values(line, report) end)
  end

  def build, do: {:error, "Insira o nome de um arquivo"}

  defp sum_values(
         [name, working_hours, _day, month, year],
         %{
           "all_hours" => all_hours,
           "hours_per_month" => hours_per_month,
           "hours_per_year" => hours_per_year
         }
       ) do
    all_hours = Map.put(all_hours, name, all_hours[name] + working_hours)

    hours_per_month =
      put_in(
        hours_per_month[name][month],
        hours_per_month[name][month] + working_hours
      )

    hours_per_year =
      put_in(
        hours_per_year[name][year],
        hours_per_year[name][year] + working_hours
      )

    build_report(
      all_hours,
      hours_per_month,
      hours_per_year
    )
  end

  defp report_acc do
    all_hours = Enum.into(@users, %{}, &{&1, 0})
    hours_per_month = Enum.into(@users, %{}, &{&1, @months})
    hours_per_year = Enum.into(@users, %{}, &{&1, @years})

    build_report(
      all_hours,
      hours_per_month,
      hours_per_year
    )
  end

  defp build_report(
         all_hours,
         hours_per_month,
         hours_per_year
       ),
       do: %{
         "all_hours" => all_hours,
         "hours_per_month" => hours_per_month,
         "hours_per_year" => hours_per_year
       }
end
