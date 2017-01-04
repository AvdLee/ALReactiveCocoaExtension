import UIKit
import XCTest
import ALReactiveCocoaExtension
import ReactiveSwift
import enum Result.NoError

enum ALErrorType : Error {
    case testError
}

class Tests: XCTestCase {
    
    func testCastingSuccess() {
        let expectation = self.expectation(description: "This will cast AnyObject to Double")
    
        let producer:SignalProducer<Double, NoError> = SignalProducer(value: 50.0)
        var errorValue:Error?
        var doubleValue:Double?
        
        producer.onError({ (error) in
            errorValue = error
            expectation.fulfill()
        }).onNextAs { (number:Double) in
            doubleValue = number
        }.onCompleted({ 
            expectation.fulfill()
        }).start()
        
        waitForExpectations(timeout: 10.0) { (_) in
            XCTAssertNil(errorValue)
            XCTAssertNotNil(doubleValue)
        }
    }
    
    func testCastingFailure() {
        let expectation = self.expectation(description: "This will fail to cast AnyObject to String")
        
        let producer:SignalProducer<Double, NoError> = SignalProducer(value: 50.0)
        var errorValue:Error?
        var stringValue:String?
        
        producer.onNextAs { (string:String) in
            stringValue = string
        }.onError({ (error) in
            errorValue = error
            expectation.fulfill()
        }).onCompleted({
            expectation.fulfill()
        }).start()
        
        waitForExpectations(timeout: 10.0) { (_) in
            XCTAssertNotNil(errorValue)
            XCTAssertNil(stringValue)
        }
    }
    
    func testErrorCast(){
        
        let producer:SignalProducer<String, NoError> = SignalProducer(value: "String")
        
        producer.flatMapErrorToNSError().onError { (error) -> () in
            print(error.userInfo)
        }.start()
    }
    
}
