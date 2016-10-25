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
    func onStarted(_ callback:@escaping () -> ()) -> SignalProducer<Value, Error> {
        return self.on(started: callback)
    }
    
    func onError(_ callback:@escaping (_ error:Error) -> () ) -> SignalProducer<Value, Error> {
        return self.on(failed: { (error) -> () in
            callback(error)
        })
    }
    
    func onNext(_ nextClosure:@escaping (Value) -> ()) -> SignalProducer<Value, Error> {
        return self.on(value: nextClosure)
    }
    
    func onCompleted(_ nextClosure:@escaping () -> ()) -> SignalProducer<Value, Error> {
        return self.on(completed: nextClosure)
    }
    
    func onNextAs<U>(_ nextClosure:@escaping (U) -> ()) -> SignalProducer<U, ALCastError> {
        return self.mapToType().on(value: nextClosure)
    }
    
//    func startWithNextAs<U>(_ nextClosure:@escaping (U) -> ()) -> Disposable {
//        return self.mapToType()
//    }
}
