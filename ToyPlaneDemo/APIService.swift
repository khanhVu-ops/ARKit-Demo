//
//  APIService.swift
//  ToyPlaneDemo
//
//  Created by BHSoft on 25/08/2022.
//

import Foundation
import Alamofire

protocol JsonInitObject: NSObject {
    init(json: [String : Any])
}

final class APIService {
    static let polyApiKey = "AIzaSyDP06_ZC4j0Nyj6I9VcsIJUrijpg0cLQtQ"
    static let polyBaseUrl = "https://poly.googleapis.com/v1/"

   
    static func requestDataModel(assetId: String, completionHandler: ((UrlTypeModel?, APIError?) -> Void)?) {
        guard let url = URL(string: "\(polyBaseUrl)\(assetId)?key=\(polyApiKey)") else{
            return
        }
        print(url)
        jsonResponseObject(url: url, method: .get, headers: [:], completionHandler: completionHandler)
    }

    //MARK: BASE
    
    static private func jsonResponseObject<T: JsonInitObject>(url: URL, method: HTTPMethod, headers: HTTPHeaders, completionHandler: ((T?, APIError?) -> Void)?) {
        
        jsonResponse(url: url, isPublicAPI: false, method: method, headers: headers) { response in
            
            switch response.result {
            case .success(let value):
               
                guard let responseDict = value as? [String: Any] else {
                          completionHandler?(nil, .resposeFormatError)
                          return
                      }
                
                let obj = T(json: responseDict)
                
                completionHandler?(obj, nil)
                
            case .failure(let error):
                completionHandler?(nil, .unowned(error))
            }
        }
    }
    
    
    
    static private func jsonResponse(url: URL,
                                     isPublicAPI: Bool,
                                     method: HTTPMethod,
                                     parameters: Parameters? = nil,
                                     encoding: ParameterEncoding = JSONEncoding.default,
                                     headers: HTTPHeaders = [:],
                                     completionHandler: ((DataResponse<Any>) -> Void)?) {
        
        
        Alamofire.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers)
            .responseJSON { response in
                
              
                
                switch response.result {
                case .success(_): break
                case .failure(_):
                    break
                }
                
                completionHandler?(response)
            }
    }
}


extension APIService {
    enum APIError: Error {
        //        case loginFail
        //        case signUpFail
        case resposeFormatError
        case serverError(Int?, String?)
        case unowned(Error)
    }
}
