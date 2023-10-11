//
//  EmptyContainer.swift
//  BaseViewController
//
//  Created by 杨雄凯 on 2023/4/7.
//

import UIKit

class EmptyContainer: UIStackView {
    
    var tapped: (() -> Void)?
    
    private var haveSubtitle: Bool = false
    private var haveBtn: Bool = false
    private var haveImage: Bool = false
    
    /// 横向边距
    let horizontalEdge: CGFloat = 40
    /// 纵向偏移量
    var verticalOffset: CGFloat = 0
    
    /// 整体StackView的高度
    var height: CGFloat {
        var titleHeight: CGFloat = 40
        if haveSubtitle { titleHeight += 20 }
        if haveImage { titleHeight += normalItem.imageSize }        
        if haveBtn { titleHeight += 40 }
        return titleHeight
    }
    
    private var normalItem: EmptyItem!
    private var networkErrorItem: EmptyItem!
    
    convenience init(normalItem: EmptyItem, networkErrorItem: EmptyItem) {
        self.init()
        
        // 监听网络，在已经显示的情况下随时刷新UI
        NotificationCenter.default.addObserver(self, selector: #selector(network(_:)), name: Notification.Name.connectivityStatus, object: nil)
        
        self.normalItem = normalItem
        self.networkErrorItem = networkErrorItem
        setupUI(NetworkMonitor.shared.isConnected ? normalItem : networkErrorItem)
    }
    
    deinit {
        NetworkMonitor.shared.stopMonitoring()
    }
}

extension EmptyContainer {
    
    private func setupUI(_ item: EmptyItem) {
        
        verticalOffset = item.verticalOffset
        
        var imgView: UIImageView?
        if let img = item.image {
            imgView = UIImageView(image: img)
            imgView?.contentMode = .scaleAspectFit
        }
        haveImage = imgView != nil
        
        let label = UILabel()
        label.text = item.title
        label.font = .boldSystemFont(ofSize: 14)
        label.textColor = .darkGray
        label.numberOfLines = 0
        label.textAlignment = .center
        
        var sublabel: UILabel?
        if let st = item.subtitle {
            sublabel = UILabel()
            sublabel?.text = st
            sublabel?.font = .systemFont(ofSize: 14)
            sublabel?.textColor = .lightGray
            sublabel?.numberOfLines = 0
            sublabel?.textAlignment = .center
        }
        haveSubtitle = sublabel != nil
        
        var button: UIButton?
        if let bt = item.buttonTitle {
            button = UIButton(type: .system)
            button?.setTitle(bt, for: .normal)
            button?.setTitleColor(.systemBlue, for: .normal)
            button?.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            button?.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        }
        haveBtn = button != nil
        
        if let iv = imgView {
            addArrangedSubview(iv)
        }
        
        addArrangedSubview(label)
        
        if let sv = sublabel {
            addArrangedSubview(sv)
            setCustomSpacing(20, after: sv)
        } else {
            setCustomSpacing(20, after: label)
        }
        
        if let bv = button {
            addArrangedSubview(bv)
        }
        
        spacing = 10
        axis = .vertical
        alignment = .fill
        distribution = .fill
    }
    
    @objc private func buttonAction() {
        tapped?()
    }
}

extension EmptyContainer {
    
    /// 网络状态发生变化，刷新UI
    @objc func network(_ notification: Notification) {
        
        if superview == nil { return }
        
        removeAllArrangedSubviews()
        setupUI(NetworkMonitor.shared.isConnected ? normalItem : networkErrorItem)
        
        // 更新一下高度
        bounds.size.height = height
    }
}

fileprivate extension UIStackView {
    
    func removeAllArrangedSubviews() {
        
        arrangedSubviews.forEach {
            self.removeArrangedSubview($0)
            NSLayoutConstraint.deactivate($0.constraints)
            $0.removeFromSuperview()
        }
    }
}
