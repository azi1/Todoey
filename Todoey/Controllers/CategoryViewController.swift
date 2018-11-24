//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Mac on 11/19/18.
//  Copyright © 2018 aziKrazy. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
 var CategoryArray = [Category]()
 let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()

    }

    // MARK: - Table view delegate methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return CategoryArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        let category = CategoryArray[indexPath.row]
        
        cell.textLabel?.text = category.name
        return cell
    }
    
    

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        performSegue(withIdentifier: "goToListItem", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let DestinationVC  = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            print(CategoryArray[indexPath.row], indexPath,"CategoryArray");
            DestinationVC.selectedCategory = CategoryArray[indexPath.row]
        }
    }
    //MARK Load data function
    
    func loadData() {
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        do {
            CategoryArray = try context.fetch(request)
            
        } catch {
            print("error fetching categories")
        }
        
    
    }
    
    

    @IBAction func ButtonPressed(_ sender: UIBarButtonItem) {
        var TextField = UITextField()
        
        let alert  = UIAlertController(title: "Add New Category", message:"", preferredStyle: .alert)
        let action  = UIAlertAction(title: "Add", style: .default) { (action) in
        let newCat = Category(context: self.context)
        newCat.name = TextField.text!
        self.CategoryArray.append(newCat)
        self.tableView.reloadData()
        self.PersistData()
        }
        let cancelActon = UIAlertAction(title: "cancel", style: .destructive)
        alert.addAction(action)
        alert.addAction(cancelActon)
        
        alert.addTextField { (UITextField) in
            UITextField.placeholder = "Add Category"
            TextField = UITextField
        }
        
        present(alert,animated: true,completion: nil)
    }
    
    //MARK DATA PERSISTING
    
    func PersistData() {
        do{
            try context.save()
        } catch{
            print("error saving context \(error)")
            
        }
        
    }
    
}
