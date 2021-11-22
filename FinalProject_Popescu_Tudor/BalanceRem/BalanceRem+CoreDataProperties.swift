//
//  BalanceRem+CoreDataProperties.swift
//  FinalProject_Popescu_Tudor
//
//  Created by Tudor Popescu on 10/31/21.
//
//

import Foundation
import CoreData


extension BalanceRem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BalanceRem> {
        return NSFetchRequest<BalanceRem>(entityName: "BalanceRem")
    }

    @NSManaged public var balance: Int
    @NSManaged public var month: Int
    @NSManaged public var year: Int
    @NSManaged public var userName: String?

}

extension BalanceRem : Identifiable {

}
