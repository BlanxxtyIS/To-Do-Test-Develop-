//
//  TaskModel.swift
//  To-Do
//
//  Created by Марат Хасанов on 18.06.2024.
//

import UIKit

struct TaskModel: Codable {
    let id: String
    let name: String
    let time: Date
    let description: String
    var completed: Bool
    var imageData: Data?
    
    enum CodingKeys: String, CodingKey {
        case id, name, time, description, completed, imageData
    }
    
    init(id: String, name: String, time: Date, description: String, completed: Bool, image: UIImage?) {
        self.id = id
        self.name = name
        self.time = time
        self.description = description
        self.completed = completed
        self.imageData = image?.jpegData(compressionQuality: 1.0)
    }
}

