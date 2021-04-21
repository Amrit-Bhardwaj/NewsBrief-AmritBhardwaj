//
//  Task.swift
//  NewsBrief
//
//  Created by Amrit Bhardwaj on 20/04/21.
//

import Foundation

/* This protocol describes the interface for a task object
 */
protocol Task {
    // associatedtype Output
    
    /// Request to execute
    var request: Request { get }
    
    
    /// Execute request in passed dispatcher
    ///
    /// - Parameter dispatcher: dispatcher
    /// - success: Success Block
    /// - failure: Failure Block
    func execute(in dispatcher: Dispatcher, success: @escaping ((Any) -> Void), failure: @escaping ((Error?) -> Void))
    
}
