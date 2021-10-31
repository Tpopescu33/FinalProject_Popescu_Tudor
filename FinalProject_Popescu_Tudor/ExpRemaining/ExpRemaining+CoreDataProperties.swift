//
//  ExpRemaining+CoreDataProperties.swift
//  FinalProject_Popescu_Tudor
//
//  Created by Tudor Popescu on 10/30/21.
//
//

import Foundation
import CoreData


extension ExpRemaining {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ExpRemaining> {
        return NSFetchRequest<ExpRemaining>(entityName: "ExpRemaining")
    }

    @NSManaged public var optionAmount: Int
    @NSManaged public var option: String?
    @NSManaged public var month: Int

}

extension ExpRemaining : Identifiable {

}
