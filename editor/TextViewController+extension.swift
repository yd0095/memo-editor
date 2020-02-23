//
//  TextViewController+extension.swift
//  editor
//
//  Created by iamport on 24/02/2020.
//  Copyright © 2020 iamport. All rights reserved.
//

import UIKit
import MobileCoreServices
import CoreData

extension TextViewController {
    func textViewSetting() {
        contentField.layer.borderWidth = 1.0
        contentField.layer.borderColor = UIColor.black.cgColor
        contentField.layer.cornerRadius = 10
        contentField.backgroundColor = .white
    }
    
    func buttonSetting() {
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(btnFloatingButtonTapped(floatingButton:)), for: .touchUpInside)
        button.frame = CGRect(x: 30 ,y: view.frame.height * 0.9, width: 48, height: 48)
        self.view.addSubview(button)
    
    }
    func fetch() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "AppData")
        do {
          app = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }
        
    }
    
    
}

//MARK: - popover viewController 설정용 prepare, style

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
//MARK: - Camera Button 눌렀을 시 일어나는 Button Action + ImagePicker

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
               let alertController = UIAlertController(title: "추가", message: "URL입력 ", preferredStyle: .alert)
                alertController.addTextField(configurationHandler: {
                    (textField) in textField.placeholder = "URL 입력 "
                      })
                      
                      let confirmAction = UIAlertAction(title: "확인", style: .default) {
                          _ in
                        do{
                            let textField = alertController.textFields![0]
                            if let urlString = textField.text, !urlString.isEmpty{
                                let url = URL(string: urlString)
                                let data = try Data(contentsOf: url!)
                                self.captureImage = UIImage(data: data)
                                self.modelController.saveImageObject(image: self.captureImage,whichRow: self.whichRow)
                            }
                        } catch {
                            let alertC = UIAlertController(title: "오류", message: "URL오류입니다.", preferredStyle: .alert)
                            let cancelAction = UIAlertAction(title:"취소",style: .cancel){
                                _ in
                            }
                            alertC.addAction(cancelAction)
                            self.present(alertC, animated: true, completion: nil)
                            
                        }
                      }
                      let cancelAction = UIAlertAction(title:"취소",style: .cancel){
                          _ in
                      }
                      alertController.addAction(confirmAction)
                      alertController.addAction(cancelAction)
                      
                      self.present(alertController, animated: true, completion: nil)

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
            captureImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
            
            if flagImageSave {
                UIImageWriteToSavedPhotosAlbum(captureImage, self, nil, nil)
            }
            
            //todo 이걸 coredata로 저장
            modelController.saveImageObject(image: self.captureImage,whichRow: self.whichRow)
        }
        self.dismiss(animated: true, completion: nil)
    }
  
}
//MARK: - AppData entity를 위한 Save

extension TextViewController {
    
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
//MARK: - Back을 눌렀을 시 나오는 alert
extension TextViewController {
    
    func alertForBackAction() {
        
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
    
}
