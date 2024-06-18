//
//  TaskModel.swift
//  To-Do
//
//  Created by Марат Хасанов on 18.06.2024.
//

import Foundation

struct TaskModel: Codable {
    let id: String
    let name: String
    let time: Date
    let description: String
}

extension UserDefaults {
    // Ключ для хранения задач в UserDefaults
    private static let tasksKey = "tasksKey"
    
    // Метод для сохранения задач в UserDefaults
    func setTasks(_ tasks: [TaskModel]) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(tasks) {
            set(encoded, forKey: UserDefaults.tasksKey)
        }
    }
    
    // Метод для извлечения задач из UserDefaults
    func getTasks() -> [TaskModel]? {
        if let savedTasksData = data(forKey: UserDefaults.tasksKey) {
            let decoder = JSONDecoder()
            if let tasks = try? decoder.decode([TaskModel].self, from: savedTasksData) {
                return tasks
            }
        }
        return nil
    }
}
