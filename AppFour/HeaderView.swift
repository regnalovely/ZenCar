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
}
class HeaderView: UIView {
    
    var secIndex:Int?
    var delegate:HeaderDelegate?
    
    override init(frame: CGRect){
        super.init(frame:frame)
        self.addSubview(button)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var button:UIButton = {
        let btn = UIButton(frame: CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.width, height: self.frame.height))
        btn.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        btn.titleLabel?.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        btn.layer.cornerRadius = 10
        btn.clipsToBounds = true
        btn.addTarget(self, action: #selector(onClickHeaderView), for: .touchUpInside)
        
        return btn
    }()
    
    @objc func onClickHeaderView() {
        if let index = secIndex {
            delegate?.cellHeader(index: index)
        }
    }

}
