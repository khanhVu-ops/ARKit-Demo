//
//  UrlTypeModel.swift
//  ToyPlaneDemo
//
//  Created by BHSoft on 24/08/2022.
//

import Foundation

class UrlTypeModel: NSObject {
    var name: String?
    var displayName: String?
    var authorName: String?
    var createTime: String?
    var updateTime: String?
    var formats: FormatsType?
    var thumbnail: ContentUrl?
    var license: String?
    var visibility: String?
    var isCurated: Bool?
    var presentationParams: PresentationParams?
    
    convenience init(name: String?,
                     displayName: String?,
                     authorName: String?,
                     createTime: String?,
                     updateTime: String?,
                     formats: FormatsType?,
                     thumbnail: ContentUrl?,
                     license: String?,
                     visibility: String?,
                     isCurated: Bool?,
                     presentationParams: PresentationParams?) {
        self.init()
        self.name = name
        self.displayName = authorName
        self.createTime = createTime
        self.authorName = authorName
        self.formats = formats
        self.thumbnail = thumbnail
        self.license = license
        self.visibility = visibility
        self.isCurated = isCurated
        self.presentationParams = presentationParams
    }
}

class FormatsType {
    var root: ContentUrl?
    var resource: [ContentUrl]?
    var formatComplexity: FormatComplexity?
    var formatType: String?
    
}
class FormatComplexity {
    var triangleCount: String?
}
class ContentUrl {
    var relativePath: String?
    var url: String?
    var contentType: String?
}

class PresentationParams {
    
    var orientingRotation: OrientingRotation?
    var colorSpace: String?
    var backgroundColor: String?
}
class OrientingRotation {
    var w: Int?
}
