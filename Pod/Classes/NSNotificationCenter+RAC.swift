//
//  NSNotificationCenter+RAC.swift
//  Pods
//
//  Created by Antoine van der Lee on 15/01/16.
//
//

import Foundation
import ReactiveSwift
import enum Result.NoError

public extension NotificationCenter {
    open func rac_addObserversForNames(_ names:[String]) -> SignalProducer<Notification, NoError> {
        var signals = [SignalProducer<Notification, NoError>]()
        for name in names {
            signals.append(SignalProducer(reactive.notifications(forName: Notification.Name(rawValue: name))))
        }
        
        return SignalProducer.merge(signals)
    }
}
