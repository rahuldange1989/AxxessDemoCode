//
//  AxxessDemoAppTests.swift
//  AxxessDemoAppTests
//
//  Created by Rahul Dange on 12/08/20.
//  Copyright © 2020 Rahul Dange. All rights reserved.
//

import XCTest
import RealmSwift
@testable import AxxessDemoApp

class AxxessDemoAppTests: XCTestCase {

	override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

	// -- Unit testing of challenge API used
    func testChallengeAPI() {
		let postsServices = PostsWebServices()
		
		// -- create the expectation
		let exp = expectation(description: "Loading posts")
		
		postsServices.getPosts { (data, result) in
			// -- got API callback, marking exp fullfil
			exp.fulfill()
			
			// -- check if we get data
			XCTAssertNotNil(data, "Loading posts failed.")
		}
		
		// wait five seconds for all outstanding expectations to be fulfilled
		wait(for: [exp], timeout: 5.0)
	}
	
	// -- Unit testing of Offline storage
	func testOfflineFunctionality() throws {
		
		// -- create sample Post
		let post = PostElement()
		post.data = "Test Post"
		post.date = "10/10/2019"
		post.type = "text"
		post.id = "1"
		
		// -- get Realm and save Post object to DB
		do {
			let realm = try Realm()
			try realm.write {
				realm.add(post)
			}
		} catch {
			print(error.localizedDescription)
		}
		
		// -- retrieve saved Post Object from DB
		do {
			let realm = try Realm()
			let post = realm.objects(PostElement.self).last
			XCTAssertEqual(post?.data, "Test Post", "Saving and retrieving data from database failed.")
			
			// -- remove last added object
			if let post = post {
				try realm.write {
					realm.delete(post)
				}
			}
		} catch {
			print(error.localizedDescription)
		}
	}
}
