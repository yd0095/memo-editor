//
//  ViewController.swift
//  editor
//
//  Created by iamport on 12/02/2020.
//  Copyright © 2020 iamport. All rights reserved.
//

import UIKit
import CoreData

class MainPageViewController: UIViewController {
    
    //Data except Image
    var app: [NSManagedObject] = []

    var titleTmpInViewController: String = ""
    
    //Image Data
    let modelController = ModelController()
    
    //whichRow는 Segue 변경 시 함께 움직이며 모든 viewcontroller가 같은 값을 공유한다.
    var whichRow = -1
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        
        //AppData entity fetch
        fetch()
        //Image entity fetch
        for i in 0 ..< whichRow {
            modelController.fetchImageObjects(whichRow2: i)
        }
        
        tableView.reloadData()
    }

    //테이블의 add 버튼
    @IBAction func addBtn(_ sender: UIBarButtonItem) {
        alertAddAction()
    }
    //테이블의 delete 버튼
    @IBAction func delBtn(_ sender: UIBarButtonItem) {
        setEditingMode(sender: sender)
       
    }
    
}





