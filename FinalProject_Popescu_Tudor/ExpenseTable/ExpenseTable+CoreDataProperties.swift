//
//  ExpenseTable+CoreDataProperties.swift
//  FinalProject_Popescu_Tudor
//
//  Created by Tudor Popescu on 10/30/21.
//
//

import Foundation
import CoreData


extension ExpenseTable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ExpenseTable> {
        return NSFetchRequest<ExpenseTable>(entityName: "ExpenseTable")
    }

    @NSManaged public var option: String?
    @NSManaged public var optionAmount: Int
    @NSManaged public var month: Int

}

extension ExpenseTable : Identifiable {

}
