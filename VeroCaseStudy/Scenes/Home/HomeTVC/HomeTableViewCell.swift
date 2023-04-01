//
//  HomeTableViewCell.swift
//  VeroCaseStudy
//
//  Created by Adem Burak Cevizli on 31.03.2023.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    static let identifier = "HomeTableViewCell"
    
    private let taskLabel = UILabel()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private var colorCode: String = ""
   
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        createCell()
    
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    private func createCell() {
        contentView.addSubview(taskLabel)
        taskLabel.numberOfLines = 0
        taskLabel.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, bottom: nil, right: nil, padding: UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 0), size: CGSize(width: self.contentView.frame.width - 20, height: 50))
        
        contentView.addSubview(titleLabel)
        titleLabel.numberOfLines = 0
        titleLabel.anchor(top: taskLabel.bottomAnchor, left: contentView.leftAnchor, bottom: nil, right: nil, padding: UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 0), size: CGSize(width: self.contentView.frame.width - 20, height: 50))
        
        contentView.addSubview(descriptionLabel)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.anchor(top: titleLabel.bottomAnchor, left: contentView.leftAnchor, bottom: nil, right: nil, padding: UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 0), size: CGSize(width: self.contentView.frame.width - 20, height: 50))
        
       
    }
    func updateCell(with model: Items) {
        taskLabel.text = model.task
        titleLabel.text = model.title
        descriptionLabel.text = model.description
        colorCode = model.colorCode  // assign the color code from the model to the colorCode property
                    print(colorCode)
                    // Convert the color code to a UIColor and set the background color of the cell
                    let convertedColor = UInt64(colorCode, radix: 16) ?? 0
                    let red = CGFloat((convertedColor & 0xFF0000) >> 16) / 255.0
                    let green = CGFloat((convertedColor & 0x00FF00) >> 8) / 255.0
                    let blue = CGFloat(convertedColor & 0x0000FF) / 255.0
                    let backColor = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        contentView.backgroundColor = backColor
        
//        colorCode = model.colorCode  // assign the color code from the model to the colorCode property
//            print(colorCode)
//            // Convert the color code to a UIColor and set the background color of the cell
//            let convertedColor = UInt64(colorCode, radix: 16) ?? 0
//            let red = CGFloat((convertedColor & 0xFF0000) >> 16) / 255.0
//            let green = CGFloat((convertedColor & 0x00FF00) >> 8) / 255.0
//            let blue = CGFloat(convertedColor & 0x0000FF) / 255.0
//            let backColor = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
//        self.backgroundColor = backColor
//        self.contentView.backgroundColor = backColor
    }
    
}
