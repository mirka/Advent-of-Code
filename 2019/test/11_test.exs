defmodule Day11Test do
  use ExUnit.Case
  require PaintingRobot
  require HullPanels
  require ScreenDraw

  test "Normalize direction" do
    assert PaintingRobot.normalize_direction(0) === 0
    assert PaintingRobot.normalize_direction(-90) === 270
    assert PaintingRobot.normalize_direction(-180) === 180
    assert PaintingRobot.normalize_direction(360) === 0
    assert PaintingRobot.normalize_direction(-270) === 90
  end

  test "Turn" do
    assert PaintingRobot.turn({0, 0}, 0) === {0, 1}
    assert PaintingRobot.turn({0, 0}, 90) === {1, 0}
    assert PaintingRobot.turn({0, 0}, 180) === {0, -1}
    assert PaintingRobot.turn({0, 0}, 270) === {-1, 0}
  end

  test "Set color" do
    panels =
      %HullPanels{position: {2, 4}}
      |> HullPanels.paint(1)

    assert panels.map[{2, 4}] === 1
  end

  test "Get color" do
    assert HullPanels.get_color(%HullPanels{}) === 0
    assert HullPanels.get_color(%HullPanels{map: %{{2, 4} => 1}, position: {2, 4}}) === 1
  end

  test "Move to" do
    # 90 deg
    manipulator = PaintingRobot.make_direction_manipulator(1)

    assert %HullPanels{}
           |> HullPanels.move_to(manipulator)
           |> Map.get(:position) === {1, 0}
  end

  test "Paint over existing panel" do
    panels =
      %HullPanels{position: {2, 4}, map: %{{2, 4} => 1}}
      |> HullPanels.paint(0)

    assert panels.map[{2, 4}] === 0
  end

  test "Paint and turn" do
    panels1 =
      %HullPanels{direction: 0, position: {2, 4}, map: %{{2, 4} => 1}}
      |> PaintingRobot.paint_and_turn(0, 1)

    assert panels1 === %HullPanels{direction: 90, position: {3, 4}, map: %{{2, 4} => 0}}

    panels2 =
      %HullPanels{direction: 0, position: {2, 4}, map: %{{2, 4} => 1}}
      |> PaintingRobot.paint_and_turn(0, 0)

    assert panels2 === %HullPanels{direction: 270, position: {1, 4}, map: %{{2, 4} => 0}}
  end

  test "Find bounds" do
    map = %{{-2, 4} => 0, {3, 0} => 0, {5, -3} => 0}

    assert ScreenDraw.find_bounds(map) === {[-2, 5], [-3, 4]}
  end
end
