//
//  TaskListViewController.swift
//  CoreDataDemo
//
//  Created by Alexey Efimov on 04.10.2021.
//

import UIKit

class TaskListViewController: UITableViewController {
    
    private let cellID = "task"

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        setupNavigationBar()
        StorageManager.shared.fetchData()
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            StorageManager.shared.delete(indexPath.row)
        }
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showRenameAlert(with: "Rename Task", message: "Put new name", and: indexPath)
    }

    private func setupNavigationBar() {
        title = "Task List"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let navBarAppearance = UINavigationBarAppearance()
        
        navBarAppearance.backgroundColor = UIColor(
            red: 21/255,
            green: 101/255,
            blue: 192/255,
            alpha: 194/255
        )
        
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addNewTask)
        )
        
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
    }
    
    @objc private func addNewTask() {
        showSaveAlert(with: "New Task", and: "What do you want to do?")
    }
    
    private func save(_ taskName: String) {
        StorageManager.shared.save(taskName)
        let cellIndex = IndexPath(row: StorageManager.shared.taskList.count - 1, section: 0)
        tableView.insertRows(at: [cellIndex], with: .automatic)
    }
    
    private func rename(_ taskIndex: IndexPath,_ newTaskName: String) {
        StorageManager.shared.rename(taskIndex, newTaskName)
        tableView.reloadRows(at: [taskIndex], with: .automatic)
    }
}

// MARK: - UITableViewDataSource
extension TaskListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        StorageManager.shared.taskList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        let task = StorageManager.shared.taskList[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = task.title
        cell.contentConfiguration = content
        return cell
    }
}

// MARK: - AlertControllers
extension TaskListViewController {
    
    private func showSaveAlert(with title: String, and message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            guard let task = alert.textFields?.first?.text, !task.isEmpty else { return }
            self.save(task)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        alert.addTextField { textField in
            textField.placeholder = "New Task"
        }
        present(alert, animated: true)
    }
    
    private func showRenameAlert(with title: String, message: String, and taskIndexPath: IndexPath) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let renameAction = UIAlertAction(title: "Rename", style: .default) { _ in
            guard let task = alert.textFields?.first?.text, !task.isEmpty else { return }
            self.rename(taskIndexPath, task)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        alert.addAction(renameAction)
        alert.addAction(cancelAction)
        alert.addTextField { textField in
            textField.text = StorageManager.shared.taskList[taskIndexPath.row].title
        }
        present(alert, animated: true)
    }
}
