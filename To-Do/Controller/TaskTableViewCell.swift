//
//  TaskTableViewCell.swift
//  To-Do
//
//  Created by Марат Хасанов on 17.06.2024.
//

import UIKit

protocol TaskTableViewCellDelegate: AnyObject {
    func didUpdateTaskCompletion(task: TaskModel)
}

class TaskTableViewCell: UITableViewCell {
    //MARK: - Public Properties
    static let reuseIdentifire = "TaskCell"
    weak var delegate: TaskTableViewCellDelegate?
    
    var task: TaskModel?
    
    var taskIsDone: Bool = false {
        didSet {
            let imageName = taskIsDone ? "checkmark.seal.fill" : "seal"
            doneButton.setImage(UIImage(systemName: imageName), for: .normal)
        }
    }
    
    //MARK: - Private Properties
    private lazy var taskNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textColor = .red
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textColor = .red
        return label
    }()
    
    
    private lazy var doneButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        button.setImage(UIImage(systemName: "seal"), for: .normal)
        button.setTitleColor(.systemGreen, for: .normal)
        return button
    }()
    
    //MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Public Methods
    func configure(with task: TaskModel, delegate: TaskTableViewCellDelegate) {
        self.task = task
        self.delegate = delegate
        taskIsDone = task.completed
        taskNameLabel.text = task.name
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let formattedDate = dateFormatter.string(from: task.time)
        dateLabel.text = formattedDate
    }
    
    //MARK: - Private Methods
    @objc
    private func doneButtonTapped() {
        taskIsDone.toggle()
        task?.completed = taskIsDone
        if let updatedTask = task {
            delegate?.didUpdateTaskCompletion(task: updatedTask)
        }
    }
    
    private func setupUI() {
        let uiViews: [UIView] = [taskNameLabel, doneButton, dateLabel]
        uiViews.forEach { uiView in
            uiView.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(uiView)
        }
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            doneButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            doneButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            doneButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            dateLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            taskNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            taskNameLabel.leadingAnchor.constraint(equalTo: doneButton.trailingAnchor, constant: 5)])
    }
}
