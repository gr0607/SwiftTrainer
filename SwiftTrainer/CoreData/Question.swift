//
//  Question.swift
//  SwiftTrainer
//
//

import Foundation
import CoreData

@objc(Question)
public class Question: NSManagedObject {
    @NSManaged public var questionText: String
    @NSManaged public var answer1: String
    @NSManaged public var answer2: String
    @NSManaged public var answer3: String
    @NSManaged public var answer4: String
    @NSManaged public var correctAnswer: Int16
    @NSManaged public var hint: String
    
    @NSManaged public var parentSubCategory: SubCategory
}


extension Question {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Question> {
        return NSFetchRequest<Question>(entityName: "Question")
    }
}
