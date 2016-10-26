//
//  SyncVC.swift
//  Potatso
//
//  Created by LEI on 8/4/16.
//  Copyright © 2016 TouchingApp. All rights reserved.
//

import Foundation
import Eureka

class UserViewController: FormViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        generateForm()
    }
    
    func generateForm() {
        form.delegate = nil
        form.removeAll()
        form +++ generateTrafficUsageSection()
        form.delegate = self
        tableView?.reloadData()
    }
    
    func generateTrafficUsageSection() -> Section {
        let section = Section()
        section
            <<< LabelRow() {
                $0.title = "总流量".localized()
                $0.value = "15G"
        }
//            <<< LabelRow() {
//                $0.title = "上传流量".localized()
//                $0.value= "15G"
//        }
        return section
    }
    
    func forceSync() {
        SyncManager.shared.sync(true, completion: { (error) in
            if let error = error {
                Alert.show(self, title: "Sync Failed".localized(), message:  "\(error)")
            } else {
                Alert.show(self, title: "Sync Success".localized())
            }
        })
    }
    
}