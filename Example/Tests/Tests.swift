// https://github.com/Quick/Quick

import Quick
import Nimble
import comthreadsafety

class TableOfContentsSpec: QuickSpec {
    override func spec() {
        describe("Testes of array method") {
            
            it("thread safty while appending") {
                let array = SyncArray<Int>()
                DispatchQueue.concurrentPerform(iterations: 1000, execute: { (index) in
                    let last = array.last ?? 0
                    array.append(last+1)
                    DispatchQueue.global().sync {
                        guard index == 999 else { return }
                        expect(array.isEmpty) == false
                        expect(array.underestimatedCount) <= 1000
                        expect(array.count) == 1000
                        DispatchQueue.concurrentPerform(iterations: 1000, execute: { (index) in
                            array.remove(at: 999 - index)
                            DispatchQueue.global().sync {
                                guard index == 999 else { return }
                                expect(array.isEmpty) == true
                                expect(array.underestimatedCount) <= 0
                                expect(array.count) == 0
                            }
                        })
                    }
                })
            }
            
            it("thread safty while appending") {
                let array = SyncArray<Int>()
                DispatchQueue.concurrentPerform(iterations: 1000, execute: { (index) in
                    let last = array.first ?? 0
                    array.append(contentsOf: [last+1,last+2])
                    DispatchQueue.global().sync {
                        guard index == 999 else { return }
                        expect(array.count) == 2000
                        array.removeAll(keepingCapacity: false)
                        expect(array.count) == 0
                    }
                })
            }
            
            it("thread safty while inserting") {
                let array = SyncArray<Int>(repeating: 0, count: 1000)
                var done = 0
                DispatchQueue.concurrentPerform(iterations: 1000, execute: { (index) in
                    array.insert(index, at: index)
                    done += 1
                    DispatchQueue.global().sync {
                        guard done == 999 else { return }
                        expect(array[index]) != 0
                        array.removeAll(completion: { (result) in
                            expect(result.count) == 0
                        })
                    }
                })
            }
            
            it("can do first,firstIndex,last,lastIndex,filter") {
                let array : SyncArray<String> = SyncArray()
                array.append("one")
                array.append("two")
                array.append("three")
                array.append("one")
                array.append("two")
                array.append("three")
                let firstResult = array.first(where: { (string) -> Bool in
                    return string == "one"
                })
                expect(firstResult) == "one"
                
                let firstIndexResult = array.firstIndex(where: { (string) -> Bool in
                    return string == "one"
                })
                expect(firstIndexResult) == 0
                
                let lastResult = array.last(where: { (string) -> Bool in
                    return string == "one"
                })
                expect(lastResult) == "one"
                
                let lastResultIndex = array.lastIndex(where: { (string) -> Bool in
                    return string == "one"
                })
                expect(lastResultIndex) == 3
                
                let filterResult = array.filter(isIncluded: { (string) -> Bool in
                    return string == "one"
                })
                expect(filterResult.count) == 2
                
               
                
            }
            
            it("can do sorted"){
                let array : SyncArray<Int> = SyncArray()
                array.append(5)
                array.append(1)
                array.append(3)
                array.append(2)
                array.append(4)
                array.append(6)
                let sortResult = array.sorted(by: { (a, b) -> Bool in
                    return a < b
                })
                expect(sortResult) == [1,2,3,4,5,6]
            }
            
            it("can do flatMap"){
                let array : SyncArray<[Int]> = SyncArray()
                array.append([5,2])
                array.append([1,4])
                let flatMapResult = array.flatMap{ $0 }
                expect(flatMapResult) == [5,2,1,4]
            }
            
            it("can do compactMap"){
                let array : SyncArray<Int> = SyncArray()
                array.append(1)
                array.append(2)
                let compactMapResult = array.compactMap{ $0+1 }
                expect(compactMapResult) == [2,3]
            }
          
            it("can do contains"){
                let array : SyncArray<String> = SyncArray()
                array.append("Sonna")
                array.append("Joe")
                let containsResult = array.contains(where: { (string) -> Bool in
                    return string == "Joe"
                })
                expect(containsResult) == true
            }
            
            it("can do forEach"){
                let array = SyncArray<Int>(repeating: 1, count: 200)
                array.forEach({ (value) in
                    expect(value) == 1
                })
            }
            
            it("can do subscript"){
                let array = SyncArray<Any>(repeating: "", count: 3)
                array[0] = 100
                array[1] = "test"
                array[2] = 2.0
                
                let a = array[0] as? Int ?? 0
                let b = array[1] as? String ?? ""
                let c = array[2] as? Double ?? 0.0
                expect(a) == 100
                expect(b) == "test"
                expect(c) == 2.0
            }
            
            it("can do operators"){
                var array : SyncArray<Int> = SyncArray()
                array.append(1)
                array.append(2)
                array += 3
                array += [4,5]
                expect(array[2]) == 3
                expect(array[3]) == 4
                expect(array[4]) == 5
            }
        
        }
        
        describe("Testes of dictionary method") {
            it("can do subscript"){
                let dic = SyncDictionary<String, Any>()
                dic["test1"] = 100
                dic["test2"] = "test"
                expect(dic["test1"] as? Int ?? 0) == 100
                expect(dic["test2"] as? String ?? "") == "test"
            }
        }
        
    }
}
