//
//  HomeVCPreviewDelegate.swift
//  Potatso
//
//  Created by luogang on 16/10/16.
//  Copyright © 2016年 TouchingApp. All rights reserved.
//

import UIKit

extension HomeVC: UIViewControllerPreviewingDelegate {
    func previewingContext(previewingContext: UIViewControllerPreviewing, commitViewController viewControllerToCommit: UIViewController) {
        showViewController(ProxyListViewController(), sender: self)
    }
    
    func previewingContext(previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = tableView?.indexPathForRowAtPoint(location) else {
            return nil
        }
        let row = indexPath.row
        if row == 0{
            let proxyListVC = ProxyListViewController()
            proxyListVC.preferredContentSize = CGSize(width: 0, height: 400)
            return proxyListVC
        } else {
            return nil
        }
    }
}
