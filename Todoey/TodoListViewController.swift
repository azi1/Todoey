//
//  ViewController.swift
//  Todoey
//
//  Created by Mac on 11/14/18.
//  Copyright © 2018 aziKrazy. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    var itemArray = ["buy eggs", "find Zohaib", "Cook"]
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if let items = defaults.array(forKey: "toDoListArray") as? [String] {
            itemArray = items
        }
    }

    //MARK - TABleView Datasource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "toDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
       
        return cell
    
    }
    
    //MARK - TABLEView DELEGATES
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
  
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark
        {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
                 tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK add item
    
    
    @IBAction func AddItems(_ sender: UIBarButtonItem) {
        var TextField = UITextField()
        
        let alert  = UIAlertController(title: "Add Todo Item", message: "", preferredStyle: .alert)
        
        let action  = UIAlertAction(title: "Add Item", style: .default) { (action) in
            print("success");
            self.itemArray.append(TextField.text!)
            self.defaults.set(self.itemArray, forKey: "toDoListArray")
            self.tableView.reloadData()
            
        
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        alert.addAction(action)
        alert.addAction(cancelAction)
        
        
        alert.addTextField { (UITextField) in
            UITextField.placeholder = "Add item"
            TextField = UITextField
            
        }
        present(alert, animated: true,completion: nil)
    
    
    }
    
    
}

