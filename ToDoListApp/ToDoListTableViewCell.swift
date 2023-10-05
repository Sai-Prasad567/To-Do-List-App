//
//  ToDoListTableViewCell.swift
//  ToDoListApp
//
//  Created by Sai Prasad on 01/10/23.
//

import UIKit

class ToDoListTableViewCell: UITableViewCell{
    
    let button = ToDoListButton()
    let label = UILabel()
    
    init(text : String, style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpViews(text:text)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpViews(text:String){
        
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textColor = .blue
        
        self.contentView.addSubview(button)
        self.contentView.addSubview(label)
    
        
        button.addConstraint(top: self.contentView.topAnchor, leading: self.contentView.leadingAnchor, bottom: nil, trailing: nil,padding: UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 0),size: CGSize(width: 24, height: 24))
        label.addConstraint(top: contentView.topAnchor, leading: button.trailingAnchor, bottom: nil, trailing: contentView.trailingAnchor,padding: UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)) 
    }
}
