//
//  DataModal.swift
//  AppFour
//
//  Created by etudiant on 21/11/2018.
//  Copyright © 2018 L3P-IEM. All rights reserved.
//

import Foundation

class DataModal{
    var headerName:String?
    var subType = [String]()
    var isExpandable:Bool = false
    
    init(headerName:String, subType:[String], isExpandable:Bool){
        self.headerName = headerName
        self.subType = subType
        self.isExpandable = isExpandable
    }
}
