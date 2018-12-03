//
//  HeaderView.swift
//  AppFour
//
//  Created by etudiant on 21/11/2018.
//  Copyright © 2018 L3P-IEM. All rights reserved.
//

import UIKit
protocol HeaderDelegate {
    func cellHeader(index:Int)
    func deleteSection(id:Int)
}
class HeaderView: UIView {
    
    var sectionID:Int!
    var secIndex:Int?
    var delegate:HeaderDelegate?
    var myColor = "E86D8A"
    
    override init(frame: CGRect){
        super.init(frame:frame)
        self.addSubview(button)
        self.addSubview(image)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var button:UIButton = {
        let btn = UIButton(frame: CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.width, height: self.frame.height))
        btn.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        btn.titleLabel?.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        btn.layer.cornerRadius = 0
        btn.clipsToBounds = true
        btn.addTarget(self, action: #selector(onClickHeaderView), for: .touchUpInside)
        
        return btn
    }()
    
    lazy var image:UIImageView = {
        let img = UIImageView(frame: CGRect(x: self.frame.origin.x+50, y: self.frame.origin.y+5, width: self.frame.width/4, height: self.frame.height-10))

        return img
    }()
    
    @objc func onClickHeaderView() {
        if let index = secIndex {
            delegate?.cellHeader(index: index)
        }
    }
    
    @objc func onClickBtnDelete(){
        print("Deleted button is clicking")
        
        if let id = sectionID {
            delegate?.deleteSection(id: id)
        }
    }
}
