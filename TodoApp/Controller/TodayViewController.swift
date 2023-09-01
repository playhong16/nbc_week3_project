//
//  TodayViewController.swift
//  TodoApp
//
//  Created by playhong on 2023/08/09.
//

import UIKit

final class TodayViewController: UIViewController {
    
    /// [TodaDataManager] 싱글톤 객체를 사용합니다.
    private let todoDataManager = TodoDataManager.shared
    
    // MARK: - Interface Builder Outlet

    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var addButton: UIButton!

    // MARK: - Life Cycle

    /// 뷰가 로드되면 실행됩니다.
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Configure UI
    
    /// 기본 구성을 설정하는 메서드를 호출합니다.
    private func configureUI() {
        configureButton()
        configureTableView()
        configureTabBar()
        setDateFormat()
    }
    
    /// [addButton] 의 기본 구성을 설정합니다.
    private func configureButton() {
        addButton.layer.borderWidth = 1
        addButton.layer.borderColor = UIColor.buttonBorderColor.cgColor
    }
    
    /// [tableView]의 기본 구성을 설정합니다.
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    /// [tabBar]의 기본 구성을 설정합니다.
    private func configureTabBar() {
        tabBarController?.tabBar.layer.borderWidth = 0.5
        tabBarController?.tabBar.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    // MARK: - Setting

    /// 오늘 날짜를 입력받아서 원하는 문자열 포맷으로 변경하고 [dateLabel.text] 을 설정합니다.
    private func setDateFormat() {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormat.date
        let dateToString = formatter.string(from: date)
        dateLabel.text = dateToString
    }
    
    // MARK: - Segue

    /// [Segue]를 실행하기 전에 수행해야하는 동작들을 처리합니다.
    /// [Segue]의 Destination(목적지)가 [DetailTodoViewController]일 때 [sender] 파라미터에 [Todo] 객체가 담겨있다면, [DetailTodoViewController] 의 [todo] 저장 속성에 [sender] 의 [todo] 를 담는다.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Identifier.Segue.toDetailSceneFromTodayScene {
            guard let moveVC = segue.destination as? DetailTodoViewController,
                  let todo = sender as? Todo
            else { return }
            moveVC.todo = todo
        }
    }
    
    // MARK: - Unwind Segue Action
    
    /// [DetailTodoScene] 에서 취소 버튼을 누르면 동작합니다.
    @IBAction func cancelFromDetailTodoScene(_ segue: UIStoryboardSegue) {
        dismiss(animated: true)
    }
    
    /// [DetailTodoScene] 에서 [Todo] 객체를 새롭게 만드는 경우 동작합니다.
    @IBAction func createFromDetailTodoScene(_ segue: UIStoryboardSegue) {
        tableView.insertRows(at: [IndexPath(row: <#T##Int#>, section: <#T##Int#>)], with: .automatic)
    }
    
    /// [DetailTodoScene] 에서 [Todo] 객체를 업데이트하는 경우 동작합니다.
    @IBAction func updateFromDetailTodoScene(_ segue: UIStoryboardSegue) {
        tableView.reloadData()
        dismiss(animated: true)
    }
}

// MARK: - Extension

// MARK: - Table View Data Source

extension TodayViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return TodoCategory.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 { return todoDataManager.getLifeTodo().count }
        if section == 1 { return todoDataManager.getWorkTodo().count }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.Cell.todayList,
                                                       for: indexPath) as? TodayListCell else { return UITableViewCell() }
        if indexPath.section == 0 {
            let todoList = todoDataManager.getLifeTodo()
            cell.todo = todoList[indexPath.row]
            cell.selectionStyle = .none
            return cell
        }
        if indexPath.section == 1 {
            let todoList = todoDataManager.getWorkTodo()
            cell.todo = todoList[indexPath.row]
            cell.selectionStyle = .none
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 { return TodoCategory.life.rawValue }
        if section == 1 { return TodoCategory.work.rawValue }
        return "none"
    }
}

// MARK: - Table View Delegate

extension TodayViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let todo = todoDataManager.getTodoList()[indexPath.row]
        performSegue(withIdentifier: Identifier.Segue.toDetailSceneFromTodayScene, sender: todo)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .normal, title: Title.delete) { (action, view, completionHandler) in
            self.todoDataManager.deleteTodoList(index: indexPath.row)
            tableView.deleteRows(at: [IndexPath(row: indexPath.row, section: 0)], with: .automatic)
        }
        delete.backgroundColor = .red
        delete.title = Title.delete
        return UISwipeActionsConfiguration(actions: [delete])
    }
}
