//
//  BudgetViewController.swift
//  FinalProject_Popescu_Tudor
//
//  Created by Tudor Popescu on 10/17/21.
//

import UIKit


//struct that holds the data

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
    mutating func addOptionAmount(option: Int){
        optionsAmount.append(option)
    }
    mutating func changeTitleAmount(option: Int){
        titleAmount += option
    }
    
}

// global variables

let red = UIColor(hexString: "#D32626")
let green = UIColor(hexString: "#79D70F")
let orange = UIColor(hexString: "#F5A31A")
var totalIncome: Int = 3000
var totalExpenses: Int = 2500
var balanceAmount: Int = totalIncome - totalExpenses




class BudgetViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    
    // init sections and months
    
    
    
    var sections = [Section(title: "Income", options: ["Salary", "Child Tax Credit"], titleAmount:totalIncome, optionsAmount: [2700, 300]),
                    Section(title: "Expenses", options: ["Electricity Bill", "Phone Bill", "Credit Card Payment", "Rent", "Car Payment", "Insurance", "Groceries"], titleAmount: totalExpenses, optionsAmount: [200, 80, 50, 1200, 400, 80, 490]), Section(title: "Balance", options: [], titleAmount: balanceAmount, optionsAmount: [])]
    
    let months: [String] = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.allowsSelectionDuringEditing = true
    }

    @IBOutlet weak var editBtnLabel: UIBarButtonItem!
    @IBAction func editBtn(_ sender: UIBarButtonItem) {
        
        self.tableView.isEditing = !self.tableView.isEditing
        sender.title = (self.tableView.isEditing) ? "Done" : "Edit"
    }
    
    // Alert controller functions
    
    func presentAddIncome() {
        let addIncomeCont = UIAlertController(title: "Add Income", message: nil, preferredStyle: .alert)
        addIncomeCont.addTextField{ (textfield) in
            textfield.placeholder = "Enter Name"
        }
        addIncomeCont.addTextField{ (textfield) in
            textfield.placeholder = "Enter Amount"
        }
        let confirmAction = UIAlertAction(title: "Confirm", style: .default, handler: {_ in
            guard let textfield = addIncomeCont.textFields else {return}
            
            if let incomeText = textfield[0].text,
               let amountText = Int(textfield[1].text!) {
                
                
                if self.sections[1].isOpen == true && self.sections[0].isOpen == true{
                    self.sections[0].addOption(option: incomeText)
                    self.sections[0].addOptionAmount(option: amountText)
                    self.sections[0].isOpen = false
                    self.sections[1].isOpen = false
                    self.tableView.reloadData()
                    self.tableView.isEditing = false
                    self.editBtnLabel.title = "Edit"
                    self.sections[1].changeTitleAmount(option: amountText)
                    self.sections[2].changeTitleAmount(option: +amountText)
                    self.tableView.reloadSections([1], with: .none)
                    self.tableView.reloadSections([2], with: .none)
                
                
                } else {
                self.sections[0].addOption(option: incomeText)
                self.sections[0].addOptionAmount(option: amountText)
                self.sections[0].isOpen = false
                self.sections[1].isOpen = false
                self.tableView.isEditing = false
                self.editBtnLabel.title = "Edit"
                self.sections[0].changeTitleAmount(option: amountText)
                self.sections[2].changeTitleAmount(option: (+amountText))
                self.tableView.reloadSections([0], with: .none)
                self.tableView.reloadSections([2], with: .none)
               
                }}
            
        })
       
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in self.dismiss(animated: true, completion: nil)})
        addIncomeCont.addAction(confirmAction)
        addIncomeCont.addAction(cancelAction)
        self.present(addIncomeCont, animated: true, completion: nil)
    }
    
    func presentAddExpense() {
        
        
        
        let addIncomeCont = UIAlertController(title: "Add Expense", message: nil, preferredStyle: .alert)
        addIncomeCont.addTextField{ (textfield) in
            textfield.placeholder = "Enter Name"
        }
        addIncomeCont.addTextField{ (textfield) in
            textfield.placeholder = "Enter Amount"
        }
        let confirmAction = UIAlertAction(title: "Confirm", style: .default, handler: {_ in
            guard let textfield = addIncomeCont.textFields else {return}
            
            if  let incomeText = textfield[0].text,
                let amountText = Int(textfield[1].text!) {
                
                if self.sections[1].isOpen == true && self.sections[0].isOpen == true{
                    self.sections[1].addOption(option: incomeText)
                    self.sections[1].addOptionAmount(option: amountText)
                    self.sections[0].isOpen = false
                    self.sections[1].isOpen = false
                    self.tableView.reloadData()
                    self.tableView.isEditing = false
                    self.editBtnLabel.title = "Edit"
                    self.sections[1].changeTitleAmount(option: amountText)
                    self.sections[2].changeTitleAmount(option: -amountText)
                    self.tableView.reloadSections([1], with: .none)
                    self.tableView.reloadSections([2], with: .none)
                
                
                } else {
                    self.sections[1].addOption(option: incomeText)
                    self.sections[1].addOptionAmount(option: amountText)
                    self.sections[0].isOpen = false
                    self.sections[1].isOpen = false
                    self.tableView.isEditing = false
                    self.editBtnLabel.title = "Edit"
                    self.sections[1].changeTitleAmount(option: amountText)
                    self.sections[2].changeTitleAmount(option: -amountText)
                    self.tableView.reloadSections([1], with: .none)
                    self.tableView.reloadSections([2], with: .none)
                }
            }
            
        })
       
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in self.dismiss(animated: true, completion: nil)})
        addIncomeCont.addAction(confirmAction)
        addIncomeCont.addAction(cancelAction)
        self.present(addIncomeCont, animated: true, completion: nil)
    }
    

    //TableView functions
    
  

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if indexPath.row != 0 {
            return .delete
        } else {
            return .insert
        }
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        
            
        if (editingStyle == .insert){
            if indexPath.section == 0 {
                print("add income")
                self.presentAddIncome()
            } else if indexPath.section == 1 {
                print("add expense")
                self.presentAddExpense()
            }
        }



        if (editingStyle == .delete){
            sections[indexPath.section].options.remove(at: indexPath.item - 1)
            sections[indexPath.section].optionsAmount.remove(at: indexPath.item - 1)


            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
      
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let section = sections[section]
        
        if section.isOpen {
            return section.options.count + 1
        } else {
            return 1
        }
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 2 {
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
            if indexPath.section == 0 {
                cell.backgroundColor = green
            } else if indexPath.section == 1 {
                cell.backgroundColor = red
            } else {
               
                if self.sections[2].titleAmount == 0 {
                    cell.backgroundColor = green
                    
                } else if self.sections[2].titleAmount < 0{
                    cell.backgroundColor = red
                    
                } else {
                    cell.backgroundColor = orange
                }
            }
            
        } else {
            cellName.text = self.sections[indexPath.section].options[indexPath.row - 1]
            cellAmount.text = "$\(self.sections[indexPath.section].optionsAmount[indexPath.row - 1])"
            
            if indexPath.section == 0 {
                cell.backgroundColor = green.withAlphaComponent(0.5)
            } else {
                cell.backgroundColor = red.withAlphaComponent(0.5)
            }
            
            
           
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

