//
//  BudgetTableTableViewController.swift
//  FinalProject_Popescu_Tudor
//
//  Created by Tudor Popescu on 10/17/21.
//

import UIKit

struct Section {
    init(title: String, options: [String], isOpened: Bool = false) {
        self.title = title
        self.options = options
        self.isOpen = false
        
    }
    var title: String
    var options: [String]
    var isOpen: Bool
    
    mutating func addOption(option: String){
        options.append(option)
        
    }
    
    
}

class BudgetTableTableViewController: UITableViewController {

    
  
        
      
    var sections = [Section(title: "Income", options: ["Salary"]),
                    Section(title: "Expenses", options: ["Electricity Bill", "Phone Bill", "Credit Card Payment", "Rent", "Car Payment", "Insurance"])]

    override func viewDidLoad() {
        super.viewDidLoad()
        
       
            
        

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let section = sections[section]
        
        if section.isOpen {
            return section.options.count + 1
        } else {
            return 1
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "budgetCell", for: indexPath)
        
        if indexPath.row == 0 {
           
            cell.textLabel?.text = sections[indexPath.section].title
            cell.backgroundColor = .systemTeal
        } else {
            cell.textLabel?.text = sections[indexPath.section].options[indexPath.row - 1]
            cell.backgroundColor = .systemRed
           
        }
        
        
           
        return cell

            
        
        

        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        if indexPath.row == 0{
            sections[indexPath.section].isOpen = !sections[indexPath.section].isOpen
            tableView.reloadSections([indexPath.section], with: .none)
        } else {
            print("tapped sub cell")
        }
        
        
    }

}
