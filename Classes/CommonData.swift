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



//MARK: Properties
public extension SyncData {
    var count: Int {
        var result = 0
        queue.sync {
            result = self.data.count
        }
        return result
    }
    var isEmpty: Bool {
        var result = true
        queue.sync {
            result = self.data.isEmpty
        }
        return result
    }
    var startIndex: Data.Index {
        queue.sync {
            return self.data.startIndex
        }
    }
    var endIndex: Data.Index {
        queue.sync {
            return self.data.endIndex
        }
    }
}

//MARK: Mutating
public extension SyncData {
    func append(_ bytes: UnsafePointer<UInt8>, count: Int){
        queue.async(flags: .barrier) {
            self.data.append(bytes, count: count)
        }
    }
    func append(_ other: Data){
        queue.async(flags: .barrier) {
            self.data.append(other)
        }
    }
    func append<SourceType>(_ buffer: UnsafeBufferPointer<SourceType>){
        queue.async(flags: .barrier) {
            self.data.append(buffer)
        }
    }
    func append(contentsOf bytes: [UInt8]){
        queue.async(flags: .barrier) {
            self.data.append(contentsOf: bytes)
        }
    }
    func append<S>(contentsOf elements: S) where S : Sequence, S.Element == Data.Element{
        queue.async(flags: .barrier) {
            self.data.append(contentsOf: elements)
        }
    }
    func resetBytes(in range: Range<Data.Index>){
        queue.async(flags: .barrier) {
            self.data.resetBytes(in: range)
        }
    }
    func replaceSubrange(_ subrange: Range<Data.Index>, with data: Data){
        queue.async(flags: .barrier) {
            self.data.replaceSubrange(subrange, with: data)
        }
    }
    func replaceSubrange<SourceType>(_ subrange: Range<Data.Index>, with buffer: UnsafeBufferPointer<SourceType>){
        queue.async(flags: .barrier) {
            self.data.replaceSubrange(subrange, with: buffer)
        }
    }
    func replaceSubrange<ByteCollection>(_ subrange: Range<Data.Index>, with newElements: ByteCollection) where ByteCollection : Collection, ByteCollection.Element == Data.Iterator.Element{
        queue.async(flags: .barrier) {
            self.data.replaceSubrange(subrange, with: newElements)
        }
    }
    func replaceSubrange(_ subrange: Range<Data.Index>, with bytes: UnsafeRawPointer, count cnt: Int){
        queue.async(flags: .barrier) {
            self.data.replaceSubrange(subrange, with: bytes, count: cnt)
        }
    }
}

//MARK: Subscript
public extension SyncData {
    subscript(index: Data.Index) -> UInt8{
        get {
            queue.sync {
                guard self.data.startIndex <= index else {
                    return UInt8()
                }
                guard self.data.endIndex >= index else {
                    return UInt8()
                }
                return self.data[index]
            }
        }
        set {
            queue.async(flags: .barrier) {
                self.data[index] = newValue
            }
        }
    }
    
    subscript(bounds: Range<Data.Index>) -> Data{
        get {
            queue.sync {
                guard self.data.startIndex >= bounds.startIndex else {
                    return Data()
                }
                guard self.data.endIndex <= bounds.endIndex else {
                    return Data()
                }
                return self.data[bounds]
            }
        }
        set {
            queue.async(flags: .barrier) {
                self.data[bounds] = newValue
            }
        }
    }
    
    subscript<R>(rangeExpression: R) -> Data where R : RangeExpression, R.Bound : FixedWidthInteger{
        get {
            queue.sync {
                return self.data[rangeExpression]
            }
        }
        set {
            queue.async(flags: .barrier) {
                self.data[rangeExpression] = newValue
            }
        }
    }
}
