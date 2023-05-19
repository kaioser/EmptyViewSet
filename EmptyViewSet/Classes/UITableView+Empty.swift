//
//  UITableView+Empty.swift
//  BaseViewController
//
//  Created by 杨雄凯 on 2023/4/8.
//

// 本来这里打算hook系统的reloadData方法，但是考虑到这种方案的不稳定性(可能与其他库的hook方法冲突，产生不可预估的后果)
// swift hook方法: https://github.com/DarielChen/iOSTips#27

import UIKit

extension UITableView {
    
    /// 刷新数据源 + 刷新空数据视图（如果控制器遵守了Emptiable协议，必须使用此方法刷新数据）
    public func reloadDataEmptiable() {
        
        // 先走正常的刷新方法
        reloadData()
        
        // Some tips ↓ from https://juejin.cn/post/6844904099444588552
        // UITableViewController中，tableView的nextResponder直接是控制器本身；UICollectionViewController同理
        // UIViewController中，对于手动添加到self.view上的tableView，它的nextResponder是self.view，self.view的nextResponder才是控制器本身
        // 即当一个View为Controller的根视图时，View的nextResponder是Controller本身
        // 基于以上规则，递归查询nextResponder，直到找到控制器为止
        
        if let controller = controller(),
           controller is Emptiable,// 检查tableView所在控制器是否遵守了Emptiable协议
           let emptyController = controller as? Emptiable {
            emptyController.showEmpty(isEmpty())
        }
    }
    
    /// 列表数据是否为空
    /// - Returns: Bool
    private func isEmpty() -> Bool {
        
        var count: Int = 0
        
        let section = numberOfSections
        if section > 0 {
            for i in 0..<section {
                count += numberOfRows(inSection: i)
            }
        }
        
        return count == 0
    }
}

private extension UIView {
    
    /// 获取view所在的控制器
    /// - Returns: 所在控制器
    func controller() -> UIViewController? {
        
        var times = 0
        var nextResponder: UIResponder? = next
        
        // 固定遍数就行, 防止递归卡死
        while times < 5 {
            if let controller = nextResponder as? UIViewController {
                return controller
            }
            
            nextResponder = nextResponder?.next
            times += 1
        }
        
        return nil
    }
}
