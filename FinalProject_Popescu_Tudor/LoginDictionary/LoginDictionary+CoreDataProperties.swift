//
//  LoginDictionary+CoreDataProperties.swift
//  FinalProject_Popescu_Tudor
//
//  Created by Tudor Popescu on 10/29/21.
//
//

import Foundation
import CoreData


extension LoginDictionary {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LoginDictionary> {
        return NSFetchRequest<LoginDictionary>(entityName: "LoginDictionary")
    }

    @NSManaged public var userName: String?
    @NSManaged public var passWord: String?
    

}

extension LoginDictionary : Identifiable {

}
