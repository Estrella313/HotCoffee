//
//  AddOrderViewController.swift
//  HotCoffee
//
//  Created by BRM13259 on 05/07/22.
//

import Foundation
import UIKit
class AddOrderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var vm = AddCoffeeOrderViewModel()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    private var coffeeSizesSegmentedControl: UISegmentedControl!
    
    var delegate: AddCoffeeOrderDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    @IBAction func close() {
        if let delegate = delegate {
            delegate.addCoffeeeViewControllerDidClose(controller: self)
        }
    }
    
    @IBAction func save() {
        
        let name = self.nameTxt.text
        let email = self.emailTxt.text
        let seletedSize = self.coffeeSizesSegmentedControl.titleForSegment(at: self.coffeeSizesSegmentedControl.selectedSegmentIndex)
        guard let indexPath = self.tableView.indexPathForSelectedRow else {
            fatalError("Error in selecting coffee")
        }
        
        self.vm.name = name
        self.vm.email = email
        self.vm.selectedSize = seletedSize
        self.vm.selectedType = self.vm.type[indexPath.row]
        
        WebService().load(resource: Order.create(vm: self.vm)) { result in
            switch result {
            case .success(let order):
                if let order = order, let delegate = self.delegate {
                    DispatchQueue.main.async {
                        delegate.addCoffeeOrderViewControllerDidSave(order: order, controller: self)
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func setUpUI() {
        self.coffeeSizesSegmentedControl = UISegmentedControl(items: self.vm.size)
        self.coffeeSizesSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(self.coffeeSizesSegmentedControl)
        
        self.coffeeSizesSegmentedControl.topAnchor.constraint(equalTo: self.tableView.bottomAnchor, constant: 24).isActive = true
        self.coffeeSizesSegmentedControl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.vm.type.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CoffeeTypeTableViewCell", for: indexPath)
        cell.textLabel?.text = self.vm.type[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
    }
}
protocol AddCoffeeOrderDelegate {
    func addCoffeeOrderViewControllerDidSave(order: Order, controller: UIViewController)
    func addCoffeeeViewControllerDidClose(controller: UIViewController)
}
