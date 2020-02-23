//
//  CollectionViewController.swift
//  editor
//
//  Created by iamport on 21/02/2020.
//  Copyright © 2020 iamport. All rights reserved.
//

import UIKit
import CoreData
import MaterialComponents.MaterialButtons

class CollectionViewController: UIViewController , UIPopoverPresentationControllerDelegate{
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var editBtn: MDCFloatingButton!
    
    
    var whichRow = -1
    
    //편집 or 완료 버튼 click event
    var buttonSwitch = false
    
    //core data 변수
    let entityName = "AppData"
    let modelController = ModelController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.delegate = self
        
        //gesture
        settingGestureAction()
        
        //editBtnsetting
        settingEditBtn()
    
    }
    override func viewWillAppear(_ animated: Bool) {
        //imagefetch
        modelController.fetchImageObjects(whichRow2: self.whichRow)
    }
    
    @IBAction func editBtn(_ sender: MDCFloatingButton) {
        if self.buttonSwitch == false {
            self.editBtn.setTitle("완료", for: .normal)
            self.buttonSwitch = true
  
        } else {
            self.editBtn.setTitle("편집", for: .normal)
            self.buttonSwitch = false
            
        }
        
    }
    @IBAction func gesture(_ sender: UITapGestureRecognizer) {
        if self.buttonSwitch == true{
           let point = sender.location(in: collectionView)
           if let indexPath = collectionView?.indexPathForItem(at: point) {
               print(#function, indexPath)
               modelController.deleteImageObject(imageIndex: indexPath.row, whichRow2: self.whichRow)
               modelController.fetchImageObjects(whichRow2: self.whichRow)
               collectionView.reloadData()
           }
        }
       }
    
    @objc func btnFloatingButtonTapped(floatingButton: MDCFloatingButton){
        floatingButton.collapse(true) {
            floatingButton.expand(true, completion: nil)
        }
        
        
    }
  
}





