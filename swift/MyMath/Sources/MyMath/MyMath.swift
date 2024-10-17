// MyMath/Sources/MyMath/MyMath.swift

public struct MyMath {
    public static func add(_ a: Int, _ b: Int) -> Int {
        return a + b
    }
    
    public static func subtract(_ a: Int, _ b: Int) -> Int {
        return a - b
    }
    
    public static func multiply(_ a: Int, _ b: Int) -> Int {
        return a * b
    }
    
    public static func divide(_ a: Int, _ b: Int) -> Int? {
        guard b != 0 else { return nil }
        return a / b
    }
}
