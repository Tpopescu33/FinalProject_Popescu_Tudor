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


var green2 = UIColor(hexString: "#1E5128")
var green1 = UIColor(hexString: "#4E9F3D")
var green3 = UIColor(hexString: "#D8E9A8")
var black1 = UIColor(hexString: "#191A19")

var totalIncomeRemaining: Int = 0
var totalUpcomingExpenses: Int = 0
var totalCurrentExpenses: Int = 0

var setOptions = ""
var setAmount = 0
var setBalanceAmount = 0

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    
    
    @IBOutlet weak var monthLabel: UILabel!
    
    var monthNo: Int = 0
    var yearNo: Int = 0
  
    
    // CORE DATA //
    
    func getBalance() {
        
        let fetchReq: NSFetchRequest<BalanceRem>
        fetchReq = BalanceRem.fetchRequest()
        
        fetchReq.predicate = NSPredicate(
            format: "month == %i AND year == %i AND userName = %@", monthNo, yearNo, userName        )
        self.sections[0].titleAmount = 0
        self.tableView.reloadData()
        
        do {
            let items = try context.fetch(fetchReq)
            
            print(items)
            
            
            self.sections[0].titleAmount = 0
            for i in 0..<items.count {
                if (items.count != 0) {
                   
                    sections[0].changeTitleAmount(option: items[i].balance)
                }
                self.tableView.reloadData()
                
            }
            
            sections[0].changeTitleAmount(option: 0 - sections[2].titleAmount)
        } catch {
            print("error getting balance")
        }
        
        
    }
    
    func getExpRemaining() {
        
        let fetchReq: NSFetchRequest<ExpRemaining>
        fetchReq = ExpRemaining.fetchRequest()
        
        fetchReq.predicate = NSPredicate(
            format: "month == %i AND year == %i AND userName = %@", monthNo, yearNo, userName
        )
        
        self.sections[1].optionsAmount.removeAll()
        self.sections[1].options.removeAll()
        self.sections[1].titleAmount = 0
        self.tableView.reloadData()
        do {
            let items = try context.fetch(fetchReq)
            
            print(items)
            
           
            for i in 0..<items.count {
                if (items.count != 0) {
                    sections[1].addOption(option: items[i].option!)
                    sections[1].addOptionAmount(option: items[i].optionAmount)
                    sections[1].changeTitleAmount(option: items[i].optionAmount)
                }
                self.tableView.reloadData()
                
            }
            

        } catch {
            print("error getexpremaining" )
        }
            
       
        
        
    }
    
    func getExpPaid() {
        
        let fetchReq: NSFetchRequest<ExpPaid>
        fetchReq = ExpPaid.fetchRequest()
        
        fetchReq.predicate = NSPredicate(
            format: "month == %i AND year == %i AND userName = %@", monthNo, yearNo, userName
        )
        
        self.sections[2].optionsAmount.removeAll()
        self.sections[2].options.removeAll()
        self.sections[2].titleAmount = 0
        
        do {
            let items = try context.fetch(fetchReq)
            
            print(items)
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
            print("error getexppaid")
        }
        
    }
    
    func createPaidEntry(option: String, optionAmount: Int, monthNo: Int, yearNo: Int) {
        let newItem = ExpPaid(context: context)
        newItem.option = option
        newItem.optionAmount = optionAmount
        newItem.month = monthNo
        newItem.year = yearNo
        newItem.userName = userName
        do {
            try context.save()
            getExpPaid()
        } catch {
            print("createpaidentry")
        }

    }
    
    func checkRemainingEntry(option: String, optionAmount: Int, monthNo: Int, yearNo: Int){
        let title = option
        let titleAmount = optionAmount
        let fetchReq: NSFetchRequest<ExpRemaining>
        fetchReq = ExpRemaining.fetchRequest()
        
        let namePredicate = NSPredicate(format: "option LIKE %@",  "\(title)")
        let monthPredicate = NSPredicate(format: "month == %i AND year == %i AND userName = %@", monthNo, yearNo, userName)
        
        fetchReq.predicate = NSCompoundPredicate(
           andPredicateWithSubpredicates: [namePredicate, monthPredicate]
        )
        
//        self.sections[1].titleAmount = 0
//        self.sections[1].optionsAmount[0] = 0
        
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
    
    func checkRemainingEntryDelete(option: String, optionAmount: Int, monthNo: Int, yearNo: Int){
        let title = option
        let titleAmount = optionAmount
        let fetchReq: NSFetchRequest<ExpRemaining>
        fetchReq = ExpRemaining.fetchRequest()
        
        let namePredicate = NSPredicate(format: "option LIKE %@",  "\(title)")
        let monthPredicate = NSPredicate(format: "month == %i AND year == %i AND userName = %@", monthNo, yearNo, userName)
        
        fetchReq.predicate = NSCompoundPredicate(
           andPredicateWithSubpredicates: [namePredicate, monthPredicate]
        )
        
//        self.sections[1].titleAmount = 0
//        self.sections[1].optionsAmount[0] = 0
        
        do {
            let items = try context.fetch(fetchReq)
            
            print(items.count)
            self.tableView.reloadData()
          
           
                if (items.count != 0) {
                    
                    
                    
                    updateRemainingEntry(item: items[0], newOptionAmount: items[0].optionAmount + titleAmount)
                    sections[1].changeTitleAmount(option: items[0].optionAmount + titleAmount)
                
                   
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
        self.tableView.reloadData()
        do {
            try context.save()
            self.tableView.reloadData()
        } catch {
            //error
        }
    }
    
    
    
    ////
  
    
    
    @IBOutlet weak var editBtn: UIBarButtonItem!
    @IBAction func editBtnAction(_ sender: UIBarButtonItem) {
        self.tableView.isEditing = !self.tableView.isEditing
        sender.title = (self.tableView.isEditing) ? "Done" : "Delete"
    }
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var setExpenseOption: [String] = []
    var setExpenseAmount: [Int] = []
    var setIncomeAmount: Int = 0
    var isExpense = false
    var userName: String = ""
    
    override func viewDidAppear(_ animated: Bool) {
        userName = defaults.string(forKey: "userName")!
        monthNo = defaults.integer(forKey: "monthNo")
        yearNo = defaults.integer(forKey: "yearNo")
        monthLabel.text = "\(months[monthNo]), \(years[yearNo])"
        getExpPaid()
        getExpRemaining()
        getBalance()
        print("month: \(self.monthNo)", " year: \(self.yearNo)", "user: \(self.userName)")

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userName = defaults.string(forKey: "userName")!
        monthNo = defaults.integer(forKey: "monthNo")
        yearNo = defaults.integer(forKey: "yearNo")
        self.tableView.allowsSelectionDuringEditing = true
        monthLabel.text = "\(months[monthNo]), \(years[yearNo])"
        getExpPaid()
        getExpRemaining()
        getBalance()
       
        
    }
    
    override open var shouldAutorotate: Bool {
       return false
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
       get {
          return .portrait
       }
    }
    
    
   
    
   
    
    
   
    var setOptions: String = ""
    var setTitleAmount: Int = 0
    var setOptionsAmount: Int = 0
    
   
    
    
    var sections = [Sections(title: "Balance Remaining", options: [], titleAmount: totalIncome-totalCurrentExpenses, optionsAmount: []),
                    Sections(title: "Expenses Remaining", options: [], titleAmount: totalUpcomingExpenses, optionsAmount: []),
                    Sections(title: "Expenses Paid", options: [], titleAmount: totalCurrentExpenses, optionsAmount: [])]

    // Alert Functions

    @IBAction func addExpenseButton(_ sender: Any) {
        print("click")
        self.presentAddExpense()
    }
    
    func presentAddExpense() {
        
        
        
        let addExpenseCont = UIAlertController(title: "Add Expense", message: nil, preferredStyle: .alert)
        addExpenseCont.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = green3
        addExpenseCont.view.tintColor = black1
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
                
                self.createPaidEntry(option: incomeText, optionAmount: amountText, monthNo: self.monthNo, yearNo: self.yearNo)
                self.checkRemainingEntry(option: incomeText, optionAmount: amountText, monthNo: self.monthNo, yearNo: self.yearNo)
                self.getExpPaid()
                self.getBalance()
                
               
                
                
                
                
            }
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in })
        addExpenseCont.addAction(confirmAction)
        addExpenseCont.addAction(cancelAction)
        self.present(addExpenseCont, animated: true, completion: nil)
    
    
    }
    

    // TableView Functions
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if sections[2].isOpen == true {
        if sections[2].options.count > 7 {
            if indexPath.section == 0 {
                return 0
            }
            if indexPath.section == 1 {
                return 0
            }
        }
        }
        if sections[1].isOpen == true {
        if sections[1].options.count > 7 {
            if indexPath.section == 0 {
                return 0
            }
            if indexPath.section == 2 {
                return 0
            }
        }
        }

        return 50

    }
    
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


            if indexPath.section == 2 {
                
                do {
                let items = try context.fetch(ExpPaid.fetchRequest())
                    let item = items[indexPath.row-1]
                    
                    self.checkRemainingEntryDelete(option: item.option!, optionAmount: item.optionAmount, monthNo: self.monthNo, yearNo: self.yearNo)
                    deletePaidEntry(item: item)
                    getExpPaid()
                    getBalance()
                }
                catch{
                    print("error deleting")
                    
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
//            cell.backgroundColor = green2
            cellName.textColor = green3
            cellAmount.textColor = green3
            if indexPath.section == 2 {
                cell.backgroundColor = green2
                cellName.textColor = green3
                cellAmount.textColor = green3

                
            } else if indexPath.section == 1 {
                cell.backgroundColor = green2
                cellName.textColor = green3
                cellAmount.textColor = green3

            } else {

                if self.sections[0].titleAmount - sections[1].titleAmount > 200 {
                    cell.backgroundColor = green1
                    cellName.textColor = black1
                    cellAmount.textColor = black1

                } else if self.sections[0].titleAmount - sections[1].titleAmount < 0{
                    cell.backgroundColor = red
                    cellName.textColor = black1
                    cellAmount.textColor = black1

                } else {
                    cell.backgroundColor = orange
                    cellName.textColor = black1
                    cellAmount.textColor = black1
                }
            }
            
        } else {
            cellName.text = self.sections[indexPath.section].options[indexPath.row - 1]
            cellAmount.text = "$\(self.sections[indexPath.section].optionsAmount[indexPath.row - 1])"
            cell.backgroundColor = green1
            cellName.textColor = black1
            cellAmount.textColor = black1
//            if indexPath.section == 2 {
//                cell.backgroundColor = green.withAlphaComponent(0.5)
//            } else {
//                cell.backgroundColor = red.withAlphaComponent(0.5)
//            }
            
            
           
        }
        
        
           
        return cell

            
        
        

        
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        if indexPath.row == 0{
            sections[indexPath.section].isOpen = !sections[indexPath.section].isOpen
            tableView.reloadSections([indexPath.section], with: .none)
            tableView.reloadData()
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
