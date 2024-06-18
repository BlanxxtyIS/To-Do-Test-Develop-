//
//  CreateTasksViewController.swift
//  To-Do
//
//  Created by Марат Хасанов on 17.06.2024.
//

import UIKit


class CreateTaskViewController: UIViewController {
    
    var task: TaskModel?
    
    private lazy var taskName: UITextField = {
        let taskName = UITextField()
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.systemGray]
        taskName.attributedPlaceholder = NSAttributedString(string: "Название", attributes: attributes)
        taskName.textColor = .black
        
        taskName.layer.borderWidth = 1.0
        taskName.layer.borderColor = UIColor.systemGray.cgColor
        taskName.layer.cornerRadius = 5.0
        taskName.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        //Отступ от левого края
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: taskName.frame.height))
        
        taskName.leftView = paddingView
        taskName.leftViewMode = .always
        taskName.delegate = self
        taskName.translatesAutoresizingMaskIntoConstraints = false
        return taskName
    }()
    
    private lazy var datePicker: UIDatePicker = {
       let picker = UIDatePicker()
        picker.datePickerMode = .dateAndTime
        picker.preferredDatePickerStyle = .automatic
        picker.locale = .current
        picker.date = .now
        picker.addTarget(self, action: #selector(pickerDateChanged), for: .valueChanged)
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    private lazy var descriptionText: UITextView = {
        let description = UITextView()
        description.text = "Описание"
        description.textColor = .black
        description.isEditable = true
        description.center = self.view.center
        description.font = .systemFont(ofSize: 20, weight: .medium)
        description.delegate = self
        description.translatesAutoresizingMaskIntoConstraints = false
        return description
    }()
    
    private lazy var createTaskButton: UIButton = {
       let button = UIButton()
        button.backgroundColor = .blue
        button.setTitle("Сохранить", for: .normal)
        button.addTarget(self, action: #selector(createTaskButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        taskName.text = task?.name
        datePicker.date = task?.time ?? Date()
        descriptionText.text = task?.description
        title = "Создать задачу"
        view.backgroundColor = .white
        setupUI()
    }
    
    @objc
    func createTaskButtonTapped() {
        let task = TaskModel(id: UUID().uuidString, name: taskName.text ?? "", time: datePicker.date, description: descriptionText.text)
        dismiss(animated: true)
    }
    
    private func setupUI() {
        view.addSubview(taskName)
        view.addSubview(datePicker)
        view.addSubview(descriptionText)
        view.addSubview(createTaskButton)
        setupConstaints()
    }
    
    private func setupConstaints() {
        NSLayoutConstraint.activate([
            taskName.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            taskName.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            taskName.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            datePicker.topAnchor.constraint(equalTo: taskName.bottomAnchor, constant: 10),
            datePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
        
            descriptionText.topAnchor.constraint(equalTo: datePicker
                .bottomAnchor, constant: 10),
            descriptionText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            descriptionText.bottomAnchor.constraint(equalTo: createTaskButton.topAnchor, constant: 10),
            
            createTaskButton.heightAnchor.constraint(equalToConstant: 55),
            createTaskButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            createTaskButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            createTaskButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 10)])
    }
    
    @objc
    private func pickerDateChanged() {
        print(datePicker.date)
    }
    
}

extension CreateTaskViewController: UITextFieldDelegate {
    // Скрыть клавиатуру
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Получаем текущий текст
        if let currentText = textField.text, let textRange = Range(range, in: currentText) {
            let updatedText = currentText.replacingCharacters(in: textRange, with: string)
            
            print(updatedText)
        }
        return true
    }
}

extension CreateTaskViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        if let textView = textView.text {
            print(textView)
        }
    }
}

