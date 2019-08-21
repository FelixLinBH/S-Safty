// https://github.com/Quick/Quick

import Quick
import Nimble
import comthreadsafety

class TableOfContentsSpec: QuickSpec {
    override func spec() {
        describe("Testes") {
            
            it("thread safty while appending") {
                let array = SyncArray<Int>()
                DispatchQueue.concurrentPerform(iterations: 1000, execute: { (index) in
                    let last = array.last ?? 0
                    print(index)
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
                    print(index)
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
                DispatchQueue.concurrentPerform(iterations: 1000, execute: { (index) in
                    print("\(index)")
                    array.insert(index, at: index)
                    DispatchQueue.global().sync {
                        guard index == 999 else { return }
                        expect(array[index]) != 0
                        array.removeAll(completion: { (result) in
                            expect(result.count) == 0
                        })
                    }
                })
            }
            
            it("can do first,firstIndex,last,lastIndex,filter,sorted") {
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
                
            }
            
        
            
            
            
            //                array.append(5)
            //                array.append(6)
            //                expect(array[0]) == 5
            //                expect(array.first) == 5
            //                expect(array.last) == 6
            //                expect(array.count) == 2
            //                expect(array.isEmpty) == false
            //                expect(array.underestimatedCount) <= array.count
            //                array.append(contentsOf: [7,8])
            //                expect(array[2]) == 7
            //                array.remove(at: 2)
            //                expect(array[2]) == 8
            //                array.insert(3, at: 2)
            //                expect(array[2]) == 3
            
//
//            it("will eventually fail") {
//                expect("time").toEventually( equal("done") )
//            }
//
//            context("these will pass") {
//
//                it("can do maths") {
//                    expect(23) == 23
//                }
//
//                it("can read") {
//                    expect("🐮") == "🐮"
//                }
//
//                it("will eventually pass") {
//                    var time = "passing"
//
//                    DispatchQueue.main.async {
//                        time = "done"
//                    }
//
//                    waitUntil { done in
//                        Thread.sleep(forTimeInterval: 0.5)
//                        expect(time) == "done"
//
//                        done()
//                    }
//                }
//            }
        }
    }
}
