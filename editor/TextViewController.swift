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
    
    var whichRow : Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentField.layer.borderWidth = 1.0
        contentField.layer.borderColor = UIColor.black.cgColor
        contentField.layer.cornerRadius = 10
        contentField.backgroundColor = .white
        
        
        
        //fetch
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "AppData")
        do {
          app = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        if whichRow == -1 {
            titleField.text = titleTmp
        } else {
            let appData = app[whichRow]
            titleField.text = appData.value(forKey: "title") as? String
            contentField.text = appData.value(forKey: "content") as? String
        }
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

        do {
            if whichRow == -1 {
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
                let managedContext = appDelegate.persistentContainer.viewContext
                let entity = NSEntityDescription.entity(forEntityName: "AppData", in: managedContext)
                let appData = NSManagedObject(entity: entity!, insertInto: managedContext)
                appData.setValue(title, forKey: "title")
                appData.setValue(content, forKey: "content")
                
                try managedContext.save()
            }
            else {
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
                let managedContext = appDelegate.persistentContainer.viewContext
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AppData")
         
                do {
                    let results = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
                    
                    if results?.count != 0 {
                        results![whichRow].setValue(title, forKey: "title")
                        results![whichRow].setValue(content, forKey: "content")
                    }
                    whichRow = -1
                }
            
            }
        } catch let error as NSError {
            print("Not Saved. \(error)")
        }
    }
    @IBAction func CameraPopView(_ sender: UIBarButtonItem) {
        
        //add option TODO
        let message = NSLocalizedString("Type of Ticket", comment: "Title for the action sheet asking for the type of ticket")
        
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Open Camera", style: .default) { [unowned self] _ in
            //self.performSegue(withIdentifier: .CreateNewTicket, sender: LottoType.powerball.rawValue)
        })
        
        alert.addAction(UIAlertAction(title: "Open My Album", style: .default) { [unowned self] _ in
          //  self.performSegue(withIdentifier: .CreateNewTicket, sender: LottoType.megaMillions.rawValue)
            })
        
        alert.addAction(UIAlertAction(title: "Open URL", style: .default) { [unowned self] _ in
          //  self.performSegue(withIdentifier: .CreateNewTicket, sender: LottoType.luckyForLife.rawValue)
            })
        alert.addAction(UIAlertAction(title: "cancel", style: .cancel ) {
            _ in
        })

        alert.popoverPresentationController?.barButtonItem = sender
        
        present(alert, animated: true, completion: nil)
    }
    
}
