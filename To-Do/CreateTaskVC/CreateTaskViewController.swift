//
//  CreateTasksViewController.swift
//  To-Do
//
//  Created by Марат Хасанов on 17.06.2024.
//

import UIKit

protocol CreateTaskViewControllerDelegate: AnyObject {
    func didCreateTask(_ task: TaskModel)
}

class CreateTaskViewController: UIViewController {
    
    //MARK: - Public Properties
    weak var delegate: CreateTaskViewControllerDelegate?
    var task: TaskModel?
    
    //MARK: - Private Properties
    private var selectedImage: UIImage?
    
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
        return taskName
    }()
    
    private lazy var datePicker: UIDatePicker = {
       let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .automatic
        picker.addTarget(self, action: #selector(pickerDateChanged), for: .valueChanged)
        return picker
    }()
    
    private lazy var selectImageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Выбрать изображение", for: .normal)
        button.addTarget(self, action: #selector(selectImageFromGallery), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var dateAndSelectedImageStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [datePicker, selectImageButton])
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.alignment = .trailing
        stack.spacing = 40
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.systemGray.cgColor
        imageView.layer.cornerRadius = 5 
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var descriptionText: UITextView = {
        let description = UITextView()
        description.text = "Описание"
        description.textColor = .black
        description.isEditable = true
        description.layer.borderWidth = 1.0
        description.layer.borderColor = UIColor.systemGray.cgColor
        description.layer.cornerRadius = 5.0
        description.center = self.view.center
        description.font = .systemFont(ofSize: 20, weight: .medium)
        description.delegate = self
        return description
    }()
    
    private lazy var createTaskButton: UIButton = {
       let button = UIButton()
        button.backgroundColor = .blue
        button.setTitle("Сохранить", for: .normal)
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(createTaskButtonTapped), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        taskName.text = task?.name
        datePicker.date = task?.time ?? Date()
        descriptionText.text = task?.description
        if let image = task?.imageData {
            productImageView.image = UIImage(data: image)
        }
        title = "Создать задачу"
        view.backgroundColor = .white
        setupUI()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        clearInputFields()
    }
    
    //MARK: - Private Methods
    
    private func setupUI() {
        let uiViews: [UIView] = [taskName, dateAndSelectedImageStackView, descriptionText, productImageView, createTaskButton]
        uiViews.forEach { uiView in
            uiView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(uiView)
        }
        setupConstaints()
    }
    
    private func clearInputFields() {
        taskName.text = ""
        datePicker.date = Date()
        descriptionText.text = "Описание"
        productImageView.image = nil
    }
    
    @objc private func selectImageFromGallery() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = false
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @objc
    func createTaskButtonTapped() {
        let task: TaskModel
        if let existingTask = self.task {
            task = TaskModel(id: existingTask.id, 
                             name: taskName.text ?? "",
                             time: datePicker.date,
                             description: descriptionText.text,
                             completed: existingTask.completed,
                             image: selectedImage)
        } else {
            task = TaskModel(id: UUID().uuidString, 
                             name: taskName.text ?? "",
                             time: datePicker.date,
                             description: descriptionText.text,
                             completed: false, 
                             image: selectedImage)
        }
        delegate?.didCreateTask(task)
        dismiss(animated: true) {
        self.tabBarController?.selectedIndex = 0
        }
    }
    
    @objc
    private func pickerDateChanged() {
        print(datePicker.date)
    }
    
    private func setupConstaints() {
        NSLayoutConstraint.activate([
            taskName.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, 
                                          constant: 10),
            taskName.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                                              constant: 16),
            taskName.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                                               constant: -16),
            
            dateAndSelectedImageStackView.topAnchor.constraint(equalTo: taskName.bottomAnchor,
                                            constant: 10),
            dateAndSelectedImageStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                constant: 16),
            
        
            descriptionText.topAnchor.constraint(equalTo: datePicker
                .bottomAnchor, 
                                                 constant: 10),
            descriptionText.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                     constant: 16),
            descriptionText.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                      constant: -16),
            descriptionText.bottomAnchor.constraint(equalTo: productImageView.topAnchor,
                                                    constant: -10),
            
            productImageView.heightAnchor.constraint(equalToConstant: 155),
            productImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                      constant: 16),
            productImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                       constant: -16),
            productImageView.bottomAnchor.constraint(equalTo: createTaskButton.topAnchor,
                                                     constant: -10),
            
            createTaskButton.heightAnchor.constraint(equalToConstant: 55),
            createTaskButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, 
                                                      constant: 16),
            createTaskButton.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                       constant: -16),
            createTaskButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                                     constant: -10)])
    }
}

//MARK: - CreateTaskViewController
extension CreateTaskViewController: UITextFieldDelegate {
    // Скрыть клавиатуру
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, 
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        if let currentText = textField.text, let textRange = Range(range, in: currentText) {
            let updatedText = currentText.replacingCharacters(in: textRange, with: string)
            print(updatedText)
        }
        return true
    }
}

//MARK: - CreateTaskViewController
extension CreateTaskViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        if let textView = textView.text {
            print(textView)
        }
    }
}

extension CreateTaskViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let selectedImage = info[.originalImage] as? UIImage { productImageView.image = selectedImage
            self.selectedImage = selectedImage
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) { picker.dismiss(animated: true, completion: nil)
    }
}
