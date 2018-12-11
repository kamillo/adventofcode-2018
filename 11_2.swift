#if os(Linux)
import Glibc
#else
import Darwin
#endif
import Foundation

let input = 6303

let test = 42

var grid: [[Int]] = Array(repeating: Array(repeating: 0, count: 299), count: 299)


for x in grid.indices {
    for y in grid[x].indices {
        let calc = ((((x + 1 + 10) * (y + 1)) + input) * (x + 1 + 10))
        let digits = String(calc).compactMap{Int(String($0))}
        var houndreds = 0
        if (digits.count >= 3) {
            houndreds = digits[String(calc).indices.count - 3]
        }
        grid[x][y] = houndreds - 5
        
        grid[x][y] += (y > 0 ? grid[x][y - 1] : 0) + (x > 0 ? grid[x - 1][y] : 0) - (x * y > 0 ? grid[x - 1][y - 1] : 0)
    }
}

grid.forEach { print($0) }


var max = 0
var xy = (0,0)
var size = 0
for x in 0..<grid.count {
    for y in 0..<grid[x].count {
        for i in 0..<min((grid.count - x), (grid[x].count - y)) {
            var sum = (x * y > 0 ? grid[x - 1][y - 1] : 0) + grid[x + i][y + i] - (x > 0 ? grid[x - 1][y + i] : 0) - (y > 0 ? grid[x + i][y - 1] : 0)

            if sum > max {
                max = sum
                xy  = (x + 1, y + 1)
                size = i + 1
            }
        }
    }
//    print(x)
}

print(max, xy, size)
