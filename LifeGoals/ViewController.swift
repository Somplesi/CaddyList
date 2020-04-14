//
//  ViewController.swift
//  LifeGoals
//
//  Created by Rodolphe DUPUY on 09/04/2020.
//  Copyright © 2020 Rodolphe DUPUY. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {

    var itemArray = [ToDoItem]()    // Internal Table sync with CoreData
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    @IBOutlet weak var outlet_TextInput: UITextField!
    
    @IBOutlet weak var outlet_TableView: UITableView!
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add", message: "Please", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default, handler: .none)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("Appel du DidLoad") // Test
        
        //  Delegations
        outlet_TextInput.delegate = self  // protocole UITextFieldDelegate
        outlet_TableView.delegate = self // protocole UITableViewDelegate
        outlet_TableView.dataSource = self // protocole UITableViewDataSource

        // CoreData READ
        loadItems()
    }

    
    //MARK: - These TableView DataSource Methods are mandatories "required" by protocole of UITableViewDataSource (see Help)
    //  Set the internal table itemArray Row Count
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        print("Lignes dispo \(itemArray.count)") // Test
           
        return itemArray.count
       }
    //  Fill the value into TableView from internal table ItemArray called for each line
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell=tableView.dequeueReusableCell(withIdentifier: "uiCellTable", for: indexPath)
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.itemLifeGoals
        cell.accessoryType = item.done ? .checkmark : .none

        print("Ligne chargée: \(item.itemLifeGoals!) \(item.done)") // Test
        
        return cell
    }

    //MARK: - Select a row - TableView Delegate Methods
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

            print("Select ligne: \(indexPath.row)") // Test
            
            // tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            itemArray[indexPath.row].done = !itemArray[indexPath.row].done  // Check or Uncheck line
            tableView.deselectRow(at: indexPath, animated: true)
            // tableView.selectRow(at: indexPath, animated: true, scrollPosition: UITableView.ScrollPosition.top)
            saveItems()
        }
        
    //MARK: - Delete management into TableView
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        context.delete(itemArray[indexPath.row])
        itemArray.remove(at: indexPath.row)

        print("Delete de l'indexe: \(indexPath.row)") // Test
        
        tableView.deleteRows(at: [indexPath], with: .automatic) // with animation

        self.saveItems()
    }

    //MARK: - Add new Items
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if let charactFill = outlet_TextInput.text?.count { // Check if Input line is filled
            if charactFill > 0 {
                let newItem = ToDoItem(context: self.context)
                newItem.itemLifeGoals = outlet_TextInput.text!
                newItem.done = false
                self.itemArray.append(newItem)
                
                print("Ajout Ligne \(outlet_TextInput.text!)") // Test
                self.saveItems()
            }
        }
        outlet_TextInput.text=nil
        textField.resignFirstResponder() // Keyboard off
        return false
    }
    
    //MARK: - Load data
    func loadItems(with request: NSFetchRequest<ToDoItem>=ToDoItem.fetchRequest()) {
        do { // into internal table itemArray from CoreData
            itemArray = try context.fetch(request)

            print("Lecture CoreData & Chargement dans itemArray") // Test

        } catch {
            print("Error fetching data from context \(error)")
        }
        outlet_TableView.reloadData()
    }
    
    //MARK: - Save data
    func saveItems() {
        do {
          try context.save()

            print("Sauvegarde dans CoreData") // Test

        } catch {
           print("Error saving context \(error)")
        }
        self.outlet_TableView.reloadData() // Refresh TableView
    }
    
    //MARK: - Clear button management
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        textField.text = nil
        textField.resignFirstResponder() // Keyboard off
        return false
    }
}
