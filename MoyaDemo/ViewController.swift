//
//  ViewController.swift
//  MoyaDemo
//
//  Created by sungrow on 2017/2/23.
//  Copyright © 2017年 sungrow. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    @IBOutlet weak var emptyView: UIView!
    
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var pageTextField: UITextField!
    @IBOutlet weak var resultTableView: UITableView!
    
    let disposeBag = DisposeBag()
    let viewModel:ViewModel = ViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultTableView.register(UINib(nibName: "CourseTableViewCell", bundle: nil), forCellReuseIdentifier: "CourseTableViewCell")
        
        let results = inputTextField.rx.text.orEmpty
        .asDriver()
        .throttle(0.3)
        .distinctUntilChanged()
        .filter { query in
            query.count > 0
        }
        .flatMapLatest { query in
            self.viewModel.wikipediaSearch(query: query) //.startWith([])
            .asDriver(onErrorJustReturn: [])
        }
        
        results.map {
            $0.count != 0
        }.drive(self.emptyView.rx.isHidden)
        .disposed(by: disposeBag)
        
        
//        let courseResults = pageTextField.rx.text.orEmpty
//            .asDriver()
//            .throttle(0.3)
//            .distinctUntilChanged()
//            .filter{  query in
//                query.count > 0
//        }
//            .map { query in
//                Int(query)
//        }
//            .flatMapLatest { page  in
//                self.viewModel.queryYoutube(page: page ?? 0)
//                    .asDriver(onErrorJustReturn:  [] )
//        }
//
//        courseResults.drive( resultTableView.rx.items(cellIdentifier: "CourseTableViewCell", cellType: CourseTableViewCell.self))  {
//            (_, course, cell) in
//            cell.course = course
//        }
//        .disposed(by: disposeBag)
        
        
            let courseResults = pageTextField.rx.text.orEmpty
                .asDriver()
                .throttle(0.3)
                .distinctUntilChanged()
                .filter{  query in
                    query.count > 0
            }
                .map { query in
                    Int(query)
            }
                .flatMapLatest { page  in
                    self.viewModel.queryYoutube(page: page ?? 0)
                        .asDriver(onErrorJustReturn:  [] )
            }
                .map {  course in
                    course.map( YoutubeCourseViewModel.init )
                    
            }

        
           courseResults.drive( resultTableView.rx.items(cellIdentifier: "CourseTableViewCell", cellType: CourseTableViewCell.self))  {
            (_, model, cell) in
                cell.courseModel  = model
            }
            .disposed(by: disposeBag)
        
        
    }
    
    @IBAction func loginBtnClick(_ sender: Any) {
        viewModel.login(username: "520it", pwd: "520it").subscribe(onNext: { (loginModel) in
            print("---\(loginModel.success ?? "fail ") \(loginModel.error  ?? "")")
        }, onError: { error in
            print( error.localizedDescription )
        }).disposed(by: disposeBag)
    }
    
    
    @IBAction func videosBtnClick(_ sender: Any) {
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

