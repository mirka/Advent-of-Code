class Keypad {
  var current = 5
  
  func move(direction: Direction) -> Int {
    switch direction {
    case .up:
      if current > 3 {
        current -= 3
      }
    case .right:
      if current % 3 != 0 {
        current += 1
      }
    case .down:
      if current < 7 {
        current += 3
      }
    case .left:
      if (current + 2) % 3 != 0 {
        current -= 1
      }
    }
    
    return current
  }
}

class Instructions {
  private let keypad = Keypad()
  let linesOfStrings: [String]?
  var numericalCode: String {
    var result = ""
    if let lines = linesOfStrings {
      for line in lines {
        result += (moveButtonForLine(line: line)).description
      }
    }
    return result
  }
  
  init(fromInput input: [String]) {
    linesOfStrings = input
  }
  
  private func moveButtonForLine(line: String) -> Int {
    for direction in line.characters {
      keypad.move(direction: Direction(rawValue: direction)!)
    }
    return keypad.current
  }
}

enum Direction: Character {
  case up = "U"
  case right = "R"
  case down = "D"
  case left = "L"
}

let input = ["RRLLRLLRULLRUUUDRDLDDLLLDDDDDUUURRRRUUDLRULURRRDRUDRUUDDRUDLLLRLDDDUDRDDRRLLLLRLRLULUURDRURRUULDRRDUDURRUURURDLURULLDUDRDLUUUUDDURRLLLUDLDLRDRRRDULLDLDULLDRLDLDURDLRRULLDDLDRLLLUDDLLRDURULLDDDDDUURURLRLRRDUURUULRLLLULLRLULLUUDRRLLDURLDDDDULUUDLUDDDULRLDURDDRUUDRRUUURLLLULURUDRULDRDUDUDRRDDULRURLLRRLRRLLDLULURDRDRULDRDRURUDLLRRDUUULDDDUURDLULDLRLLURRURLLUDURDDRUDRDLLLLDLRLDLDDRDRRDUUULLUULRRDLURLDULLDLDUUUULLLDRURLRULLULRLULUURLLRDDRULDULRLDRRURLURUDLRRRLUDLDUULULLURLDDUDDLLUDRUDRLDUDURRRRLRUUURLUDDUDURDUDDDLLRLRDDURDRUUDUDRULURLRLDRULDRRLRLDDDRDDDRLDUDRLULDLUDLRLRRRLRDULDDLRRDDLDDULDLLDU",
             "RULLUDDUDLULRRDLLDRUDLLLDURLLLURDURLRDRRDLRDRDLLURRULUULUDUDDLLRRULLURDRLDURDLDDUURLUURLDLDLRLDRLRUULDRLRLDRLRLUDULURDULLLDRUDULDURURRRUDURDUDLRDRRURULRRLRLRRRRRRDRUDLDRULDRUDLRDLRRUDULDLRLURRRLLDRULULRUDULRLULLRLULDRUDUULLRUULDULDUDDUUULLLDRDDRRDLURUUDRRLRRRDLRRLULLLLDLRUULDLLULURUURURDRURLLDUDRRURRURRUUDDRRDDRRRRUDULULRLUULRRDDRDDLLUDLDLULLRLDRLLUULDURLDRULDDUDRUUUURRLDDUDRUURUDLLDLDLURDLULDRLLLULLLUDLLDLD",
             "RDLDULURDLULRRDLRLLLULRUULURULLLDLLDDRLLURUUUURDRLURLLRLRLLLULRDLURDURULULDDUDDUDRLRLDLULLURRRUULUDRDURRRUDDDLUDLDLRLRRLLLRUULLLLURRDDDRRRUURULRLDRRRLRLUDDRRULDDDRUUDDRLLDULRLUDUDLDLDDDUDDLLDDRDRDUDULDRRUDRDRRDRLUURDLRDDDULLDRRRRRUDRLURDUURRDDRLUDLURRRLRDDDLRRLUULRLURDUUURRDLDDULLLRURRRUDRLUDLLDDDDDUDDRDULLUUDDURRLULLUDULUUDRLDRRRLLURLRRLLDLLLLUDRUUUDDULLRDLLDUDUDUURRUUUDRUURDRDLLDLDDULLDDRRULDLDDUUURLDLULLLRRLLRDDULLDLDLDDLDLDULURRDURURDRDRRDLR",
             "RDRLRRUUDRLDUDLLDLUDLUUDUDLRRUUDRDDDLDDLLLRRRUDULLRRRRRURRRLUDDDLRRRRUUULDURDRULLDLRURRUULUDRURRRRLRURLRDUUDUDUDRDDURRURUDLLLLLRURUULRUURLLURDRUURLUDDDRLDDURDLDUDRURDRLRRRRUURDDRRRRURDLUUDRLDRDUULURUDDULLURRDUDLUULLDURRURLUDUUDRDDDUUDDUUUULDLDUDDLUDUUDRURLLULRUUULLRRDDUDDLULDDUUUDLUDDLDDLLRUUDRULLRRDRLLDLLRRLULLRRDDRLRDUULLLUULLDLLUDUDDLRDULUDLDLUDDRRRRDUDLUULLULDLRRDLULRLRRRULRURRDRLULDDUDLDLDULLURLLRDLURRULURDLURLUDRDRRUUDRLLUDDRLRDDUURLRRDUDLDRURDUUUDRRLLRDLDLLDRRURLUDURUULDUDLDDDDRUULLDDRLRURRDURLURRLDDRRRRLRLRDRURUDDRDLDRURLULDDL",
             "RULRDLDDLRURDDDDDDRURLLLDDDUUULLRRDLDLURUURLUDLURRLUDUURDULDRUULDDURULDUULDDULLLUDLRULDRLDLRDDRRDLDDLLDRRUDDUDRDUULUDLLLDDLUUULDDUUULRRDULLURLULDLRLLLRLURLLRLRLDRDURRDUUDDURRULDDURRULRDRDUDLRRDRLDULULDRDURDURLLLDRDRLULRDUURRUUDURRDRLUDDRRLDLDLULRLLRRUUUDDULURRDRLLDLRRLDRLLLLRRDRRDDLDUULRLRRULURLDRLRDULUDRDLRUUDDDURUDLRLDRRUDURDDLLLUDLRLURDUDUDULRURRDLLURLLRRRUDLRRRLUDURDDDDRRDLDDLLDLRDRDDRLLLURDDRDRLRULDDRRLUURDURDLLDRRRDDURUDLDRRDRUUDDDLUDULRUUUUDRLDDD"
]
let myInstructions = Instructions(fromInput: input)
myInstructions.numericalCode
