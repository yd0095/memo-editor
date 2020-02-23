//
//  CollectionViewController.swift
//  editor
//
//  Created by iamport on 21/02/2020.
//  Copyright © 2020 iamport. All rights reserved.
//

import UIKit
import CoreData

class CollectionViewController: UIViewController , UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    //DataBase CoreData
    //static let shared = ModelController()

    let entityName = "AppData"

    private var savedObjects = [NSManagedObject]()
    private var images = [UIImage]()
    private var managedContext: NSManagedObjectContext!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

}

extension CollectionViewController : UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.width/2.5, height: self.collectionView.frame.width/2)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! CustomCell
        
        cell.image.image = UIImage(named: "1.jpeg")
        
        return cell
    }
}


class CustomCell : UICollectionViewCell {
    @IBOutlet weak var image: UIImageView!
 
}
