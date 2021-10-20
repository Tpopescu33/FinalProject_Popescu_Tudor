//
//  BudgetViewController.swift
//  FinalProject_Popescu_Tudor
//
//  Created by Tudor Popescu on 10/17/21.
//

import UIKit

struct Section {
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


let green4 = UIColor(hexString: "#C6E377")
let green3 = UIColor(hexString: "#36622B")
var totalIncome: Int = 3000
var totalExpenses: Int = 2500

class BudgetViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    var sections = [Section(title: "Income", options: ["Salary", "Child Tax Credit"], titleAmount:totalIncome, optionsAmount: [2700, 300]),
                    Section(title: "Expenses", options: ["Electricity Bill", "Phone Bill", "Credit Card Payment", "Rent", "Car Payment", "Insurance", "Groceries"], titleAmount: totalExpenses, optionsAmount: [200, 80, 50, 1200, 400, 80, 490])]
    
    let months: [String] = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.allowsSelectionDuringEditing = true
    }

    @IBAction func editBtn(_ sender: UIBarButtonItem) {
        
        self.tableView.isEditing = !self.tableView.isEditing
        sender.title = (self.tableView.isEditing) ? "Done" : "Edit"
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete){
            sections[indexPath.section].options.remove(at: indexPath.item - 1)
            sections[indexPath.section].optionsAmount.remove(at: indexPath.item - 1)


            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let section = sections[section]
        
        if section.isOpen {
            return section.options.count + 1
        } else {
            return 1
        }
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row == 0 {
            return false
        }
         return true
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "budgetCell", for: indexPath)
        
        let cellName = cell.viewWithTag(3) as! UILabel
        let cellAmount = cell.viewWithTag(4) as! UILabel
            
        if indexPath.row == 0 {
           
            cellName.text = self.sections[indexPath.section].title
            cellAmount.text = "$\(self.sections[indexPath.section].titleAmount)"
            cell.backgroundColor = green3
            cellName.textColor = green4
            cellAmount.textColor = green4
            
        } else {
            cellName.text = self.sections[indexPath.section].options[indexPath.row - 1]
            cellAmount.text = "$\(self.sections[indexPath.section].optionsAmount[indexPath.row - 1])"
            cell.backgroundColor = green4
            cellName.textColor = green3
            cellAmount.textColor = green3
            
           
        }
        
        
           
        return cell

            
        
        

        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        if indexPath.row == 0{
            sections[indexPath.section].isOpen = !sections[indexPath.section].isOpen
            tableView.reloadSections([indexPath.section], with: .none)
        } else {
            print("tapped sub cell")
        }
        
        
    }
    var monthNo = 0
    
    @IBOutlet weak var monthLabel: UILabel!
    
    
    @IBAction func monthBtn(_ sender: Any) {
        let actionSheet = UIAlertController(title: "Select Month", message: "", preferredStyle: .actionSheet)
        
        for monthNo in 0...11 {
            actionSheet.addAction(UIAlertAction(title: "\(months[monthNo])", style: .default, handler: { _ in
                
                self.monthLabel.text = "\(self.months[monthNo])"
                
            }))
        }
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    
  
    
}

