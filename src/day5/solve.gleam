import adglent.{First, Second}
import gleam/dict
import gleam/int
import gleam/io
import gleam/list
import gleam/order
import gleam/result
import gleam/set
import gleam/string

fn parse(input: String) -> #(dict.Dict(Int, set.Set(Int)), List(List(Int))) {
  let assert Ok(#(rules, pages)) = case string.split(input, on: "\n\n") {
    [r, p] -> Ok(#(r, p))
    _ -> Error("Invalid input")
  }
  let assert Ok(page_rules) = rules
    |> string.split(on: "\n")
    |> list.map(fn (rule) {
      rule
      |> string.split(on: "|")
      |> fn (l) {
        case l {
          [first, second] -> Ok(#(first, second))
          _ -> Error(Nil)
        }
      }
      |> result.try(fn (pair) {
        pair
        |> fn (p) { 
          p.0
          |> int.parse()
          |> result.map(fn (i) { #(i, p.1) })        }
      })
      |> result.try(fn (pair) {
        pair
        |> fn (p) { 
          p.1
          |> int.parse()
          |> result.map(fn (i) { #(p.0, i) })  
        }
      })
      |> result.map_error(fn (_) { Error("Invalid input") })
    })
    |> result.all()
    |> result.map(fn (l) {
      l
      |> list.group(fn (e) { e.0 })
      |> dict.map_values(fn (_, v) {
        v
        |> list.map(fn (i) { i.1 })
        |> set.from_list
      })
    })
  let assert Ok(pages_lists) = pages
    |> string.split(on: "\n")
    |> list.map(fn (l) {
      l
      |> string.split(on: ",")
      |> list.map(int.parse)
      |> result.all
      |> result.map_error(fn (_) { Error("Invalid input") })
    })
    |> result.all
  #(page_rules, pages_lists)
}

fn middle(l: List(Int)) -> Int {
  case l {
    [i] -> i
    _ -> l
      |> list.take(list.length(l) - 1)
      |> list.drop(1)
      |> middle
  }
}

fn is_valid(page_rules: dict.Dict(Int, set.Set(Int)), pages: List(Int)) {
  internal_is_valid(page_rules, set.new(), pages)
}

fn internal_is_valid(page_rules: dict.Dict(Int, set.Set(Int)), previous_pages: set.Set(Int), next_pages: List(Int)) {
  case next_pages {
    [] -> True
    [a, ..rest] -> page_rules
      |> dict.get(a)
      |> result.map(fn (followers) {
        let num_illegal_followers = followers
          |> set.intersection(previous_pages)
          |> set.size
        case num_illegal_followers {
          0 -> internal_is_valid(page_rules, set.insert(previous_pages, a), rest)
          _ -> False
        }
      })
      |> result.unwrap(or: internal_is_valid(page_rules, set.insert(previous_pages, a), rest))
  }
}

fn build_cmp(page_rules: dict.Dict(Int, set.Set(Int))) -> fn(Int, Int) -> order.Order {
  fn(a: Int, b: Int) {
    page_rules
    |> dict.get(a)
    |> result.try(fn (s) {
      case set.contains(s, b) {
        True -> Ok(order.Lt)
        False -> Error(Nil)
      }
    })
    |> result.try_recover(fn(_) {
      page_rules
      |> dict.get(b)
      |> result.try(fn (s) {
        case set.contains(s, a) {
          True -> Ok(order.Gt)
          False -> Ok(order.Eq)
        }
      })
    })
    |> result.unwrap(or: order.Eq)
  }
}

pub fn part1(input: String) {
  let parsed_input = input
  |> parse
  parsed_input.1
  |> list.filter(fn (e) {
    is_valid(parsed_input.0, e)
  })
  |> list.map(middle)
  |> int.sum
}

pub fn part2(input: String) {
  let parsed_input = input
  |> parse
  parsed_input.1
  |> list.filter(fn (e) {
    is_valid(parsed_input.0, e) == False
  })
  |> list.map(fn (l) {
    l
    |> list.sort(by: build_cmp(parsed_input.0))
  })
  |> list.map(middle)
  |> int.sum
}

pub fn main() {
  let assert Ok(part) = adglent.get_part()
  let assert Ok(input) = adglent.get_input("5")
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
