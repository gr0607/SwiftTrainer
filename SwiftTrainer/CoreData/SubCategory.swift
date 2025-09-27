//
//  SubCategory.swift
//  SwiftTrainer
//
//

import CoreData

@objc(SubCategory)
public class SubCategory: NSManagedObject {
    @NSManaged public var name: String
    @NSManaged public var parentCategory: Category
    
    @NSManaged public var questions: Set<Question>
}


extension SubCategory {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<SubCategory> {
        return NSFetchRequest<SubCategory>(entityName: "SubCategory")
    }
}
