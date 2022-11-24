import Foundation

struct Coordinate {
    let x: Int
    let y: Int
}
enum Direction: CaseIterable {
    case down
    case right
    case up
    case left
    
    static var allCases: [Direction] {
        return [
            .down,
            .right,
            .up,
            .left
        ]
    }
    
    var coordinate: Coordinate {
        switch self {
        case .down:
            return Coordinate(x: 0, y: 1)
        case .right:
            return Coordinate(x: 1, y: 0)
        case .up:
            return Coordinate(x: 0, y: -1)
        case .left:
            return Coordinate(x: -1, y: 0)
        }
    }
}

struct Maze {
    let W: Int = 8
    let H: Int = 8
    
    var field: [[Int?]] = []
    var start: Coordinate?
    var goal: Coordinate?
    var now: Coordinate = Coordinate(x: -1, y: -1)

    init(val: String) {
        val.split(separator: "\n").enumerated().forEach { i, line in
            field.append(
                line.split(separator: " ").enumerated().map { j, block in
                    if block == "S" {
                        now = Coordinate(x: j, y: i)
                        start = now
                        return 0
                    } else if block == "G" {
                        goal = Coordinate(x: j, y: i)
                        return 999
                    } else if block == "#" {
                        return -1
                    }
                    return nil
                }
            )
        }
    }
    
    func findNext() -> [Direction] {
        Direction.allCases.filter { direction in
            guard now.x + direction.coordinate.x < W, now.x + direction.coordinate.x >= 0 else {
                return false
            }
            guard now.y + direction.coordinate.y < H, now.y + direction.coordinate.y >= 0 else {
                return false
            }
            if field[now.y + direction.coordinate.y][now.x + direction.coordinate.x] == -1 {
                return false
            }
            if field[now.y + direction.coordinate.y][now.x + direction.coordinate.x] != nil && field[now.y + direction.coordinate.y][now.x + direction.coordinate.x] != 999 {
                return false
            }
            return true
        }
    }
    
    mutating func move(direction: Direction) {
        var step = field[now.y][now.x] ?? 0
        now = Coordinate(x: now.x + direction.coordinate.x, y: now.y + direction.coordinate.y)
        if now.x == goal?.x && now.y == goal?.y {
            return
        }
        step += 1
        field[now.y][now.x] = step
    }

    func isGoal() -> Bool {
        return now.x == goal?.x && now.y == goal?.y
    }
    
    func print() {
        field.map { line in
            Swift.print(line.map { block in
                guard block != nil else {
                    return "x"
                }
                if block == 0 {
                    return "S"
                } else if block == 999 {
                    return "G"
                } else if block == -1 {
                    return "#"
                }
                return String(block!)
            }.joined(separator: "\t"))
        }
    }
}
func solve(board: String) {
    var nodes: [Maze] = []
    var answer: Maze?
    
    let maze = Maze(val: board)
    nodes.append(maze)
    repeat {
        var tmpNodes: [Maze] = []
        for _ in nodes {
            let preNode = nodes.popLast()!
            let next = preNode.findNext()
            if next.isEmpty {
                continue
            }
            next.enumerated().forEach { j, n in
                var newNode = preNode
                newNode.move(direction: n)
                if newNode.isGoal() {
                    answer = newNode
                }                
                if !tmpNodes.contains(where: { $0.now.x == newNode.now.x && $0.now.y == newNode.now.y }) {
                    tmpNodes.append(newNode)
                }
            }
        }
        nodes = tmpNodes
    } while (answer == nil)
    print("best answer is: ")
    answer?.print()
}


let initialize = """
x # x x x x # G
x # x # x x x x
x x x # x # # #
# x # # x x x #
x x x # # # x #
x # x x x x x #
x x x # x # x x
S x x x x x x x
"""

solve(board: initialize)
