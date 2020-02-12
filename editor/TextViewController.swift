//
//  TextViewController.swift
//  editor
//
//  Created by iamport on 12/02/2020.
//  Copyright © 2020 iamport. All rights reserved.
//

import UIKit

class TextViewController : UIViewController {
    @IBAction func backBtn(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "title", message: "저장하시겠습니까?", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .default){
                        _ in
            //TODO 확인 시 저장할것..
                        self.performSegue(withIdentifier: "ToList", sender: self)
                   }
        let cancelAction = UIAlertAction(title:"취소",style: .cancel){
            _ in
            self.performSegue(withIdentifier: "ToList", sender: self)
        }
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        alertController.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func saveBtn(_ sender: UIBarButtonItem) {
        //TODO 저장기능
    }
    
    
    
    
    
    
    
    
    
}
