//
//  BudgetViewController.swift
//  FinalProject_Popescu_Tudor
//
//  Created by Tudor Popescu on 10/17/21.
//

import UIKit
import CoreData





//struct that holds the data

struct Section {
    init(title: String, options: [String], isOpen: Bool = false, titleAmount: Int, optionsAmount: [Int]) {
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

let red = UIColor(hexString: "#950101")
let green = UIColor(hexString: "#79D70F")
let orange = UIColor(hexString: "#FFB319")
var totalIncome: Int = 0
var totalExpenses: Int = 0
var balanceAmount: Int = 0
let years = ["2021", "2022", "2023", "2024", "2025"]
let months: [String] = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]



class BudgetViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    // CORE DATA //
    func getBalance() {
        balanceAmount = sections[0].titleAmount - sections[1].titleAmount
        sections[2].titleAmount = 0
        sections[2].changeTitleAmount(option: balanceAmount)
        self.tableView.reloadData()
    }
    
    func getTable() {
        
        let fetchReq: NSFetchRequest<IncomeTable>
        fetchReq = IncomeTable.fetchRequest()
        
        fetchReq.predicate = NSPredicate(
        format: "month == %i AND year == %i AND userName = %@", monthNo, yearNo, userName
        )
        
        self.sections[0].optionsAmount.removeAll()
        self.sections[0].options.removeAll()
        self.sections[0].titleAmount = 0
        self.tableView.reloadData()
        
        
        do {
            let items = try context.fetch(fetchReq)
            
            print(items.count)
            
            
            for i in 0..<items.count {
                if (items.count != 0) {
                    sections[0].addOption(option: items[i].option!)
                    sections[0].addOptionAmount(option: items[i].optionAmount)
                    sections[0].changeTitleAmount(option: items[i].optionAmount)
                }
                print(items)
                getBalance()
                sendDataIncome()
                self.tableView.reloadData()
                
            }
            

        } catch {
            //error
        }
        
    }
    
    func getTableExp() {
        let fetchReqExp: NSFetchRequest<ExpenseTable>
        fetchReqExp = ExpenseTable.fetchRequest()
        
        fetchReqExp.predicate = NSPredicate(
            format: "month == %i AND year == %i AND userName = %@", monthNo, yearNo, userName
            )
        
        self.sections[1].optionsAmount.removeAll()
        self.sections[1].options.removeAll()
        self.sections[1].titleAmount = 0
        self.tableView.reloadData()
        
        do {
            let items = try context.fetch(fetchReqExp)
            
            print(items.count)
            
            
            for i in 0..<items.count {
                if (items.count != 0) {
                    sections[1].addOption(option: items[i].option!)
                    sections[1].addOptionAmount(option: items[i].optionAmount)
                    sections[1].changeTitleAmount(option: items[i].optionAmount)
                }
                
            }
            getBalance()
            sendDataIncome()
            self.tableView.reloadData()
            
        } catch {
            //error
        }
        
    }
    
    func createIncomeEntry(option: String, optionAmount: Int, monthNo: Int, yearNo: Int) {
        let newItem = IncomeTable(context: context)
        newItem.option = option
        newItem.optionAmount = optionAmount
        newItem.month = monthNo
        newItem.year = yearNo
        newItem.userName = userName
        
        do {
            try context.save()
            
            getTable()
        } catch {
            //error
        }

    }
    
    func createIncomeEntry2(balance: Int, monthNo: Int, yearNo: Int) {
        let newItem = BalanceRem(context: context)
        newItem.balance = balance
        newItem.month = monthNo
        newItem.year = yearNo
        newItem.userName = userName
        
        do {
            try context.save()
            
            getTable()
        } catch {
            //error
        }

    }
    
    
    
    func createExpenseEntry(option: String, optionAmount: Int, monthNo: Int, yearNo: Int) {
        let newItem = ExpenseTable(context: context)
        newItem.option = option
        newItem.optionAmount = optionAmount
        newItem.month = monthNo
        newItem.year = yearNo
        newItem.userName = userName
        
        do {
            try context.save()
            getTable()
        } catch {
            //error
        }

    }
    func createExpenseEntry2(option: String, optionAmount: Int, monthNo: Int, yearNo: Int) {
        let newItem = ExpRemaining(context: context)
        newItem.option = option
        newItem.optionAmount = optionAmount
        newItem.month = monthNo
        newItem.year = yearNo
        newItem.userName = userName
        
        do {
            try context.save()
            getTable()
        } catch {
            //error
        }

    }
    
    func deleteIncomeEntry(item: IncomeTable) {
        context.delete(item)
        sections[0].isOpen = false
        getTable()
        do {
            try context.save()
            getTable()
        } catch {
            //error
        }
    }
    
    func deleteIncomeEntry2(item: BalanceRem) {
        context.delete(item)
        getTable()
        
        do {
            try context.save()
            getTable()
        } catch {
            //error
        }
    }
    
    func deleteExpenseEntry(item: ExpenseTable) {
        context.delete(item)
        getTableExp()
       
        do {
            try context.save()
            getTableExp()
                    } catch {
            //error
        }
    }
    func deleteExpenseEntry2(item: ExpRemaining) {
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
    
    
    var monthNo: Int = 0
    var yearNo: Int = 0
    var tempMonth: String = "November"
    var tempYear: String = "2021"
    var tempMonthNo: Int = 0
    var tempYearNo: Int = 0
    var userName: String = ""
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userName = defaults.string(forKey: "userName")!
        monthNo = defaults.integer(forKey: "monthNo")
        yearNo = defaults.integer(forKey: "yearNo")
        inputMonthField.text = "\(defaults.string(forKey: "month")!), \(defaults.string(forKey: "year")!)"
        self.tableView.allowsSelectionDuringEditing = true
        getTable()
        getTableExp()
        datePicker = UIPickerView()
        datePicker?.dataSource = self
        datePicker?.delegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        view.addGestureRecognizer(tapGesture)
        tapGesture.delegate = self
        
        inputMonthField.inputView = datePicker
        
       
        
        
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
       get {
          return .portrait
       }
    }
    
    @objc func viewTapped() {
        
        view.endEditing(true)
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
        addIncomeCont.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = green3
        addIncomeCont.view.tintColor = black1
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
                
                
                self.createIncomeEntry(option: incomeText, optionAmount: amountText, monthNo: self.monthNo, yearNo: self.yearNo)
                self.createIncomeEntry2(balance: amountText, monthNo: self.monthNo, yearNo: self.yearNo)
                
                self.getTable()
                self.sendDataIncome()
                
            
              
            }
            
        })
        
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in self.dismiss(animated: true, completion: nil)})
        addIncomeCont.addAction(confirmAction)
        addIncomeCont.addAction(cancelAction)
        self.present(addIncomeCont, animated: true, completion: nil)
    }
    
    
    
    
    func presentAddExpense() {
        
        
        
        let addIncomeCont = UIAlertController(title: "Add Expense", message: nil, preferredStyle: .alert)
        addIncomeCont.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = green3
        addIncomeCont.view.tintColor = black1
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
                
                
                
                self.createExpenseEntry(option: incomeText, optionAmount: amountText, monthNo: self.monthNo, yearNo: self.yearNo)
                self.createExpenseEntry2(option: incomeText, optionAmount: amountText, monthNo: self.monthNo, yearNo: self.yearNo)
                self.getTableExp()
                self.sendDataExpense()
                
                
                
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
        firstTab.yearNo = yearNo
        

    }

    func sendDataIncome() {


        let Nav = self.tabBarController!.viewControllers![0] as! UINavigationController
        let Nav2 = self.tabBarController!.viewControllers![2] as! UINavigationController
        let firstTab = Nav.topViewController as! ViewController
        let thirdTab = Nav2.topViewController as! ChartViewController


        
        firstTab.monthNo = monthNo
        firstTab.yearNo = yearNo
        thirdTab.monthNo = monthNo
        thirdTab.yearNo = yearNo

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
                sections[0].isOpen = false
                getTable()
                getTableExp()
               
               
                
            }
            catch{
                
            }
                
                do {
                let items = try context.fetch(BalanceRem.fetchRequest())
                    let item = items[indexPath.row-1]
                    deleteIncomeEntry2(item: item)
                    sections[0].isOpen = false
                    getTable()
                    getTableExp()
                   
                   
                    
                }
                catch{
                    
                }
            } else if indexPath.section == 1 {
                
                do {
                let items = try context.fetch(ExpenseTable.fetchRequest())
                    let item = items[indexPath.row-1]
                    deleteExpenseEntry(item: item)
                    
                    getTableExp()
                }
                catch{
                    
                }
                do {
                let items = try context.fetch(ExpRemaining.fetchRequest())
                    let item = items[indexPath.row-1]
                    deleteExpenseEntry2(item: item)
                    
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
//            cell.backgroundColor = green2
//            cellName.textColor = green3
//            cellAmount.textColor = green3
            if indexPath.section == 0 {
                cell.backgroundColor = green2
                cellName.textColor = green3
                cellAmount.textColor = green3
            } else if indexPath.section == 1 {
                cell.backgroundColor = green2
                cellName.textColor = green3
                cellAmount.textColor = green3
            } else {

                if self.sections[2].titleAmount == 0 {
                    cell.backgroundColor = orange
                    cellName.textColor = black1
                    cellAmount.textColor = black1

                } else if self.sections[2].titleAmount < 0{
                    cell.backgroundColor = red
                    cellName.textColor = black1
                    cellAmount.textColor = black1

                } else {
                    cell.backgroundColor = green1
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
            
//            if indexPath.section == 0 {
//                cell.backgroundColor = green.withAlphaComponent(0.5)
//            } else {
//                cell.backgroundColor = red.withAlphaComponent(0.5)
//            }
//            
            
           
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
    @IBOutlet weak var inputMonthField: UITextField!
    private var datePicker: UIPickerView?
    
    
    @IBOutlet weak var monthLabel: UILabel!
    
    
    @IBAction func monthBtn(_ sender: Any) {
        let actionSheet = UIAlertController(title: "Select Month", message: "", preferredStyle: .actionSheet)
        
        for i in 0...11 {
            actionSheet.addAction(UIAlertAction(title: "\(months[i])", style: .default, handler: { _ in
                
                self.monthLabel.text = "\(months[i])"
                self.monthNo = i
                self.getTable()
                self.getTableExp()
                self.getBalance()
                self.sendDataIncome()
                print(self.monthNo)
                
            }))
        }
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    
    
    
  
    
}

extension BudgetViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {

        if component == 0 {
            return 12
        }
        return 5
    }
    
    
}



extension BudgetViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
       
        if component == 0 {
            for i in 0...11 {
                if row == i {
                    return months[i]
                }
            }
        } else {
            for i in 0...4 {
                if row == i {
                    return years[i]
        }
            }}
        return "test"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        
        if component == 0 {
            tempMonth = months[row]
            tempMonthNo = row
        } else if component == 1 {
            tempYear = years[row]
            tempYearNo = row
        }
        
       
        defaults.set(tempMonth, forKey: "month")
        defaults.set(tempYear, forKey: "year")
        defaults.set(tempMonthNo, forKey: "monthNo")
        defaults.set(tempYearNo, forKey: "yearNo")
        
        inputMonthField.text = "\(defaults.string(forKey: "month")!), \(defaults.string(forKey: "year")!)"
        self.monthNo = tempMonthNo
        self.yearNo = tempYearNo
        self.getTable()
        self.getTableExp()
        self.getBalance()
        self.sendDataIncome()
        print("month \(monthNo)")
        print("year \(yearNo)")
        
    }
}

extension BudgetViewController: UIGestureRecognizerDelegate {

func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
    if  touch.view!.isKind(of: UIButton.self) {
        return false
    } else if touch.view!.isKind(of: UITableView.self) || touch.view!.isKind(of: UITextField.self){
        view.endEditing(true)
        return true
    } else {
        return false
    }
    
    
}
    
}
