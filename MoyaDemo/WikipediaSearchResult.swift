//
//  WikipediaSearchResult.swift
//  MoyaDemo
//
//  Created by mao on 1/22/18.
//  Copyright © 2018 sungrow. All rights reserved.
//

import Foundation
import ObjectMapper


func apiError(_ error: String) -> NSError {
    return NSError(domain: "WikipediaAPI", code: -1, userInfo: [NSLocalizedDescriptionKey: error])
}

public let WikipediaParseError = apiError("Error during parsing")


struct WikipediaSearchResult {
    let title:String
    let description:String?
    let URL:String?
    
    static func parseJSON( _ json:[AnyObject] ) throws -> [WikipediaSearchResult]  {
        let rootArrayTyped:[[AnyObject]] = json.flatMap{
            $0 as? [AnyObject]
        }
        guard rootArrayTyped.count == 3 else {
            throw WikipediaParseError
        }
        
        let (titles, descriptions, urls) = ( rootArrayTyped[0], rootArrayTyped[1], rootArrayTyped[2] )
        
        let titleDescriptionAndUrl : [ ((AnyObject, AnyObject), AnyObject)] = Array(zip( zip(titles, descriptions), urls ))
        return try titleDescriptionAndUrl.map { result -> WikipediaSearchResult in
            let ((title, description), url) = result
            
            guard let titleString = title as? String,
                  let descriptionString = description as? String,
                let urlString = url as? String  else {
                    throw WikipediaParseError
            }
            return WikipediaSearchResult(title: titleString, description: descriptionString, URL: urlString)
        }
        
    }
}


