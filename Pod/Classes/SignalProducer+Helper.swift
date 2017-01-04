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

public enum ALCastError : Error {
    case couldNotCastToType
}

private extension SignalProducerProtocol  {
    func mapToType<U>() -> SignalProducer<U, ALCastError> {
        return flatMapError({ (_) -> SignalProducer<Value, ALCastError> in
            return SignalProducer(error: ALCastError.couldNotCastToType)
        }).flatMap(.concat) { object -> SignalProducer<U, ALCastError> in
            if let castedObject = object as? U {
                return SignalProducer(value: castedObject)
            } else {
                return SignalProducer(error: ALCastError.couldNotCastToType)
            }
        }
    }
}

public extension SignalProducerProtocol {
    open func onStarted(_ callback:@escaping () -> ()) -> SignalProducer<Value, Error> {
        return self.on(started: callback)
    }
    
    open func onError(_ callback:@escaping (_ error:Error) -> () ) -> SignalProducer<Value, Error> {
        return self.on(failed: { (error) -> () in
            callback(error)
        })
    }
    
    open func onNext(_ nextClosure:@escaping (Value) -> ()) -> SignalProducer<Value, Error> {
        return self.on(value: nextClosure)
    }
    
    open func onCompleted(_ nextClosure:@escaping () -> ()) -> SignalProducer<Value, Error> {
        return self.on(completed: nextClosure)
    }
    
    open func onNextAs<U>(_ nextClosure:@escaping (U) -> ()) -> SignalProducer<U, ALCastError> {
        return self.mapToType().on(value: nextClosure)
    }
    
    /// This function ignores any parsing errors
    open func startWithNextAs<U>(_ nextClosure:@escaping (U) -> ()) -> Disposable {
        return mapToType()
            .flatMapError { (object) -> SignalProducer<U, NoError> in
                return SignalProducer.empty
            }.startWithValues(nextClosure)
    }
    
    public func flatMapErrorToNSError() -> SignalProducer<Value, NSError> {
        return flatMapError({
            SignalProducer(error: $0 as NSError)
        })
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

