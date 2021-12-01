//
//  SignInViewController.swift
//  FinalProject_Popescu_Tudor
//
//  Created by Tudor Popescu on 10/24/21.
//

import UIKit

let defaults = UserDefaults.standard

class SignInViewController: UIViewController {
    
    
    
    
    var loginDictionary: [String:String] = ["admin" : "admin"]
    
    
    @IBAction func SignIn(_ sender: Any) {
        
        self.presentSignIn()
    }
    
    
    @IBAction func SignUp(_ sender: Any) {
        
        self.presentSignUp()
    }
    
    
    
    
    func presentSignIn () {
        
        let signInCont = UIAlertController(title: "Sign In", message: nil, preferredStyle: .alert)
        signInCont.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = green3
        signInCont.view.tintColor = black1
        signInCont.addTextField{ (textfield) in
            textfield.placeholder = "Enter Username"
        }
        signInCont.addTextField{ (textfield) in
            textfield.placeholder = "Enter Password"
            textfield.isSecureTextEntry = true
        }
        
        let signInAction = UIAlertAction(title: "Sign In", style: .default, handler: {_ in
            guard let textfield = signInCont.textFields else {return}
            
            let userName = textfield[0].text
            let passWord = textfield[1].text
            
            if  (userName?.count != 0 && passWord?.count != 0) {
                
                
                
                do {
                    let items = try context.fetch(LoginDictionary.fetchRequest())
                    for i in 0..<items.count {
                        self.loginDictionary[items[i].userName!] = items[i].passWord
                        
                        if self.loginDictionary[userName!] == passWord! {
                            defaults.set(userName, forKey: "userName")
                            self.performSegue(withIdentifier: "login", sender: self)
                            print("matches")
                        }else {
                            self.createAlert(title: "Invalid Entry!", msg: "Combination of User Name and Password is not valid")
                        }
                        
                    } } catch {
                    print("error")
                }
                
                
                
                
                
            } else {
                self.createAlert(title: "Missing Entry!", msg: "Missing User Name or Password")
            }
                
                
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in self.dismiss(animated: true, completion: nil)})
        signInCont.addAction(signInAction)
        signInCont.addAction(cancelAction)
        self.present(signInCont, animated: true, completion: nil)
        
    }
    
    func createAlert(title: String, msg:String) {
        let alert = UIAlertController(title: title, message: msg , preferredStyle: .alert)
        alert.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = green1
        alert.view.tintColor = black1
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: {_ in }))
        
        self.present(alert, animated: true, completion: nil)
        
                
    }
    
    
    func presentSignUp () {
        
        let signUpCont = UIAlertController(title: "Sign Up", message: nil, preferredStyle: .alert)
        signUpCont.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = green3
        signUpCont.view.tintColor = black1
        signUpCont.addTextField{ (textfield) in
            textfield.placeholder = "Enter Username"
        }
        signUpCont.addTextField{ (textfield) in
            textfield.placeholder = "Enter Password"
            textfield.isSecureTextEntry = true
        }
        
        signUpCont.addTextField{ (textfield) in
            textfield.placeholder = "Confirm Password"
            textfield.isSecureTextEntry = true
        }
        
        let signUpAction = UIAlertAction(title: "Sign Up", style: .default, handler: {_ in
            guard let textfield = signUpCont.textFields else {return}
            
            let userName = textfield[0].text
            let passWord = textfield[1].text
            let confirmPassWord = textfield[2].text
            
            if  (userName?.count != 0 && passWord?.count != 0 && confirmPassWord?.count != 0) {
                if confirmPassWord! == passWord! {
                    
                    if self.loginDictionary.keys.contains(userName!) {
                        self.createAlert(title: "User Exists!", msg: "The User Name is already taken")
                    } else {
                    
                    
                    self.createEntry(userName: userName! ,passWord: passWord!)
                    defaults.set(userName, forKey: "userName")
                    self.performSegue(withIdentifier: "login", sender: self)
                    }
                    
                } else {
                    self.createAlert(title: "Password Don't Match!", msg: "Password and Confirm Password do not match")
                }
                
            } else {
                self.createAlert(title: "Missing Entry", msg: "Missing User Name, or Password, or Confirm Password")
            }
                
                
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in self.dismiss(animated: true, completion: nil)})
        signUpCont.addAction(signUpAction)
        signUpCont.addAction(cancelAction)
        self.present(signUpCont, animated: true, completion: nil)
        
    }
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDictionary()
        self.navigationController?.isNavigationBarHidden = true
    }
    
    
    
    
    // CORE DATA //
    
    
    func getDictionary() {
        do {
            let items = try context.fetch(LoginDictionary.fetchRequest())
            for i in 0..<items.count {
                loginDictionary[items[i].userName!] = items[i].passWord

            }
            
            print(items, items.count, loginDictionary)
        } catch {
            //error
        }
        
    }
    
    func createEntry(userName: String, passWord: String) {
     
        
        
        
        let newItem = LoginDictionary(context: context)
        newItem.userName = userName
        newItem.passWord = passWord
        
        do {
            try context.save()
        } catch {
            
        }
        
    }
    
    func deleteEntry (item: LoginDictionary) {
        
        context.delete(item)
        
        do{
            try context.save()
        } catch {
            //error
        }
        
    }
    
   
    
    
    
   
}

let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


