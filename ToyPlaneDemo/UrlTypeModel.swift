//
//  UrlTypeModel.swift
//  ToyPlaneDemo
//
//  Created by BHSoft on 24/08/2022.
//

import Foundation

class UrlTypeModel: NSObject, JsonInitObject {
    var name: String?
    var displayName: String?
    var authorName: String?
    var createTime: String?
    var updateTime: String?
    var formats: [FormatsType]?
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
                     formats: [FormatsType]?,
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
    
    convenience required init(json: [String : Any]) {
        self.init()
        for (key, value) in json {
            if key == "name", let wrapValue = value as? String {
                let jsonValue = wrapValue
                self.name = jsonValue
            }
            if key == "displayName", let wrapValue = value as? String {
                let jsonValue = wrapValue
                self.displayName = jsonValue
            }
            if key == "createTime", let wrapValue = value as? String {
                let jsonValue = wrapValue
                self.createTime = jsonValue
            }
            if key == "updateTime", let wrapValue = value as? String {
                let jsonValue = wrapValue
                self.updateTime = jsonValue
            }
            if key == "authorName", let wrapValue = value as? String {
                let jsonValue = wrapValue
                self.authorName = jsonValue
            }
            if key == "formats", let wrapValue = value as? [[String : Any]] {
                let jsonValue = wrapValue.map({FormatsType.init(json: $0)})
                self.formats = jsonValue
            }
            if key == "thumbnail", let wrapValue = value as? [String : Any] {
                let jsonValue = ContentUrl.init(json: wrapValue)
                self.thumbnail = jsonValue
            }
            if key == "license", let wrapValue = value as? String {
                let jsonValue = wrapValue
                self.license = jsonValue
            }
            if key == "visibility", let wrapValue = value as? String {
                let jsonValue = wrapValue
                self.visibility = jsonValue
            }
            if key == "isCurated", let wrapValue = value as? Bool {
                let jsonValue = wrapValue
                self.isCurated = jsonValue
            }
            if key == "presentationParams", let wrapValue = value as? PresentationParams {
                let jsonValue = wrapValue
                self.presentationParams = jsonValue
            }
        }
    }
    
    
}

class FormatsType: NSObject, JsonInitObject {
    
    
    var root: ContentUrl?
    var resources: [ContentUrl]?
    var formatComplexity: FormatComplexity?
    var formatType: String?
    
    convenience init(root: ContentUrl?,
                     resources: [ContentUrl]?,
                     formatComplexity: FormatComplexity?,
                     formatType: String?) {
        self.init()
        self.root = root
        self.resources = resources
        self.formatType = formatType
        self.formatComplexity = formatComplexity
    }
    
    convenience required init(json: [String : Any]) {
        self.init()
        for (key, value) in json {
            if key == "root", let wrapValue = value as? [String : Any] {
                let jsonValue = ContentUrl.init(json: wrapValue)
                self.root = jsonValue
            }
            if key == "resources", let wrapValue = value as? [[String : Any]] {
                let jsonValue = wrapValue.map({ContentUrl(json: $0)})
                self.resources = jsonValue
            }
            if key == "formatType", let wrapValue = value as? String {
                let jsonValue = wrapValue
                self.formatType = jsonValue
            }
            if key == "formatComplexity", let wrapValue = value as? [String : Any] {
                let jsonValue = FormatComplexity.init(json: wrapValue)
                self.formatComplexity = jsonValue
            }
        }
    }
    
}
class FormatComplexity: NSObject, JsonInitObject {
    var triangleCount: String?
    convenience init(triangleCount: String?) {
        self.init()
        self.triangleCount = triangleCount
    }
    convenience required init(json: [String : Any]) {
        self.init()
        for(key, value) in json {
            if key == "triangleCount", let wrapValue = value as? String {
                let jsonValue = wrapValue
                self.triangleCount = jsonValue
            }
        }
    }
}
class ContentUrl: NSObject, JsonInitObject {
    var relativePath: String?
    var url: String?
    var contentType: String?
    
    convenience init(relativePath: String?, url: String?, contentType: String?) {
        self.init()
        self.relativePath = relativePath
        self.url = url
        self.contentType = contentType
    }
    convenience required init(json: [String : Any]) {
        self.init()
        for(key, value) in json {
            if key == "relativePath", let wrapValue = value as? String {
                let jsonValue = wrapValue
                self.relativePath = jsonValue
            }
            if key == "url", let wrapValue = value as? String {
                let jsonValue = wrapValue
                self.url = jsonValue
            }
            if key == "contentType", let wrapValue = value as? String {
                let jsonValue = wrapValue
                self.contentType = jsonValue
            }
        }
    }
}

class PresentationParams: NSObject, JsonInitObject {
    
    var orientingRotation: OrientingRotation?
    var colorSpace: String?
    var backgroundColor: String?
    
    convenience init(orientingRotation: OrientingRotation?, colorSpace: String?, backgroundColor: String?) {
        self.init()
        self.orientingRotation = orientingRotation
        self.colorSpace = colorSpace
        self.backgroundColor = backgroundColor
    }
    convenience required init(json: [String : Any]) {
        self.init()
        for(key, value) in json {
            if key == "orientingRotation", let wrapValue = value as? [String : Any] {
                let jsonValue = OrientingRotation.init(json: wrapValue)
                self.orientingRotation = jsonValue
            }
            if key == "colorSpace", let wrapValue = value as? String {
                let jsonValue = wrapValue
                self.colorSpace = jsonValue
            }
            if key == "backgroundColor", let wrapValue = value as? String {
                let jsonValue = wrapValue
                self.backgroundColor = jsonValue
            }
        }
    }
}
class OrientingRotation: NSObject, JsonInitObject {
    var w: Int?
    
    convenience init(w: Int?) {
        self.init()
        self.w = w
    }
    convenience required init(json: [String : Any]) {
        self.init()
        for(key, value) in json {
            if key == "w", let wrapValue = value as? Int {
                let jsonValue = wrapValue
                self.w = jsonValue
            }
        }
    }
}
