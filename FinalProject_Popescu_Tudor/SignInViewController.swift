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
        
        self.presentSignUp()
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
                
                
                
                do {
                    let items = try context.fetch(LoginDictionary.fetchRequest())
                    for i in 0..<items.count {
                        self.loginDictionary[items[i].userName!] = items[i].passWord
                        
                        if self.loginDictionary[userName!] == passWord! {
                            self.performSegue(withIdentifier: "login", sender: self)
                            print("matches")
                        } else {
                            return
                        }
                        
                    } } catch {
                    print("error")
                }
                
                
                
                
                
            } else { return }
                
                
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in self.dismiss(animated: true, completion: nil)})
        signInCont.addAction(signInAction)
        signInCont.addAction(cancelAction)
        self.present(signInCont, animated: true, completion: nil)
        
    }
    
    
    func presentSignUp () {
        
        let signUpCont = UIAlertController(title: "Sign In", message: nil, preferredStyle: .alert)
        signUpCont.addTextField{ (textfield) in
            textfield.placeholder = "Enter Username"
        }
        signUpCont.addTextField{ (textfield) in
            textfield.placeholder = "Enter Password"
        }
        
        signUpCont.addTextField{ (textfield) in
            textfield.placeholder = "Confirm Password"
        }
        
        let signUpAction = UIAlertAction(title: "Sign Up", style: .default, handler: {_ in
            guard let textfield = signUpCont.textFields else {return}
            
            let userName = textfield[0].text
            let passWord = textfield[1].text
            let confirmPassWord = textfield[2].text
            
            if  (userName?.count != 0 && passWord?.count != 0 && confirmPassWord?.count != 0) {
                if confirmPassWord! == passWord! {
                    self.createEntry(userName: userName! ,passWord: passWord!)
                    self.performSegue(withIdentifier: "login", sender: self)
                    
                } else {
                    return
                }
                
            } else { return }
                
                
            
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
    
    
    override func viewDidAppear(_ animated: Bool) {
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


