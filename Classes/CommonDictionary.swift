//
//  CommonDictionary.swift
//  comthreadsafety
//
//  Created by Felix Lin林柏含 on 2019/8/26.
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
