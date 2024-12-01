import adglent.{First, Second}
import gleam/dict
import gleam/int.{absolute_value, compare, parse, sum}
import gleam/io
import gleam/list.{fold, map, sort, unzip, zip}
import gleam/result.{all}
import gleam/string.{split, trim}

fn parse_input(input: String) -> Result(#(List(Int), List(Int)), String) {
  split(input, on: "\n")
  |> map(fn(line: String) {
    trim(line)
    |> split(on: "   ")
    |> map(parse)
    |> fn(nums) {
      case nums {
        [Ok(a), Ok(b), ..] -> Ok(#(a, b))
        _ -> Error("Invalid Input")
      }
    }
  })
  |> all
  |> result.map(unzip)
}

pub fn part1(input: String) -> Int {
  let assert Ok(value) =
    input
    |> parse_input
    |> result.map(fn(result) {
      let #(first, second) = result
      let first_sorted = sort(first, compare)
      let second_sorted = sort(second, compare)
      zip(first_sorted, second_sorted)
      |> map(fn(entry) { absolute_value(entry.1 - entry.0) })
      |> sum
    })
  value
}

pub fn part2(input: String) -> Int {
  let assert Ok(#(first, second)) =
    input
    |> parse_input
  let second_dict =
    second
    |> fold(dict.new(), fn(d, elem) {
      case dict.get(d, elem) {
        Ok(val) -> dict.insert(d, elem, val + 1)
        Error(_) -> dict.insert(d, elem, 1)
      }
    })
  first
  |> map(fn(elem) {
    case dict.get(second_dict, elem) {
      Ok(val) -> elem * val
      Error(_) -> 0
    }
  })
  |> sum
}

pub fn main() {
  let assert Ok(part) = adglent.get_part()
  let assert Ok(input) = adglent.get_input("1")
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
