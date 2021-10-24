//
//  SignInViewController.swift
//  FinalProject_Popescu_Tudor
//
//  Created by Tudor Popescu on 10/24/21.
//

import UIKit

class SignInViewController: UIViewController {
    
    
    
    
    var loginDictionary: [String:String] = ["admin" : "admin"]
    
    
    @IBAction func SignIn(_ sender: Any) {
        
        self.presentSignIn()
    }
    
    
    @IBAction func SignUp(_ sender: Any) {
    }
    
    
    func presentSignIn () {
        
        let signInCont = UIAlertController(title: "Sign In", message: nil, preferredStyle: .alert)
        signInCont.addTextField{ (textfield) in
            textfield.placeholder = "Enter Username"
        }
        signInCont.addTextField{ (textfield) in
            textfield.placeholder = "Enter Password"
        }
        
        let signInAction = UIAlertAction(title: "Sign In", style: .default, handler: {_ in
            guard let textfield = signInCont.textFields else {return}
            
            let userName = textfield[0].text
            let passWord = textfield[1].text
            
            if  (userName?.count != 0 && passWord?.count != 0) {
                if self.loginDictionary[userName!] == passWord! {
                    self.performSegue(withIdentifier: "login", sender: self)
                } else {
                    return
                }
                
            } else { return }
                
                
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in self.dismiss(animated: true, completion: nil)})
        signInCont.addAction(signInAction)
        signInCont.addAction(cancelAction)
        self.present(signInCont, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
