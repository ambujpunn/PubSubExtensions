import Foundation
import Combine

/// Sink with limitation as per demand
public extension Publisher where Self.Failure == Never {
    func sink(_ demand: Int, receivedValue: @escaping Subscribers.ReceivedValue<Self.Output>) -> AnyCancellable {
        let limitedSinkSub = Subscribers.LimitedSink<Self.Output, Never>(demand: demand, receivedValue: receivedValue)
        subscribe(limitedSinkSub)
        return AnyCancellable(limitedSinkSub)
    }
}

public extension Publisher {
    func sink(_ demand: Int, receivedCompletion: @escaping Subscribers.ReceivedCompletion<Self.Failure>,
              receivedValue: @escaping Subscribers.ReceivedValue<Self.Output>) -> AnyCancellable {
        let limitedSinkSub = Subscribers.LimitedSink<Self.Output, Self.Failure>(demand: demand, receivedCompletion: receivedCompletion, receivedValue: receivedValue)
        subscribe(limitedSinkSub)
        return AnyCancellable(limitedSinkSub)
    }
}

public typealias IntTimeInterval = Int

public protocol TimerStartable {
    func start(totalTime: IntTimeInterval?) -> AnyPublisher<Date, Never>
    func stop()
}

/// Extension functions for instances of AutoConnect publishers that have TimerPublisher as its their upstream aka "autoconnect()" has been called on the TimerPublisher instance
extension Publishers.Autoconnect: TimerStartable where Upstream: Timer.TimerPublisher {
    
    /// Stops timer of current timer publisher instance
    public func stop() {
        upstream.connect().cancel()
    }
    
    /// Stops timer of current timer publisher instance after totalTime
    /// If totalTime is nil, then continues until hard stopped
    public func start(totalTime: IntTimeInterval? = nil) -> AnyPublisher<Date, Never> {
        var timeElapsed: IntTimeInterval = 0
        return flatMap { date in
            return Future<Date, Never> { promise in
                if let totalTime = totalTime, timeElapsed >= totalTime { self.stop() }
                promise(.success(date))
                timeElapsed += 1
            }
        }.eraseToAnyPublisher()
    }
}

