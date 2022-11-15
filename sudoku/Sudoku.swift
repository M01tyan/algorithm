struct Coordinate {
    let x: Int
    let y: Int
}
struct Sudoku {
    var field: [[Int?]] = []
    
    init(val: String) {
        val.split(separator: "\n").forEach { line in
            field.append(line.split(separator: " ").map { Int($0) })
        }
    }
    
    mutating func put(x: Int, y: Int, val: Int) {
        field[x][y] = val
    }
    
    mutating func reset(x: Int, y: Int) {
        field[x][y] = nil;
    }
    
    func findEmpty() -> Coordinate? {
        for (x, line) in field.enumerated() {
            if let y = line.firstIndex(of: nil) {
                return Coordinate(x: x, y: y)
            }
        }
        return nil
    }
    
    func findChoices(coordinate: Coordinate) -> [Int] {
        var cannotUse = Set<Int>([])
        
        // 行
        field[coordinate.x].filter { $0 != nil }.forEach { useNumber in
            cannotUse.insert(useNumber!)
        }
        // 列
        field.forEach { line in
            if let useNumber = line[coordinate.y] {
                cannotUse.insert(useNumber)
            }
        }
        // ブロック
        let x2 = coordinate.x / 3 * 3
        let y2 = coordinate.y / 3 * 3
        for i in stride(from: x2, to: x2 + 3, by: 1) {
            for j in stride(from: y2, to: y2 + 3, by: 1) {
                if let useNumber = field[i][j] {
                    cannotUse.insert(useNumber)
                }
            }
        }
        return Array(1...9).filter { !cannotUse.contains($0) }
    }
    
    func print() {
        field.map { line in
            Swift.print(line.map { String($0 ?? 0) }.joined(separator: " "))
        }
    }
}

func dfs(board: inout Sudoku) {
    
    guard let coordinate = board.findEmpty() else {
        board.print()
        return
    }
    
    let canUse: [Int] = board.findChoices(coordinate: coordinate)
    canUse.forEach { number in
        board.put(x: coordinate.x, y: coordinate.y, val: number)
        dfs(board: &board)
        board.reset(x: coordinate.x, y: coordinate.y)
    }
}

let initialize = """
5 3 x x 7 x x x x
6 x x 1 9 5 x x x
x 9 8 x x x x 6 x
8 x x x 6 x x x 3
4 x x 8 x 3 x x 1
7 x x x 2 x x x 6
x 6 x x x x 2 8 x
x x x 4 1 9 x x 5
x x x x 8 x x 7 9
"""
var sudoku = Sudoku(val: initialize)

dfs(board: &sudoku)