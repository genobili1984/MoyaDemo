//
//  YoutubeCourseViewModel.swift
//  MoyaDemo
//
//  Created by mao on 1/23/18.
//  Copyright © 2018 sungrow. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa


class YoutubeCourseViewModel  {
    let courseResult :  YoutubeCourse

    var title : Driver<String>
    var imageUrl: Driver<String>

    init( course: YoutubeCourse )  {
        self.courseResult = course

        //self.title = PublishRelay<String>().asDriver(onErrorJustReturn: "")
        //self.imageUrl = PublishRelay<String>().asDriver(onErrorJustReturn: "")
        //这里如果没有根据异步获取的逻辑， 不需要在再创建序列了， 这么写只是测试代码
        self.title = Variable<String>( course.name ?? "" ).asDriver()
        self.imageUrl = Variable<String>( course.link ?? "").asDriver()
        
        
    }
 }

