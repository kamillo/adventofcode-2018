#if os(Linux)
import Glibc
#else
import Darwin
#endif
import Foundation


//let playersCount = 435
//let lastMarble = 71184 * 100
let playersCount = 30
let lastMarble = 5807

var marble = 0
//var circle = Array(repeating: 0, count: lastMarble)
//circle.insert(1, at: 1)
var circle = [0]
var current = 0
var players = Array(repeating: 0, count: playersCount)


while marble < lastMarble {
    for player in players.indices {
        marble += 1
        
        if (marble % 23 == 0) {
            var toRemove = (current - 7)
            if (toRemove < 0) {
                toRemove = circle.count + toRemove
            }
            
            players[player] += marble + circle[toRemove]
            circle.remove(at: toRemove)
            current = toRemove
            
        } else {
            current = (current + 2) % circle.count
            
            if (current == 0) {
                current = circle.count
                circle.insert(marble, at: circle.count)
            } else {
                circle.insert(marble, at: current)
            }
        }
//        print(circle)
        
        if (marble >= lastMarble) {
            break
        }
    }
}

print(players.max())
