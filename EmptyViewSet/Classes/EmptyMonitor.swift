//
//  EmptyMonitor.swift
//  BaseViewController
//
//  Created by 杨雄凯 on 2023/4/8.
//

import Network
import Foundation

extension Notification.Name {
    static let connectivityStatus = Notification.Name(rawValue: "connectivityStatusChanged")
}

final class NetworkMonitor {
    static let shared = NetworkMonitor()
    
    private var monitor = NWPathMonitor()
    
    private(set) var isConnected = true
    
    private init() {}
    
    func startMonitoring() {
        
        // tips: NWPathMonitor每次cancel以后重新start之前，必须使用新初始化的实例!!!!
        monitor = NWPathMonitor()
        
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            
            // tips: 蜂窝和wifi之间切换时，status可能为.requiresConnection，所以这里用.unsatisfied反选取值，包含requiresConnection情景
            self.isConnected = path.status != .unsatisfied
            
            // 这里的线程取决于monitor.start传的参数
            // debugPrint("[EmptyMonitor] - 网络监听是否在主线程:\(Thread.isMainThread)")
            NotificationCenter.default.post(name: .connectivityStatus, object: nil)
        }
        
        monitor.start(queue: .main)
    }
    
    func stopMonitoring() {
        monitor.cancel()
    }
}
