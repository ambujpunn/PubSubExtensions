# PubSubExtensions
Simple playground for extensions of Publisher and Subscribers for iOS Combine

## Limited Sink

```swift
[1,2,3,4]
    .publisher
    .sink(demand: 3, receivedCompletion: { completion in
        print("completion: \(completion)")
    }) { print($0) }
    .store(in: &cancellables)
```
```
// No completion
1
2
3
```

```swift
[1,2,3,4]
    .publisher
    .sink(demand: 4, receivedCompletion: { completion in
        print("completion: \(completion)")
    }) { print($0) }
    .store(in: &cancellables)
```
```
// Completion
1
2
3
4
completion: finished
```
