//
//  PostsWebServices.swift
//  AxxessDemoApp
//
//  Created by Rahul Dange on 13/08/20.
//  Copyright © 2020 Rahul Dange. All rights reserved.
//

import Foundation

class PostsWebServices: BaseServices {
	
	///
	/// The  getPosts function accepts requestUrl and
	/// get allPosts and send it using callback function
	///
	/// - parameter url: requestUrl
	/// - parameter callback: callback function returns data and RequestResult
	///
	func getPosts(url: String = "/Mobile-Projects/master/challenge.json", callback: @escaping (_ result: Any?, _ requestResult: RequestResult) -> Void) {
		
		self.getRequestDataWithURL(requestUrl: url) { (data, requestResult) in
			callback(data, requestResult)
		}
		
	}
}
