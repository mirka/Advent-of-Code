import Foundation

func textFromFile(name: String) -> String? {
  do {
    if let path = Bundle.main.path(forResource: name, ofType: "txt") {
      return try String(contentsOfFile: path, encoding: String.Encoding.utf8)
    }
  } catch { }
  return nil
}

class Rooms {
  var all: [Room]

  struct Room {
    let name: String
    let sector: Int
    let checksum: String
    let delimitedName: String

    var isRealRoom: Bool {
      let chars = name.characters
      var counts = [Character:Int]()
      var generatedChecksum = ""

      for char in chars {
        if let count = counts[char] {
          counts[char] = count + 1
        } else {
          counts[char] = 1
        }
      }

      let sortedCounts = counts.sorted(by: {
        switch true {
        case $0.value > $1.value:
          return true
        case $0.value == $1.value:
          return $0.key < $1.key
        default:
          return false
        }
      })

      for (i, count) in sortedCounts.enumerated() {
        if i < 5 {
          generatedChecksum += String(count.key)
        }
      }

      return checksum == generatedChecksum
    }

    var decryptedName: String {
      let chars = delimitedName.unicodeScalars
      let shift: Int = sector % 26
      let decrypted: [UnicodeScalar] = chars.map {
        if $0 == "-" {
          return UnicodeScalar(" ")!
        } else {
          let codePoint = Int($0.value) + shift
          return UnicodeScalar( codePoint > 122 ? codePoint - 26 : codePoint)!
        }
      }
      return decrypted.reduce("", { $0 + String($1) } )
    }
  }

  init(from text: String) {
    let lines = text.components(separatedBy: "\n").filter { !$0.isEmpty }
    let delimiters = CharacterSet(charactersIn: "-[]")

    all = lines.map {
      var elements = $0.components(separatedBy: delimiters).filter { !$0.isEmpty }
      let checksum = elements.removeLast()
      let sector = Int(elements.removeLast())
      let name = elements.joined()

      return Room(name: name, sector: sector!, checksum: checksum, delimitedName: elements.joined(separator: "-"))
    }
  }

  subscript(i: Int) -> Room {
    return all[i]
  }
}


let inputFileName = "day04-1"
if let inputFile = textFromFile(name: inputFileName) {
  let rooms = Rooms(from: inputFile)

  let realRooms = rooms.all.filter { $0.isRealRoom }

  realRooms.map {
    if $0.decryptedName.contains("northpole") {
      print($0.sector)
    }
  }

}
