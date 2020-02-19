//
//  ViewController.swift
//  editor
//
//  Created by iamport on 12/02/2020.
//  Copyright © 2020 iamport. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    var app: [NSManagedObject] = []

    var titleTmpInViewController: String = ""
    
    var whichRow = -1
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "AppData")
        do {
          app = try managedContext.fetch(fetchRequest)
          self.tableView.reloadData()
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    
    
    @IBAction func addBtn(_ sender: UIBarButtonItem) {

        let alertController = UIAlertController(title: "title", message: "제목입력 ", preferredStyle: .alert)
               alertController.addTextField(configurationHandler: {
               (textField) in textField.placeholder = "제목 입력 "
               })
               
        //확인 했을 때 다음으로 넘어가는 Action 추가 TODO
               let confirmAction = UIAlertAction(title: "확인", style: .default){
                   _ in
                   let textField = alertController.textFields![0]
                   if let newName = textField.text, !newName.isEmpty {
                        self.titleTmpInViewController = newName
                        self.performSegue(withIdentifier: "ToTextView", sender: self)
                
                   }
               }
               let cancelAction = UIAlertAction(title:"취소",style: .cancel){
                   _ in
               }
               alertController.addAction(confirmAction)
               alertController.addAction(cancelAction)
               
               self.present(alertController, animated: true, completion: nil)
    }
    @IBAction func delBtn(_ sender: UIBarButtonItem) {
        
        if tableView.isEditing {
            sender.title = "Edit"
            tableView.setEditing(false, animated: true)
        } else {
            sender.title = "Done"
            tableView.setEditing(true, animated: true)
        }
    }
    
}

extension ViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return app.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       // let appDataCnt = app.count - indexPath.row - 1
        //let appData = app[appDataCnt]
        let appData = app[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableCell
        
        cell.title.text = appData.value(forKey: "title") as? String
        cell.contents.text = appData.value(forKey: "content") as? String
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let managedContext = appDelegate.persistentContainer.viewContext
            managedContext.delete(app[indexPath.row])
            app.remove(at: indexPath.row)
            do {
                try managedContext.save()
            } catch _ {
            }
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        whichRow = indexPath.row
        self.performSegue(withIdentifier: "ToTextView2", sender: self)
    }
    
}
extension ViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "ToTextView" {
                guard let toText = segue.destination as? TextViewController else { return }
                toText.titleTmp = titleTmpInViewController
            }
            else if segue.identifier == "ToTextView2" {
                guard let toText = segue.destination as? TextViewController else { return }
                toText.whichRow = self.whichRow
                self.whichRow = -1
            }
        }
        
}

