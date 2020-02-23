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

    let entityName = "Image"

    public var savedObjects = [NSManagedObject]()
    public var images = [UIImage]()
    public var managedContext: NSManagedObjectContext!
    
    init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        managedContext = appDelegate.persistentContainer.viewContext
        //fetchImageObjects()
    }
    
    func fetchImageObjects(whichRow2: Int) {
        let imageObjectRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        
        do {
            savedObjects = try managedContext.fetch(imageObjectRequest)
            
            images.removeAll()
            
            // name = name1&name2&name3

            if savedObjects.count == 0 {
                return
            }
            if whichRow2 == savedObjects.count {
                return
            }
            if savedObjects[whichRow2].value(forKey: "imageName") == nil {
                return
            }
            guard let name = savedObjects[whichRow2].value(forKey: "imageName") as! String? else {return}
            
            let nameList = name.components(separatedBy: "&")
            
            for imageObject in nameList {

                let storedImage = ImageController.shared.fetchImage(imageName: imageObject)
                
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
                   let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Image")
            
                   do {
                       let results = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
                       if results?.count != 0 {
                        if whichRow != results?.count{
                            var nameTmp = results![whichRow].value(forKey: "imageName") as! String
                            nameTmp += "&"
                            nameTmp += imageName
                            results![whichRow].setValue(nameTmp, forKey: "imageName")
                        } else {
                            let coreDataEntity = NSEntityDescription.entity(forEntityName: entityName, in: managedContext)
                            let newImageEntity = NSManagedObject(entity: coreDataEntity!, insertInto: managedContext) as! Image
                            
                            newImageEntity.imageName = imageName
                        }
                       } else {
                        let coreDataEntity = NSEntityDescription.entity(forEntityName: entityName, in: managedContext)
                        let newImageEntity = NSManagedObject(entity: coreDataEntity!, insertInto: managedContext) as! Image
                        
                        newImageEntity.imageName = imageName
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
        
        let imageObjectToDelete = savedObjects[imageIndex] as! Image
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

