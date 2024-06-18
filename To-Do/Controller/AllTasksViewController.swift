//
//  AllTasksViewController.swift
//  To-Do
//
//  Created by Марат Хасанов on 17.06.2024.
//

import UIKit

enum SortingType {
    case byCompletion
    case byDate
}

class AllTasksViewController: UIViewController {
    //MARK: - Public Properties
    var tasks: [TaskModel] = []
    let newTask = CreateTaskViewController()
    
    //MARK: - Private Properties
    private let shared = TaskManager.shared
    private var currentSortingType: SortingType = .byCompletion
    
    private let taskCellReuseIdentifire = TaskTableViewCell.reuseIdentifire
    
    private lazy var allTasksTableView: UITableView = {
        let table = UITableView()
        table.register(TaskTableViewCell.self, 
                       forCellReuseIdentifier: taskCellReuseIdentifire)
        table.backgroundColor = .white
        table.layer.cornerRadius = 16
        table.delegate = self
        table.dataSource = self
        table.sectionHeaderHeight = 30
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Задачи"
        view.backgroundColor = .white
        loadAndUpdateView()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadAndUpdateView()
    }

    //MARK: - Private Methods
    //Сортировка
    @objc
    private func rightButtonAction() {
        let sortByCompletionAction = UIAction(title: "По выполненным") { [weak self] _ in
            self?.currentSortingType = .byCompletion
            self?.sortTasksAndUpdateView()
        }
        
        let sortByDateAction = UIAction(title: "По дате") { [weak self] _ in
            self?.currentSortingType = .byDate
            self?.sortTasksAndUpdateView()
        }
        
        let menu = UIMenu(title: "Сортировка", children: [sortByCompletionAction, sortByDateAction])
        
        let rightButton = UIBarButtonItem(title: "Сортировать",
                                          image: UIImage(systemName: "line.horizontal.3.decrease"),
                                          primaryAction: nil,
                                          menu: menu)
        
        navigationItem.rightBarButtonItem = rightButton
        setAndUpdateView(tasks: tasks)
    }
    
    private func sortTasksAndUpdateView() {
        switch currentSortingType {
        case .byCompletion:
            tasks.sort { $0.completed && !$1.completed }
        case .byDate:
            tasks.sort { $0.time < $1.time }
        }
        allTasksTableView.reloadData()
    }
    
    private func loadAndUpdateView() {
        let loadedTasks = shared.loadTasks()
        tasks = loadedTasks
        allTasksTableView.reloadData()
    }
    
    private func setAndUpdateView(tasks: [TaskModel]) {
        shared.saveTasks(tasks)
        loadAndUpdateView()
    }
    
    private func setupUI() {
        view.addSubview(allTasksTableView)
        setupConstraints()
        let rightButtonItem = UIBarButtonItem(title: "Сортировать", 
                                              image: UIImage(systemName: "line.horizontal.3.decrease"),
                                              target: self,
                                              action: #selector(rightButtonAction),
                                              menu: .none)
        navigationItem.rightBarButtonItem = rightButtonItem
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            allTasksTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            allTasksTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            allTasksTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            allTasksTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, 
                                                      constant: -20)])
    }
}

//MARK: - UITableView
extension AllTasksViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: taskCellReuseIdentifire, for: indexPath) as! TaskTableViewCell
        let task = tasks[indexPath.row]
        cell.configure(with: task, delegate: self)
        cell.taskIsDone = tasks[indexPath.row].completed
        cell.backgroundColor = .white
        cell.selectionStyle = .none
        return cell
    }
}

extension AllTasksViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    // Удаление ячейки
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            shared.saveTasks(tasks)
            loadAndUpdateView()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = tasks[indexPath.row]
        let vc = CreateTaskViewController()
        vc.delegate = self
        vc.task = task
        present(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
}

//MARK: - CreateTaskViewControllerDelegate
extension AllTasksViewController: CreateTaskViewControllerDelegate {
    func didCreateTask(_ task: TaskModel) {
        var allTasks = tasks
        
        if let index = allTasks.firstIndex(where: { $0.id == task.id }) {
            allTasks[index] = task 
        } else {
            allTasks.append(task)
        }
        setAndUpdateView(tasks: allTasks)
    }
}

//MARK: - TaskTableViewCellDelegate
extension AllTasksViewController: TaskTableViewCellDelegate {
    func didUpdateTaskCompletion(task: TaskModel) {
        if let rowIndex = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[rowIndex] = task
            setAndUpdateView(tasks: tasks)
        }
    }
}
