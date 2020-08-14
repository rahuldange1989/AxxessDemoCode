//
//  NetworkReachability.swift
//  LocalWeatherApp
//
//  Created by Rahul Dange on 4/10/19.
//  Copyright © 2019 Rahul Dange. All rights reserved.
//

import Foundation
import Alamofire

// -- shared instance
private let _sharedInstance = NetworkReachability.init()

class NetworkReachability {
    
    class var sharedInstance: NetworkReachability {
        return _sharedInstance
    }
    
    let backgroudQueue = DispatchQueue.global(qos: .background)
    
	///
	/// The isNetworkAvailable function checks if internet is available
	/// and returns its status either true or false
	///
	/// - returns: status of Network connection.
	///
    func isNetworkAvailable() -> Bool {
		return NetworkReachabilityManager()?.isReachable ?? false
    }
}
