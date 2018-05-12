//
//  Macros.swift
//  BaseProject
//
//  Created by Admin on 10.05.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation

func DLog<T>(_ object: T, function: String = #function, line: Int = #line, file: String = #file) {
    print("[\((file as NSString).lastPathComponent)] \(function) [Line \(line)]:")
    print("\(object)")
    print("")
}

func delay(_ delay:Double, closure:@escaping ()->())
{
    DispatchQueue.main.asyncAfter(
        deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
}

func delayCancellable(_ delay: Double, workItem: DispatchWorkItem)
{
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay, execute: workItem)
}

class AsyncBlockOperation: Operation
{
    // MARK: public interface
    
    var asynchronousExecutionBlock: (()->())?
    
    var asynchronousPortionIsFinished: Bool = false {
        didSet {
            if asynchronousPortionIsFinished == true
            {
                self.isExecuting = false
                self.isFinished = true
            }
        }
    }
    
    // MARK: implementation
    override func start()
    {
        self.isExecuting = true
        
        if let block = asynchronousExecutionBlock {
            block()
        }else {
            asynchronousPortionIsFinished = true
        }
    }
    
    override var isAsynchronous: Bool {
        get {
            return true
        }
    }
    
    override var isExecuting: Bool {
        get {
            return _executing
        }
        set {
            willChangeValue(forKey: "isExecuting")
            _executing = newValue
            didChangeValue(forKey: "isExecuting")
        }
    }
    private var _executing: Bool = false
    
    override var isFinished: Bool {
        get {
            return _finished
        }
        set {
            willChangeValue(forKey: "isFinished")
            _finished = newValue
            didChangeValue(forKey: "isFinished")
        }
    }
    private var _finished: Bool = false
}
