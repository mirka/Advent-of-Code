import Foundation

func textFromFile(name: String) -> String? {
  do {
    if let path = Bundle.main.path(forResource: name, ofType: "txt") {
      return try String(contentsOfFile: path, encoding: String.Encoding.utf8)
    }
  } catch { }
  return nil
}

class Messages {
  let all: [String]
  var counts = [[Character:Int]]()
  var corrected: String {
    for line in all {
      for (i, char) in line.characters.enumerated() {
        if i >= counts.count {
          counts.append([char: 1])
          continue
        }

        if let charcount = counts[i][char] {
          counts[i][char] = charcount + 1
        } else {
          counts[i][char] = 1
        }
      }
    }

    return counts.reduce("") {
      let maxElement = $1.min() { $0.value < $1.value }
      return $0 + String(maxElement!.key)
    }
  }

  init(from text: String) {
    all = text.components(separatedBy: "\n").filter { !$0.isEmpty }
  }
}


let inputFileName = "day06-2"
if let inputFile = textFromFile(name: inputFileName) {
  let messages = Messages(from: inputFile)
  print(messages.corrected)
}
