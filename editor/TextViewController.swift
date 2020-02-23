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
        
        contentField.layer.borderWidth = 1.0
        contentField.layer.borderColor = UIColor.black.cgColor
        contentField.layer.cornerRadius = 10
        contentField.backgroundColor = .white
    
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(btnFloatingButtonTapped(floatingButton:)), for: .touchUpInside)
        button.frame = CGRect(x: 30 ,y: view.frame.height * 0.9, width: 48, height: 48)
        self.view.addSubview(button)
        
        
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
    @objc func btnFloatingButtonTapped(floatingButton: MDCFloatingButton){
        floatingButton.collapse(true) {
            floatingButton.expand(true, completion: nil)
        }
        performSegue(withIdentifier: "popover", sender: floatingButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        if whichRow == app.count {
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
            if whichRow == app.count {
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
    
    
}
extension TextViewController : UIPopoverPresentationControllerDelegate {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           if segue.identifier == "popover" {
               let popoverViewController = segue.destination as! CollectionViewController
               popoverViewController.preferredContentSize = CGSize(width: self.view.frame.width * 0.9, height: self.view.frame.height * 0.2)
               popoverViewController.whichRow = self.whichRow
               popoverViewController.popoverPresentationController?.delegate = self
           }

       }
       func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
              return UIModalPresentationStyle.none
          }
    
    
}
extension TextViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBAction func CameraPopView(_ sender: UIBarButtonItem) {
        
        //add option TODO
        let message = NSLocalizedString("이미지 불러오기", comment: "어디서 이미지를 불러올 건가요?")
        
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Open Camera", style: .default) { [unowned self] _ in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.flagImageSave = true
                self.imagePicker.delegate = self
                self.imagePicker.sourceType = .camera
                self.imagePicker.mediaTypes = [kUTTypeImage as String]
                self.imagePicker.allowsEditing = false
                
                self.present(self.imagePicker, animated: true, completion: nil)
                
            }
            
        })
        
        alert.addAction(UIAlertAction(title: "Open My Album", style: .default) { [unowned self] _ in
              if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                self.flagImageSave = false
                  
                self.imagePicker.delegate = self
                self.imagePicker.sourceType = .photoLibrary
                self.imagePicker.mediaTypes = [kUTTypeImage as String]
                self.imagePicker.allowsEditing = true
                  
                self.present(self.imagePicker, animated: true, completion: nil)
              }
            
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
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let mediaType = info[UIImagePickerController.InfoKey.mediaType] as! NSString
        print(mediaType)
        
        if mediaType.isEqual(to: kUTTypeImage as NSString as String) {
            captureImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            
            if flagImageSave {
                UIImageWriteToSavedPhotosAlbum(captureImage, self, nil, nil)
            }
            
            //todo 이걸 coredata로 저장
            modelController.saveImageObject(image: self.captureImage,whichRow: self.whichRow)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
}
