//
//  Posts.swift
//  AxxessDemoApp
//
//  Created by Rahul Dange on 12/08/20.
//  Copyright © 2020 Rahul Dange. All rights reserved.
//

import Foundation
import RealmSwift

// MARK: - PostElement
class PostElement: Object, Codable {
    @objc dynamic var id: String = ""
    @objc dynamic var date: String? = ""
    @objc dynamic var data: String? = ""
	var type: TypeEnum = .other
}

enum TypeEnum: String, Codable {
    case image = "image"
    case other = "other"
    case text = "text"
}

typealias Posts = [PostElement]
