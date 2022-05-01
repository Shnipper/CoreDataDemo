//
//  StorageManager.swift
//  CoreDataDemo
//
//  Created by Евгений Волошенко on 01.05.2022.
//

import Foundation
import CoreData
import UIKit

class StorageManager {
    
    static let shared = StorageManager()
    
    var taskList: [Task] = []
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private init() {}
    
    func save(_ taskName: String) {
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "Task", in: context) else { return }
        guard let task = NSManagedObject(entity: entityDescription, insertInto: context) as? Task else { return }
        task.title = taskName

        saveContext()
        fetchData()
    }
    
    func delete(taskIndex: Int) {
        
        let fetchRequest = Task.fetchRequest()
        
        do {
            let tasks = try context.fetch(fetchRequest)
            for task in tasks {
                if task == taskList[taskIndex] {
                    context.delete(task)
                }
            }
        } catch let error {
            print("Failed to delete data", error)
        }
    
        saveContext()
        fetchData()
    }
    
    func fetchData(){

        let fetchRequest = Task.fetchRequest()
        do {
            taskList = try context.fetch(fetchRequest)
        } catch let error {
            print("Failed to fetch data", error)
        }
    }
    
    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch let error {
                print(error)
            }
        }
    }
}
