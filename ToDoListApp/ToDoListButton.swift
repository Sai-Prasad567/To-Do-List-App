//
//  ToDoListButton.swift
//  ToDoListApp
//
//  Created by Sai Prasad on 01/10/23.
//

import UIKit

class ToDoListButton: UIButton {
    
    override var isSelected: Bool{
        didSet{
            if isSelected == true{
                self.setImage(UIImage(named: "Checkboxfilled"), for: .selected)
            }
            else{
                self.setImage(UIImage(named: "Checkboxempty"), for: .normal)
            }
            print("checkBox",isSelected)
        }
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear;
        self.adjustsImageWhenHighlighted = false;
        self.setImage(UIImage(named: "Checkboxfilled"), for: .selected)
        self.setImage(UIImage(named: "Checkboxempty"), for: .normal)
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.width = contentSize.width+titleEdgeInsets.left+titleEdgeInsets.right
        return contentSize;
    }
}
