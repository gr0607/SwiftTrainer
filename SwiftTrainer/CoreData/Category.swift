//
//  Category.swift
//  SwiftTrainer
//
//

import CoreData

@objc(Category)
public class Category: NSManagedObject {
    @NSManaged public var name: String
    @NSManaged public var subcategories: NSSet?
}


extension Category {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Category> {
        return NSFetchRequest<Category>(entityName: "Category")
    }
}
