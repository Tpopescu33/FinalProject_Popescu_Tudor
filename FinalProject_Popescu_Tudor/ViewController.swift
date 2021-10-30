//
//  ViewController.swift
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
    mutating func addOptionAmount(option: Int){
        optionsAmount.append(option)
    }
    mutating func changeTitleAmount(option: Int){
        titleAmount += option
    }
    
}
let green2 = UIColor(hexString: "#DDFFBC")
let green1 = UIColor(hexString: "#91C788")

var totalIncomeRemaining: Int = 0
var totalUpcomingExpenses: Int = 0
var totalCurrentExpenses: Int = 0

var setOptions = ""
var setAmount = 0
var setBalanceAmount = 0

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
  
    
    
  
    
    
    @IBOutlet weak var editBtn: UIBarButtonItem!
    @IBAction func editBtnAction(_ sender: UIBarButtonItem) {
        self.tableView.isEditing = !self.tableView.isEditing
        sender.title = (self.tableView.isEditing) ? "Done" : "Edit"
    }
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var setBalanceAmount = 0
    var setExpenseOption: [String] = []
    var setExpenseAmount: [Int] = []
    var setIncomeAmount: [Int] = []
    var isExpense = false
    
    override func viewDidAppear(_ animated: Bool) {
        
        if (setExpenseOption.count != 0 && setExpenseAmount.count != 0 ) {
            
           
            
            for i in 0..<(setExpenseAmount.count) {
            
            self.sections[1].addOption(option: setExpenseOption[i])
            self.sections[1].addOptionAmount(option: setExpenseAmount[i])
            self.sections[1].changeTitleAmount(option: setExpenseAmount[i])
            self.tableView.reloadSections([1], with: .none)
            self.tableView.reloadData()
            }
            
            setExpenseOption.removeAll()
            
            setExpenseAmount.removeAll()
            
        }
        
        if (setIncomeAmount.count != 0) {
            
            let j = setIncomeAmount.count
            
            for i in 0...(j - 1) {
            
            self.sections[0].changeTitleAmount(option: setIncomeAmount[i])
            self.tableView.reloadData()
            self.tableView.reloadSections([0], with: .none)
            }
            setIncomeAmount.removeAll()
        }
        
        

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.allowsSelectionDuringEditing = true
        
      
       
        
    }
    
    
   
    
   
    
    
   
    var setOptions: String = ""
    var setTitleAmount: Int = 0
    var setOptionsAmount: Int = 0
    
   
    
    
    var sections = [Sections(title: "Balance Remaining", options: [], titleAmount: totalIncomeRemaining, optionsAmount: []),
                    Sections(title: "Expenses Remaining", options: [], titleAmount: totalUpcomingExpenses, optionsAmount: []),
                    Sections(title: "Expenses Paid", options: [], titleAmount: totalCurrentExpenses, optionsAmount: [])]

    // Alert Functions
    
    @IBAction func addExpenseBtn(_ sender: Any) {
        print("click")
        self.presentAddExpense()
    }
    
    func presentAddExpense() {
        
        
        
        let addExpenseCont = UIAlertController(title: "Add Expense", message: nil, preferredStyle: .alert)
        addExpenseCont.addTextField{ (textfield) in
            textfield.placeholder = "Enter Name"
        }
        addExpenseCont.addTextField{ (textfield) in
            textfield.placeholder = "Enter Amount"
        }
        let confirmAction = UIAlertAction(title: "Confirm", style: .default, handler: {_ in
            guard let textfield = addExpenseCont.textFields else {return}
            
            if  let incomeText = textfield[0].text,
                let amountText = Int(textfield[1].text!),
                let index = self.sections[1].options.firstIndex(where: {$0 == incomeText}) {
                
                
                
               
                
                
                    self.sections[2].addOption(option: incomeText)
                    self.sections[2].addOptionAmount(option: amountText)
                    self.sections[0].isOpen = false
                    self.sections[1].isOpen = false
                    self.tableView.reloadData()
                    self.tableView.isEditing = false
                    self.editBtn.title = "Edit"
                    self.sections[2].changeTitleAmount(option: amountText)
                    self.sections[1].changeTitleAmount(option: -amountText)
                    self.sections[0].changeTitleAmount(option: -amountText)
                    self.tableView.reloadSections([1], with: .none)
                    self.tableView.reloadSections([2], with: .none)
                    self.tableView.reloadSections([0], with: .none)
                if (self.sections[1].options.contains(incomeText) && self.sections[1].optionsAmount[index] == amountText){
                    
                    self.sections[1].options.remove(at: index)
                    self.sections[1].optionsAmount.remove(at: index)
                    self.tableView.reloadData()
                } else if (self.sections[1].options.contains(incomeText)) {
                    let tempAmount = self.sections[1].optionsAmount[index]
                    self.sections[1].optionsAmount.remove(at: index)
                    self.sections[1].optionsAmount.insert(tempAmount - amountText, at: index)
                    self.tableView.reloadData()
                    
                }
                
                
            }
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in self.dismiss(animated: true, completion: nil)})
        addExpenseCont.addAction(confirmAction)
        addExpenseCont.addAction(cancelAction)
        self.present(addExpenseCont, animated: true, completion: nil)
    
    
    }
    

    // TableView Functions
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row != 0 {
            if indexPath.section == 2 {
                return true
            }
          
        }
         return false
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if indexPath.row != 0 {
            if indexPath.section == 2 {
                return .delete
            }
           
        }
        return .none
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

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let cellName = cell.viewWithTag(1) as! UILabel
        let cellAmount = cell.viewWithTag(2) as! UILabel
            
        if indexPath.row == 0 {
           
            cellName.text = self.sections[indexPath.section].title
            cellAmount.text = "$\(self.sections[indexPath.section].titleAmount)"
            if indexPath.section == 2 {
                cell.backgroundColor = green
            } else if indexPath.section == 1 {
                cell.backgroundColor = red
            } else {
               
                if self.sections[0].titleAmount > 100 {
                    cell.backgroundColor = green
                    
                } else if self.sections[0].titleAmount < 0{
                    cell.backgroundColor = red
                    
                } else {
                    cell.backgroundColor = orange
                }
            }
            
        } else {
            cellName.text = self.sections[indexPath.section].options[indexPath.row - 1]
            cellAmount.text = "$\(self.sections[indexPath.section].optionsAmount[indexPath.row - 1])"
            
            if indexPath.section == 2 {
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
    
}

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}
