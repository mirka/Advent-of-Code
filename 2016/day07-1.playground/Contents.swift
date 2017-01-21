import Foundation

func textFromFile(name: String) -> String? {
  do {
    if let path = Bundle.main.path(forResource: name, ofType: "txt") {
      return try String(contentsOfFile: path, encoding: String.Encoding.utf8)
    }
  } catch { }
  return nil
}

class IPAddresses {
  let all: [IPAddress]

  init(from text: String) {
    let lines = text.components(separatedBy: "\n").filter { !$0.isEmpty }

    all = lines.map {
      let allFragments = $0.components(separatedBy: "[")
      var fragments = [String]()
      var bracketedFragments = [String]()

      for fragment in allFragments {
        if fragment.contains("]") {
          let splitComponents = fragment.components(separatedBy: "]")
          bracketedFragments.append(splitComponents[0])
          fragments.append(splitComponents[1])
        } else {
          fragments.append(fragment)
        }
      }
      return IPAddress(raw: $0, fragments: fragments, bracketedFragments: bracketedFragments)
    }
  }

}

struct IPAddress {
  let raw: String
  let fragments: [String]
  let bracketedFragments: [String]
  var supportsTLS: Bool {
    for fragment in bracketedFragments {
      if ABBAExistsIn(fragment: fragment) {
        return false
      }
    }
    for fragment in fragments {
      if ABBAExistsIn(fragment: fragment) {
        return true
      }
    }
    return false
  }

  func ABBAExistsIn(fragment: String) -> Bool {
    let chars = fragment.characters
    var char1: Character
    var char2: Character

    for i in 0..<(chars.count - 3) {
      let thisIndex = chars.index(chars.startIndex, offsetBy: i)
      let nextIndex = chars.index(after: thisIndex)
      char1 = chars[thisIndex]
      char2 = chars[nextIndex]

      if char1 != char2 &&
        chars[chars.index(after: nextIndex)] == char2 &&
        chars[chars.index(nextIndex, offsetBy: 2)] == char1 {
        return true
      }
    }
    return false
  }
}


let inputFileName = "data"
if let inputFile = textFromFile(name: inputFileName) {
  let addresses = IPAddresses(from: inputFile)
  var tlsCount = 0

  for address in addresses.all {
    if address.supportsTLS {
      tlsCount += 1
    }
//    print("\(address.raw): TLS? \(address.supportsTLS)")
  }

  print(tlsCount)
}

