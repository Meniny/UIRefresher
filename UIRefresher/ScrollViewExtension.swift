//
//  ScrollViewExtension.swift
//  UIRefresher
//
//  Created by Elias Abel on 2017/12/19.
//  Copyright © 2017 Meniny Lab. All rights reserved.
//

import UIKit

private var headerKey: UInt8 = 0
private var footerKey: UInt8 = 0
private var tempFooterKey: UInt8 = 0

public extension UIScrollView {

    private var header: RefreshView? {
        get {
            return objc_getAssociatedObject(self, &headerKey) as? RefreshView
        }
        set {
            header?.removeFromSuperview()
            objc_setAssociatedObject(self, &headerKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            newValue.map { insertSubview($0, at: 0) }
        }
    }

    private var footer: RefreshView? {
        get {
            return objc_getAssociatedObject(self, &footerKey) as? RefreshView
        }
        set {
            footer?.removeFromSuperview()
            objc_setAssociatedObject(self, &footerKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            newValue.map { insertSubview($0, at: 0) }
        }
    }

    private var tempFooter: RefreshView? {
        get {
            return objc_getAssociatedObject(self, &tempFooterKey) as? RefreshView
        }
        set {
            objc_setAssociatedObject(self, &tempFooterKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    /// Indicator header
    ///
    /// - Parameters:
    ///   - height: refresh view height and also the trigger requirement, default is 60
    ///   - action: refresh action
    func setIndicatorHeader(height: CGFloat = 60,
                                       action: @escaping () -> Void) {
        header = IndicatorView(isHeader: true, height: height, action: action)
    }

    /// Indicator + Text header
    ///
    /// - Parameters:
    ///   - refreshText: text display for different states
    ///   - height: refresh view height and also the trigger requirement, default is 60
    ///   - action: refresh action
    func setTextHeader(refreshText: RefreshText = headerText,
                                  height: CGFloat = 60,
                                  action: @escaping () -> Void) {
        header = TextView(isHeader: true, refreshText: refreshText, height: height, action: action)
    }

    /// GIF header
    ///
    /// - Parameters:
    ///   - data: data for the GIF file
    ///   - flexible: whether the GIF is displayed with full screen width
    ///   - height: refresh view height and also the trigger requirement
    ///   - action: refresh action
    func setGIFHeader(data: Data,
                                 flexible: Bool = false,
                                 height: CGFloat = 60,
                                 action: @escaping () -> Void) {
        header = GIFHeader(data: data, flexible: flexible, height: height, action: action)
    }

    /// GIF + Text header
    ///
    /// - Parameters:
    ///   - data: data for the GIF file
    ///   - refreshText: text display for different states
    ///   - height: refresh view height and also the trigger requirement, default is 60
    ///   - action: refresh action
    func setGIFTextHeader(data: Data,
                                     refreshText: RefreshText = headerText,
                                     height: CGFloat = 60,
                                     action: @escaping () -> Void) {
        header = GIFTextHeader(data: data, refreshText: refreshText, height: height, action: action)
    }

    /// Custom header
    /// Inherit from RefreshView
    /// Update the presentation in 'didUpdateState(_:)' and 'didUpdateProgress(_:)' methods
    ///
    /// - Parameter header: your custom header inherited from RefreshView
    func setCustomHeader(_ header: RefreshView) {
        self.header = header
    }

    /// Begin refreshing with header
    func beginRefreshing() {
        header?.beginRefreshing()
    }

    /// End refreshing with both header and footer
    func endRefreshing() {
        header?.endRefreshing()
        footer?.endRefreshing()
    }

    /// End refreshing with footer and remove it
    func endRefreshingWithNoMoreData() {
        tempFooter = footer
        footer?.endRefreshing { [weak self] in
            self?.footer = nil
        }
    }

    /// Reset footer which is set to no more data
    func resetNoMoreData() {
        if footer == nil {
            footer = tempFooter
        }
    }

    /// Indicator footer
    ///
    /// - Parameters:
    ///   - height: refresh view height and also the trigger requirement, default is 60
    ///   - action: refresh action
    func setIndicatorFooter(height: CGFloat = 60,
                                       action: @escaping () -> Void) {
        footer = IndicatorView(isHeader: false, height: height, action: action)
    }

    /// Indicator + Text footer
    ///
    /// - Parameters:
    ///   - refreshText: text display for different states
    ///   - height: refresh view height and also the trigger requirement, default is 60
    ///   - action: refresh action
    func setTextFooter(refreshText: RefreshText = footerText,
                                  height: CGFloat = 60,
                                  action: @escaping () -> Void) {
        footer = TextView(isHeader: false, refreshText: refreshText, height: height, action: action)
    }

    /// Indicator auto refresh footer (auto triggered when scroll down to the bottom of the content)
    ///
    /// - Parameters:
    ///   - height: refresh view height, default is 60
    ///   - action: refresh action
    func setIndicatorAutoFooter(height: CGFloat = 60,
                                           action: @escaping () -> Void) {
        footer = IndicatorAutoFooter(height: height, action: action)
    }

    /// Indicator + Text auto refresh footer (auto triggered when scroll down to the bottom of the content)
    ///
    /// - Parameters:
    ///   - loadingText: text display for refreshing
    ///   - height: refresh view height, default is 60
    ///   - action: refresh action
    func setTextAutoFooter(loadingText: String = loadingText,
                                      height: CGFloat = 60,
                                      action: @escaping () -> Void) {
        footer = TextAutoFooter(loadingText: loadingText, height: height, action: action)
    }
    
    /// Custom footer
    /// Inherit from RefreshView
    /// Update the presentation in 'didUpdateState(_:)' and 'didUpdateProgress(_:)' methods
    ///
    /// - Parameter footer: your custom footer inherited from RefreshView
    func setCustomFooter(_ footer: RefreshView) {
        self.footer = footer
    }
}

public enum RefresherType {
    case indicator
    case text(RefreshText)
    case custom(RefreshView)
    case gif(Data, flexible: Bool)
    case gifText(Data, text: RefreshText)
}

public extension UIScrollView {
    
    func setLoadMoreFooter(_ type: RefresherType, height h: CGFloat = 60, action a: @escaping () -> Void) {
        switch type {
        case .indicator:
            self.setIndicatorFooter(height: h, action: a)
            break
        case .text(let t):
            self.setTextFooter(refreshText: t, height: h, action: a)
            break
        case .custom(let rv):
            rv.height = h
            rv.action = a
            self.setCustomFooter(rv)
            break
        case .gif(_, _), .gifText(_, _):
            self.setIndicatorFooter(height: h, action: a)
            break
        }
    }
    
    func setRefreshHeader(_ type: RefresherType, height h: CGFloat, action a: @escaping () -> Void) {
        switch type {
        case .indicator:
            self.setIndicatorHeader(height: h, action: a)
            break
        case .text(let t):
            self.setTextHeader(refreshText: t, height: h, action: a)
            break
        case .custom(let rv):
            rv.height = h
            rv.action = a
            self.setCustomHeader(rv)
            break
        case let .gif(d, f):
            self.setGIFHeader(data: d, flexible: f, height: h, action: a)
            break
        case let .gifText(d, t):
            self.setGIFTextHeader(data: d, refreshText: t, height: h, action: a)
            break
        }
    }
}

/// Text display for different states
public struct RefreshText {
    public let loadingText: String
    public let pullingText: String
    public let releasingText: String

    /// Initialization method
    ///
    /// - Parameters:
    ///   - loadingText: text display for refreshing
    ///   - pullingText: text display for dragging when don't reach the trigger
    ///   - releasingText: text display for dragging when reach the trigger
    public init(loadingText: String, pullingText: String, releasingText: String) {
        self.loadingText = loadingText
        self.pullingText = pullingText
        self.releasingText = releasingText
    }
}

private let isChinese = Locale.preferredLanguages[0].contains("zh-Han")

public let loadingText = isChinese ? "正在加载..." : "Loading..."

public let headerText = RefreshText(
    loadingText: loadingText,
    pullingText: isChinese ? "下拉刷新" : "Pull down to refresh",
    releasingText: isChinese ? "释放刷新" : "Release to refresh"
)

public let footerText = RefreshText(
    loadingText: loadingText,
    pullingText: isChinese ? "上拉加载" : "Pull up to load more",
    releasingText: isChinese ? "释放加载" : "Release to load more"
)
