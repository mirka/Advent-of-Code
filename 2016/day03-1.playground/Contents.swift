import Foundation

class TriangleList {
  var array = [[Int]]()
  var possibleTriangles: Int {
    var count = 0
    for triangle in array {
      if isPossibleTriangle(arrayOfSides: triangle) {
        count += 1
      }
    }
    return count
  }
  
  init(fromFileWithName filename: String) {
    guard let path = Bundle.main.path(forResource: inputFile, ofType: "txt") else {
      return
    }
    
      do {
        let content = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
        let lines = content.components(separatedBy: "\n")
        let regex = try NSRegularExpression(pattern: "\\d+")
        
        for line in lines {
          guard !line.isEmpty else {
            break
          }
          let lineAsNSString = line as NSString
          let thisLine = regex.matches(in: line, range: NSRange(location: 0, length: lineAsNSString.length))
          self.array.append(thisLine.map {
            let substring = lineAsNSString.substring(with: $0.range)
            return Int(substring, radix: 10)!
          })
        }
      } catch {
        print("Error in input")
      }
  }

  private func isPossibleTriangle(arrayOfSides: [Int]) -> Bool {
    let sum = arrayOfSides[0] + arrayOfSides[1] + arrayOfSides[2]

    for side in arrayOfSides {
      if (sum - side) <= side {
        return false
      }
    }
    
    return true
  }


}


let inputFile = "day03-1"
let myArray = TriangleList(fromFileWithName: inputFile)
print(myArray.possibleTriangles)