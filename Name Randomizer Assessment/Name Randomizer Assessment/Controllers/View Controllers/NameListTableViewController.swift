//
//  NameListTableViewController.swift
//  Name Randomizer Assessment
//
//  Created by Anthroman on 4/10/20.
//  Copyright © 2020 Anthroman. All rights reserved.
//

import UIKit

class NameListTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Actions
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        // Create the alert
        let alert = UIAlertController(title: "Add Person", message: "Add someone new to the list.", preferredStyle: .alert)
        
        // Add a text field
        alert.addTextField(configurationHandler: nil)
        
        // Create a cancel button
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        // Create an add button
        let addButton = UIAlertAction(title: "Add", style: .default) { (_) in
            guard let name = alert.textFields?[0].text, name != "" else {return}
            NameViewController.sharedInstance.createName(name: name)
            // reload data
            self.tableView.reloadData()
        }
        
        // Add our buttons to the alert
        alert.addAction(cancelButton)
        alert.addAction(addButton)
        
        // Present our alert
        self.present(alert, animated: true)
    }
    
    @IBAction func randomizeButtonTapped(_ sender: UIButton) {
        NameViewController.sharedInstance.shuffleNames()
        tableView.reloadData()
    }
    
    func nameIndex(indexPath: IndexPath) -> Int {
        // returns an integer based on number of sections (starting at index 0) and how many rows are in the final section (which is either 1 or 2)
        return (indexPath.section * 2) + (indexPath.row)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return NameViewController.sharedInstance.names.count % 2 == 0 ? NameViewController.sharedInstance.names.count / 2 : (NameViewController.sharedInstance.names.count / 2) + 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if NameViewController.sharedInstance.names.count % 2 == 0 {
            return 2
        } else {
            // the last section should have only one row, all other sections should have 2
            return section == (tableView.numberOfSections - 1) ? 1 : 2
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "nameCell", for: indexPath)
        
        let name = NameViewController.sharedInstance.names[nameIndex(indexPath: indexPath)]

        cell.textLabel?.text = name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Group \(section + 1)"
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let name = NameViewController.sharedInstance.names[nameIndex(indexPath: indexPath)]
            
            NameViewController.sharedInstance.deleteName(name: name)
            tableView.reloadData()
        }
    }
}
