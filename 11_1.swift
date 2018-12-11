#if os(Linux)
import Glibc
#else
import Darwin
#endif
import Foundation

let input = 6303

let test = 303

var grid: [[Int]] = Array(repeating: Array(repeating: 0, count: 299), count: 299)


for x in grid.indices {
    for y in grid[x].indices {
        let calc = ((((x + 1 + 10) * (y + 1)) + test) * (x + 1 + 10))
        let digits = String(calc).compactMap{Int(String($0))}
        var houndreds = 0
        if (digits.count >= 3) {
            houndreds = digits[String(calc).indices.count - 3]
        }
        grid[x][y] = houndreds - 5
    }
}

grid.forEach { print($0) }


var max = 0
var xy = (0,0)
for x in 0..<grid.count - 2 {
    for y in 0..<grid[x].count - 2 {
        var sum = 0
        for xx in x..<x + 3 {
            for yy in y..<y + 3 {
                sum += grid[xx][yy]
            }
        }
        if sum > max {
            max = sum
            xy  = (x + 1, y + 1)
        }
    }
}

print(max, xy)
