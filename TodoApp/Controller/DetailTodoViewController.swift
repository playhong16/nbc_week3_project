//
//  DetailTodoViewController.swift
//  TodoApp
//
//  Created by playhong on 2023/08/09.
//

import UIKit

final class DetailTodoViewController: UIViewController {
    
    // MARK: - Interface Builder Outlet
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var highPriorityButton: UIButton!
    @IBOutlet weak var mediumPriorityButton: UIButton!
    @IBOutlet weak var lowPriorityButton: UIButton!
    
    @IBOutlet var priorityButtons: [UIButton]!
    
    // MARK: - Properties
    
    /// [TodaDataManager] 싱글톤 객체를 사용합니다.
    let todoDataManager = TodoDataManager.shared
    
    /// [todo] 객체를 전달받기 위해 사용합니다.
    var todo: Todo?
    
    /// [TodoPriority] 타입의 기본값 설정과 임시 저장을 위해 사용합니다.
    var priority: TodoPriority = .medium

    // MARK: - Life Cycle
    
    /// 뷰가 로드되면 실행됩니다.
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self /// 테이블 뷰의 이벤트를 처리 할 수 있도록 권한을 위임받습니다.
        setConfigureButton()
        setConfigureTextView()
        setConfigureTextField()
        setTodoData()
    }
    
    // MARK: - Setting
    
    /// [todo] 객체의 상태에 따라 기본 구성을 설정합니다.
    private func setTodoData() {
        if let todo {
            textField.text = todo.title
            textView.text = todo.textContent
            textView.textColor = .black
            setPriorityColor()
        } else {
            textView.text = Placeholder.textView
            textView.textColor = .lightGray
            textField.placeholder = Placeholder.textField
            setPriorityColor()
        }
    }

    
    /// [priorityButtons]의 기본 구성을 설정합니다.
    private func setConfigureButton() {
        for button in priorityButtons {
            button.layer.masksToBounds = true
            button.layer.cornerRadius = 10
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    
    /// [textView]의 기본 구성을 설정합니다.
    private func setConfigureTextView() {
        textView.layer.masksToBounds = true
        textView.layer.cornerRadius = 10
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    /// [texField]의 기본 구성을 설정합니다.
    private func setConfigureTextField() {
        textField.layer.masksToBounds = true
        textField.layer.cornerRadius = 10
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    /// [priority] 의 케이스에 따라 버튼의 색깔을 변경할 수 있도록 설정합니다.
    private func setPriorityColor() {
        switch priority {
        case .high:
            setHighPriorityButton()
        case .medium:
            setMediumPriorityButton()
        case .low:
            setLowPriorityButton()
        case .complete:
            return
        }
    }
    
    /// [priorityButtons]의 색깔을 설정합니다.
    private func setClearPriorityColor() {
        for button in priorityButtons {
            button.backgroundColor = .clear
            button.tintColor = .black
        }
    }

    // MARK: - Priority Button Tapped
    
    /// highPriorityButton(높음) 의 색깔을 설정합니다.
    private func setHighPriorityButton() {
        highPriorityButton.backgroundColor = priority.color
        highPriorityButton.tintColor = .white
    }
    
    /// [mediumPriorityButton(중간)] 의 색깔을 설정합니다.
    private func setMediumPriorityButton() {
        mediumPriorityButton.backgroundColor = priority.color
        mediumPriorityButton.tintColor = .white
    }
    
    /// [lowPriorityButton(낮음)] 의 색깔을 설정합니다.
    private func setLowPriorityButton() {
        lowPriorityButton.backgroundColor = priority.color
        lowPriorityButton.tintColor = .white
    }
    
    /// [priorityButtons]를 눌렀을 때 버튼의 [tag] 를 확인하고, 버튼의 색깔을 [priority]에 맞게 설정합니다.
    @IBAction func priorityButtonTapped(sender: UIButton) {
        switch sender.tag {
        case 0:
            priority = .high
            setClearPriorityColor()
            setPriorityColor()
        case 1:
            priority = .medium
            setClearPriorityColor()
            setPriorityColor()
        case 2:
            priority = .low
            setClearPriorityColor()
            setPriorityColor()
        default:
            priority = .complete
        }
    }
    
    // MARK: - Task on incoming todo data
    
    /// [todo] 객체를 전달받은 경우 [todo] 객체를 수정하는 경우 실행합니다.
    private func update(todo: Todo) {
        guard let text = textField.text else { return }
        todo.title = text
        todo.textContent = textView.text
        todo.priority = self.priority
        performSegue(withIdentifier: "todoDidUpdate", sender: todo)
    }
    
    /// [todo] 객체를 전달받지 못하고, [todo] 객체를 새로 생성하는 경우 실행합니다.
    private func addTodo() {
        guard let text = textField.text else { return }
        let todo = Todo(title: text, textContent: textView.text, priority: self.priority)
        todoDataManager.createTodoList(todo: todo)
        performSegue(withIdentifier: "todoDidCreate", sender: nil)
    }

    /// [todo] 객체의 존재 여부에 따라 [saveButton]의 동작을 설정합니다.
    private func setSaveButtonAction() {
        if let todo { update(todo: todo) }
        else { addTodo() }
    }
    
    // MARK: - Button Tapped

    /// [saveButton]을 누르면 동작합니다.
    /// - '제목'이 비어있으면, 저장하지 않고 '취소' 버튼이 눌린 것과 동일하게 동작합니다.
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        guard let isEmpty = textField.text?.isEmpty else { return }
        isEmpty ? performSegue(withIdentifier: "cancel", sender: nil) : setSaveButtonAction()
    }
}

// MARK: - Extension

extension DetailTodoViewController: UITextViewDelegate {
    /// [textView]의 편집이 시작될 때 실행됩니다.
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == Placeholder.textView {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    /// [textView]의 편집이 종료될 때 실행됩니다.
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = Placeholder.textView
            textView.textColor = .lightGray
        }
    }
}
