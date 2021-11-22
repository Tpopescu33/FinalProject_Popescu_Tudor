//
//  SettingsTableViewController.swift
//  FinalProject_Popescu_Tudor
//
//  Created by Tudor Popescu on 11/21/21.
//

import UIKit

struct settings {
    init(title: String, isSwitched: Bool, label: String) {
        self.title = title
        self.isSwitched = false
        self.label = label
    }
    var title: String
    var isSwitched: Bool
    var label: String
}

class SettingsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        stayLoggedIn()

      
    }
    
    override func viewDidAppear(_ animated: Bool) {
        stayLoggedIn()
    }
    
    @IBAction func stayLoggedIn(_ sender: Any) {
        
    }
    func stayLoggedIn () {
        
        if sections[1].isSwitched == true {
            
            print(defaults.bool(forKey: "isUserLoggedIn"))
        } else if sections[1].isSwitched == false {
            
            print(defaults.bool(forKey: "isUserLoggedIn"))
        }
        
    }
    
    var sections = [
                    settings(title: "Stay Logged In", isSwitched: defaults.bool(forKey: "isUserLoggedIn"), label: ""),
                    settings(title: "Version:", isSwitched: false, label: "1.0"),
                    settings(title: "Developed by:", isSwitched: false, label: "Tudor Popescu"),
                    settings(title: "Log Out", isSwitched: false, label: "")
                    ]
   

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    @objc func didChangeSwitch(_ sender: UISwitch){
        if sender.isOn {
            defaults.set(true, forKey: "isUserLoggedIn")
            print(defaults.bool(forKey: "isUserLoggedIn"))
            
        } else {
            defaults.set(false, forKey: "isUserLoggedIn")
               print(defaults.bool(forKey: "isUserLoggedIn"))
           
        }
    }
    
  
    
    
    
 
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell1 = tableView.dequeueReusableCell(withIdentifier: "switch", for: indexPath)
        let cell2 = tableView.dequeueReusableCell(withIdentifier: "doubleLabel", for: indexPath)
        let cell3 = tableView.dequeueReusableCell(withIdentifier: "withButton", for: indexPath)
        let cell1Title = cell1.viewWithTag(10) as! UILabel
        let cell1Switch = cell1.viewWithTag(11) as! UISwitch
        let cell2Title = cell2.viewWithTag(12) as! UILabel
        let cell2Label = cell2.viewWithTag(13) as! UILabel
        let cell3Title = cell3.viewWithTag(14) as! UILabel
        
         if indexPath.section == 0{
            cell1Title.text = self.sections[indexPath.section].title
            cell1Switch.addTarget(self, action: #selector(didChangeSwitch(_:)), for: .valueChanged)
            cell1Switch.isOn = defaults.bool(forKey: "isUserLoggedIn")
            cell1.accessoryView = cell1Switch
            cell1.backgroundColor = green2
            cell1Title.textColor = green3
            return cell1
        
            
        } else if indexPath.section == 1{
            cell2Title.text = self.sections[indexPath.section].title
            cell2Label.text = self.sections[indexPath.section].label
            cell2.backgroundColor = green2
            cell2Title.textColor = green3
            cell2Label.textColor = green3

            return cell2
            
        } else if indexPath.section == 2{
            cell2Title.text = self.sections[indexPath.section].title
            cell2Label.text = self.sections[indexPath.section].label
            cell2.backgroundColor = green2
            cell2Title.textColor = green3
            cell2Label.textColor = green3
           

            return cell2
        } else {
            cell3Title.text = self.sections[indexPath.section].title
            cell3.backgroundColor = green2
            cell3Title.textColor = green3
            
            
            return cell3
        }

        
    }
    
    func logOut() {
        
        let logOutCont = UIAlertController(title: "Log Out", message: "Are you sure you wish to log out?", preferredStyle: .alert)
        logOutCont.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = green3
        logOutCont.view.tintColor = black1
        
        let logOutAction = UIAlertAction(title: "Log Out", style: .default, handler: {_ in
           
            
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in self.dismiss(animated: true, completion: nil)})
        
        logOutCont.addAction(logOutAction)
        logOutCont.addAction(cancelAction)
        self.present(logOutCont, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 3 {
            logOut()
        }
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
