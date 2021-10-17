//
//  ViewController.swift
//  FinalProject_Popescu_Tudor
//
//  Created by Tudor Popescu on 10/16/21.
//

import UIKit



class ViewController: UIViewController {
    
  
    
   
    


    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label1: UILabel!
    
    
    @IBOutlet weak var IncomeTable: UITableView!
    
    
    @IBAction func addExpenseBtn(_ sender: Any) {
        performSegue(withIdentifier: "addExpenseSeg", sender: self)
    }
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
       
        
    }
    
    

}
