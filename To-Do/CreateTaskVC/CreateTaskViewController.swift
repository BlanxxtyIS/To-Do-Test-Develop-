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
    
    private lazy var decription: UITextView = {
        let description = UITextView()
        description.text = "ВЫВЫВОФОВОФОВОФОВООВ"
        description.textColor = .black
        description.isEditable = true
        description.center = self.view.center
        description.font = .systemFont(ofSize: 20, weight: .medium)
        description.delegate = self
        description.translatesAutoresizingMaskIntoConstraints = false
        return description
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Hello")
        title = "Создать задачу"
        view.backgroundColor = .white
        setupUI()
        loadTaskData()
    }
    
    private func setupUI() {
        view.addSubview(taskName)
        view.addSubview(datePicker)
        view.addSubview(decription)
        setupConstaints()
    }
    
    private func setupConstaints() {
        NSLayoutConstraint.activate([
            taskName.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            taskName.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            taskName.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            datePicker.topAnchor.constraint(equalTo: taskName.bottomAnchor, constant: 10),
            datePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
        
            decription.topAnchor.constraint(equalTo: datePicker
                .bottomAnchor, constant: 10),
            decription.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            decription.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            decription.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)])
    }
    
    @objc
    private func pickerDateChanged() {
        print(datePicker.date)
    }
    
    private func loadTaskData() {
        guard let task = task else { return }
        taskName.text = task.name
        datePicker.date = task.time
        decription.text = task.description
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
