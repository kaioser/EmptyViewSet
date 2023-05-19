//
//  EmptyProtocol.swift
//  BaseViewController
//
//  Created by 杨雄凯 on 2023/4/7.
//

import Foundation

// MARK: - Public

public protocol Emptiable: UIViewController {
    
    /// 空数据模型
    var emptiableItem: EmptyItem { get }
    
    /// 无网络链接情景下的空数据模型
    var emptiableNetworkItem: EmptyItem { get }
    
    /// 空数据视图的父视图；可以是tableView，也可以是非nil的tableView.backgroundView
    var emptySuperView: UIView { get }
    
    /// 空视图按钮点击事件
    func emptyButtonAction()
}

public extension Emptiable {
    
    /// 默认实现网络错误的item
    var emptiableNetworkItem: EmptyItem { EmptyItem.networkErrorItem }
    
    /// 手动触发是否显示空视图
    /// - Parameter show: 是否
    func showEmpty(_ show: Bool) { empty(show: show) }
}

// MARK: - Private

extension Emptiable {
    
    private var emptyView: EmptyContainer {
        let targetView = EmptyContainer(normalItem: emptiableItem, networkErrorItem: emptiableNetworkItem)
        //        targetView.backgroundColor = .cyan
        targetView.tag = 761376
        return targetView
    }
    
    private func empty(show: Bool) {
        
        if show {
            // 在主线程开始网络监听!
            NetworkMonitor.shared.startMonitoring()
            
            let targetView = emptyView// 保证只调用一次，所以用targetView临时保存
            targetView.tapped = { [weak self] in
                guard let self = self else { return }
                self.emptyButtonAction()
            }
            
            let superView = emptySuperView
            targetView.center = CGPoint(x: superView.bounds.size.width * 0.5, y: superView.bounds.size.height * 0.5 + targetView.verticalOffset)
            targetView.bounds = CGRect(x: 0, y: 0, width: superView.bounds.size.width - targetView.horizontalEdge * 2, height: targetView.height)
            superView.insertSubview(targetView, at: 0)
            
        } else {
            let superView = emptySuperView
            let targetView = superView.viewWithTag(761376)
            targetView?.removeFromSuperview()
            
            NetworkMonitor.shared.stopMonitoring()
        }
    }
}

// 这种判断方法不好，不适用于在UIViewController中手动添加的tableView的场景，因为self.view会被tableView挡住
//    private func emptySuperViewX() -> UIView {
//
//        var superView: UIView!
//
//        if let vc = self as? UITableViewController {
//            superView = vc.tableView
//        } else if let vc = self as? UICollectionViewController {
//            superView = vc.collectionView
//        } else {
//            superView = view
//        }
//
//        return superView
//    }
