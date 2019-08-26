//
//  CommonArray.swift
//  comthreadsafety
//
//  Created by FelixLinBH on 2019/8/21.
//

import Foundation

public class SyncArray<Element> {
    fileprivate let queue = DispatchQueue(label: "com.threadsafety.array.queue")
    fileprivate var array = [Element]()
    public init(){
    }
    public init(repeating repeatedValue: Element, count: Int){
        self.array = [Element](repeating: repeatedValue, count: count)
    }
}

//MARK: Properties
public extension SyncArray {
    var first: Element? {
        var result: Element?
        queue.sync {
            result = self.array.first
        }
        return result
    }
    var last: Element? {
        var result: Element?
        queue.sync {
            result = self.array.last
        }
        return result
    }
    var count: Int {
        var result = 0
        queue.sync {
            result = self.array.count
        }
        return result
    }
    
    var isEmpty: Bool {
        var result = true
        queue.sync {
            result = self.array.isEmpty
        }
        return result
    }
    
    var underestimatedCount: Int {
        var result = 0
        queue.sync {
            result = self.array.underestimatedCount
        }
        return result
    }
}

//MARK: Mutating
public extension SyncArray {
    func append(_ newElement: __owned Element){
        queue.async(flags: .barrier) {
            self.array.append(newElement)
        }
    }
    
    func append<S>(contentsOf newElements: __owned S) where Element == S.Element, S : Sequence{
        queue.async(flags: .barrier) {
            self.array.append(contentsOf: newElements)
        }
    }
    
    func remove(at index: Int, completion:((Element)->Void)? = nil){
        queue.async(flags: .barrier) {
            guard index < self.array.count else {
                return
            }
            let element = self.array.remove(at: index)
            DispatchQueue.main.async {
                completion?(element)
            }
        }
    }
    
    func insert(_ newElement: __owned Element, at i: Int){
        queue.async(flags: .barrier) {
            self.array.insert(newElement, at: i)
        }
    }
    
    func removeAll(completion:(([Element])->Void)? = nil){
        queue.async(flags: .barrier) {
            self.array.removeAll()
            DispatchQueue.main.async {
                completion?(self.array)
            }
        }
    }
    
    func removeAll(keepingCapacity keepCapacity: Bool = false){
        queue.async(flags: .barrier) {
            self.array.removeAll()
        }
    }
    
}

//MARK: Immutable
public extension SyncArray{
    func first(where predicate: (Element) throws -> Bool) rethrows -> Element?{
        var result: Element?
        queue.sync {
            do{
                result = try self.array.first(where: predicate)
            } catch let error as NSError {
                print("\(error)")
            }
        }
        return result
    }
    
    func firstIndex(where predicate: (Element) throws -> Bool) rethrows -> Int?{
        var result: Int?
        queue.sync {
            do{
                result = try self.array.firstIndex(where: predicate)
            } catch let error as NSError {
                print("\(error)")
            }
        }
        return result
    }
    
    func last(where predicate: (Element) throws -> Bool) rethrows -> Element?{
        var result: Element?
        queue.sync {
            do{
                result = try self.array.last(where: predicate)
            } catch let error as NSError {
                print("\(error)");
            }
        }
        return result
    }
    
    func lastIndex(where predicate: (Element) throws -> Bool) rethrows -> Int?{
        var result: Int?
        queue.sync {
            do{
                result = try self.array.lastIndex(where: predicate)
            } catch let error as NSError {
                print("\(error)")
            }
        }
        return result
    }
    
    func filter(isIncluded: (Element) throws -> Bool) -> [Element] {
        var result = [Element]()
        queue.sync {
            do{
                result = try self.array.filter(isIncluded)
            } catch let error as NSError {
                print("\(error)")
            }
        }
        return result
    }
    
    func sorted(by areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows -> [Element]{
        var result = [Element]()
        queue.sync {
            do{
                result = try self.array.sorted(by: areInIncreasingOrder)
            } catch let error as NSError {
                print("\(error)")
            }
        }
        return result
    }
    
    func flatMap<SegmentOfResult>(_ transform: (Element) throws -> SegmentOfResult) rethrows -> [SegmentOfResult.Element] where SegmentOfResult : Sequence{
        var result = [SegmentOfResult.Element]()
        queue.sync {
            do{
                result = try self.array.flatMap(transform)
            } catch let error as NSError {
                print("\(error)")
            }
        }
        return result
    }
    
    
    func compactMap<ElementOfResult>(_ transform: (Element) throws -> ElementOfResult?) rethrows -> [ElementOfResult]{
        var result = [ElementOfResult]()
        queue.sync {
            do{
                result = try self.array.compactMap(transform)
            } catch let error as NSError {
                print("\(error)")
            }
        }
        return result
    }
    
    func forEach(_ body: (Element) throws -> Void) rethrows {
        queue.sync {
            do{
                try self.array.forEach(body)
            } catch let error as NSError {
                print("\(error)")
            }
        }
    }
    
    func contains(where predicate: (Element) throws -> Bool) rethrows -> Bool{
        var result = false
        queue.sync {
            do{
                try result = self.array.contains(where: predicate)
            } catch let error as NSError {
                print("\(error)")
            }
        }
        return result
    }
}

//MARK: Subscript
public extension SyncArray{
    subscript(index: Int) -> Element? {
        get {
            var result: Element?
            queue.sync {
                guard self.array.startIndex <= index else {
                    return
                }
                guard self.array.endIndex >= index else {
                    return
                }
                result = self.array[index]
            }
            return result
        }
        set {
            guard let newValue = newValue else {
                return
            }
            queue.async(flags: .barrier) {
                self.array[index] = newValue
            }
        }
    }
}

// MARK: - Infix operators
public extension SyncArray {
    
    static func +=(left: inout SyncArray, right: Element) {
        left.append(right)
    }
    
    static func +=(left: inout SyncArray, right: [Element]) {
        left.append(contentsOf: right)
    }
}
