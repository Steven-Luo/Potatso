//
//  ProxyListViewController.swift
//  Potatso
//
//  Created by LEI on 5/31/16.
//  Copyright © 2016 TouchingApp. All rights reserved.
//

import Foundation
import PotatsoModel
import Cartography
import Eureka

private let rowHeight: CGFloat = 107
private let kProxyCellIdentifier = "proxy"

class ProxyListViewController: FormViewController {

//    https://github.com/icodesign/ICSPullToRefresh.Swift
    var selectedProxy: Proxy?
    
    var proxies: [Proxy?] = []
    let allowNone: Bool
    let chooseCallback: (Proxy? -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if traitCollection.forceTouchCapability == .Available {
            registerForPreviewingWithDelegate(self, sourceView: tableView!)
        }
    }

    init(allowNone: Bool = false, chooseCallback: (Proxy? -> Void)? = nil) {
        self.chooseCallback = chooseCallback
        self.allowNone = allowNone
        super.init(style: .Plain)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "Proxy".localized()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(add))
        reloadData()
    }

    func add() {
        let addMenu = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        if let popoverPresentationController = addMenu.popoverPresentationController {
            popoverPresentationController.sourceView = self.view
            popoverPresentationController.sourceRect = CGRect(x: self.view.bounds.width - 30, y: 30, width: 30, height: 30)
        }
        
        addMenu.addAction(UIAlertAction(title: "Add Mannally".localized(), style: UIAlertActionStyle.Default , handler: { (action) in
            let vc = ProxyConfigurationViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }))
        addMenu.addAction(UIAlertAction(title: "qrcode.title".localized(), style: UIAlertActionStyle.Default, handler: { (action) in
            let importer = Importer(vc: self)
            importer.importConfigFromQRCode()
        }))
        addMenu.addAction(UIAlertAction(title: "Import From URL".localized(), style: UIAlertActionStyle.Default, handler: { (action) in
            let importer = Importer(vc: self)
            importer.importConfigFromUrl()
        }))
        addMenu.addAction(UIAlertAction(title: "CANCEL".localized(), style: .Cancel, handler: { (action) in
        }))
        self.presentViewController(addMenu, animated: true, completion: nil)
    }

    func reloadData() {
        proxies = DBUtils.allNotDeleted(Proxy.self, sorted: "createAt").map({ $0 })
        if allowNone {
            proxies.insert(nil, atIndex: 0)
        }
        form.delegate = nil
        form.removeAll()
        let section = Section()
        for proxy in proxies {
            section
                <<< ProxyRow () {
                    $0.value = proxy
                }.cellSetup({ (cell, row) -> () in
                    cell.selectionStyle = .None
                    cell.accessoryType = .DetailButton
                }).onCellSelection({ [unowned self] (cell, row) in
                    cell.setSelected(false, animated: true)
                    let proxy = row.value
                    if let cb = self.chooseCallback {
                        cb(proxy)
                        self.close()
                    }else {
                        if proxy?.type != .None {
                            self.showProxyConfiguration(proxy)
                        }
                    }
                })
        }
        form +++ section
        form.delegate = self
        tableView?.reloadData()
    }
    
    func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        let row = indexPath.row
        if let proxy = proxies[row] {
            self.showProxyConfiguration(proxy)
        }
    }

    func showProxyConfiguration(proxy: Proxy?) {
        let vc = ProxyConfigurationViewController(upstreamProxy: proxy)
        navigationController?.pushViewController(vc, animated: true)
    }

    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if allowNone && indexPath.row == 0 {
            return false
        }
        return true
    }

    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return .Delete
    }

    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            guard indexPath.row < proxies.count, let item = (form[indexPath] as? ProxyRow)?.value else {
                return
            }
            do {
                try DBUtils.softDelete(item.uuid, type: Proxy.self)
                proxies.removeAtIndex(indexPath.row)
                form[indexPath].hidden = true
                form[indexPath].evaluateHidden()
            }catch {
                self.showTextHUD("\("Fail to delete item".localized()): \((error as NSError).localizedDescription)", dismissAfterDelay: 1.5)
            }
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView?.tableFooterView = UIView()
        tableView?.tableHeaderView = UIView()
    }

}
