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
    let modelController = ModelController()
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
        fetch()
        for i in 0 ..< whichRow {
            modelController.fetchImageObjects(whichRow2: i)
        }
        tableView.reloadData()
    }

    
    @IBAction func addBtn(_ sender: UIBarButtonItem) {
        alertAddAction()
    }
    @IBAction func delBtn(_ sender: UIBarButtonItem) {
        setEditingMode(sender: sender)
       
    }
    
}





