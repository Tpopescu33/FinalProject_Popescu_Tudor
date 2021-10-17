//
//  ViewController.swift
//  FinalProject_Popescu_Tudor
//
//  Created by Tudor Popescu on 10/16/21.
//

import UIKit

struct Sections: Codable {
    let title: String
    let options: [String]
    let isOpen: Bool
    
    init() {
        self.title = ""
        self.options = [""]
        self.isOpen = false
    }
    
    
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
   
    
    var sections = [Sections]()
    

    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let section = sections[section]
        
        if section.isOpen {
            return section.options.count + 1
        } else {
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "incomeCell")
            cell.textLabel?.text = sections[indexPath.section].title
        
        
            return cell
        }
        return UITableViewCell()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    

    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label1: UILabel!
    
    
    @IBOutlet weak var IncomeTable: UITableView!
    
    @IBOutlet weak var AddExpenseButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
       
        
    }
    
    

}
