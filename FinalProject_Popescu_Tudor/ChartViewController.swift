//
//  ChartViewController.swift
//  FinalProject_Popescu_Tudor
//
//  Created by Tudor Popescu on 11/27/21.
//

import UIKit
import Charts
import CoreData

class ChartViewController: UIViewController {
    @IBOutlet weak var pieChartView: PieChartView!
    var monthNo: Int = 0
    var yearNo: Int = 0
    var userName: String = ""
    var tempRemEntries: Int = 0
    var tempPaidEntries: Int = 0
    
    func getExpRemaining() {
        
        let fetchReq: NSFetchRequest<ExpRemaining>
        fetchReq = ExpRemaining.fetchRequest()
        
        fetchReq.predicate = NSPredicate(
            format: "month == %i AND year == %i AND userName = %@", monthNo, yearNo, userName
        )
        
       
        do {
            let items = try context.fetch(fetchReq)
            
            print(items.count)
            
           
            for i in 0..<items.count {
                if (items.count != 0) {
                    tempRemEntries += items[i].optionAmount
                    
                }
                
                
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
        
       
        do {
            let items = try context.fetch(fetchReq)
            
            print(items.count)
            
          
            for i in 0..<items.count {
                if (items.count != 0) {
                    tempPaidEntries += items[i].optionAmount
                }
                
                
               
                
            }
            

        } catch {
            print("error getexppaid")
        }
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getExpPaid()
        getExpRemaining()
        userName = defaults.string(forKey: "userName")!
        monthNo = defaults.integer(forKey: "monthNo")
        yearNo = defaults.integer(forKey: "yearNo")
        
        var entries : [ChartDataEntry] = []
        
        let dataEntryRem = PieChartDataEntry(value: Double(tempRemEntries), label: "Remaining Expenses")
        let dataEntryPaid = PieChartDataEntry(value: Double(tempPaidEntries), label: "Remaining Paid")
        entries.append(dataEntryRem)
        entries.append(dataEntryPaid)
        
    let set = PieChartDataSet(entries: entries)
        set.colors = ChartColorTemplates.colorful()
    let data = PieChartData(dataSet: set)
    
    pieChartView.data = data
    

    }
    
    
    
    
}
