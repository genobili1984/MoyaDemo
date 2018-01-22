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
}
