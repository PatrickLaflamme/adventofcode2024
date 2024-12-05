import adglent.{First, Second}
import gleam/int
import gleam/io
import gleam/list
import gleam/regex
import gleam/result
import gleam/string

fn regex_match(re: regex.Regex, input: String) -> Int {
  re
    |> regex.scan(content: input)
    |> list.length
}

pub fn part1(input: String) {
  let width = input
  |> string.split(on: "\n")
  |> list.first
  |> result.unwrap(or: "")
  |> string.length

  let down_up = width
    |> int.to_string
  let down_diag = width + 1
    |> int.to_string
  let up_diag = width - 1
    |> int.to_string

  [
    "XMAS",
    "SAMX",
    "S(?=(.|\n){" <> down_up <> "}A(.|\n){" <> down_up <> "}M(.|\n){" <> down_up <> "}X)",
    "S(?=(.|\n){" <> up_diag <> "}A(.|\n){" <> up_diag <> "}M(.|\n){" <> up_diag <> "}X)",
    "S(?=(.|\n){" <> down_diag <> "}A(.|\n){" <> down_diag <> "}M(.|\n){" <> down_diag <> "}X)",
    "X(?=(.|\n){" <> down_up <> "}M(.|\n){" <> down_up <> "}A(.|\n){" <> down_up <> "}S)",
    "X(?=(.|\n){" <> up_diag <> "}M(.|\n){" <> up_diag <> "}A(.|\n){" <> up_diag <> "}S)",
    "X(?=(.|\n){" <> down_diag <> "}M(.|\n){" <> down_diag <> "}A(.|\n){" <> down_diag <> "}S)"
  ]
  |> list.map(regex.from_string)
  |> result.all
  |> result.map(fn (l) {
    l
    |> list.map(fn (r) { regex_match(r, input) })
    |> int.sum
  })
  |> result.unwrap(or: 0)
}

pub fn part2(input: String) {
  let width = input
  |> string.split(on: "\n")
  |> list.first
  |> result.unwrap(or: "")
  |> string.length
  |> fn (i) { i - 1 }
  |> int.to_string
  [
    "M(?=.S(.|\n){" <> width <>"}A(.|\n){" <> width <> "}M.S)",
    "M(?=.M(.|\n){" <> width <>"}A(.|\n){" <> width <> "}S.S)",
    "S(?=.M(.|\n){" <> width <>"}A(.|\n){" <> width <> "}S.M)",
    "S(?=.S(.|\n){" <> width <>"}A(.|\n){" <> width <> "}M.M)",
  ]
  |> list.map(regex.from_string)
  |> result.all
  |> result.map(fn (l) {
    l
    |> list.map(fn (r) { regex_match(r, input) })
    |> int.sum
  })
  |> result.unwrap(or: 0)
}

pub fn main() {
  let assert Ok(part) = adglent.get_part()
  let assert Ok(input) = adglent.get_input("4")
  case part {
    First ->
      part1(input)
      |> adglent.inspect
      |> io.println
    Second ->
      part2(input)
      |> adglent.inspect
      |> io.println
  }
}
