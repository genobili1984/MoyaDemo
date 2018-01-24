//
//  RootViewController.swift
//  MoyaDemo
//
//  Created by mao on 1/24/18.
//  Copyright © 2018 sungrow. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let textView = UITextView()
        textView.frame = CGRect(x: 0, y: 0, width:200, height: 100)
        textView.backgroundColor = .lightGray
        textView.text = "this is the default text to show example!!!!"
        
        view.addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        if #available(iOS 11.0, *) {
            [
                textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                textView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                textView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                textView.heightAnchor.constraint(equalToConstant: 100)
                ].forEach {
                    $0.isActive = true
            }
        } else {
            // Fallback on earlier versions
        }
        
        textView.font = UIFont.preferredFont(forTextStyle: .headline)
        textView.delegate = self
        textView.isScrollEnabled = false
        textViewDidChange(textView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func nextBtnClick(_ sender: Any) {
        let viewController = TestViewController(nibName: "TestViewController", bundle: nil)
        self.navigationController?.pushViewController(viewController, animated: true)
    }

}


extension RootViewController : UITextViewDelegate  {
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: view.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
//        textView.constraints.forEach { (constrait) in
//            if constrait.firstAttribute == .height {
//                constrait.constant = estimatedSize.height
//            }
//        }
        _ = textView.constraints.filter{
            $0.firstAttribute == .height
        }
            .map {
                $0.constant = estimatedSize.height
        }
    }

}
