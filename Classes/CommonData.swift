//
//  CommonData.swift
//  comthreadsafety
//
//  Created by Lin Bo Han on 2019/10/11.
//

import Foundation

public class SyncData {
    fileprivate let queue = DispatchQueue(label: "com.ssafty.data.queue")
    public var data = Data()
    @inlinable public init(bytes: UnsafeRawPointer, count: Int){
        self.data = Data.init(bytes: bytes, count: count)
    }
    @inlinable public init(repeating repeatedValue: UInt8, count: Int){
        self.data = Data.init(repeating: repeatedValue, count: count)
    }
    @inlinable public init<SourceType>(buffer: UnsafeBufferPointer<SourceType>){
        self.data = Data.init(buffer: buffer)
    }
    @inlinable public init<SourceType>(buffer: UnsafeMutableBufferPointer<SourceType>){
        self.data = Data.init(buffer: buffer)
    }
    @inlinable public init(capacity: Int){
        self.data = Data.init(capacity: capacity)
    }
    @inlinable public init(count: Int){
        self.data = Data.init(count: count)
    }
    @inlinable public init(bytesNoCopy bytes: UnsafeMutableRawPointer, count: Int, deallocator: Data.Deallocator){
        self.data = Data.init(bytesNoCopy: bytes, count: count, deallocator: deallocator)
    }
    @inlinable public init(contentsOf url: URL, options: Data.ReadingOptions = []) throws{
        self.data = try Data.init(contentsOf: url, options: options)
    }
    @inlinable public init?(base64Encoded base64String: String, options: Data.Base64DecodingOptions = []){
        self.data = Data.init(base64Encoded: base64String, options:  options) ?? Data()
    }
    @inlinable public init?(base64Encoded base64Data: Data, options: Data.Base64DecodingOptions = []){
        self.data = Data.init(base64Encoded: base64Data, options: options) ?? Data()
    }
    public init(referencing reference: NSData){
        self.data = Data.init(referencing: reference)
    }
    @inlinable public init<S>(_ elements: S) where S : Sequence, S.Element == UInt8{
        self.data = Data.init(elements)
    }
    @inlinable public init(){
        self.data = Data()
    }
}
