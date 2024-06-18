//
//  AllTasksViewController.swift
//  To-Do
//
//  Created by Марат Хасанов on 17.06.2024.
//

import UIKit

class AllTasksViewController: UIViewController {
    
    var tasks: [[TaskModel]] = [
        [TaskModel(id: UUID().uuidString, name: "Сдать тех-задание", time: Date(), description: "Создать мини To-Do приложение"), TaskModel(id: UUID().uuidString, name: "Перепрочитать про GCD", time: Date(), description: "Подкрепить знания про многопоточность")],
        [TaskModel(id: UUID().uuidString, name: "Доделать конспекты в PDF", time: Date(), description: "Закриншотить все учебные материалы"), TaskModel(id: UUID().uuidString, name: "SwiftUI", time: Date(), description: "Просмотреть и изучить курс Angella")],
        [TaskModel(id: UUID().uuidString, name: "Приложение склада", time: Date(), description: "Додлеать приложение оптимизации склада, почистить код и привести логику в порядок ")]
    ]
    
    let newTask = CreateTaskViewController()

    
    private let tasksHeaders = ["Просроченные", "Сегодня",
                                "Завтра","На неделе", "Позже"]
    
    private let taskCellReuseIdentifire = TaskTableViewCell.reuseIdentifire
    
    private lazy var allTasksTableView: UITableView = {
        let table = UITableView()
        table.register(TaskTableViewCell.self, forCellReuseIdentifier: taskCellReuseIdentifire)
        table.backgroundColor = .clear
        table.layer.cornerRadius = 16
        table.delegate = self
        table.dataSource = self
        table.sectionHeaderHeight = 30
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Задачи"
        view.backgroundColor = .white
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("Приветики")
    }

    
    private func setupUI() {
        view.addSubview(allTasksTableView)
        setupConstraints()
        let rightButtonItem = UIBarButtonItem(title: "Сортировать", image: UIImage(systemName: "line.horizontal.3.decrease"), target: self, action: #selector(rightButtonAction), menu: .none)
        navigationItem.rightBarButtonItem = rightButtonItem
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            allTasksTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            allTasksTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            allTasksTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            allTasksTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)])
    }
    @objc
    private func rightButtonAction() {
        print("Сортировка")
    }
}

extension AllTasksViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let taskSection = tasks[section]
        return taskSection.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: taskCellReuseIdentifire, for: indexPath) as! TaskTableViewCell
        cell.taskNameLabel.text = tasks[indexPath.section][indexPath.row].name
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tasksHeaders[section]
    }
}

extension AllTasksViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    // Удаление ячейки
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Удаляем задачу из исходных данных
            tasks[indexPath.section].remove(at: indexPath.row)
            
            // Удаляем строку из таблицы
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = tasks[indexPath.section][indexPath.row]
        let vc = CreateTaskViewController()
        vc.task = task
        present(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
}

