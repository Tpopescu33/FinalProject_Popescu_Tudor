//
//  ExpPaid+CoreDataProperties.swift
//  FinalProject_Popescu_Tudor
//
//  Created by Tudor Popescu on 10/30/21.
//
//

import Foundation
import CoreData


extension ExpPaid {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ExpPaid> {
        return NSFetchRequest<ExpPaid>(entityName: "ExpPaid")
    }

    @NSManaged public var optionAmount: Int
    @NSManaged public var option: String?
    @NSManaged public var month: Int
    @NSManaged public var year: Int


}

extension ExpPaid : Identifiable {

}
