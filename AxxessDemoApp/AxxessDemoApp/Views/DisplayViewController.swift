//
//  DisplayViewController.swift
//  AxxessDemoApp
//
//  Created by Rahul Dange on 14/08/20.
//  Copyright © 2020 Rahul Dange. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

class DisplayViewController: UIViewController {

	private let imageView = UIImageView()
	private let dataTextView = UITextView()
	
	private var postModel: PostElement? {
		didSet {
			self.updateUI()
		}
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		self.createUI()
	}
	
	// MARK: - Internal Methods -
	func setPostModel(model: PostElement) {
		self.postModel = model
	}
	
	// -- create required initial UI
	private func createUI() {
				
		// -- add imageviw and set constraints
		self.view.addSubview(imageView)
		self.imageView.contentMode = .scaleAspectFit
		self.imageView.backgroundColor = .white
		self.imageView.snp.makeConstraints { (make) in
			make.edges.equalTo(self.view).inset(UIEdgeInsets(top: self.topbarHeight, left: 0, bottom: -20, right: 0))
		}
		
		// -- add textView and set constraints
		self.view.addSubview(dataTextView)
		dataTextView.font = UIFont.systemFont(ofSize: 14.0)
		dataTextView.isEditable = false
		dataTextView.isSelectable = false
		self.dataTextView.snp.makeConstraints { (make) in
			make.edges.equalTo(self.view).inset(UIEdgeInsets(top: self.topbarHeight, left: 0, bottom: -20, right: 0))
		}
	}
	
	// -- update UI once postModel is set
	private func updateUI() {
		
		guard let postModel = self.postModel else { return }
		self.title = postModel.date ?? "Selected Post"
		
		// -- hide imageview if posttype is text/other
		if postModel.type == TypeEnum.text.rawValue || postModel.type == TypeEnum.other.rawValue {
			
			self.imageView.isHidden = true
			self.dataTextView.isHidden = false
			self.dataTextView.text = postModel.data ?? ""
			
		} else { // -- hide textview if post type is image
			
			self.dataTextView.isHidden = true
			self.imageView.isHidden = false
			guard let imageUrl = URL(string: postModel.data ?? "") else { return }
			self.imageView.kf.indicatorType = .activity
			self.imageView.kf.setImage(with: imageUrl, placeholder: UIImage(named: "placeholder"))
			
		}
	}
}
