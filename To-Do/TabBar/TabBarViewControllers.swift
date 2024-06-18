//
//  TabBarViewControllers.swift
//  To-Do
//
//  Created by Марат Хасанов on 17.06.2024.
//

import UIKit

class TabBarViewControllers: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = createViewController()
    }
    
    private func createViewController() -> [UIViewController] {
        let allTasksViewController = createNewViewController(for: AllTasksViewController(), title: "Tasks", imageName: "border")
        let createTaskViewController = createNewViewController(for: CreateTaskViewController(), title: "Create task", imageName: "crop")
        return [allTasksViewController, createTaskViewController]
    }
    
    private func createNewViewController(for rootViewController: UIViewController,
                                         title: String,
                                         imageName: String) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        let tabBarItem = UITabBarItem(title: title, image: UIImage(named: imageName), tag: 0)
        navController.tabBarItem = tabBarItem
        return navController
    }
}
