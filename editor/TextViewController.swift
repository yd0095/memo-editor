//
//  TextViewController.swift
//  editor
//
//  Created by iamport on 12/02/2020.
//  Copyright © 2020 iamport. All rights reserved.
//

import UIKit
import CoreData

class TextViewController : UIViewController {
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var contentField: UITextView!
    
    var app: [NSManagedObject] = []

    var titleTmp : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentField.layer.borderWidth = 1.0
        contentField.layer.borderColor = UIColor.black.cgColor
        contentField.layer.cornerRadius = 10
        contentField.backgroundColor = .white
        titleField.text = titleTmp
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    @IBAction func backBtn(_ sender: UIBarButtonItem) {
        
     let alertController = UIAlertController(title: "title", message: "저장하시겠습니까?", preferredStyle: .alert)
     let confirmAction = UIAlertAction(title: "확인", style: .default){
                     _ in
        guard let titleToSave = self.titleField.text else {return}
        guard let contentToSave = self.contentField.text else {return}
        
        self.save(title: titleToSave, content: contentToSave)
        
        self.navigationController?.popViewController(animated: true)
                }
     let cancelAction = UIAlertAction(title:"취소",style: .cancel){
         _ in
     }
     alertController.addAction(confirmAction)
     alertController.addAction(cancelAction)
     self.present(alertController, animated: true, completion: nil)
        
    }
    
    func save(title: String, content: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "AppData", in: managedContext)
        let appData = NSManagedObject(entity: entity!, insertInto: managedContext)
        appData.setValue(title, forKey: "title")
        appData.setValue(content, forKey: "content")
        
        do {
            try managedContext.save()
            app.append(appData)
            
        } catch let error as NSError {
            print("Not Saved. \(error)")
        }
    }
    
}
