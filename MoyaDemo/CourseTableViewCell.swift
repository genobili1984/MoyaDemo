//
//  CourseTableViewCell.swift
//  MoyaDemo
//
//  Created by mao on 1/23/18.
//  Copyright © 2018 sungrow. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CourseTableViewCell: UITableViewCell {
    
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    
    var disposeBag: DisposeBag?
    
//    var course : YoutubeCourse?  {
//        didSet {
//            guard let course = course  else {
//                return
//            }
//
//            self.label1.text = course.name
//            self.label2.text = course.url
//
//        }
//    }
    
    var courseModel : YoutubeCourseViewModel?   {
        didSet   {
            let disposeBag = DisposeBag()
            
            guard let courseModel = courseModel else {
                return
            }
            
            courseModel.title.map( Optional.init )
            .drive( self.label1.rx.text )
            .disposed(by: disposeBag)
            
            courseModel.imageUrl.map( Optional.init )
            .drive( self.label2.rx.text )
            .disposed(by: disposeBag)
            
            self.label1.text = courseModel.courseResult.name
            
            self.disposeBag = disposeBag
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        self.courseModel = nil
        self.disposeBag = nil
    }
    
}
