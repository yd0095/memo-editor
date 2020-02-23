//
//  CollectionViewController+extension.swift
//  editor
//
//  Created by iamport on 24/02/2020.
//  Copyright © 2020 iamport. All rights reserved.
//

import UIKit

extension CollectionViewController {
    
    func settingGestureAction() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(gesture(_:)))
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        tap.delegate = self
        collectionView?.addGestureRecognizer(tap)
        
    }
    
    func settingEditBtn() {
        self.editBtn.backgroundColor = .white
        self.editBtn.addTarget(self, action: #selector(btnFloatingButtonTapped(floatingButton:)), for: .touchUpInside)
        self.editBtn.frame = CGRect(x: 10 ,y: 10, width: 48, height: 48)
        self.view.addSubview(editBtn)
        
    }
    
    
    
}


//MARK: - CollectionView Delegate Methods

extension CollectionViewController : UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.width/2.5, height: self.collectionView.frame.width/2)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return modelController.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! CustomCell
        
        cell.image.image = modelController.images[indexPath.row]
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if buttonSwitch == true {
            modelController.deleteImageObject(imageIndex: indexPath.row, whichRow2: self.whichRow)
            collectionView.reloadData()
            
        }
    }
}
//MARK: - Cell touch를 위한 gesture recognizer
extension CollectionViewController : UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let point = touch.location(in: collectionView)
        if let indexPath = collectionView?.indexPathForItem(at: point),
            let cell = collectionView?.cellForItem(at: indexPath) {
            return touch.location(in: cell).y > 50
        }
        
        return false
    }
    
}
