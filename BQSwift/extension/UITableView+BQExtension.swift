// *******************************************
//  File Name:      UITableView+BQExtension.swift
//  Author:         MrBai
//  Created Date:   2019/8/15 2:29 PM
//
//  Copyright © 2019 baiqiang
//  All rights reserved
// *******************************************

import UIKit

typealias TableViewProtocol = UITableViewDelegate & UITableViewDataSource

protocol EmptyViewProtocol: NSObjectProtocol {
    /// 用以判断是会否显示空视图
    func showEmptyView(tableView: UITableView) -> Bool

    /// 配置空数据提示图用于展示
    func configEmptyView(tableView: UITableView) -> UIView
}

extension EmptyViewProtocol {
    func configEmptyView() -> UIView {
        return UIView()
    }
}

extension UITableView {
    // MARK: - ***** Public Method *****

    /// convenience method use config tableView has no separator
    convenience init(frame: CGRect, style: UITableView.Style, delegate: TableViewProtocol) {
        self.init(frame: frame, style: style)
        separatorStyle = .none
        tableFooterView = UIView()
        estimatedRowHeight = 50
        dataSource = delegate
        self.delegate = delegate
    }

    func setEmtpyViewDelegate(target: EmptyViewProtocol) {
        emptyDelegate = target
        DispatchQueue.once(token: #function) {
            UITableView.exchangeMethod(targetSel: #selector(layoutSubviews), newSel: #selector(re_layoutSubviews))
        }
    }

    @objc func re_layoutSubviews() {
        re_layoutSubviews()
        if let delegate = emptyDelegate {
            if delegate.showEmptyView(tableView: self) {
                let emptyView = delegate.configEmptyView(tableView: self)
                let emptyViewTag = 10_231_343

                if let v = viewWithTag(emptyViewTag), v != emptyView {
                    v.removeFromSuperview()
                }

                if emptyView.superview == nil {
                    emptyView.tag = emptyViewTag
                    addSubview(emptyView)
                }
            }
        }
    }

    // MARK: - ***** Associated Object *****

    private enum AssociatedKeys {
        static var emptyDelegateKey: Void?
    }

    private var emptyDelegate: EmptyViewProtocol? {
        get {
            return (objc_getAssociatedObject(self, &AssociatedKeys.emptyDelegateKey) as? EmptyViewProtocol)
        }
        set(newValue) {
            objc_setAssociatedObject(self, &AssociatedKeys.emptyDelegateKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
}

public extension UITableViewCell {
    /// 获取cell标示符，标示符为cell名称
    static func getCellName() -> String {
        return description().components(separatedBy: ".").last!
    }

    /// 注册cell
    static func register(to tableV: UITableView, isNib: Bool = false) {
        let identifier = getCellName()
        if isNib {
            tableV.register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
        } else {
            tableV.register(self, forCellReuseIdentifier: identifier)
        }
    }

    /// 加载cell
    static func load(from tableV: UITableView, indexPath: IndexPath) -> Self {
        return tableV.dequeueReusableCell(withIdentifier: getCellName(), for: indexPath) as! Self
    }

    /// 加载临时cell用于计算cell相关属性并缓存
    static func loadTempleteCell(from tableV: UITableView) -> Self {
        return tableV.dequeueReusableCell(withIdentifier: getCellName()) as! Self
    }

    /// 获取cell的最大高度(layout和frame对比)
    func fetchCellHeight(from tableV: UITableView) -> CGFloat {
        var fittingHeight: CGFloat = 0

        var contentViewWidth = tableV.bounds.width
        if let accessoryView = self.accessoryView {
            contentViewWidth -= (16 + accessoryView.bounds.width)
        } else {
            let systemAccessoryWidths: [CGFloat] = [0, 34, 68, 40, 48]
            contentViewWidth -= systemAccessoryWidths[accessoryType.rawValue]
        }

        let widthFenceConstraint = NSLayoutConstraint(item: contentView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: contentViewWidth)
        widthFenceConstraint.priority = UILayoutPriority.required - 1

        let leftConstraint = NSLayoutConstraint(item: contentView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: contentViewWidth)
        let rightConstraint = NSLayoutConstraint(item: contentView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: contentViewWidth)
        let topConstraint = NSLayoutConstraint(item: contentView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: contentViewWidth)
        let bottomConstraint = NSLayoutConstraint(item: contentView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: contentViewWidth)
        let edgeConstraint = [leftConstraint, rightConstraint, topConstraint, bottomConstraint]
        addConstraints(edgeConstraint)
        contentView.addConstraint(widthFenceConstraint)

        fittingHeight = contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height

        contentView.removeConstraint(widthFenceConstraint)
        removeConstraints(edgeConstraint)

        if tableV.separatorStyle != .none {
            fittingHeight += (1.0 / UIScreen.main.scale)
        }

        return max(bounds.height, fittingHeight)
    }
}

#if canImport(MJRefresh)
    import MJRefresh

    extension UITableView {
        func addHeaderRefresh(block: @escaping VoidBlock) {
            let head = MJRefreshNormalHeader(refreshingBlock: block)
            mj_header = head
        }

        func addFooterRefresh(block: @escaping VoidBlock) {
            let footer = MJRefreshAutoNormalFooter(refreshingBlock: block)
            mj_footer = footer
        }
    }

#endif
