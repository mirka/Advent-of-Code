defmodule Day17Test do
  use ExUnit.Case
  import Day17

  test "get_char_at" do
    assert get_char_at([[1, 2, 3], [4, 5, 6]], 2, 0) === 3
    assert get_char_at([[1, 2, 3], [4, 5, 6]], 3, 0) === nil
  end

  test "is_intersection" do
    assert is_intersection(
             [
               '.#.',
               '###',
               '.#.'
             ],
             1,
             1
           ) === true

    assert is_intersection(
             [
               '.#.',
               '##.',
               '.#.'
             ],
             1,
             1
           ) === false
  end

  test "find_intersections" do
    assert find_intersections([
             '.#.#',
             '#####',
             '.#.#'
           ]) === [[3, 1], [1, 1]]
  end
end
