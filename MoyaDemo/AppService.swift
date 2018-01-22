//
//  OnekeyService.swift
//  operation4ios
//
//  Created by sungrow on 2017/2/17.
//  Copyright © 2017年 阳光电源股份有限公司. All rights reserved.
//

import Foundation
import Moya
import Alamofire

enum AppService: TargetType {
    case login(username: String, pwd: String)
    case video
}

extension AppService {
    var baseURL: URL {
        return URL(string: API_PRO)!
    }
    
    var path: String {
        switch self {
        case .login(username: _, pwd: _):
            return "/login"
        case .video:
            return "/video"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .login(username: _, pwd: _):
            return .get
        case .video:
            return .post
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .login(username: let username, pwd: let pwd):
            return ["username": username, "pwd": pwd]
        case .video:
            return ["type": "JSON"]
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }
    
    
    var sampleData: Data {
        var str:String = ""
        switch self {
        case .login:
            str = "{\"success\":\"success\", \"error\":\"no\"}"
        default:
            break
        }
        return str.data(using: String.Encoding.utf8)!
    }
    
    var validate : Bool {
        return true
    }
    
    var task: Task {
        return .requestPlain
    }
    
    var headers: [String: String]? {
        return nil
    }
}

private let endPointClosure = { (target: AppService) -> Endpoint<AppService> in
//    //添加默认的http头
//    let defaultEndpoint = MoyaProvider<AppService>.defaultEndpointMapping(for: target)
//    return defaultEndpoint.adding( newHTTPHeaderFields:headerFields )
    
    
//  用本地数据 模拟http数据返回, 必须要设置 stubClosure参数为 immediatelyStub, 否则不起作用
   let url = URL(target: target).absoluteString
   var endpoint:Endpoint<AppService>?
    switch target {
    case .login:
        endpoint = Endpoint( url: url, sampleResponseClosure: {.networkResponse(200, target.sampleData)}, method: target.method, task: target.task, httpHeaderFields: nil)
    default:
        endpoint = MoyaProvider<AppService>.defaultEndpointMapping(for: target)
    }
    return endpoint!
}

private let requestClosure  = { (endpoint: Endpoint<AppService>, done: @escaping MoyaProvider.RequestResultClosure)  in
    do {
        var request:URLRequest  = try endpoint.urlRequest()
        //request.httpShouldHandleCookies = false //禁用cookie
        done( .success( request ) )
    }catch {
        done( .failure( MoyaError.underlying( error, nil ) ))
    }
}


let policies : [String:ServerTrustPolicy] = [
    "example.com" : .pinPublicKeys(
        publicKeys: ServerTrustPolicy.publicKeys(),
        validateCertificateChain:true,
        validateHost: true
    )
]

//private let alamoreManager = Manager(configuration: URLSessionConfiguration.default,  serverTrustPolicyManager: ServerTrustPolicyManager( policies: policies))


//public final class  NetworkActivityPlugin :  PluginType  {
//    public typealias NetworkActivityClosure = (_ change: NetworkActivityChangeType) -> ()
//    let networkActivityClosure: NetworkActivityClosure
//
//    public init(networkActivityClosure: @escaping NetworkActivityClosure) {
//        self.networkActivityClosure = networkActivityClosure
//    }
//
//    // MARK: Plugin
//
//    /// Called by the provider as soon as the request is about to start
//    public func willSend(request: RequestType, target: TargetType) {
//        networkActivityClosure(.began)
//    }
//
//    /// Called by the provider as soon as a response arrives
//    public func didReceive(data: Data?, statusCode: Int?, response: URLResponse?, error: Error?, target: TargetType) {
//        networkActivityClosure(.ended)
//    }
//}

private let networkActitity = { (chaged:NetworkActivityChangeType, target:TargetType)  in
    switch chaged {
    case .began:
        print( target )
    case .ended:
        print( target )
    }
}

//AccessTokenPlugin,  CredentialsPlugin

let appServiceProvider = MoyaProvider<AppService>(endpointClosure: endPointClosure, requestClosure: requestClosure, /*stubClosure: MoyaProvider.immediatelyStub,*/ plugins:[NetworkLoggerPlugin(verbose: true), NetworkActivityPlugin(networkActivityClosure: networkActitity)])
