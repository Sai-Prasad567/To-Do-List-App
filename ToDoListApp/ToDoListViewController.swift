//
//  ViewController.swift
//  ToDoListApp
//
//  Created by Sai Prasad on 01/10/23.
//

import UIKit

class ToDoListViewController: UIViewController {
    
    private var indicatorTopAnchor: NSLayoutConstraint?
    private let reusableIdentifier = "dictCell"
    
    private var dictionaryItems: [String] {
        return self.presenter.getItems()
    }
    
    private var completedDictionaryTask : [String] {
        return self.presenter.getCompletedItems()
    }
    
    var presenter: ToDoListPresenter
    var index = 0
    var buttonSelected : Bool = false
    
    lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = UIColor(red: 170.0 / 255.0, green: 172.0 / 255.0, blue: 178.0 / 255.0, alpha: 1.0)
        label.text = "Add Tasks"
        return label
    }()
    
    lazy var addTaskField: ListTextField = {
        let textField = ListTextField()
        textField.placeholder = "Add a Task"
        textField.layer.cornerRadius = 40 / 2
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor(red: 7.0 / 255.0, green: 173.0 / 255.0, blue: 104.0 / 255.0, alpha: 1.0).cgColor
        textField.tintColor = UIColor(red: 7.0 / 255.0, green: 173.0 / 255.0, blue: 104.0 / 255.0, alpha: 1.0)
        textField.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
        textField.rightViewMode = .always
        textField.rightView = addButton
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var addButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "AddTask"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -15, bottom: 0, right: 0)
        button.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        button.addTarget(self, action: #selector(addTask(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: .zero, style: .insetGrouped)
        tableView.layer.cornerRadius = 6
        tableView.backgroundColor = UIColor(red: 248.0 / 255.0, green: 248.0 / 255.0, blue: 249.0 / 255.0, alpha: 1.0)
        tableView.layer.borderColor = UIColor(red: 226.0 / 255.0, green: 226.0 / 255.0, blue: 228.0 / 255.0, alpha: 1.0).cgColor
        tableView.estimatedRowHeight = 44
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    init(){
        self.presenter = ToDoListPresenter()
        super.init(nibName: nil, bundle: nil)
        self.presenter.delegate = self
        self.setUpViews()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
            let count = dictionaryItems.count
            if count > 1 {
                tableView.scrollToRow(at: IndexPath(row: count - 1, section: 0), at: .bottom, animated: true)
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
            let count = dictionaryItems.count
            if count > 1 {
                tableView.scrollToRow(at: IndexPath(row: count - 1, section: 0), at: .bottom, animated: true)
            }
        }
    }
    
    func setUpViews() {
        self.view.backgroundColor = UIColor(red: 248.0 / 255.0, green: 248.0 / 255.0, blue: 249.0 / 255.0, alpha: 1.0)
        self.view.addSubview(addTaskField)
        self.view.addSubview(headerLabel)
        self.view.addSubview(tableView)
        
        /// autolayout constraint
        headerLabel.addConstraint(top: self.view.topAnchor, leading: self.view.leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 100, left: 18, bottom: 0, right: 0), size: CGSize(width: 100, height: 20))
        addTaskField.addConstraint(top: self.headerLabel.bottomAnchor, leading: self.view.leadingAnchor, bottom: nil, trailing: self.view.trailingAnchor, padding: UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10), size: CGSize(width: 0, height: 40))
        tableView.addConstraint(top: self.addTaskField.bottomAnchor, leading:  self.view.leadingAnchor, bottom: self.view.bottomAnchor, trailing: self.view.trailingAnchor, padding: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0))
        tableView.register(ToDoListTableViewCell.self, forCellReuseIdentifier: reusableIdentifier)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "To-Do-List"
    }
    
    @objc func addTask(_ button: UIButton){
        if let text = addTaskField.text, text != "" {
            self.presenter.addToDictionary(text: text)
        }
        addTaskField.text = ""
    }
}

extension ToDoListViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if dictionaryItems.count == 0 && completedDictionaryTask.count == 0{
            return 0
        }
        else if dictionaryItems.count > 0 && completedDictionaryTask.count == 0{
            return 1
        }
        else if dictionaryItems.count == 0 && completedDictionaryTask.count > 0{
            return 1
        }
        else{
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if section == 0{
            if dictionaryItems.count > 0{
                return dictionaryItems.count
            }
            else{
                return completedDictionaryTask.count
            }
        }
        else {
            return completedDictionaryTask.count
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: .zero)
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 140, height: 40))
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = UIColor(red: 170.0 / 255.0, green: 172.0 / 255.0, blue: 178.0 / 255.0, alpha: 1.0)
        if section == 0{
            label.text = "Tasks"
        }
        else if section == 1{
            label.text = "Completed"
        }
        view.addSubview(label)
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : ToDoListTableViewCell?
        if indexPath.section == 0{
            cell = ToDoListTableViewCell(text: dictionaryItems[indexPath.row], style: .default, reuseIdentifier: "\(indexPath.row+10)")
            cell?.label.text = dictionaryItems[indexPath.row]
            self.index = indexPath.section
            cell?.button.addTarget(self, action: #selector(selectedButton(button:)), for: .touchUpInside)
            cell?.button.tag = indexPath.row
            return cell!
        }
        else{
            cell = ToDoListTableViewCell(text: completedDictionaryTask[indexPath.row], style: .default, reuseIdentifier: "\(indexPath.row)")
            cell?.label.text = completedDictionaryTask[indexPath.row]
            self.index = indexPath.section
            cell?.button.tag = indexPath.row
            cell?.button.setImage(UIImage(named: "Checkboxfilled"), for: .normal)
            cell?.button.addTarget(self, action: #selector(completedButtonAction(button:)), for: .touchUpInside)
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        self.presenter.removeFromDictionaryAt(index: indexPath.row,section: indexPath.section)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let font = UIFont.systemFont(ofSize: 15, weight: .regular)
        let color = UIColor.blue
        var height:CGFloat = 0
        var text : String = ""
        if indexPath.section == 0{
             text = dictionaryItems[indexPath.row]
        }
        else{
             text = completedDictionaryTask[indexPath.row]
        }
        height = text.heightWithConstrainedWidth(width: self.view.frame.width, font: [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: color][NSAttributedString.Key.font] as! UIFont)+30+5
        return height
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    @objc func selectedButton(button: UIButton){
        self.presenter.addCompletedTasksToDictionary(text: dictionaryItems[button.tag], index: button.tag)
        reloadDictionaryItems()
    }
    
    @objc func completedButtonAction(button: UIButton){
        self.presenter.moveCompletedTasksToDictionary(text: completedDictionaryTask[button.tag], index: button.tag)
        reloadDictionaryItems()
    }
}

extension ToDoListViewController: ToDoListPresenterViewDelegate{
    
    func reloadDictionaryItems() {
        self.tableView.reloadData()
    }
    
    func insertRowAt(index: Int) {
        let indexSet = IndexSet(integer: 0)
        if tableView.numberOfSections == 0 {
            tableView.insertSections(indexSet, with: .automatic)
        } else {
            tableView.reloadSections(indexSet, with: .automatic)
        }
        if dictionaryItems.count > 2 {
            tableView.scrollToRow(at: IndexPath(row: index, section: 0), at: .none, animated: true)
        }
    }
    
    func deleteRowAt(index: Int,section : Int) {
        let indexPath = IndexPath(row: index, section: section)
        if section == 0{
            if (dictionaryItems.count == 0){
                let indexSet = IndexSet(arrayLiteral: section)
                tableView.deleteSections(indexSet, with: .automatic)
            }
            else {
                tableView.beginUpdates()
                tableView.deleteRows(at: [indexPath], with: .automatic)
                tableView.endUpdates()
            }
        }
        else{
            if (completedDictionaryTask.count == 0){
                let indexSet = IndexSet(arrayLiteral: section)
                tableView.deleteSections(indexSet, with: .automatic)
            }
            else {
                tableView.beginUpdates()
                tableView.deleteRows(at: [indexPath], with: .automatic)
                tableView.endUpdates()
            }
        }
    }
}

