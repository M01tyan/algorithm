
extension Array where Element == String {
    func toString() -> String {
        return map { $0 }.joined(separator: "")
    }
}

func calc_poland(poland: String) -> Double {
    var space: [Double] = []
    poland.forEach {
        if let intValue = $0.wholeNumberValue {
            space.append(Double(intValue))
        } else {
            guard let second: Double = space.popLast(), 
                  let first: Double = space.popLast() else {
                return;
            }
            if $0 == "+" {
                space.append(first + second)
            } else if $0 == "-" {
                space.append(first - second)
            } else if $0 == "*" {
                space.append(first * second)
            } else if $0 == "/" {
                space.append(first / second)
            }
        }
    }
    return space.popLast() ?? 0
}

func decode_poland(poland: String) -> String {
    var space: [String] = []
    poland.forEach {
        if let intValue = $0.wholeNumberValue {
            space.append(String(intValue))
        } else {
            guard var second: String = space.popLast(), 
                  var first: String = space.popLast() else {
                return;
            }
            if $0 == "*" || $0 == "/" {
                if first.count > 1 {
                    first = "(" + first + ")"
                }
                if second.count > 1 {
                    second = "(" + second + ")"
                }
            }
            if $0 == "+" {
                space.append(first + " + " + second)
            } else if $0 == "-" {
                space.append(first + " - " + second)
            } else if $0 == "*" {
                space.append(first + " * " + second)
            } else if $0 == "/" {
                space.append(first + " / " + second)
            }
        }
    }
    return space.popLast() ?? ""
}

func solve(val: [Int], target: Int) {
    var results: Set<String> = []
    let operators = "+-*/"
    
    var numbers: [String] = val.map { "\($0)" }.sorted { $0 < $1 }

    numbers.enumerated().forEach { k1, n1 in
        numbers.enumerated().forEach { k2, n2 in
            numbers.enumerated().forEach { k3, n3 in
                numbers.enumerated().forEach { k4, n4 in
                    if k1 == k2 || k1 == k3 || k1 == k4 || k2 == k3 || k2 == k4 || k3 == k4 { return; }
                    operators.forEach { o1 in
                        operators.forEach { o2 in
                            operators.forEach { o3 in
                                // パターン1を試す nnnnooo
                                var poland = [n1, n2, n3, n4, "\(o1)", "\(o2)", "\(o3)"].toString()
                                if calc_poland(poland: poland) == Double(target) {
                                    results.insert(poland)
                                }
                                // パターン2を試す nnnonoo
                                poland = [n1, n2, n3, "\(o1)", n4, "\(o2)", "\(o3)"].toString()
                                if calc_poland(poland: poland) == Double(target) {
                                    results.insert(poland)
                                }
                                // パターン3を試す nnnoono
                                poland = [n1, n2, n3, "\(o1)", "\(o2)", n4, "\(o3)"].toString()
                                if calc_poland(poland: poland) == Double(target) {
                                    results.insert(poland)
                                }
                                // パターン4を試す nnonnoo
                                poland = [n1, n2, "\(o1)", n3, n4, "\(o2)", "\(o3)"].toString()
                                if calc_poland(poland: poland) == Double(target) {
                                    results.insert(poland)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    print("result pattern count: \(results.count)")
    results.forEach { poland in
        print(decode_poland(poland: poland))
    }
}

// 4つの数字と目標値となる値を渡す
solve(val: [3, 4, 7, 8], target: 10)