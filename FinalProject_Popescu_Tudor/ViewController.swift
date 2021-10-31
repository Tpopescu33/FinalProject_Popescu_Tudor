//
//  ViewController.swift
//  FinalProject_Popescu_Tudor
//
//  Created by Tudor Popescu on 10/16/21.
//

import UIKit
import CoreData

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
    mutating func changeOptionAmount(option: Int){
        optionsAmount[0] += option
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
    
    
    
    
    var monthNo: Int = 0
  
    
    // CORE DATA //
    
    func getBalance() {
        
        let fetchReq: NSFetchRequest<BalanceRem>
        fetchReq = BalanceRem.fetchRequest()
        
        fetchReq.predicate = NSPredicate(
            format: "month LIKE %@", "\(self.monthNo)"
        )
        self.tableView.reloadData()
        self.sections[0].titleAmount = 0
        do {
            let items = try context.fetch(fetchReq)
            
            print(items.count)
            
            
            self.sections[0].titleAmount = 0
            for i in 0..<items.count {
                if (items.count != 0) {
                   
                    sections[0].changeTitleAmount(option: items[i].balance - sections[2].titleAmount)
                }
                self.tableView.reloadData()
                
            }
            

        } catch {
            //error
        }
        
        
    }
    
    func getExpRemaining() {
        
        let fetchReq: NSFetchRequest<ExpRemaining>
        fetchReq = ExpRemaining.fetchRequest()
        
        fetchReq.predicate = NSPredicate(
            format: "month LIKE %@", "\(self.monthNo)"
        )
        
        self.sections[1].optionsAmount.removeAll()
        self.sections[1].options.removeAll()
        self.sections[1].titleAmount = 0
        self.tableView.reloadData()
        do {
            let items = try context.fetch(fetchReq)
            
            print(items.count)
            
           
            for i in 0..<items.count {
                if (items.count != 0) {
                    sections[1].addOption(option: items[i].option!)
                    sections[1].addOptionAmount(option: items[i].optionAmount)
                    sections[1].changeTitleAmount(option: items[i].optionAmount)
                }
                self.tableView.reloadData()
                
            }
            

        } catch {
            //error
        }
            
       
        
        
    }
    
    func getExpPaid() {
        
        let fetchReq: NSFetchRequest<ExpPaid>
        fetchReq = ExpPaid.fetchRequest()
        
        fetchReq.predicate = NSPredicate(
            format: "month LIKE %@", "\(self.monthNo)"
        )
        
        self.sections[2].optionsAmount.removeAll()
        self.sections[2].options.removeAll()
        self.sections[2].titleAmount = 0
        
        do {
            let items = try context.fetch(fetchReq)
            
            print(items.count)
            self.tableView.reloadData()
          
            for i in 0..<items.count {
                if (items.count != 0) {
                    sections[2].addOption(option: items[i].option!)
                    sections[2].addOptionAmount(option: items[i].optionAmount)
                    sections[2].changeTitleAmount(option: items[i].optionAmount)
                }
                
                
                self.tableView.reloadData()
                
            }
            

        } catch {
            //error
        }
        
    }
    
    func createPaidEntry(option: String, optionAmount: Int, month: Int) {
        let newItem = ExpPaid(context: context)
        newItem.option = option
        newItem.optionAmount = optionAmount
        newItem.month = monthNo
        
        do {
            try context.save()
            getExpPaid()
        } catch {
            //error
        }

    }
    
    func checkRemainingEntry(option: String, optionAmount: Int, month: Int){
        let title = option
        let titleAmount = optionAmount
        let fetchReq: NSFetchRequest<ExpRemaining>
        fetchReq = ExpRemaining.fetchRequest()
        
        let namePredicate = NSPredicate(format: "option LIKE %@",  "\(title)")
        let monthPredicate = NSPredicate(format: "month LIKE %@", "\(self.monthNo)")
        
        fetchReq.predicate = NSCompoundPredicate(
           andPredicateWithSubpredicates: [namePredicate, monthPredicate]
        )
        
        self.sections[1].titleAmount = 0
        self.sections[1].optionsAmount[0] = 0
        
        do {
            let items = try context.fetch(fetchReq)
            
            print(items.count)
            self.tableView.reloadData()
          
           
                if (items.count != 0) {
                    
                    
                    
                    updateRemainingEntry(item: items[0], newOptionAmount: items[0].optionAmount - titleAmount)
                    sections[1].changeTitleAmount(option: items[0].optionAmount - titleAmount)
                
                   
                getExpRemaining()
                self.tableView.reloadData()
                
            }
            

        } catch {
            //error
        }
        
    }
    
    func deleteRemainingEntry(item: ExpRemaining) {
        context.delete(item)
        
        do {
            try context.save()
        } catch {
            //error
        }
    }
    
    func deletePaidEntry(item: ExpPaid) {
        context.delete(item)
        
        do {
            try context.save()
        } catch {
            //error
        }
    }
    
    func updateRemainingEntry(item: ExpRemaining, newOptionAmount: Int){
        item.optionAmount = newOptionAmount
        do {
            try context.save()
        } catch {
            //error
        }
    }
    
    
    
    ////
  
    
    
    @IBOutlet weak var editBtn: UIBarButtonItem!
    @IBAction func editBtnAction(_ sender: UIBarButtonItem) {
        self.tableView.isEditing = !self.tableView.isEditing
        sender.title = (self.tableView.isEditing) ? "Done" : "Edit"
    }
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var setExpenseOption: [String] = []
    var setExpenseAmount: [Int] = []
    var setIncomeAmount: Int = 0
    var isExpense = false
    
    override func viewDidAppear(_ animated: Bool) {
        
     getExpPaid()
     getExpRemaining()
     getBalance()
        print("month: \(self.monthNo)")

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.allowsSelectionDuringEditing = true
        getExpPaid()
        getExpRemaining()
        getBalance()
       
        
    }
    
    
   
    
   
    
    
   
    var setOptions: String = ""
    var setTitleAmount: Int = 0
    var setOptionsAmount: Int = 0
    
   
    
    
    var sections = [Sections(title: "Balance Remaining", options: [], titleAmount: totalIncome-totalCurrentExpenses, optionsAmount: []),
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
                let amountText = Int(textfield[1].text!){
                
                self.createPaidEntry(option: incomeText, optionAmount: amountText, month: self.monthNo)
                self.checkRemainingEntry(option: incomeText, optionAmount: amountText, month: self.monthNo)
                self.getExpPaid()
                self.getBalance()
                
               
                
                
                
                
            }
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in self.dismiss(animated: true, completion: nil)})
        addExpenseCont.addAction(confirmAction)
        addExpenseCont.addAction(cancelAction)
        self.present(addExpenseCont, animated: true, completion: nil)
    
    
    }
    

    // TableView Functions
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        
            
//        if (editingStyle == .insert){
//            if indexPath.section == 0 {
//                print("add income")
//                self.presentAddIncome()
//            } else if indexPath.section == 1 {
//                print("add expense")
//                self.presentAddExpense()
//            }
//        }



        if (editingStyle == .delete){


            if indexPath.section == 1 {

            do {
            let items = try context.fetch(ExpRemaining.fetchRequest())
                let item = items[indexPath.row-1]
                deleteRemainingEntry(item: item)
                getExpPaid()
                getBalance()
            }
            catch{
                
            }} else if indexPath.section == 2 {
                
                do {
                let items = try context.fetch(ExpPaid.fetchRequest())
                    let item = items[indexPath.row-1]
                    deletePaidEntry(item: item)
                    
                    getExpPaid()
                    getBalance()
                }
                catch{
                    
                }
                
            }
            
        }
        
    }
    
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
