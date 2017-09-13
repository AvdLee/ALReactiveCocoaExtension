//
//  SignalProducer+Helper.swift
//  Pods
//
//  Created by Antoine van der Lee on 15/01/16.
//
//

import Foundation
import ReactiveSwift
import enum Result.NoError

public enum ALCastError : Swift.Error {
    case couldNotCastToType
}

private extension SignalProducer  {
    func mapToType<U>() -> SignalProducer<U, ALCastError> {
        return flatMapError({ (error) -> SignalProducer<Value, ALCastError> in
                return SignalProducer<Value, ALCastError>(error: ALCastError.couldNotCastToType)
            })
            .flatMap(FlattenStrategy.concat) { (object) -> SignalProducer<U, ALCastError> in
                if let castedObject = object as? U {
                    return SignalProducer<U, ALCastError>(value: castedObject)
                } else {
                    return SignalProducer<U, ALCastError>(error: ALCastError.couldNotCastToType)
                }
            }
    }
}

public extension SignalProducer {
    @available(*, deprecated, renamed: "onStarting(_:)")
    public func onStarted(_ callback:@escaping () -> ()) -> SignalProducer<Value, Error> {
        return onStarting(callback)
    }
    
    public func onStarting(_ callback:@escaping () -> ()) -> SignalProducer<Value, Error> {
        return self.on(starting: callback)
    }
    
    public func onError(_ callback:@escaping (_ error:Error) -> () ) -> SignalProducer<Value, Error> {
        return self.on(failed: { (error) -> () in
            callback(error)
        })
    }
    
    public func onNext(_ nextClosure:@escaping (Value) -> ()) -> SignalProducer<Value, Error> {
        return self.on(value: nextClosure)
    }
    
    public func onCompleted(_ nextClosure:@escaping () -> ()) -> SignalProducer<Value, Error> {
        return self.on(completed: nextClosure)
    }
    
    public func onNextAs<U>(_ nextClosure:@escaping (U) -> ()) -> SignalProducer<U, ALCastError> {
        return self.mapToType().on(value: nextClosure)
    }
    
    /// This function ignores any parsing errors
    public func startWithNextAs<U>(_ nextClosure:@escaping (U) -> ()) -> Disposable {
        return mapToType()
            .flatMapError { (object) -> SignalProducer<U, NoError> in
                return SignalProducer<U, NoError>.empty
            }.startWithValues(nextClosure)
    }
    
    public func flatMapErrorToNSError() -> SignalProducer<Value, NSError> {
        return flatMapError({ return SignalProducer<Value, NSError>(error: $0 as NSError) })
    }
}

public extension SignalProducer {
    public func ignoreError() -> SignalProducer<Value, NoError> {
        return flatMapError { _ in
            SignalProducer<Value, NoError>.empty
        }
    }
}

public extension Signal {
    
    func toSignalProducer() -> SignalProducer<Value, Error> {
        return SignalProducer(self)
    }
    
}

