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
    
    //추후 db에서 받아와야함.
    //label을 text field로 바꿔야 할듯?
    //TODO
    var cellTitle = ["title1","title2","title3"]
    var cellContents = ["a","b","c"]
    var cellImage = ["1.jpeg","2.jpeg","3.jpeg"]
    
    var text: [NSManagedObject] = []
    
    var titleTmpInViewController: String = ""
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        
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
                        self.cellTitle.insert(newName, at: 0)
                        let indexPath = IndexPath(row: 0, section: 0)
                        self.tableView.insertRows(at: [indexPath], with: .automatic)
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
        return cellTitle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableCell
        //추후 존재하지 않는 조건부로 변경 TODO
        if indexPath.row < 3 {
            cell.cellImage.image = UIImage(named: cellImage[indexPath.row])
            cell.title.text = cellTitle[indexPath.row]
            cell.contents.text = cellContents[indexPath.row]
        }
        else {
            cell.cellImage.image = UIImage(named: cellImage[0])
            cell.title.text = cellTitle[indexPath.row]
            cell.contents.text = cellContents[0]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            //다른 항목 지우는 조건부추가 TODO
            cellTitle.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableCell
//        //내가 선택한 cell이 몇번째인지!! 처리할것 TODO
//        let indexPath = tableView.indexPath(for: cell)
        
        
        self.performSegue(withIdentifier: "ToTextView", sender: self)
    }
    
}
extension ViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToTextView" {
            guard let toText = segue.destination as? TextViewController else { return }
            toText.titleTmp = titleTmpInViewController
        }
    }
    
}

