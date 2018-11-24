//
//  ViewController.swift
//  Todoey
//
//  Created by Mac on 11/14/18.
//  Copyright © 2018 aziKrazy. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    var itemArray = [TodoItem]()
    var selectedCategory : Category? {
        didSet {
            loadData()
        }
    }
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  
    override func viewDidLoad() {
        super.viewDidLoad()
       
//        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
    }

    //MARK - TABleView Datasource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "toDoItemCell", for: indexPath)
        let item  = itemArray[indexPath.row];

        cell.textLabel?.text = item.todo
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
            let newItem = TodoItem(context: self.context)
            newItem.todo = TextField.text!
            newItem.isDone = false
            newItem.parentCategory = self.selectedCategory
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
        do{
           try context.save()
        } catch{
        print("error saving context \(error)")
            
        }
        
    }
    
    //LOad persisted data

    func loadData (with request: NSFetchRequest<TodoItem> = TodoItem.fetchRequest(), predicate:NSPredicate? =  nil) {
        let categoryPredicate  = NSPredicate(format: "parentCategory.name MATCHES %@ ", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        

        do {
           itemArray =  try context.fetch(request)
        }
        catch{
            print("error occured in fetching request from database \(error)")
        }
        
        tableView.reloadData()

    }

}

//MARK Search bar Methods


extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print(searchBar.text!)
        let request : NSFetchRequest<TodoItem> = TodoItem.fetchRequest()
        let predicate = NSPredicate(format: "todo CONTAINS[cd] %@" , searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "todo", ascending: true)]
        loadData(with: request, predicate: predicate)
    
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadData()
            
            DispatchQueue.main.async {
            searchBar.resignFirstResponder()
            }
            
        }
    }
}


