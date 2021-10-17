//
//  TableViewController.swift
//  FinalProject_Popescu_Tudor
//
//  Created by Tudor Popescu on 10/16/21.
//

import UIKit


struct Sections {
    init(title: String, options: [String], isOpened: Bool = false, titleAmount: Int, optionsAmount: [Int]) {
        self.title = title
        self.options = options
        self.isOpen = false
        self.titleAmount = titleAmount
        self.optionsAmount = optionsAmount
        
    }
    var title: String
    var options: [String]
    var isOpen: Bool
    var titleAmount: Int
    var optionsAmount: [Int]
    
    mutating func addOption(option: String){
        options.append(option)
        
        
    }
    
    
}
var daysUntilPaid: Int = 10
var totalIncomeRemaining: Int = 2000
var totalUpcomingExpenses: Int = 1680
var totalCurrentExpenses: Int = 360


class TableViewController: UITableViewController {
    
    var sections = [
                    Sections(title: "Expenses Remaining", options: ["Rent", "Car Payment", "Water Bill"], titleAmount: totalUpcomingExpenses, optionsAmount: [1200, 400, 80]),
                    Sections(title: "Expenses Paid", options: ["Electricity Bill", "Phone Bill", "Credit Card Payment"], titleAmount: totalCurrentExpenses, optionsAmount: [200, 80, 50])]

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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let cellName = cell.viewWithTag(1) as! UILabel
        let cellAmount = cell.viewWithTag(2) as! UILabel
        
        if indexPath.row == 0 {
           
            cellName.text = self.sections[indexPath.section].title
            cellAmount.text = "$\(self.sections[indexPath.section].titleAmount)"
            cell.backgroundColor = .systemGreen
        } else {
            cellName.text = self.sections[indexPath.section].options[indexPath.row - 1]
            cellAmount.text = "$\(self.sections[indexPath.section].optionsAmount[indexPath.row - 1])"
            cell.backgroundColor = .systemGray
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
