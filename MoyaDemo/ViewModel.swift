//
//  ViewModel.swift
//  MoyaDemo
//
//  Created by sungrow on 2017/2/23.
//  Copyright © 2017年 sungrow. All rights reserved.
//

import Foundation
import RxSwift
import ObjectMapper

func exampleError(_ error: String, location: String = "\(#file):\(#line)") -> NSError {
    return NSError(domain: "ExampleError", code: -1, userInfo: [NSLocalizedDescriptionKey: "\(location): \(error)"])
}

class ViewModel {
    
    func login(username: String, pwd: String) -> Observable<LoginModel> {
        return appServiceProvider.rx.request(.login(username: username, pwd: pwd))
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .asObservable()
            .mapObject(type: LoginModel.self)
            .showAPIErrorToast()
    }
    
    func video() -> Observable<VideoModel> {
        return appServiceProvider.rx.request(.video)
            .asObservable()
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .showAPIErrorToast()
            .mapObject(type: VideoModel.self)
    }
    
    func wikipediaSearch(query:String)  -> Observable<[WikipediaSearchResult]> {
        return appServiceProvider.rx.request(.wikiSearch(query: query))
        .filterSuccessfulStatusCodes()
        .mapJSON()
        .asObservable()
        //.mapJSON
        .map{ json in
            guard let json = json as? [AnyObject] else {
                throw exampleError("Parsing error!")
            }
            return try WikipediaSearchResult.parseJSON(json)
        }
        //.mapArray(type: WikipediaSearchResult.self)
    }
    
    func queryYoutube(page:Int)  ->  Observable<[YoutubeCourse]>  {
        return appServiceProvider.rx.request(.queryYoutube(page: page))
            .asObservable()
            .filterSuccessfulStatusCodes()
        .mapJSON()
        .mapArray(type: YoutubeCourse.self)
    }
}
