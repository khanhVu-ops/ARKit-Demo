//
//  Object2DModel.swift
//  ToyPlaneDemo
//
//  Created by BHSoft on 25/08/2022.
//

import Foundation

class Object3DModel {
    var thumbnail: String?
    var displayName: String?
    var assetId: String?
    var objURL: String?
    var mtlURL: String?
    convenience init(thumbnail: String?, displayName: String?, assetId: String?, objURL: String?, mtlURL: String?) {
        self.init()
        self.thumbnail = thumbnail
        self.displayName = displayName
        self.assetId = assetId
        self.objURL = objURL
        self.mtlURL = mtlURL
    }
}
