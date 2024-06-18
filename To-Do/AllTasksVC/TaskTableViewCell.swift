//
//  TaskTableViewCell.swift
//  To-Do
//
//  Created by Марат Хасанов on 17.06.2024.
//

import UIKit

class TaskTableViewCell: UITableViewCell {
    
    static let reuseIdentifire = "TaskCell"
    private var taskIsDone: Bool = false
    
    lazy var taskNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textColor = .red
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var datePicker: UIDatePicker = {
       let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .automatic
        picker.locale = .current
        picker.date = .now
        //picker.addTarget(self, action: #selector(pickerDateChanged), for: .valueChanged)
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    private lazy var doneButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        button.setImage(UIImage(systemName: "seal"), for: .normal)
        button.setTitleColor(.systemGreen, for: .normal)

        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func doneButtonTapped() {
        if taskIsDone {
            doneButton.setImage(UIImage(systemName: "seal"), for: .normal)
            taskIsDone = false
        } else {
            doneButton.setImage(UIImage(systemName: "checkmark.seal.fill"), for: .normal)
            taskIsDone = true
        }
    }
    
    private func setupUI() {
        contentView.addSubview(taskNameLabel)
        contentView.addSubview(doneButton)
        contentView.addSubview(datePicker)
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            doneButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            doneButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            doneButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            datePicker.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            datePicker.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            taskNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            taskNameLabel.leadingAnchor.constraint(equalTo: doneButton.trailingAnchor, constant: 5)])
    }
}
