//
//  ViewController.swift
//  CaddyList
//
//  Created by Rodolphe DUPUY on 09/04/2020.
//  Copyright © 2020 Rodolphe DUPUY. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    var itemArray = [ToDoItem]()    // Internal Table sync with CoreData directly
    
    //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let context = CoreDataCloudDeclaration.persistentContainer.viewContext
    
    var refreshControl = UIRefreshControl()
    
    @IBOutlet weak var outlet_TextInput: UITextField!
    @IBOutlet weak var outlet_TableView: UITableView!
    @IBOutlet weak var outlet_Logo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print("Appel du DidLoad") // Test
        
        //  Delegations
        outlet_TextInput.delegate = self  // protocole UITextFieldDelegate
        outlet_TableView.delegate = self // protocole UITableViewDelegate
        outlet_TableView.dataSource = self // protocole UITableViewDataSource
        
        // CoreData READ
        loadItems()
        
        // Refresh with animation
        //refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        outlet_TableView.addSubview(refreshControl) // not required when using UITableViewController
    }
    
    @objc func refresh(_ sender: AnyObject) {
        // Code to refresh table view
        loadItems()
        outlet_TableView.reloadData()
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false, block: { (timer: Timer) in
            self.refreshControl.endRefreshing()
        })
    }
    
    //    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
    //        //print("Edit button clic")
    //        //            tableView.setEditing(true, animated: true)
    //        //            tableView.allowsSelectionDuringEditing = true  // Test TableView Edit mode
    //        if outlet_TableView.isEditing == true {
    //            outlet_TableView.setEditing(false, animated: true)
    //        } else {
    //            outlet_TableView.setEditing(true, animated: true)
    //        }
    //    }
    
    @IBAction func clearButton(_ sender: UIBarButtonItem) {
        //        for index in 0..<itemArray.count {
        //            //if itemArray[index].done == true || itemArray[index].highLighted == true {
        //            itemArray[index].highLighted = false
        //            //}
        //            itemArray[index].done = false
        //        }
        //        saveItems()
    }
    
    //MARK: - These TableView DataSource Methods are mandatories "required" by protocole of UITableViewDataSource (see Help)
    //  Set the internal table itemArray Row Count - Required by delegation
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print("Lignes dispo \(itemArray.count)") // Test
        return itemArray.count
    }
    //  Fill the value into TableView from internal table ItemArray called for each line - Required by delegation
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "uiCellTable", for: indexPath)
        let item = itemArray[indexPath.row]
        // Display List
        //        if displayChoose.selectedSegmentIndex == 0 {
        // Fill the text into TableView
        cell.textLabel?.text = item.itemLifeGoals
        // Choose Category
        cell.detailTextLabel?.text = item.category
        // Check or UnCheck
        cell.accessoryType = item.done ? .checkmark : .none
        // HighLight or not
        cell.textLabel?.isEnabled = item.highLighted
        cell.detailTextLabel?.isEnabled = item.highLighted
        //print("Ligne chargée: \(item.itemLifeGoals!) \(item.done)") // Test
        return cell
    }
    
    //MARK: - Refresh List when scroll
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        //loadItems()
        //outlet_TableView.reloadData()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        //scrollView.isScrollEnabled = true
        //scrollView.alwaysBounceVertical = true
        //scrollView.refreshControl = UIRefreshControl()
    }
    
    //MARK: - Select a row - TableView Methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Check or Uncheck line
        if itemArray[indexPath.row].done == true && itemArray[indexPath.row].highLighted == true {
            itemArray[indexPath.row].highLighted = false
            itemArray[indexPath.row].done = false
        } else {
            if itemArray[indexPath.row].highLighted == true {
                itemArray[indexPath.row].highLighted = false
                itemArray[indexPath.row].done = true
            } else {
                if itemArray[indexPath.row].done == true {
                    itemArray[indexPath.row].highLighted = false
                    itemArray[indexPath.row].done = false
                } else {
                    itemArray[indexPath.row].highLighted = true
                    itemArray[indexPath.row].done = false
                }
            }
        }
        AudioServicesPlaySystemSound (1104)
        // tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        tableView.deselectRow(at: indexPath, animated: true)
        outlet_TextInput.resignFirstResponder()
        // tableView.selectRow(at: indexPath, animated: true, scrollPosition: UITableView.ScrollPosition.top)
        saveItems()
    }
    
    //MARK: - Row Moved
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
    }
    
    //MARK: - TableView Editable
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        //return indexPath.section == 0 ? true : false
        return true
    }
    
    func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //MARK: - Row can move
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //MARK: - Delete management into TableView
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            context.delete(itemArray[indexPath.row])
            itemArray.remove(at: indexPath.row) // Delete line into array using index
            tableView.deleteRows(at: [indexPath], with: .automatic) // with animation
            AudioServicesPlaySystemSound (1155) //1114
            self.saveItems()
        }
    }
    
    //    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    //        let deleteAction = UIContextualAction(style: .destructive, title: nil) { (_, _, completionHandler) in
    //            // delete the item here
    //            completionHandler(true)
    //        }
    //        deleteAction.image = UIImage(systemName: "trash")
    //        deleteAction.backgroundColor = .systemRed
    //        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
    //                return configuration
    //    }
    
    func tableView(_ tableView: UITableView,
                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let categoryAction = UIContextualAction(style: .normal, title:  "Close", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            var textField = UITextField()
            // Alert object preparation
            let alert = UIAlertController(title: self.itemArray[indexPath.row].itemLifeGoals, message: nil, preferredStyle: .alert)
            alert.setValue(UIImage(systemName: "folder.badge.plus"), forKey: "image")
            alert.addTextField { (alertTextField) in
                alertTextField.placeholder = ""
                textField = alertTextField
                textField.keyboardType = .default
                textField.keyboardAppearance = .default
                textField.autocapitalizationType = .words
                textField.autocorrectionType = .default
                textField.returnKeyType = .done
                textField.text = self.itemArray[indexPath.row].category
            }
            // Alert action
            let action = UIAlertAction(title: "Ok", style: .default) { (action) in
                //self.context.insert(itemArray[indexPath.row])
                //if textField.text!.count > 0 {
                //self.itemArray.append(newItem)
                self.itemArray[indexPath.row].category = textField.text
                self.saveItems()
                self.loadItems()
                AudioServicesPlaySystemSound (1156)
                //}
            }
            alert.addAction(action)
            self.outlet_TextInput.resignFirstResponder()
            self.present(alert, animated: true, completion: nil)
            success(true)
        })
        categoryAction.image = UIImage(systemName: "folder.badge.plus")
        categoryAction.backgroundColor = .gray
        return UISwipeActionsConfiguration(actions: [categoryAction])
    }
    
    
    //MARK: - Add new Items
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let charactFill = outlet_TextInput.text?.count { // Check if Input line is filled (method 2)
            if charactFill > 0 {
                if duplicatesData(item: outlet_TextInput.text!) == false {
                    let newItem = ToDoItem(context: self.context)
                    newItem.itemLifeGoals = outlet_TextInput.text!
                    newItem.category = ""
                    newItem.done = false
                    newItem.highLighted = true
                    
                    self.itemArray.append(newItem)  // Add line into array & CoreData
                    self.saveItems()
                    AudioServicesPlaySystemSound (1123) //1113 or 1123
                }
            } else {
                textField.resignFirstResponder() // Keyboard off
            }
        }
        outlet_TextInput.text=nil
        
        loadItems()
        //outlet_TableView.reloadData()
        
        return false
    }
    func duplicatesData(item: String) -> Bool {
        // Sort Array
        //        itemArray.sort {
        //            $0.itemLifeGoals! < $1.itemLifeGoals!
        //        }
        // Detect duplicates item
        for oneItemArray in itemArray {
            if item == oneItemArray.itemLifeGoals {
                //let systemSoundID: SystemSoundID =  1114
                AudioServicesPlaySystemSound (1112)
                return true
            }
        }
        return false
    }
    
    //MARK: - Load data
    func loadItems(with request: NSFetchRequest<ToDoItem>=ToDoItem.fetchRequest()) {
        context.automaticallyMergesChangesFromParent = true
        
        //request.sortDescriptors = [NSSortDescriptor(key: "itemLifeGoals", ascending: true)]
        let sortDescriptorHighLighted = NSSortDescriptor(key: "highLighted", ascending: false)
        let sortDescriptorCategory = NSSortDescriptor(key: "category", ascending: true)
        let sortDescriptorDone = NSSortDescriptor(key: "done", ascending: false)
        let sortDescriptorItems = NSSortDescriptor(key: "itemLifeGoals", ascending: true)
        
        request.sortDescriptors = [sortDescriptorHighLighted, sortDescriptorCategory, sortDescriptorDone,sortDescriptorItems]
        
        do { // into internal table itemArray from CoreData
            itemArray = try context.fetch(request)  // Read CoreData & Load into array
        } catch {
            print("Error fetching data from context \(error)")
        }
        outlet_TableView.reloadData()
    }
    
    //MARK: - Save data
    func saveItems() {
        context.automaticallyMergesChangesFromParent = true
        do {
            try context.save() // Save into CoreData
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
