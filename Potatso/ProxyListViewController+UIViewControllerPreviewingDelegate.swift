//
//  ProxyListPreviewing.swift
//  Potatso
//
//  Created by luogang on 16/10/16.
//  Copyright © 2016年 AbestProxy. All rights reserved.
//

import UIKit

extension ProxyListViewController: UIViewControllerPreviewingDelegate {
    // PEEK
    func previewingContext(previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let tableView = tableView else {
            return nil
        }
        
        guard let indexPath = tableView.indexPathForRowAtPoint(location),
            cell = tableView.cellForRowAtIndexPath(indexPath) else {
                return nil
        }
        
        guard let proxyRowCell = cell as? ProxyRowCell, proxy = proxyRowCell.row.value else {
            return nil
        }
        selectedProxy = proxy
        
        let previewVC = ProxyConfigurationViewController(upstreamProxy: proxy)
        
        previewVC.preferredContentSize = CGSize(width: 0, height: 400)
        return previewVC
    }
    
    // POP
    func previewingContext(previewingContext: UIViewControllerPreviewing, commitViewController viewControllerToCommit: UIViewController) {
        if let proxy = selectedProxy {
            let previewVC = ProxyConfigurationViewController(upstreamProxy: proxy)
            showViewController(previewVC, sender: self)
        }
    }
}