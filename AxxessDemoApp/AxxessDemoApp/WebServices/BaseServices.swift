//
//  BaseServices.swift
//  AxxessDemoApp
//
//  Created by Rahul Dange on 13/08/20.
//  Copyright © 2020 Rahul Dange. All rights reserved.
//

import Foundation
import Alamofire

enum RequestResult: Int, Error {
    case Success
    case Fail
    case NoInternet
    case DataError
}

extension RequestResult {
    func getErrorMessage() -> String {
        switch self {
        case .NoInternet:
            return "You are currently offline. Please connect to internet."
		case .DataError, .Fail:
            return "Unable to connect to the server.\nPlease try again later."
        default:
            return ""
        }
    }
}

class BaseServices {
	
	private let BASEURL = "https://raw.githubusercontent.com/AxxessTech"
	
	///
	/// The private getHeaders function returns required HTTPHeaders
	///
	/// - returns: required HTTPHeaders
	///
	private func getHeaders() -> HTTPHeaders {
		return [
			"Content-Type" : "application/json"
		]
	}
	
	///
	/// The private getCompleteUrl function accepts url
	/// and return BASEURL + url
	///
	/// - parameter url: url to get complete url
	/// - returns: complete URL for request
	///
	private func getCompleteUrl(url: String) -> String {
		return self.BASEURL + url
	}
	
	///
	/// The  getRequestDataWithURL function accepts requestUrl and
	/// get response from url and then using callback sends data and RequestResult
	///
	/// - parameter url: requestUrl
	/// - parameter callback: callback function returns data and RequestResult
	///
	func getRequestDataWithURL(requestUrl: String, callback: @escaping (_ data: Any?, _ result: RequestResult) -> Void)   {
        
		// -- Check if internet is available.
		if NetworkReachability.sharedInstance.isNetworkAvailable() {
			
			AF.request(self.getCompleteUrl(url: requestUrl), headers: self.getHeaders()).responseJSON { response in
				if let responsError = response.error {
                    print(responsError.localizedDescription)
                    callback(nil, .Fail)
                } else {
                    if let value = response.data {
                        callback(value, .Success)
                    } else {
                        callback(nil, .DataError)
                    }
                }
			}
        } else {
            callback(nil, .NoInternet)
        }
    }
}
