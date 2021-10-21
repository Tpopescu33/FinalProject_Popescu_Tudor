//
//  AddExpenseViewController.swift
//  FinalProject_Popescu_Tudor
//
//  Created by Tudor Popescu on 10/17/21.
//

import UIKit

protocol AddExpense {
    func addExpenseItem(setOptions: String, setOptionsAmount: Int)
}

class AddExpenseViewController: UIViewController{
    
    
    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var amountLabel: UITextField!
    var amountText: Int {return Int(amountLabel.text!) ?? 0}
    var delegateExpense: AddExpense?

    @IBAction func confirmBtn(_ sender: Any) {
        
        if nameLabel.text?.count != 0 && amountLabel.text?.count != 0 {
            var amountText: Int {return Int(amountLabel.text!) ?? 0}
            
            
            delegateExpense?.addExpenseItem(setOptions: nameLabel.text!, setOptionsAmount: amountText)
            self.performSegue(withIdentifier: "addExpenseToHome", sender: nil)
            
            
        }
    }
    
    
    @IBAction func cancelBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "addExpenseToHome", let destination = segue.destination as? TableViewController{
            guard let setOptions = self.nameLabel.text else {return}
            
            destination.setOptions = setOptions
            destination.setOptionsAmount = amountText
        }
        
    
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
