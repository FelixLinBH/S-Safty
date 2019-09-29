//
//  CommonDictionary.swift
//  comthreadsafety
//
//  Created by FelixLinBH on 2019/8/26.
//

import Foundation

public class SyncDictionary<Key, Value> where Key : Hashable {
    fileprivate let queue = DispatchQueue(label: "com.threadsafety.dictionary.queue")
    fileprivate var dictionary = Dictionary<Key, Value>()
    public init(){
    }
}

//MARK: Properties
public extension SyncDictionary {
    var count: Int {
        var result = 0
        queue.sync {
            result = self.dictionary.count
        }
        return result
    }
    
    var isEmpty: Bool {
        var result = true
        queue.sync {
            result = self.dictionary.isEmpty
        }
        return result
    }
    var first: (key: Key, value: Value)? {
        var result: (key: Key, value: Value)?
        queue.sync {
            result = self.dictionary.first
        }
        return result
    }
    var underestimatedCount: Int {
        var result = 0
        queue.sync {
            result = self.dictionary.underestimatedCount
        }
        return result
    }
}

//MARK: Mutating
public extension SyncDictionary {
    func updateValue(_ value: Value, forKey key: Key) -> Value?{
        var result: Value?
        queue.async(flags: .barrier) {
            result = self.dictionary.updateValue(value, forKey: key)
        }
        return result
    }
    
    func merge<S>(_ other: S, uniquingKeysWith combine: @escaping(Value, Value) throws -> Value) rethrows where S : Sequence, S.Element == (Key, Value){
        queue.async(flags: .barrier) {
            do{
                try self.dictionary.merge(other, uniquingKeysWith: combine)
            } catch let error as NSError {
                print("\(error)")
           }
        }
        
    }
    
    func merge(_ other: [Key : Value], uniquingKeysWith combine: @escaping(Value, Value) throws -> Value) rethrows{
        queue.async(flags: .barrier) {
            do{
                try self.dictionary.merge(other, uniquingKeysWith: combine)
            } catch let error as NSError {
                print("\(error)")
            }
        }
    }
    
    func removeValue(forKey key: Key) -> Value?{
        var result: Value?
        queue.async(flags: .barrier) {
            result = self.dictionary.removeValue(forKey: key)
        }
        return result
    }
    
    func removeAll(keepingCapacity keepCapacity: Bool = false){
        queue.async(flags: .barrier) {
            self.dictionary.removeAll(keepingCapacity: keepCapacity)
        }
    }
}

//MARK: Immutable
public extension SyncDictionary {
    
}

//MARK: Subscript
public extension SyncDictionary {
    subscript(key: Key) -> Value?{
        get {
            var result: Value?
            queue.sync {
                guard self.dictionary[key] != nil else {
                    return
                }
                result = self.dictionary[key]
                
            }
            return result
        }
        set {
            guard let newValue = newValue else {
                return
            }
            queue.async(flags: .barrier) {
                self.dictionary[key] = newValue
            }
        }
    }
}
