//
//  EmptyItem.swift
//  BaseViewController
//
//  Created by 杨雄凯 on 2023/4/9.
//

import Foundation

// tips: pod内部的结构体必须手动实现构造器才能让外部初始化
public struct EmptyItem {
    
    /// 初始化空数据模型
    /// - Parameters:
    ///   - title: 标题
    ///   - subtitle: 副标题
    ///   - image: 图片
    ///   - imageSize: 图片尺寸
    ///   - buttonTitle: 按钮文案
    ///   - verticalOffset: 纵向偏移（可能适用于UITableViewController等场景）
    public init(title: String = "暂无数据",
                subtitle: String? = nil,
                image: UIImage? = nil,
                imageSize: CGFloat = 200,
                buttonTitle: String? = nil,
                verticalOffset: CGFloat = 0) {
        
        self.title = title
        self.subtitle = subtitle
        self.image = image
        self.imageSize = imageSize
        self.buttonTitle = buttonTitle
        self.verticalOffset = verticalOffset
    }
    
    static let networkErrorItem = EmptyItem(title: "网络错误", subtitle: "请检查您的网络设置~", buttonTitle: "重新加载")
    
    var title: String
    var subtitle: String?
    var image: UIImage?
    var imageSize: CGFloat
    var buttonTitle: String?
    var verticalOffset: CGFloat = 0
}
