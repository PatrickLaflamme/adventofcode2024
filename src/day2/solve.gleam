import adglent.{First, Second}
import gleam/bool
import gleam/dict
import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string

fn parse_and_process(input, handler: fn(List(Int)) -> Result(Bool, Nil)) {
  input
  |> string.split(on: "\n")
  |> list.map(fn (line) {
    line 
    |> string.split(on: " ")
    |> list.map(int.parse)
    |> result.all
  })
  |> result.all
  |> result.map(fn (reports) {
    reports
    |> list.map(fn (report) {
      report
      |> handler
      |> fn (result) {
        case result {
          Ok(True) -> 1
          _ -> 0
        }
      }
    })
    |> int.sum
  }) 
  |> result.unwrap(-1)
}

fn report_is_valid(report) {
    report
    |> list.window_by_2
    |> list.map(fn (pair) {
       let #(first, second) = pair
       let r = second - first
       case int.absolute_value(r) {
        1 | 2 | 3 -> Ok(r)
        _ -> Error(Nil)
      }
    })
    |> result.all
    |> result.try(fn (val) {
      val
      |> list.window_by_2()
      |> list.map(fn (pair) { 
        bool.to_int(pair.0 * pair.1 <= 0)
      })
      |> int.sum
      |> fn (total) { 
        case total < 1 {
          True -> Ok(True)
          False -> Error(Nil)
        }
      }
    })
  }

fn report_is_valid_with_drop(left: List(Int), mid: List(Int), right: List(Int)) {
  let partial_report = list.concat([left, right])
  let report = report_is_valid(partial_report)
  let new_left = list.take(left, list.length(left) - 1)
  let new_mid = list.drop(left, list.length(left) - 1)
  let new_right = list.concat([mid, right])
  case report, left {
    Ok(_), _ -> report
    Error(_), [] -> Ok(False)
    Error(_), _ -> report_is_valid_with_drop(new_left, new_mid, new_right)
  }
}

pub fn part1(input: String) {
  input
  |> parse_and_process(report_is_valid)
}

pub fn part2(input: String) {
  input
  |> parse_and_process(fn (report) {
    report_is_valid_with_drop(report, [], [])
  })
}

pub fn main() {
  let assert Ok(part) = adglent.get_part()
  let assert Ok(input) = adglent.get_input("2")
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
