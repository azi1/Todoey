//
//  ViewController.swift
//  Todoey
//
//  Created by Mac on 11/14/18.
//  Copyright © 2018 aziKrazy. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    var itemArray = [TodoItem]()
          let dataPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Item.plist")
  
    override func viewDidLoad() {
        super.viewDidLoad()

        loadData()
        
        
        
    }

    //MARK - TABleView Datasource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "toDoItemCell", for: indexPath)
        let item  = itemArray[indexPath.row];

        cell.textLabel?.text = item.Todo
        cell.accessoryType = item.isDone ? .checkmark : .none
        return cell
    
    }
    
    //MARK - TABLEView DELEGATES
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        itemArray[indexPath.row].isDone = !itemArray[indexPath.row].isDone
         self.PersistData()
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK add item
    
    
    @IBAction func AddItems(_ sender: UIBarButtonItem) {
        var TextField = UITextField()
        
        let alert  = UIAlertController(title: "Add Todo Item", message: "", preferredStyle: .alert)
        
        let action  = UIAlertAction(title: "Add Item", style: .default) { (action) in
            print("success");
            let newItem = TodoItem()
            newItem.Todo = TextField.text!
            self.itemArray.append(newItem)
           
            self.PersistData()
           
//            self.defaults.set(self.itemArray, forKey: "toDoListArray")
    
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
    
    // MARK data persist func
    func PersistData() {
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(itemArray)
            try data.write(to: dataPath!)
        } catch{
            print("error saving data")
            
        }
        
    }
    
    //LOad persisted data
    
    func loadData () {
        
        if let data = try? Data(contentsOf: dataPath!) {
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([TodoItem].self, from: data)
            }
            catch{
                print("could not retrive data")
            }
        }
        
    }
    
    
}

