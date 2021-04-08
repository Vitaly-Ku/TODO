//
//  NewTaskViewController.swift
//  TODO
//
//  Created by Александр Минк on 07.01.2021.
//  Copyright © 2021 Alexander Mink. All rights reserved.
//

import UIKit
import RealmSwift
import UserNotifications

class NewTaskViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UIColorPickerViewControllerDelegate {
    
    @IBOutlet weak var newSectionTextField: UITextField! {
        didSet{
            newSectionTextField.inputView = categoryPicker
            newSectionTextField.inputAccessoryView = makeToolBarCategories()
        }
    }
    @IBOutlet weak var notificationTF: UITextField! {
        didSet {
            notificationTF.inputAccessoryView = makeToolBarNotifications()
            notificationTF.inputView = notificationPicker
            if #available(iOS 13.4, *) {notificationPicker.preferredDatePickerStyle = .wheels}
}}
    @IBOutlet weak var newTaskNameTF: UITextField! {didSet{newTaskNameTF.inputAccessoryView = makeToolBarTaskName()}}
    @IBOutlet weak var membersButton: UIButton!
    @IBOutlet weak var checkListButton: UIButton!
    @IBOutlet weak var coverButton: UIButton!
    @IBOutlet weak var stackWiew: UIStackView!
    @IBOutlet weak var stackWidthConstr: NSLayoutConstraint!
    @IBOutlet weak var stackRowsHeight: NSLayoutConstraint!
    @IBOutlet weak var descriptionTF: UITextField! {didSet{descriptionTF.inputAccessoryView = makeToolBarTaskName()}}
    
    
    var sections: [String]?
    var router: BaseRouter?
    let categoryPicker = UIPickerView()
    let notificationPicker = UIDatePicker()
    let dateFormatter111 = DateFormatter()
    var calendar = Calendar.current
    let notificationService = NotificationService()
    var selectedBackgroundColor: UIColor? = UIColor()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryPicker.delegate = self
        categoryPicker.selectedRow(inComponent: 0)
        dateFormatter111.timeZone = .autoupdatingCurrent
        //        dateFormatter111.dateFormat = "dd, MMMM yyyy HH:mm"
        dateFormatter111.dateFormat = "dd.MM.yyyy, HH:mm"
        calendar.timeZone = .autoupdatingCurrent
        router = BaseRouter(viewController: self)
        membersButton.layer.cornerRadius = 5
        checkListButton.layer.cornerRadius = 5
        coverButton.layer.cornerRadius = 5
        sections = try? Main.instance.getSectionsFromRealm()
        newSectionTextField?.textAlignment = .center
        print(sections ?? "секции отсутствуют")
        newSectionTextField?.text = sections?[0]
        
        stackWidthConstr.constant = view.frame.width/1.6
        stackRowsHeight.constant = view.frame.height/24
        stackWiew.spacing = view.frame.height/40
    }
    
    // MARK: - ACTIONS
    
    @IBAction func createNewTaskButton(_ sender: UIButton) {
        
//        let sectionName: String = newSectionTextField?.text ?? ""
//        let taskName: String = newTaskNameTextField.text ?? ""
//
//        if !sectionName.isEmpty && !taskName.isEmpty {
//            //            Main.instance.addTask(section: sectionName!, name: taskName!)
//            try? Main.instance.addTask(sectionName: sectionName, name: taskName, backgroundColor: nil, taskDescription: nil, notificationDate: nil)
//        /*let sectionName: String? = newSectionTextField.text
//        let taskName: String? = newTaskNameTextField.text
//        let description: String? = descriptionTextField.text
//
//        if (sectionName != "") && (taskName != "") && (description != ""){
//            Main.instance.addTask(section: sectionName!, name: taskName!, descriptionDetail: description!)
//          */
//            router?.dismiss(animated: true, completion: nil)
//        } else { showAlert(title: "Ошибка", message: "Заполните поля") }
//
        notificationService.sendNotificationRequest(
            content: notificationService.makeNotificationContent(str: newTaskNameTF.text ?? ""),
            trigger: notificationService.makeIntervalNotificationTrigger(doub: dateFormatter111.date(from: Main.instance.notificationDate ?? "")?.timeIntervalSince1970 ?? Date().timeIntervalSince1970+1000)
        )
        
        // TODO: сделать правильную проверку
        if newSectionTextField.text != "" && newTaskNameTF.text != "" {
            try? Main.instance.addTask(sectionName: newSectionTextField.text!, name: newTaskNameTF.text!, backgroundColor: selectedBackgroundColor, taskDescription: descriptionTF.text, notificationDate: notificationTF.text)
            router?.dismiss(animated: true, completion: nil)
        } else {
            showAlert(title: "Ошибка", message: "Заполните поля")
        }
        
    }
    
    @IBAction func pickColorButtonTapped(_ sender: UIButton) {
        let colorPickerVC = UIColorPickerViewController()
        colorPickerVC.delegate = self
        present(colorPickerVC, animated: true)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        selectedBackgroundColor = viewController.selectedColor
    }
    
    
    
    @objc func deleteCategoryAction() {
        try? Main.instance.deleteSection(delSectionName: newSectionTextField?.text ?? "")
        print("Нажата кнопка удалить категорию")
        view.endEditing(true)
    }
    
    @objc func chooseCategoryAction() {
        print("Нажата кнопка 'Готово' выбора категории")
        view.endEditing(true)
    }
    
    @objc func chooseNotificationAction() {
        notificationTF?.text = dateFormatter111.string(from: notificationPicker.date)
        Main.instance.notificationDate = dateFormatter111.date(from: notificationTF?.text ?? "")?.localString()
        print(Main.instance.notificationDate ?? "синглтон с датой тип строка", "🍏" )
//        print(dateFormatter111.date(from: Main.instance.notificationDate!)!.timeIntervalSince1970, "🍏🍏🍏")
        view.endEditing(true)
    }
    
    // MARK: - TABLE
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sections?.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sections?[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        newSectionTextField?.text = sections?[row]
        print(categoryPicker.selectedRow(inComponent: 0))
    }
}
