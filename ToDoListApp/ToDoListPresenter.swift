//
//  ToDoListPresenter.swift
//  ToDoListApp
//
//  Created by Sai Prasad on 01/10/23.
//

import Foundation

protocol ToDoListPresenterViewDelegate : NSObjectProtocol {
    func reloadDictionaryItems()
    func insertRowAt(index: Int)
    func deleteRowAt(index: Int,section: Int)
}


class ToDoListPresenter: NSObject{
    
    private var items: [String] = []
    private var completedTasksItems : [String] = []
    private var isTasksMoved : Bool = false
    
    weak var delegate: ToDoListPresenterViewDelegate?
    
    func addToDictionary(text: String) {
        if (self.items.count > 0) {
            self.items.insert(text, at: 0)
            if !isTasksMoved{
                self.delegate?.insertRowAt(index: 0)
            }
        } else {
            self.items.append(text)
            if !isTasksMoved{
                self.delegate?.insertRowAt(index: self.items.count - 1)
            }
        }
        if isTasksMoved{
            isTasksMoved = false
        }
    }
    
    func removeFromDictionaryAt(index: Int,section : Int) {
        DispatchQueue.main.async {
            if section == 0{
                self.items.remove(at: index)
            }
            else{
                self.completedTasksItems.remove(at: index)
            }
            self.delegate?.deleteRowAt(index: index, section: section)
        }
    }
    
    func addCompletedTasksToDictionary(text:String,index:Int){
        self.items.remove(at: index)
        if (self.completedTasksItems.count > 0) {
            self.completedTasksItems.insert(text, at: 0)
        } else {
            self.completedTasksItems.append(text)
        }
    }
    
    func moveCompletedTasksToDictionary(text:String,index:Int){
        self.completedTasksItems.remove(at: index)
        self.isTasksMoved = true
        addToDictionary(text: text)
    }
    
    func getItems() -> [String] {
        return self.items
    }
    
    func getCompletedItems() -> [String] {
        return self.completedTasksItems
    }
}
