import Foundation
import Combine

var cancellables = Set<AnyCancellable>()

/// Limited Sink

let arrPub = [1,2,3,4].publisher

print("3 items")
arrPub
    .sink(demand: .max(3), receivedCompletion: { completion in
        print("completion: \(completion)")
    }) { print($0) }
    .store(in: &cancellables)

print("4 items")
arrPub
    .sink(demand: .max(4), receivedCompletion: { completion in
        print("completion: \(completion)")
    }) { print($0) }
    .store(in: &cancellables)

print("all items")
arrPub
    .sink(demand: .unlimited, receivedCompletion: { completion in
        print("completion: \(completion)")
    }) { print($0) }
    .store(in: &cancellables)

print("5 items")
arrPub
    .sink(demand: .max(5), receivedCompletion: { completion in
        print("completion: \(completion)")
    }) { print($0) }
    .store(in: &cancellables)




