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

  var supportsSLS: Bool {
    var abas = [CharacterPair]()

    for fragment in fragments {
      let fragmentAbas = getABAsIn(fragment: fragment)
      abas.append(contentsOf: fragmentAbas)
    }

    for aba in abas {
      let bab = [String(aba.b), String(aba.a), String(aba.b)].joined()

      for fragment in bracketedFragments {
        if fragment.contains(bab) {
          return true
        }
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

  func getABAsIn(fragment: String) -> [CharacterPair] {
    let chars = fragment.characters
    var char1: Character
    var char2: Character
    var results = [CharacterPair]()

    for i in 0..<(chars.count - 2) {
      let thisIndex = chars.index(chars.startIndex, offsetBy: i)
      let nextIndex = chars.index(after: thisIndex)
      char1 = chars[thisIndex]
      char2 = chars[nextIndex]

      if char1 != char2 &&
        chars[chars.index(after: nextIndex)] == char1 {
        results.append(CharacterPair(a: char1, b: char2))
      }
    }
    
    return results
  }
}

struct CharacterPair {
  let a, b: Character
}

let inputFileName = "data"
if let inputFile = textFromFile(name: inputFileName) {
  let addresses = IPAddresses(from: inputFile)
  var slsCount = 0

  for address in addresses.all {
    if address.supportsSLS {
      slsCount += 1
    }
//    print("\(address.raw): SLS? \(address.supportsSLS)")
  }

  print(slsCount)
}
