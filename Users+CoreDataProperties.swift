//
//  Users+CoreDataProperties.swift
//  
//
//  Created by Javier Gandia on 04/12/2019.
//
//

import Foundation
import CoreData


extension Users {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Users> {
        return NSFetchRequest<Users>(entityName: "Users")
    }

    @NSManaged public var id: String?

}
