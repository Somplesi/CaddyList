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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print("Appel du DidLoad") // Test

        //  Delegations
        outlet_TextInput.delegate = self  // protocole UITextFieldDelegate
        outlet_TableView.delegate = self // protocole UITableViewDelegate
        outlet_TableView.dataSource = self // protocole UITableViewDataSource

        // CoreData READ
        loadItems()
    }

    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        //print("Edit button clic")
        //            tableView.setEditing(true, animated: true)
        //            tableView.allowsSelectionDuringEditing = true  // Test TableView Edit mode
        if outlet_TableView.isEditing == true {
            outlet_TableView.setEditing(false, animated: true)
        } else {
            outlet_TableView.setEditing(true, animated: true)
        }
    }
    
    @IBAction func clearButton(_ sender: UIBarButtonItem) {
        for index in 0..<itemArray.count {
                itemArray[index].highLighted = false
                itemArray[index].done = false
        }

        saveItems()
    }
    
    //MARK: - These TableView DataSource Methods are mandatories "required" by protocole of UITableViewDataSource (see Help)
    //  Set the internal table itemArray Row Count
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print("Lignes dispo \(itemArray.count)") // Test
        return itemArray.count
       }
    //  Fill the value into TableView from internal table ItemArray called for each line
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell=tableView.dequeueReusableCell(withIdentifier: "uiCellTable", for: indexPath)
        let item = itemArray[indexPath.row]
        // Fill the text into TableView
        cell.textLabel?.text = item.itemLifeGoals
        // Check or UnCheck
        cell.accessoryType = item.done ? .checkmark : .none
        // HighLight or not
        if item.highLighted == true {
            //cell.backgroundColor = .blue
            cell.textLabel?.isEnabled = true
        } else {
            //cell.backgroundColor = .green
            cell.textLabel?.isEnabled = false
        }
        //print("Ligne chargée: \(item.itemLifeGoals!) \(item.done)") // Test
        return cell
    }

    //MARK: - Select a row - TableView Delegate Methods
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
            // itemArray[indexPath.row].done = !itemArray[indexPath.row].done  // Check or Uncheck line
            if itemArray[indexPath.row].done == true && itemArray[indexPath.row].highLighted == true {
                itemArray[indexPath.row].highLighted = false
                itemArray[indexPath.row].done = false
            } else {
                if itemArray[indexPath.row].highLighted == true {
                    itemArray[indexPath.row].done = true
                } else {
                    itemArray[indexPath.row].highLighted = true
                    itemArray[indexPath.row].done = false
                }
            }

            // tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            tableView.deselectRow(at: indexPath, animated: true)
            // tableView.selectRow(at: indexPath, animated: true, scrollPosition: UITableView.ScrollPosition.top)
            saveItems()
        }
    
    
    //MARK: - Move row
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        // print("Row moved")
    }
    
    //MARK: - TableView Editable
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section == 0 ? true : false
//        if indexPath.section == 1 {
//            return true
//        }
//        return false
    }
    
    //MARK: Row can move
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // print("Row can move")
        return true
    }
    
    //MARK: - Delete management into TableView
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        context.delete(itemArray[indexPath.row])
        itemArray.remove(at: indexPath.row)
        //print("Delete de l'indexe: \(indexPath.row)") // Test
        tableView.deleteRows(at: [indexPath], with: .automatic) // with animation
        self.saveItems()
        print("EditingStyle called")
      
    }

    //MARK: - Add new Items
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let charactFill = outlet_TextInput.text?.count { // Check if Input line is filled (method 2)
            if charactFill > 0 {
                let newItem = ToDoItem(context: self.context)
                newItem.itemLifeGoals = outlet_TextInput.text!
                newItem.done = false
                newItem.highLighted = false
                self.itemArray.append(newItem)
                //print("Ajout Ligne \(outlet_TextInput.text!)") // Test
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
            //print("Lecture CoreData & Chargement dans itemArray") // Test
        } catch {
            print("Error fetching data from context \(error)")
        }
        outlet_TableView.reloadData()
    }
    
    //MARK: - Save data
    func saveItems() {
        do {
          try context.save()
            //print("Sauvegarde dans CoreData") // Test
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
