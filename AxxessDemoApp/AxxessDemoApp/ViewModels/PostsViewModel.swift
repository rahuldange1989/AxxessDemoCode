//
//  PostsViewModel.swift
//  AxxessDemoApp
//
//  Created by Rahul Dange on 13/08/20.
//  Copyright © 2020 Rahul Dange. All rights reserved.
//

import Foundation

// -- PostsViewModelDelegate to update tableView Data
protocol PostsViewModelDelegate {
	func updateTableViewData(with data: [[PostElement]], errorStatus: Bool)
}

class PostsViewModel {
	
	private var errorMessage = ""
	
	// -- delegate
	var delegate: PostsViewModelDelegate? = nil
	
	func getErrorMessage() -> String {
		return self.errorMessage
	}
	
	///
	/// The  callGetPostsAPI function makes API call
	/// and gets allPosts and If no internet load posts from Database
	/// and using PostsViewModelDelegate pass required AllPosts to PostsViewController
	///
	func callGetPostsAPI() {
		let postsServices = PostsWebServices()
		postsServices.getPosts {[weak self] (data, result) in
			
			var requiredData = [[PostElement]]()
			var errorStatus = true
			
			switch result {
			case .Success:
				do {
					let allPosts = try JSONDecoder().decode(Posts.self, from: data as! Data)
					requiredData.append(allPosts.filter { $0.type == TypeEnum.text })
					requiredData.append(allPosts.filter { $0.type == TypeEnum.image })
					requiredData.append(allPosts.filter { $0.type == TypeEnum.other })
					errorStatus = false
				} catch {
					self?.errorMessage = error.localizedDescription
				}
				
			case .Fail, .DataError:
				self?.errorMessage = result.getErrorMessage()
				
			// -- load allPosts from database
			case .NoInternet:
				break
				
			}
		
			if let delegate = self?.delegate {
				delegate.updateTableViewData(with: requiredData, errorStatus: errorStatus)
			}
		}
	}
	
}
