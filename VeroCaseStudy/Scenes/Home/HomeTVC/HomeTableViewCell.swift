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
   
    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0))
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.layer.cornerRadius = 6
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
        taskLabel.text = "Task: \(model.task)"
        titleLabel.text = "Title: \(model.title)"
        descriptionLabel.text = "Description: \(model.description)"
                    
        contentView.backgroundColor = colorFromHex(hex: model.colorCode)
        

    }
    private func colorFromHex(hex: String) -> UIColor {
        let colorCode = hex.replacingOccurrences(of: "#", with: "")
        let convertedColor = UInt64(colorCode, radix: 16) ?? 0
        let red = CGFloat((convertedColor & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((convertedColor & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(convertedColor & 0x0000FF) / 255.0
        return UIColor(red: red, green: green, blue: blue, alpha: 0.6)
    }
}
