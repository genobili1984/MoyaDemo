//
//  ViewController.swift
//  MoyaDemo
//
//  Created by sungrow on 2017/2/23.
//  Copyright © 2017年 sungrow. All rights reserved.
//

import UIKit
import RxSwift
//import RxCocoa

class ViewController: UIViewController {

    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let viewModel = ViewModel()
        viewModel.login(username: "520it", pwd: "520it").subscribe(onNext: { (loginModel) in
            print("---\(loginModel.success ?? "fail ") \(loginModel.error  ?? "")")
        }, onError: { error in
            print( error.localizedDescription )
        }).disposed(by: disposeBag)
        
        viewModel.video().subscribe(onNext: { (videoModel) in
            guard let videos = videoModel.videos else {
                return
            }
            for video in videos {
                print("----id:\(String(describing: video.id))---length:\(String(describing: video.length))---name:\(String(describing: video.name))---url:\(String(describing: video.url))")
            }
        },  onError: { error in
            print( error.localizedDescription )
        }, onCompleted:{ _ in
            print("end")

        }).disposed(by: disposeBag)
    }
}

