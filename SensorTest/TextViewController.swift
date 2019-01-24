//
//  TextViewController.swift
//  SensorTest
//
//  Created by 杨键 on 2018/4/29.
//  Copyright © 2018年 mclarenYang. All rights reserved.
//

import UIKit

class TextViewController: UIViewController {
    
    var dataText = ""
    var dataTitle = ""

    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var DataTextView: UITextView!
    
    @IBAction func BackBtnClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TitleLabel.text = dataTitle
        DataTextView.text = dataText
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

}
