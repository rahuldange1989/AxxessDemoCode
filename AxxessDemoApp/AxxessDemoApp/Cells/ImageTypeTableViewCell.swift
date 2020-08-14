//
//  ImageTypeTableViewCell.swift
//  AxxessDemoApp
//
//  Created by Rahul Dange on 14/08/20.
//  Copyright © 2020 Rahul Dange. All rights reserved.
//

import UIKit
import SnapKit

class ImageTypeTableViewCell: UITableViewCell {

	let customImageView = UIImageView()
	let dateLabel = UILabel()
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		// -- add UIIMageView to cell
		self.contentView.addSubview(customImageView)
		self.contentView.contentMode = .scaleAspectFit
		self.customImageView.snp.makeConstraints { (make) in
			make.edges.equalTo(self.contentView).inset(UIEdgeInsets(top: 5, left: 20, bottom: 50, right: 20))
		}
		
		// -- add dateLabel to cell
		self.contentView.addSubview(dateLabel)
		dateLabel.font = UIFont.systemFont(ofSize: 12)
		dateLabel.textColor = .black
		self.dateLabel.snp.makeConstraints { (make) in
			make.top.equalTo(customImageView.snp.bottom).offset(10)
			make.left.equalTo(self.contentView).offset(20)
			make.right.equalTo(self.contentView).offset(-20)
			make.height.equalTo(30)
		}
	}
	
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
