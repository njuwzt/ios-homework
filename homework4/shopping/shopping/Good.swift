//
//  Good.swift
//  shopping
//
//  Created by Astinna on 2020/11/12.
//  Copyright © 2020 NJU. All rights reserved.
//

import UIKit
class Good {
    var name: String
    var photo: UIImage?
    var reason: String
    
    init?(name: String, photo: UIImage?, reason: String){
        if name.isEmpty||reason.isEmpty{
            return nil
        }
        self.name=name
        self.photo=photo
        self.reason=reason
    }
}
