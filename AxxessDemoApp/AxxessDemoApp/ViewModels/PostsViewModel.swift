//
//  PostsViewModel.swift
//  AxxessDemoApp
//
//  Created by Rahul Dange on 13/08/20.
//  Copyright © 2020 Rahul Dange. All rights reserved.
//

import Foundation
import RealmSwift

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
			
			var allPosts = Posts()
			var errorStatus = true
			
			switch result {
			case .Success:
				do {
					allPosts = try JSONDecoder().decode(Posts.self, from: data as! Data)
					errorStatus = false
					
					// -- save allPosts to DB
					self?.saveAllPostsToDB(allPosts: allPosts)
				} catch {
					self?.errorMessage = error.localizedDescription
				}
				
			case .Fail, .DataError:
				self?.errorMessage = result.getErrorMessage()
				
			// -- load allPosts from database
			case .NoInternet:
				allPosts = (self?.retriveAllPostsFromDB()) ?? []
				errorStatus = false
				
			}
			
			var requiredData = [[PostElement]]()
			requiredData.append(allPosts.filter { $0.type == TypeEnum.text.rawValue })
			requiredData.append(allPosts.filter { $0.type == TypeEnum.image.rawValue })
			requiredData.append(allPosts.filter { $0.type == TypeEnum.other.rawValue })
		
			if let delegate = self?.delegate {
				delegate.updateTableViewData(with: requiredData, errorStatus: errorStatus)
			}
		}
	}
	
	///
	/// The  saveAllPostsToDB function accepts parameter allPosts and
	/// saves all downloaded posts to DB
	///
	/// - parameter allPosts: All downloaded Posts
	/// - throws: Realm data save error
	///
	func saveAllPostsToDB(allPosts: Posts) {
		do {
			let realm = try Realm()
			try realm.write {
				realm.add(allPosts)
			}
		} catch {
			print(error.localizedDescription)
		}
	}
	
	///
	/// The  retriveAllPostsFromDB function
	/// returnsl all saved posts from DB
	///
	/// - returns: all saved Posts from DB
	/// - throws: Realm data save error
	///
	func retriveAllPostsFromDB() -> Posts {
		var allPosts = Posts()
		do {
			let realm = try Realm()
			allPosts = realm.objects(PostElement.self).map { return $0 as PostElement }
		} catch {
			print(error.localizedDescription)
		}
		
		return allPosts
	}
	
}
