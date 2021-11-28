//
//  ChartViewController.swift
//  FinalProject_Popescu_Tudor
//
//  Created by Tudor Popescu on 11/27/21.
//

import UIKit
import CoreData
import Charts


class ChartViewController: UIViewController {
    @IBOutlet weak var barChartView: BarChartView!
    @IBOutlet weak var pieChartView: PieChartView!
    @IBOutlet weak var segBar: UISegmentedControl!
    var monthNo: Int = 0
    var yearNo: Int = 0
    var userName: String = ""
    var tempRemEntries: Int = 0
    var tempPaidEntries: Int = 0
    var tempPaidArray: [Double] = []
    
    @IBAction func segBarControl(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 1 {
            pieChartView.isHidden = true
            barChartView.isHidden = false
        } else if sender.selectedSegmentIndex == 0 {
            pieChartView.isHidden = false
            barChartView.isHidden = true
        }
    }
    
    func getExpRemaining1() {
        
        let fetchReq: NSFetchRequest<ExpRemaining>
        fetchReq = ExpRemaining.fetchRequest()
        
        
        fetchReq.predicate = NSPredicate(
            format: "month == %i AND year == %i AND userName = %@", monthNo, yearNo, userName
        )
        tempRemEntries = 0
        
       
        do {
            let items = try context.fetch(fetchReq)
            print(monthNo,yearNo,userName,"testing")
            print(items)
            
           
            for i in 0..<items.count {
                if (items.count != 0) {
                    tempRemEntries += items[i].optionAmount
                    
                }
                
                
            }
            

        } catch {
            print("error getexpremaining" )
        }
            
       
        
        
    }
    
    func getExpPaid1() {
        
        let fetchReq: NSFetchRequest<ExpPaid>
        fetchReq = ExpPaid.fetchRequest()
        
        fetchReq.predicate = NSPredicate(
            format: "month == %i AND year == %i AND userName = %@", monthNo, yearNo, userName
        )
        
        tempPaidEntries = 0
        
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
    func getExpPaid2() {
        
        let fetchReq: NSFetchRequest<ExpPaid>
        fetchReq = ExpPaid.fetchRequest()
        
        fetchReq.predicate = NSPredicate(
            format: "year == %i AND userName = %@", yearNo, userName
        )
        
        tempPaidArray = [0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0]
        
        do {
            let items = try context.fetch(fetchReq)
            
            print(items.count)
            
          
            for i in 0..<items.count {
                if (items.count != 0) {
                    if (items[i].month == 0) {
                        tempPaidArray[0] += Double(items[i].optionAmount)
                    }
                    if (items[i].month == 2) {
                        tempPaidArray[2] += Double(items[i].optionAmount)
                    }
                    if (items[i].month == 1) {
                        tempPaidArray[1] += Double(items[i].optionAmount)
                    }
                    if (items[i].month == 3) {
                        tempPaidArray[3] += Double(items[i].optionAmount)
                    }
                    if (items[i].month == 4) {
                        tempPaidArray[4] += Double(items[i].optionAmount)
                    }
                    if (items[i].month == 5) {
                        tempPaidArray[5] += Double(items[i].optionAmount)
                    }
                    if (items[i].month == 6) {
                        tempPaidArray[6] += Double(items[i].optionAmount)
                    }
                    if (items[i].month == 7) {
                        tempPaidArray[7] += Double(items[i].optionAmount)
                    }
                    if (items[i].month == 8) {
                        tempPaidArray[8] += Double(items[i].optionAmount)
                    }
                    if (items[i].month == 9) {
                        tempPaidArray[9] += Double(items[i].optionAmount)
                    }
                    if (items[i].month == 10) {
                        tempPaidArray[10] += Double(items[i].optionAmount)
                    }
                    if (items[i].month == 11) {
                        tempPaidArray[11] += Double(items[i].optionAmount)
                    }
                    
                }
                
                
               
                
            }
            

        } catch {
            print("error getexppaid")
        }
        
    }
    func getChart() {
        var entries : [ChartDataEntry] = []
        
        let dataEntryRem = PieChartDataEntry(value: Double(tempRemEntries), label: "Remaining Expenses")
        let dataEntryPaid = PieChartDataEntry(value: Double(tempPaidEntries), label: "Remaining Paid")
        entries.append(dataEntryRem)
        entries.append(dataEntryPaid)
        pieChartView.backgroundColor = green3
    let set = PieChartDataSet(entries: entries)
        
        set.colors = [red, green2]
        set.valueTextColor = black1
        set.formSize = 20
        set.entryLabelColor = black1
        
    let data = PieChartData(dataSet: set)
        pieChartView.data = data
        pieChartView.holeColor = green3
        
    }
    
    func getBarChart(){
        var entries : [ChartDataEntry] = []
        let months = ["","Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        for i in 0..<12 {
            entries.append(BarChartDataEntry(x:  Double(i+1), y: tempPaidArray[i]))
            
        }
        
        
        let set = BarChartDataSet(entries: entries)
        set.colors = [green1,green2,green1,green2,green1,green2,green1,green2,green1,green2,green1,green2]
        let data = BarChartData(dataSet: set)
        data.setDrawValues(true)
        
        barChartView.data = data
        barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: months)
        barChartView.rightAxis.enabled = false
        barChartView.leftAxis.axisMinimum = 0.0
        barChartView.xAxis.setLabelCount(13, force: false)
        barChartView.xAxis.labelRotationAngle = 0
        barChartView.xAxis.granularity = 1.0
        
        print(months)
    }
    
    override func viewDidAppear(_ animated: Bool) {
       
        userName = defaults.string(forKey: "userName")!
        monthNo = defaults.integer(forKey: "monthNo")
        yearNo = defaults.integer(forKey: "yearNo")
        getExpPaid1()
        getExpRemaining1()
        getExpPaid2()
        getChart()
        getBarChart()
        print(tempRemEntries, tempPaidEntries, monthNo, userName, yearNo)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        userName = defaults.string(forKey: "userName")!
        monthNo = defaults.integer(forKey: "monthNo")
        yearNo = defaults.integer(forKey: "yearNo")
        getExpPaid1()
        getExpRemaining1()
        getExpPaid2()
        getChart()
        getBarChart()
        print(tempRemEntries, tempPaidEntries, monthNo, userName, yearNo)
    
    

    }
    
    
    
    
}
