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
var totalIncome: Int = 0
var totalExpenses: Int = 0
var balanceAmount: Int = totalIncome - totalExpenses




class BudgetViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    // CORE DATA //
    func getBalance() {
        balanceAmount = sections[0].titleAmount - sections[1].titleAmount
        sections[2].titleAmount = 0
        sections[2].changeTitleAmount(option: balanceAmount)
        self.tableView.reloadData()
    }
    
    func getTable() {
        do {
            let items = try context.fetch(IncomeTable.fetchRequest())
            
            print(items.count)
            
            self.sections[0].optionsAmount.removeAll()
            self.sections[0].options.removeAll()
            self.sections[0].titleAmount = 0
            for i in 0..<items.count {
                if (items.count != 0) {
                    sections[0].addOption(option: items[i].option!)
                    sections[0].addOptionAmount(option: items[i].optionAmount)
                    sections[0].changeTitleAmount(option: items[i].optionAmount)
                }
                self.tableView.reloadData()
                getBalance()
            }
            

        } catch {
            //error
        }
        
    }
    
    func getTableExp() {
        do {
            let items = try context.fetch(ExpenseTable.fetchRequest())
            
            print(items.count)
            
            self.sections[1].optionsAmount.removeAll()
            self.sections[1].options.removeAll()
            self.sections[1].titleAmount = 0
            for i in 0..<items.count {
                if (items.count != 0) {
                    sections[1].addOption(option: items[i].option!)
                    sections[1].addOptionAmount(option: items[i].optionAmount)
                    sections[1].changeTitleAmount(option: items[i].optionAmount)
                }
                self.tableView.reloadData()
                getBalance()
            }
            

        } catch {
            //error
        }
        
    }
    
    func createIncomeEntry(option: String, optionAmount: Int, month: Int) {
        let newItem = IncomeTable(context: context)
        newItem.option = option
        newItem.optionAmount = optionAmount
        newItem.month = monthNo
        
        do {
            try context.save()
            getTable()
        } catch {
            //error
        }

    }
    
    func createExpenseEntry(option: String, optionAmount: Int, month: Int) {
        let newItem = ExpenseTable(context: context)
        newItem.option = option
        newItem.optionAmount = optionAmount
        newItem.month = monthNo
        
        do {
            try context.save()
            getTable()
        } catch {
            //error
        }

    }
    
    func deleteIncomeEntry(item: IncomeTable) {
        context.delete(item)
        
        do {
            try context.save()
        } catch {
            //error
        }
    }
    
    func deleteExpenseEntry(item: ExpenseTable) {
        context.delete(item)
        
        do {
            try context.save()
        } catch {
            //error
        }
    }
    
    
    
    
    
    // init sections and months
    
    
    
    
    
    var sections = [Section(title: "Income", options: [], titleAmount:totalIncome, optionsAmount: []),
                    Section(title: "Expenses", options: [], titleAmount: totalExpenses, optionsAmount: []), Section(title: "Balance", options: [], titleAmount: balanceAmount, optionsAmount: [])]
    
    let months: [String] = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    var monthNo: Int = 0
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.allowsSelectionDuringEditing = true
        getTable()
        getTableExp()
        
    }
    
    

    @IBOutlet weak var editBtnLabel: UIBarButtonItem!
    @IBAction func editBtn(_ sender: UIBarButtonItem) {
        
        self.tableView.isEditing = !self.tableView.isEditing
        sender.title = (self.tableView.isEditing) ? "Done" : "Edit"
    }
    
    var incomeTexts = ""
    var amountTexts = 0
    
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
                
                
                self.createIncomeEntry(option: incomeText, optionAmount: amountText, month: self.monthNo)
                self.getTable()
                

            
              
            }
            
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
                
                
                
                self.createExpenseEntry(option: incomeText, optionAmount: amountText, month: self.monthNo)
                self.getTableExp()

                
                
                
            }
            
        })
       
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in self.dismiss(animated: true, completion: nil)})
        addIncomeCont.addAction(confirmAction)
        addIncomeCont.addAction(cancelAction)
        self.present(addIncomeCont, animated: true, completion: nil)
    }
    
    
    func sendDataExpense() {
       
           
        let Nav = self.tabBarController!.viewControllers![0] as! UINavigationController
        let firstTab = Nav.topViewController as! ViewController
        
        
        firstTab.monthNo = monthNo
        
        
    }
    
    func sendDataIncome() {
       
           
        let Nav = self.tabBarController!.viewControllers![0] as! UINavigationController
        let firstTab = Nav.topViewController as! ViewController
        
        
        
        
        firstTab.monthNo = monthNo
        
        
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


            if indexPath.section == 0 {

            do {
            let items = try context.fetch(IncomeTable.fetchRequest())
                let item = items[indexPath.row-1]
                deleteIncomeEntry(item: item)
                getTable()
            }
            catch{
                
            }} else if indexPath.section == 1 {
                
                do {
                let items = try context.fetch(ExpenseTable.fetchRequest())
                    let item = items[indexPath.row-1]
                    deleteExpenseEntry(item: item)
                    getTableExp()
                }
                catch{
                    
                }
                
            }
            
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
    
    
    @IBOutlet weak var monthLabel: UILabel!
    
    
    @IBAction func monthBtn(_ sender: Any) {
        let actionSheet = UIAlertController(title: "Select Month", message: "", preferredStyle: .actionSheet)
        
        for i in 0...11 {
            actionSheet.addAction(UIAlertAction(title: "\(months[i])", style: .default, handler: { _ in
                
                self.monthLabel.text = "\(self.months[i])"
                self.monthNo = i
                
            }))
        }
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    
  
    
}

