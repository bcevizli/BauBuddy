//
//  HomeTableViewCell.swift
//  VeroCaseStudy
//
//  Created by Adem Burak Cevizli on 31.03.2023.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    static let identifier = "HomeTableViewCell"
    
    let taskLabel = UILabel()
    let titleLabel = UILabel()
    let descriptionLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        createCell()
    
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    func createCell() {
        contentView.addSubview(taskLabel)
        taskLabel.text = "task"
        taskLabel.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, bottom: nil, right: nil, padding: UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 0), size: CGSize(width: 100, height: 25))
        
        contentView.addSubview(titleLabel)
        titleLabel.text = "title"
        titleLabel.anchor(top: taskLabel.bottomAnchor, left: contentView.leftAnchor, bottom: nil, right: nil, padding: UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 0), size: CGSize(width: 100, height: 25))
        
        contentView.addSubview(descriptionLabel)
        descriptionLabel.text = "description"
        descriptionLabel.anchor(top: titleLabel.bottomAnchor, left: contentView.leftAnchor, bottom: nil, right: nil, padding: UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 0), size: CGSize(width: 100, height: 25))
    }
}
