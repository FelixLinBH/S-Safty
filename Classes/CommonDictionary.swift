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
    
    var keys: Dictionary<Key, Value>.Keys {
        get{
            queue.sync {
                return self.dictionary.keys
            }
        }
    }
    
    var values: Dictionary<Key, Value>.Values {
        get{
            queue.sync {
                return self.dictionary.values
            }
        }
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
    typealias kElement = (key: Key, value: Value)
    func filter(_ isIncluded: (kElement) throws -> Bool) rethrows -> [Key : Value]{
        var result = [Key : Value]()
        queue.sync {
            do{
                result = try self.dictionary.filter(isIncluded)
            } catch let error as NSError {
                print("\(error)")
            }
        }
        return result
    }
    
    func mapValues<T>(_ transform: (Value) throws -> T) rethrows -> [Key : T]{
        var result = [Key : T]()
        queue.sync {
            do{
                result = try self.dictionary.mapValues(transform)
            } catch let error as NSError {
                print("\(error)")
            }
        }
        return result
    }

    func compactMapValues<T>(_ transform: (Value) throws -> T?) rethrows -> [Key : T]{
        var result = [Key : T]()
        queue.sync {
            do{
                result = try self.dictionary.compactMapValues(transform)
            } catch let error as NSError {
                print("\(error)")
            }
        }
        return result
    }
    
    func merging<S>(_ other: S, uniquingKeysWith combine: (Value, Value) throws -> Value) rethrows -> [Key : Value] where S : Sequence, S.Element == (Key, Value){
        var result = [Key : Value]()
        queue.sync {
           do{
               result = try self.dictionary.merging(other, uniquingKeysWith: combine)
           } catch let error as NSError {
               print("\(error)")
           }
        }
        return result
    }
    
    func merging(_ other: [Key : Value], uniquingKeysWith combine: (Value, Value) throws -> Value) rethrows -> [Key : Value]{
        var result = [Key : Value]()
        queue.sync {
            do{
                result = try self.dictionary.merging(other, uniquingKeysWith: combine)
            } catch let error as NSError {
                print("\(error)")
            }
        }
        return result
    }
    
    func map<T>(_ transform: ((key: Key, value: Value)) throws -> T) rethrows -> [T]{
         var result = [T]()
        queue.sync {
            do{
                result = try self.dictionary.map(transform)
            } catch let error as NSError {
                print("\(error)")
            }
        }
        return result
    }
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
