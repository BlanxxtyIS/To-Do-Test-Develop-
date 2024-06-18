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
        setupViewControllers()
    }
    
    private func setupViewControllers() {
        let allTasksViewController = AllTasksViewController()
        let createTaskViewController = CreateTaskViewController()
        
        createTaskViewController.delegate = allTasksViewController
        
        let allTasksNavController = createNewViewController(for: allTasksViewController, 
                                                            title: "Tasks",
                                                            imageName: "border")
        let createTaskNavController = createNewViewController(for: createTaskViewController, 
                                                              title: "Create task",
                                                              imageName: "crop")
        
        viewControllers = [allTasksNavController, createTaskNavController]
    }
    
    private func createNewViewController(for rootViewController: UIViewController,
                                         title: String,
                                         imageName: String) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = UIImage(named: imageName)
        return navController
    }
}
