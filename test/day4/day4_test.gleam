import gleam/list
import gleeunit/should
import adglent.{type Example, Example}
import day4/solve

type Problem1AnswerType =
  Int

type Problem2AnswerType =
  Int

/// Add examples for part 1 here:
/// ```gleam
///const part1_examples: List(Example(Problem1AnswerType)) = [Example("some input", "")]
/// ```
const part1_examples: List(Example(Problem1AnswerType)) = [
  Example(
  "MMMSXXMASM
MSAMXMSMSA
AMXSXMAAMM
MSAMASMSMX
XMASAMXAMM
XXAMMXXAMA
SMSMSASXSS
SAXAMASAAA
MAMMMXMMMM
MXMXAXMASX",
  18
)
]

/// Add examples for part 2 here:
/// ```gleam
///const part2_examples: List(Example(Problem2AnswerType)) = [Example("some input", "")]
/// ```
const part2_examples: List(Example(Problem2AnswerType)) = [
  Example(
  "MMMSXXMASM
MSAMXMSMSA
AMXSXMAAMM
MSAMASMSMX
XMASAMXAMM
XXAMMXXAMA
SMSMSASXSS
SAXAMASAAA
MAMMMXMMMM
MXMXAXMASX",
  9
)
]

pub fn part1_test() {
  part1_examples
  |> should.not_equal([])
  use example <- list.map(part1_examples)
  solve.part1(example.input)
  |> should.equal(example.answer)
}

pub fn part2_test() {
  part2_examples
  |> should.not_equal([])
  use example2 <- list.map(part2_examples)
  solve.part2(example2.input)
  |> should.equal(example2.answer)
}
