//
//  TextViewController.swift
//  editor
//
//  Created by iamport on 12/02/2020.
//  Copyright © 2020 iamport. All rights reserved.
//

import UIKit
import CoreData
import MaterialComponents.MaterialButtons
import MobileCoreServices

class TextViewController : UIViewController ,UIScrollViewDelegate {
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var contentField: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet var button: MDCFloatingButton!
    
    //save image
    let modelController = ModelController()
    
    //imagepicker
    let imagePicker: UIImagePickerController! = UIImagePickerController()
    var captureImage: UIImage!
    var flagImageSave = false
    
    var app: [NSManagedObject] = []

    var titleTmp : String = ""
    
    var whichRow : Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //textView의 모양세팅
        textViewSetting()
        
        //set buttonAction
        buttonSetting()
        
        //fetch
        fetch()
        
        
    }
    //버튼의 클릭액션 + segue이동
    @objc func btnFloatingButtonTapped(floatingButton: MDCFloatingButton){
        floatingButton.collapse(true) {
            floatingButton.expand(true, completion: nil)
        }
        //To popover
        performSegue(withIdentifier: "popover", sender: floatingButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        //제목과 저장된 컨텐츠 불러오기
        if whichRow == app.count {
            titleField.text = titleTmp
        } else {
            let appData = app[whichRow]
            titleField.text = appData.value(forKey: "title") as? String
            contentField.text = appData.value(forKey: "content") as? String
        }
    }
    
    @IBAction func backBtn(_ sender: UIBarButtonItem) {
        alertForBackAction()
    }
   
}

