//
//  Alert.swift
//  Castbox
//
//  Created by lazy on 2018/7/12.
//  Copyright © 2018年 Guru. All rights reserved.
//

import Foundation

public protocol Content {
    
    var dismiss: ()->() { set get }
    func view() -> UIView
    func frame() -> CGRect
    func set(with items: [_Alert.Item])
}

public protocol Cancel {
    
    var dismiss: ()->() { set get }
    func view() -> UIView
    func frame() -> CGRect
}

internal extension Content {
    
    func corner() -> CAShapeLayer {
        
        let contentFrame = frame()
        let bounds = CGRect(x: 0.0, y: 0.0, width: contentFrame.width, height: contentFrame.height)
        
        let maskPath = UIBezierPath(roundedRect: bounds,
                                byRoundingCorners: [UIRectCorner.topLeft, UIRectCorner.topRight],
                                cornerRadii: CGSize(width: 5.0, height: 5.0))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = maskPath.cgPath
        
        return maskLayer
    }
}

public class _Alert {
    
    // MARK: - Public
    @discardableResult
    public func set(with items: [_Alert.Item]) -> Self {
        self.items = items
        return self
    }
    
    @discardableResult
    public func add(with items: [_Alert.Item]) -> Self {
        items.forEach({ add(of: $0) })
        return self
    }
    
    @discardableResult
    public func add(of item: _Alert.Item) -> Self {
        if items.map({ $0.title }).contains(item.title) == false {
            items.append(item)
        }
        return self
    }
    
    public func show() {
        prepare()
        UIView.animate(withDuration: 0.25) {
            self.container.state = .show
            self.cover.state = .show
        }
    }
    
    // MARK: - Private
    private func dismiss() {
        UIView.animate(withDuration: 0.25, animations: {
            self.cover.state = .dismiss
            self.container.state = .dismiss
        }) { (finished) in
            if finished {
                self.complete()
            }
        }
    }
    
    private var items: [_Alert.Item] = [_Alert.Item]()
    
    private let container: Container = {
        let container = Container()
        container.autoresizingMask = [.flexibleLeftMargin, .flexibleTopMargin, .flexibleRightMargin]
        return container
    }()
    private let cover: Cover = {
        let cover = Cover()
        cover.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return cover
    }()
    
    private var content: Content?
    private var cancel: Cancel?
    
    // MARK: - Life Cycle
    public init(contentClazz: Swift.AnyClass, cancelClazz: Swift.AnyClass?) {
        guard let contentObject = contentClazz as? NSObject.Type else {
            assertionFailure("clazz not confirm to NSObject")
            return
        }
        guard let content = contentObject.init() as? Content else {
            assertionFailure("clazz not confirm to Content")
            return
        }
        
        if let cancelObject = cancelClazz as? NSObject.Type, let cancel = cancelObject.init() as? Cancel {
            self.cancel = cancel
        }
        self.content = content
        
        self.cover.dismiss = { [weak self] in
            self?.dismiss()
        }
        self.cancel?.dismiss = { [weak self] in
            self?.dismiss()
        }
        self.content?.dismiss = { [weak self] in
            self?.dismiss()
        }
    }
    
    deinit {
        print("Alert deinit")
    }
    
    // MARK: - Custom Method
    private func prepare() {

        if let content = self.content {
            content.set(with: items)
            container.set(content: content, cancel: self.cancel)
        }
        
        let window = UIApplication.shared.keyWindow
        cover.frame = UIScreen.main.bounds
        window?.addSubview(cover)
        window?.addSubview(container)
    }
    
    private func complete() {
        cover.removeFromSuperview()
        container.removeFromSuperview()
    }
}
