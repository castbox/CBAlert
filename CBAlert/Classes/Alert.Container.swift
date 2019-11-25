//
//  Alert.UI.swift
//  Castbox
//
//  Created by lazy on 2018/7/12.
//  Copyright © 2018年 Guru. All rights reserved.
//

import Foundation

extension _Alert {
    
    enum State {
        case show
        case dismiss
    }
    
    class Cover: UIView {
        
        public var dismiss: (()->())?
        
        internal var state: State = .dismiss {
            didSet {
                switch state {
                case .show:
                    self.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.4)
                case .dismiss:
                    self.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
                }
            }
        }
        
        override init(frame: CGRect) {
            super.init(frame: UIScreen.main.bounds)
            
            backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(onTapDismiss))
            addGestureRecognizer(tap)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        @objc private func onTapDismiss() {
            dismiss?()
        }
        
        deinit {
            print("Cover deinit")
        }
    }
    
    class Container: UIView {
        
        private let kScreenWidth: CGFloat = UIScreen.main.bounds.width
        private let kScreenHeight: CGFloat = UIScreen.main.bounds.height
        
        private var totalWidth: CGFloat = {
            if UIDevice.current.userInterfaceIdiom == .pad {
                return 414 // Xs Max screen width
            } else {
                return UIScreen.main.bounds.width
            }
        }()

        private var totoalHeight: CGFloat = 0.0
        
        // MARK: - Internal
        internal var state: State = .dismiss {
            didSet {
                switch state {
                case .show:
                    var frame = self.frame
                    frame.origin = CGPoint(x: (UIScreen.main.bounds.width - totalWidth) / 2, y: UIScreen.main.bounds.height - totoalHeight)
                    self.frame = frame
                case .dismiss:
                    var frame = self.frame
                    frame.origin = CGPoint(x: (UIScreen.main.bounds.width - totalWidth) / 2, y: UIScreen.main.bounds.height)
                    self.frame = frame
                }
            }
        }
        
        internal func set(content: Content, cancel: Cancel?) {
            
            let _content = content.view()
            totoalHeight = content.frame().height
            self.bounds = CGRect(x: 0, y: 0, width: totalWidth, height: totoalHeight)
            let paddingH = content.frame().origin.x
            _content.frame = CGRect(x: content.frame().origin.x, y: 0.0, width: self.bounds.width - paddingH * 2, height: totoalHeight)
            addSubview(_content)
            
            if let cancel = cancel {
                let _cancel = cancel.view()
                _cancel.frame = CGRect(x: _cancel.frame.origin.x, y: _content.frame.maxY, width: _cancel.bounds.width, height: _cancel.bounds.height)
                
                totoalHeight += cancel.frame().height
                addSubview(_cancel)
            }
            
            self.state = .dismiss
        }
        
        // MARK: - Life Cycle
//        override init(frame: CGRect) {
//            super.init(frame: frame)
//
//            let maskPath = UIBezierPath(roundedRect: self.bounds,
//                                        byRoundingCorners: [UIRectCorner.topLeft, UIRectCorner.topRight],
//                                        cornerRadii: CGSize(width: 5.0, height: 5.0))
//
//            let maskLayer = CAShapeLayer()
//            maskLayer.frame = self.bounds
//            maskLayer.path = maskPath.cgPath
//
//            layer.mask = maskLayer
//        }
//
//        required init?(coder aDecoder: NSCoder) {
//            fatalError("init(coder:) has not been implemented")
//        }
        
        deinit {
            print("Container deinit")
        }
    }
}
