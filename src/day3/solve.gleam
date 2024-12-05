import adglent.{First, Second}
import gleam/int
import gleam/io
import gleam/list
import gleam/option
import gleam/regex
import gleam/result
import gleam/string

fn parse_ints(a: option.Option(String), b: option.Option(String)) -> Result(#(Int, Int), Nil) {
  option.to_result(a, Nil)
  |> result.map(int.parse)
  |> result.flatten
  |> result.map(fn (a_int) {
    option.to_result(b, Nil)
    |> result.map(int.parse)
    |> result.flatten
    |> result.map(fn (b_int) { #(a_int, b_int) })
  })
  |> result.flatten
}

pub fn part1(input: String) -> Int {
  let assert Ok(re) = regex.from_string("mul\\(([0-9]+),([0-9+]+)\\)")
  regex.scan(with: re, content: input)
  |> list.map(fn (match: regex.Match) {
    let assert Ok(#(first, second)) = case match.submatches {
      [a, b] -> result.replace_error(parse_ints(a, b), "Invalid numbers!")
      _ -> Error(string.append("invalid match: ", match.content))
    }
    first * second
  })
  |> int.sum
}

pub fn part2(input: String) {
  let assert Ok(re) = regex.from_string("(don't\\(\\)|do\\(\\))[^(don't\\(\\)|do\\(\\))]*mul\\(([0-9]+),([0-9+]+)\\)")
  string.split(input, on:"don't()")
  |> fn (l) {
  let #(first, rest) = case l {
      [a, ..rest] -> #(Ok(a), rest)
      _ -> #(Error(Nil), [])
    }
  let first_int = first
    |> result.map(part1)
    |> result.unwrap(or: 0)
  rest
    |> list.map(fn (e) {
      e
      |> string.split(on: "do()")
      |> list.split(1)
      |> fn (l) { l.1 }
      |> list.map(part1)
      |> int.sum
    })
    |> int.sum
    |> fn (i) { i + first_int }
 }
}

pub fn main() {
  let assert Ok(part) = adglent.get_part()
  let assert Ok(input) = adglent.get_input("3")
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
