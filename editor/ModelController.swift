//
//  ModelController.swift
//  editor
//
//  Created by iamport on 23/02/2020.
//  Copyright © 2020 iamport. All rights reserved.
//

import UIKit
import CoreData

class ModelController {
    
    static let shared = ModelController()

    let entityName = "AppData"

    public var savedObjects = [NSManagedObject]()
    public var images = [UIImage]()
    public var managedContext: NSManagedObjectContext!
    
    init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        managedContext = appDelegate.persistentContainer.viewContext
        
        fetchImageObjects()
    }
    
    func fetchImageObjects() {
        let imageObjectRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        
        do {
            savedObjects = try managedContext.fetch(imageObjectRequest)
            
            images.removeAll()
            
            for imageObject in savedObjects {
                let savedImageObject = imageObject as! AppData
                
                guard savedImageObject.imageName != nil else { return }
                
                let storedImage = ImageController.shared.fetchImage(imageName: savedImageObject.imageName!)
                
                if let storedImage = storedImage {
                    images.append(storedImage)
                }
            }
        } catch let error as NSError {
            print("Could not return image objects: \(error)")
        }
    }
    
    func saveImageObject(image: UIImage , whichRow: Int) {
        let imageName = ImageController.shared.saveImage(image: image)
        
        if let imageName = imageName {
//                   guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
//                   let managedContext = appDelegate.persistentContainer.viewContext
                   let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AppData")
            
                   do {
                       let results = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
                       
                       if results?.count != 0 {
                           results![whichRow].setValue(imageName, forKey: "imageName")
                        }
                   } catch let error as NSError {
                       print("Not Saved. \(error)")
                   }
            
            do {
                try managedContext.save()
                
                images.append(image)
                
                print("\(imageName) was saved in new object.")
            } catch let error as NSError {
                print("Could not save new image object: \(error)")
            }
        }
    }
    
    func deleteImageObject(imageIndex: Int) {
        guard images.indices.contains(imageIndex) && savedObjects.indices.contains(imageIndex) else { return }
        
        let imageObjectToDelete = savedObjects[imageIndex] as! AppData
        let imageName = imageObjectToDelete.imageName
        
        do {
            managedContext.delete(imageObjectToDelete)
            
            try managedContext.save()
            
            if let imageName = imageName {
                ImageController.shared.deleteImage(imageName: imageName)
            }
            
            savedObjects.remove(at: imageIndex)
            images.remove(at: imageIndex)
            
            print("Image object was deleted.")
        } catch let error as NSError {
            print("Could not delete image object: \(error)")
        }
    }
    
}

