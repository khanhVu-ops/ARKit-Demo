//
//  Object2DModel.swift
//  ToyPlaneDemo
//
//  Created by BHSoft on 25/08/2022.
//

import Foundation

class Object2DModel {
    var image: String?
    var name: String?
    
    convenience init(image: String?, name: String?) {
        self.init()
        self.image = image
        self.name = name
    }
}
