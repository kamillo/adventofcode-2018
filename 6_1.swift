#if os(Linux)
import Glibc
#else
import Darwin
#endif
import Foundation

let input =
"""
83, 153
201, 74
291, 245
269, 271
222, 337
291, 271
173, 346
189, 184
170, 240
127, 96
76, 46
92, 182
107, 160
311, 142
247, 321
303, 295
141, 310
147, 70
48, 41
40, 276
46, 313
175, 279
149, 177
181, 189
347, 163
215, 135
103, 159
222, 304
201, 184
272, 354
113, 74
59, 231
302, 251
127, 312
259, 259
41, 244
43, 238
193, 172
147, 353
332, 316
353, 218
100, 115
111, 58
210, 108
101, 175
185, 98
256, 311
142, 41
68, 228
327, 194
"""

class Point {
    var x: Int = 0
    var y: Int = 0
    var name = "."
    
    init() {}
    
    init(x: Int, y: Int, name: String) {
        self.x = x
        self.y = y
        self.name = name
    }
}

let cords = input.split(separator: "\n").enumerated().reduce([Point]()) { (points, cord) -> [Point] in
    var ret = points
    let p = cord.element.split(separator: ",").map { Int($0.trimmingCharacters(in: CharacterSet.whitespaces)) ?? 0 }
    ret.append(Point(x: p[0], y: p[1], name: String(cord.element)))
    return ret
}

let width = cords.max{a, b in a.x < b.x}!.x
let height = cords.max{a, b in a.y < b.y}!.y
var grid: [[Point]] = [];

func distance(point: Point, x: Int, y: Int) -> Int{
    return (abs(point.x - x) + abs(point.y - y))
}

func findNearestCord(x: Int, y: Int) -> Point {
    var dist = 100000
    var ret: Point? = nil;
    
    for point in cords {
        let newDist = distance(point:point, x:x, y:y)
        if newDist < dist {
            dist = newDist
            ret = Point(x: x, y: y, name: point.name)
            
        } else if newDist == dist && ret != nil {
            ret = Point(x: x, y: y, name: ".")
        }
    }
    
    return ret!;
}

var infinite:Set<String> = Set()
var areas:[String:Int] = [:]
for i in 0...height {
    grid.append([])
    for j in 0...width {
        grid[i].append(findNearestCord(x: j, y: i))
        
        if (i == 0 || j == 0 || i == height || j == width) {
            infinite.insert(grid[i][j].name)
        }
        
        areas[grid[i][j].name, default: 0] += 1
        
        //print(grid[i][j].name, terminator:" ")
    }
    //print()
}

print(areas.filter { !infinite.contains($0.key) }.max { a, b in a.value < b.value }! )
