import Foundation

class TriangleList {
  var rawArray = [Int]()
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
    var columns = Array(repeating: [Int](), count: 3)
    var currentColumn = 0
    
    do {
      let content = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
      let lines = content.components(separatedBy: "\n")
      let regex = try NSRegularExpression(pattern: "\\d+")

      for line in lines {
        if line.isEmpty  { continue }
        let lineAsNSString = line as NSString
        let thisLine = regex.matches(in: line, range: NSRange(location: 0, length: lineAsNSString.length))
        thisLine.forEach {
          let substring = lineAsNSString.substring(with: $0.range)
          rawArray.append( Int(substring, radix: 10)! )
        }
      }

      for i in rawArray.indices {
        columns[currentColumn].append(rawArray[i])
        if columns[currentColumn].count == 3 {
          array.append(columns[currentColumn])
          columns[currentColumn].removeAll()
        }

        if currentColumn < 2 {
          currentColumn += 1
        } else {
          currentColumn = 0
        }
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
let triangles = TriangleList(fromFileWithName: inputFile)
print(triangles.possibleTriangles)
