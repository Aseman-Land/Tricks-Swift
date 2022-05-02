//
//  CodeHighlighterEndpoint.swift
//  Tricks
//
//  Created by Armin on 4/5/22.
//

import Foundation

enum CodeHighlighterEndpoint {
    
    case getHighlighters(token: String)
    
    case getCodeFrames(token: String)
    
    case getProgrammingLanguages(token: String)
}

extension CodeHighlighterEndpoint: Endpoint {
    var path: String {
        switch self {
        case .getHighlighters(_):
            return "/api/v1/highlighters"
        case .getCodeFrames(_):
            return "/api/v1/code-frames"
        case .getProgrammingLanguages(_):
            return "/api/v1/programing-languages"
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var header: [String : String]? {
        switch self {
        case .getHighlighters(let token),
             .getCodeFrames(let token),
             .getProgrammingLanguages(let token):
            return [
                "Authorization": token,
                "Content-Type":"application/json; charset=utf-8",
            ]
        }
    }
    
    var urlParams: [URLQueryItem]? {
        return nil
    }
    
    var body: [String : Any]? {
        return nil
    }
}
