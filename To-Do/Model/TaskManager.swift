//
//  TaskManager.swift
//  To-Do
//
//  Created by Марат Хасанов on 18.06.2024.
//

import Foundation

class TaskManager {
    static let shared = TaskManager()
    private init() {}
    
    private let userDefaults = UserDefaults.standard
    private let tasksKey = "Tasks"
    
    func saveTasks(_ tasks: [TaskModel]) {
        do {
            let encodedData = try JSONEncoder().encode(tasks)
            userDefaults.set(encodedData, forKey: tasksKey)
        } catch {
            print("Ошибка при сохранении: \(error.localizedDescription)")
        }
    }
    
    func loadTasks() -> [TaskModel] {
        var tasks: [TaskModel] = []
        if let savedData = userDefaults.data(forKey: tasksKey) {
            do {
                tasks = try JSONDecoder().decode([TaskModel].self, from: savedData)
            } catch {
                print("Ощибка при загрузке: \(error.localizedDescription)")
            }
        }
        return tasks
    }
}
