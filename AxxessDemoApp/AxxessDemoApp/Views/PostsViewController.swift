//
//  PostsViewController.swift
//  AxxessDemoApp
//
//  Created by Rahul Dange on 12/08/20.
//  Copyright © 2020 Rahul Dange. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

class PostsViewController: UIViewController {

	// -- data variable to populate tableview
	var tableViewData = [[PostElement]]()
	
	// -- create an instance of PostsViewModel
	let postsViewModel = PostsViewModel()
	
	// -- Tableview to display all posts
	let tableView = UITableView()
	
	// -- create DiplayViewController instance
	let displayVC = DisplayViewController()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		
		self.title = "Posts"
		self.addTableView()
		
		self.postsViewModel.delegate = self
		self.populateTableView()
	}
	
	// MARK: - Internal Methods -
	private func addTableView() {
		
		// -- add tableview to view
		self.view.addSubview(self.tableView)
		self.tableView.accessibilityIdentifier = "PostsTableView"
		// -- set delegates and data source
		self.tableView.dataSource = self
		self.tableView.delegate = self
		// -- remove extra tableview seperators
		self.tableView.tableFooterView = UIView()
		// -- register tableviewcell for text or other types of Post
		self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TextOrOtherTypeCell")
		self.tableView.register(ImageTypeTableViewCell.self, forCellReuseIdentifier: "ImageTypeTableViewCell")
		// -- set tableView constraints
		tableView.snp.makeConstraints { make in
			make.edges.equalTo(self.view).inset(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
		}
		
	}
	
	private func populateTableView() {
		// -- show loading indicator
		Utility.showActivityIndicatory(self.view)
		// -- call getPostAPI function from PostViewModel
		postsViewModel.callGetPostsAPI()
	}
}

// MARK: - PostsViewModelDelegate methods implementation -
extension PostsViewController : PostsViewModelDelegate {

	func updateTableViewData(with data: [[PostElement]], errorStatus: Bool) {
		if errorStatus {
			// -- Show error alert on Main thread
			DispatchQueue.main.async {
				Utility.hideActivityIndicatory(self.view)
				Utility.showAlert(self, title: "Error", message: self.postsViewModel.getErrorMessage())
			}
		} else {
			self.tableViewData = data
			
			// -- Update TableView Data on Main thread
			DispatchQueue.main.async {
				Utility.hideActivityIndicatory(self.view)
				self.tableView.reloadData()
			}
		}
	}
}

// MARK: - UITableView datasource and delegate methods -
extension PostsViewController : UITableViewDelegate, UITableViewDataSource {

	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if indexPath.section == 1 {
			return 300.0
		}
		
		return UITableView.automaticDimension
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return self.tableViewData.count
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.tableViewData[section].count
	}
	
	func sectionIndexTitles(for tableView: UITableView) -> [String]? {
		return [TypeEnum.text.rawValue.capitalized, TypeEnum.image.rawValue.capitalized, TypeEnum.other.rawValue.capitalized]
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		// -- Get current post
		let currentPost = self.tableViewData[indexPath.section][indexPath.row]
		
		// -- TableView Cell for Text and Other type
		if indexPath.section == 0 || indexPath.section == 2 {
			
			var cell = tableView.dequeueReusableCell(withIdentifier: "TextOrOtherTypeCell", for: indexPath)
			cell.accessibilityIdentifier = "textCell_\(indexPath.section)_\(indexPath.row)"
			
			if cell.detailTextLabel == nil {
				cell = UITableViewCell(style: .subtitle, reuseIdentifier: "TextOrOtherTypeCell")
			}
			
			// -- set cell selection stype to none
			cell.selectionStyle = .none
			
			// -- to make textLabel multiline
			cell.textLabel?.numberOfLines = 0
			
			// -- set data to cell
			cell.textLabel?.text = currentPost.data ?? ""
			cell.detailTextLabel?.text = currentPost.date ?? ""
			
			return cell
			
		} else { // -- TableView Cell for Image type
			
			var cell = tableView.dequeueReusableCell(withIdentifier: "ImageTypeTableViewCell", for: indexPath) as? ImageTypeTableViewCell
			if cell == nil {
				cell = ImageTypeTableViewCell.init(style: .default, reuseIdentifier: "ImageTypeTableViewCell")
			}
			
			// -- set cell selection stype to none
			cell?.selectionStyle = .none
			
			// -- create imageUrl from string and assing it to imageview using Kingfisher
			guard let imageUrl = URL(string: currentPost.data ?? "") else { return cell! }
			cell?.customImageView.kf.indicatorType = .activity
			cell?.customImageView.kf.setImage(with: imageUrl, placeholder: UIImage(named: "placeholder"))
			cell?.dateLabel.text = currentPost.date ?? ""
			
			return cell!
		}
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let selectedPost = self.tableViewData[indexPath.section][indexPath.row]
		self.displayVC.setPostModel(model: selectedPost)
		self.navigationController?.pushViewController(self.displayVC, animated: true)
	}
}
