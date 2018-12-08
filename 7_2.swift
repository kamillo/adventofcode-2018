#if os(Linux)
import Glibc
#else
import Darwin
#endif
import Foundation

let input =
"""
Step F must be finished before step P can begin.
Step R must be finished before step J can begin.
Step X must be finished before step H can begin.
Step L must be finished before step N can begin.
Step U must be finished before step Z can begin.
Step B must be finished before step C can begin.
Step S must be finished before step C can begin.
Step N must be finished before step Y can begin.
Step I must be finished before step J can begin.
Step H must be finished before step K can begin.
Step G must be finished before step Z can begin.
Step Q must be finished before step V can begin.
Step E must be finished before step P can begin.
Step P must be finished before step W can begin.
Step J must be finished before step D can begin.
Step V must be finished before step W can begin.
Step T must be finished before step D can begin.
Step Z must be finished before step A can begin.
Step K must be finished before step A can begin.
Step Y must be finished before step O can begin.
Step O must be finished before step W can begin.
Step C must be finished before step M can begin.
Step D must be finished before step A can begin.
Step W must be finished before step M can begin.
Step M must be finished before step A can begin.
Step C must be finished before step A can begin.
Step F must be finished before step Z can begin.
Step I must be finished before step A can begin.
Step W must be finished before step A can begin.
Step T must be finished before step C can begin.
Step S must be finished before step K can begin.
Step B must be finished before step J can begin.
Step O must be finished before step A can begin.
Step Q must be finished before step P can begin.
Step G must be finished before step M can begin.
Step R must be finished before step T can begin.
Step B must be finished before step G can begin.
Step J must be finished before step O can begin.
Step X must be finished before step E can begin.
Step X must be finished before step C can begin.
Step H must be finished before step Y can begin.
Step Y must be finished before step A can begin.
Step X must be finished before step W can begin.
Step H must be finished before step A can begin.
Step X must be finished before step A can begin.
Step I must be finished before step M can begin.
Step G must be finished before step J can begin.
Step N must be finished before step G can begin.
Step D must be finished before step M can begin.
Step L must be finished before step D can begin.
Step V must be finished before step T can begin.
Step I must be finished before step Y can begin.
Step S must be finished before step J can begin.
Step K must be finished before step Y can begin.
Step F must be finished before step R can begin.
Step U must be finished before step T can begin.
Step Z must be finished before step M can begin.
Step T must be finished before step Z can begin.
Step B must be finished before step I can begin.
Step E must be finished before step K can begin.
Step N must be finished before step J can begin.
Step X must be finished before step Q can begin.
Step F must be finished before step Y can begin.
Step H must be finished before step P can begin.
Step Z must be finished before step D can begin.
Step V must be finished before step O can begin.
Step E must be finished before step C can begin.
Step V must be finished before step C can begin.
Step P must be finished before step A can begin.
Step B must be finished before step N can begin.
Step S must be finished before step W can begin.
Step P must be finished before step D can begin.
Step L must be finished before step W can begin.
Step D must be finished before step W can begin.
Step K must be finished before step C can begin.
Step L must be finished before step M can begin.
Step R must be finished before step O can begin.
Step F must be finished before step L can begin.
Step R must be finished before step H can begin.
Step K must be finished before step O can begin.
Step T must be finished before step W can begin.
Step R must be finished before step K can begin.
Step C must be finished before step W can begin.
Step N must be finished before step T can begin.
Step R must be finished before step P can begin.
Step E must be finished before step M can begin.
Step G must be finished before step T can begin.
Step U must be finished before step K can begin.
Step Q must be finished before step D can begin.
Step U must be finished before step S can begin.
Step J must be finished before step V can begin.
Step P must be finished before step Y can begin.
Step X must be finished before step Z can begin.
Step U must be finished before step H can begin.
Step H must be finished before step M can begin.
Step I must be finished before step C can begin.
Step V must be finished before step M can begin.
Step N must be finished before step I can begin.
Step B must be finished before step K can begin.
Step R must be finished before step Q can begin.
Step O must be finished before step C can begin.
"""

let test =
"""
Step C must be finished before step A can begin.
Step C must be finished before step F can begin.
Step A must be finished before step B can begin.
Step A must be finished before step D can begin.
Step B must be finished before step E can begin.
Step D must be finished before step E can begin.
Step F must be finished before step E can begin.
"""

extension String {
    
    func slice(from: String, to: String) -> String? {
        
        return (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                String(self[substringFrom..<substringTo])
            }
        }
    }
}

var order:[String:Set<String>] = [:]
var steps:Set<String> = Set()

input.split(separator: "\n").forEach { (line) in
    let step = String(line).slice(from: "step ", to: " can")
    let before = String(line).slice(from: "Step ", to: " must")
    
    steps.insert(step!)
    steps.insert(before!)
    
    order[step!, default:Set<String>()].insert(before!)
    if (!order.keys.contains(before!)) {
        order[before!] = Set<String>()
    }
}

print(order)
print(steps.sorted())
var seconds = -1
var workers:[(String,Int)] = [("",0), ("",0), ("",0), ("",0), ("",0)]
var busy:[Int] = []

while !order.isEmpty || !busy.isEmpty {
    let free = workers.indices.filter { workers[$0].1 <= 0 }

    seconds += 1
    
    for worker in free {
        busy = workers.indices.filter { workers[$0].1 > 0 }
        let avail = order.filter { $0.value.isEmpty }.keys.sorted()
        
        if !order.isEmpty {
            if busy.isEmpty || (!busy.isEmpty && ( avail.count >= 1))  {
                let first = order.filter { $0.value.isEmpty }.keys.sorted()[0]
                order.remove(at: order.index(forKey: first)!)
                
                workers[worker] = (first, steps.sorted().firstIndex(of: first)! + 61)
            }
        }
    }
    workers = workers.map { ($0.0, $0.1 - 1) }
    workers.map { (worker)  -> (String, Int) in
        return ("XXX", 999)
        if worker.1 == 0 && !worker.0.isEmpty {
            print(worker.0, terminator:"")
            order.keys.forEach { order[$0]?.remove(worker.0) }
            return ("", 0)
        }
        
        return worker
    }
    
    print(workers)
}
print(seconds)
