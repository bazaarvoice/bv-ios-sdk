//
//  CircleSearchView.swift
//  ControlExperiments
//
//  Created by Sergio Azua on 2/23/17.
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

import UIKit

public class CircleSearchResult<ResultType> {
    let title: String
    let result: ResultType
    
    internal init(title: String, result: ResultType) {
        self.title = title
        self.result = result
    }
}

fileprivate enum ViewState {
    case iconOnly,
    searchBar,
    fullScreen
}

public class CircleSearchView<ResultType>: UIView, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    public typealias SearchCompletionHandler = (_ results: [CircleSearchResult<ResultType>]) -> Void
    public typealias SearchChangedHandler = (_ circleSearchView: CircleSearchView, _ searchText: String, _ emptyResults: inout [CircleSearchResult<ResultType>], _ completion: @escaping SearchCompletionHandler) -> Void
    public typealias SearchResultTappedHandler = (_ circleSearchView: CircleSearchView, _ result: ResultType) -> Void
    
    public var minimumSearchLength = 3
    public var minKeyboardRestTimeToSearch: TimeInterval = 0.5
    public let searchTextField:UITextField
    public let searchButton:UIButton
    public let cancelButton:UIButton
    public let searchTableView:UITableView
    
    private var viewState = ViewState.iconOnly
    private var searchTimer: Timer?
    private let shortDuration: TimeInterval = 0.06
    private let standardDuration: TimeInterval = 0.12
    private let searchBarHeight: CGFloat = 35.0
    private var searchBarInsetY: CGFloat!
    private weak var embeddingScrollView: UIScrollView!
    private var searchFieldConstraintPack: ViewStateConstraintPack!
    private var searchTableConstraintPack: ViewStateConstraintPack!
    private var searchButtonConstraintPack: ViewStateConstraintPack!
    private var cancelButtonConstraintPack: ViewStateConstraintPack!
    private var centerYConstraint: NSLayoutConstraint!
    private var searchResults = [CircleSearchResult<ResultType>]()
    private let cellReuseId = "searchResultReuseId"
    private let searchChangedHandler: SearchChangedHandler
    private let searchResultTappedHandler: SearchResultTappedHandler
    
    public init(scrollView: UIScrollView, changeHandler: @escaping SearchChangedHandler, tappedHandler: @escaping SearchResultTappedHandler) {
        
        searchTextField = UITextField()
        searchTableView = UITableView()
        searchButton = UIButton(type: .custom)
        cancelButton = UIButton(type: .custom)
        searchChangedHandler = changeHandler
        searchResultTappedHandler = tappedHandler
        
        super.init(frame: scrollView.frame)
        searchBarInsetY = searchBarHeight + 16
        
        //        applyDebugUI()
        
        setupSelf(scrollView: scrollView)
        setupCancelButton()
        setupSearchButton()
        setupSearchBar()
        setupSearchTable()
        embeddingScrollView = scrollView
    }
    
    public override func removeFromSuperview() {
        superview!.removeObserver(self, forKeyPath: "contentOffset")
        super.removeFromSuperview()
    }
    
    func cancelPressed(btn: UIButton) {
        searchTextField.resignFirstResponder()
        embeddingScrollView.isScrollEnabled = true
        updateState(from: embeddingScrollView.contentOffset, force: true)
    }
    
    func searchPressed(btn: UIButton) {
        animateFullScreen()
        searchTextField.becomeFirstResponder()
    }
    
    private func setupSelf(scrollView: UIScrollView) {
        scrollView.addSubview(self)
        scrollView.contentInset = UIEdgeInsets(top: searchBarInsetY, left: 0, bottom: 0, right: 0)
        self.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addObserver(self, forKeyPath: "contentOffset", options: .new, context: nil)
        
        let centerX = NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: scrollView, attribute: .centerX, multiplier: 1, constant: 0)
        centerYConstraint = NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: scrollView, attribute: .centerY, multiplier: 1, constant: searchBarInsetY * -1)
        let height = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: scrollView, attribute: .height, multiplier: 1, constant: 0)
        let width = NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: scrollView, attribute: .width, multiplier: 1, constant: 0)
        
        NSLayoutConstraint.activate([centerX, centerYConstraint, height, width])
    }
    
    private func setupSearchButton() {
        self.addSubview(searchButton)
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        let iconImage = UIImage(named: "searchIcon")
        searchButton.setImage(iconImage?.withRenderingMode(.alwaysTemplate), for: .normal)
        searchButton.addTarget(self, action: #selector(CircleSearchView.searchPressed(btn:)), for: .touchUpInside)
        searchButton.layer.borderColor = UIColor.rgbColor(r: 210, g: 210, b: 210).cgColor
        searchButton.layer.borderWidth = 1
        searchButton.backgroundColor = UIColor.white
        
        let leading = NSLayoutConstraint(item: self, attribute: .left, relatedBy: .equal, toItem: searchButton, attribute: .left, multiplier: 1, constant: -8)
        let height = NSLayoutConstraint(item: searchButton, attribute: .height, relatedBy: .equal, toItem: searchTextField, attribute: .height, multiplier: 1, constant: 0)
        let width = NSLayoutConstraint(item: searchButton, attribute: .width, relatedBy: .equal, toItem: searchButton, attribute: .height, multiplier: 1, constant: 0)
        let top = NSLayoutConstraint(item: searchTextField, attribute: .top, relatedBy: .equal, toItem: searchButton, attribute: .top, multiplier: 1, constant: 0)
        
        let fullWidth = NSLayoutConstraint(item: searchButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 0)
        fullWidth.isActive = false
        
        let iconStateSearch = [leading, height, width, top]
        let searchBarStateSearch = [leading, height, width, top]
        let fullScreenStateSearch = [leading, height, fullWidth, top]
        
        searchButtonConstraintPack = ViewStateConstraintPack(iconOnlyStateConstraints: iconStateSearch,
                                                             searchBarStateConstraints: searchBarStateSearch,
                                                             fullScreenStateConstraints: fullScreenStateSearch)
    }
    
    private func setupCancelButton() {
        self.addSubview(cancelButton)
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.addTarget(self, action: #selector(CircleSearchView.cancelPressed(btn:)), for: .touchUpInside)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.setTitleColor(UIColor.black, for: .normal)
        cancelButton.layer.borderColor = UIColor.rgbColor(r: 210, g: 210, b: 210).cgColor
        cancelButton.layer.borderWidth = 1
        cancelButton.backgroundColor = UIColor.white
        
        let trailing = NSLayoutConstraint(item: self, attribute: .right, relatedBy: .equal, toItem: cancelButton, attribute: .right, multiplier: 1, constant: 8)
        let height = NSLayoutConstraint(item: cancelButton, attribute: .height, relatedBy: .equal, toItem: searchTextField, attribute: .height, multiplier: 1, constant: 0)
        let width = NSLayoutConstraint(item: cancelButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 0)
        let top = NSLayoutConstraint(item: searchTextField, attribute: .top, relatedBy: .equal, toItem: cancelButton, attribute: .top, multiplier: 1, constant: 0)
        
        let fullWidth = NSLayoutConstraint(item: cancelButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 65)
        fullWidth.isActive = false
        
        let iconStateSearch = [trailing, height, width, top]
        let searchBarStateSearch = [trailing, height, width, top]
        let fullScreenStateSearch = [trailing, height, fullWidth, top]
        
        cancelButtonConstraintPack = ViewStateConstraintPack(iconOnlyStateConstraints: iconStateSearch,
                                                             searchBarStateConstraints: searchBarStateSearch,
                                                             fullScreenStateConstraints: fullScreenStateSearch)
        
    }
    
    private func setupSearchBar() {
        self.addSubview(searchTextField)
        searchTextField.delegate = self
        searchTextField.clearButtonMode = .whileEditing
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        searchTextField.backgroundColor = UIColor.white
        searchTextField.layer.borderColor = UIColor.rgbColor(r: 210, g: 210, b: 210).cgColor
        searchTextField.layer.borderWidth = 1
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 4, height: searchBarHeight))
        searchTextField.leftView = paddingView
        searchTextField.leftViewMode = .always
        searchTextField.autocorrectionType = .no
        searchTextField.returnKeyType = .search
        
        let heightConstraintSearch = NSLayoutConstraint(item: searchTextField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: searchBarHeight)
        let leadingConstraintSearch = NSLayoutConstraint(item: searchButton, attribute: .right, relatedBy: .equal, toItem: searchTextField, attribute: .left, multiplier: 1, constant: 0)
        let trailingConstraintSearch = NSLayoutConstraint(item: cancelButton, attribute: .left, relatedBy: .equal, toItem: searchTextField, attribute: .right, multiplier: 1, constant: 0)
        let topConstraintSearch = NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: searchTextField, attribute: .top , multiplier: 1, constant: -8)
        
        
        let iconSizeWidth = NSLayoutConstraint(item: searchTextField, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 0)
        iconSizeWidth.isActive = false
        
        let topConstraintFull = NSLayoutConstraint(item: self, attribute: .topMargin, relatedBy: .equal, toItem: searchTextField, attribute: .topMargin, multiplier: 1, constant: -8)
        topConstraintFull.isActive = false
        
        searchTextField.addConstraint(heightConstraintSearch)
        searchTextField.addConstraint(iconSizeWidth)
        
        let iconStateSearch = [heightConstraintSearch, leadingConstraintSearch, topConstraintSearch, iconSizeWidth]
        let searchBarStateSearch = [heightConstraintSearch, leadingConstraintSearch, trailingConstraintSearch, topConstraintSearch]
        let fullScreenStateSearch = [heightConstraintSearch, leadingConstraintSearch, trailingConstraintSearch, topConstraintFull]
        
        searchFieldConstraintPack = ViewStateConstraintPack(iconOnlyStateConstraints: iconStateSearch,
                                                            searchBarStateConstraints: searchBarStateSearch,
                                                            fullScreenStateConstraints: fullScreenStateSearch)
        
    }
    
    private func setupSearchTable() {
        self.addSubview(searchTableView)
        searchTableView.delegate = self
        searchTableView.dataSource = self
        searchTableView.translatesAutoresizingMaskIntoConstraints = false
        searchTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseId)
        
        let height = NSLayoutConstraint(item: searchTableView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 0)
        let width = NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: searchTableView, attribute: .width, multiplier: 1, constant: 0)
        let top = NSLayoutConstraint(item: searchTextField, attribute: .bottom, relatedBy: .equal, toItem: searchTableView, attribute: .top, multiplier: 1, constant: -8)
        let leading = NSLayoutConstraint(item: self, attribute: .left, relatedBy: .equal, toItem: searchTableView, attribute: .left, multiplier: 1, constant: 0)
        searchTableView.addConstraint(height)
        
        let fullScreenHeight = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: searchTableView, attribute: .height, multiplier: 1, constant: 0)
        fullScreenHeight.isActive = false
        let iconState = [height, width, top, leading]
        let searchBarState = [height, width, top, leading]
        let fullScreenState = [fullScreenHeight, width, top, leading]
        
        searchTableConstraintPack = ViewStateConstraintPack(iconOnlyStateConstraints: iconState,
                                                            searchBarStateConstraints: searchBarState,
                                                            fullScreenStateConstraints: fullScreenState)
    }
    
    private func applyDebugUI() {
        backgroundColor = UIColor.rgbaColor(r: 0, g: 0, b: 0, a: 125)
        searchTextField.backgroundColor = UIColor.green
        searchButton.backgroundColor = UIColor.blue
        cancelButton.backgroundColor = UIColor.red
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func getTransitionDuration(startState: ViewState, endState: ViewState) -> TimeInterval {
        if startState == .iconOnly && endState == .searchBar {
            return shortDuration
        }
        
        return standardDuration
    }
    
    private func animateFullScreen() {
        embeddingScrollView.isScrollEnabled = false//(searchTableView.isHidden || searchTableView.alpha == 0)
        superview?.bringSubview(toFront: self)
        animateTransition(to: .fullScreen)
    }
    
    public func animateDismissFullScreen() {
        self.cancelPressed(btn: cancelButton)
    }
    
    private func animateTransition(to state: ViewState) {
        
        if state == .fullScreen {
            Timer.scheduledTimer(timeInterval: 0.75, target: self, selector: #selector(updateEmbeddingScrollability), userInfo: nil, repeats: false)
        }
        
        if viewState == state {
            return
        }
        
        if state == .iconOnly {
            searchTextField.leftViewMode = .never
        }else {
            searchTextField.leftViewMode = .always
        }
        
        viewState = state
        
        let duration = getTransitionDuration(startState: viewState, endState: state)
        
        toggleConstraints(for: state)
        
        self.viewLayerAnimations(for: state, duration:  duration)
        
        UIView.animate(withDuration: duration) {
            self.layoutIfNeeded()
        }
    }
    
    @objc
    private func updateEmbeddingScrollability() {
        self.embeddingScrollView.isScrollEnabled = (self.searchTableView.isHidden || self.searchTableView.alpha == 0)
    }
    
    private func toggleConstraints(for state: ViewState) {
        
        let deactivate = searchFieldConstraintPack.constraintsToDeactivate() +
            searchTableConstraintPack.constraintsToDeactivate() +
            searchButtonConstraintPack.constraintsToDeactivate() +
            cancelButtonConstraintPack.constraintsToDeactivate()
        
        NSLayoutConstraint.deactivate(deactivate)
        
        let activate = searchFieldConstraintPack.constraintsToActivate(state) +
            searchTableConstraintPack.constraintsToActivate(state) +
            searchButtonConstraintPack.constraintsToActivate(state) +
            cancelButtonConstraintPack.constraintsToActivate(state)
        
        NSLayoutConstraint.activate(activate)
    }
    
    private func viewLayerAnimations(for state: ViewState, duration: TimeInterval) {
        switch state {
        case .searchBar:
            searchButton.addCornerRadiusAnimation(from: searchButton.layer.cornerRadius, to: 0.0, duration: duration)
            break
        case .iconOnly:
            searchButton.addCornerRadiusAnimation(from: searchButton.layer.cornerRadius, to: searchBarHeight / 2, duration: duration)
            break
        case .fullScreen:
            break
        }
    }
    
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        animateFullScreen()
        return true
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if searchTimer != nil
        {
            searchTimer?.invalidate()
            searchTimer = nil
        }
        
        let result = textField.text?.replacingCharacters(in: (textField.text?.rangeFromNSRange(range)!)!, with: string)
        if result!.characters.count >= minimumSearchLength
        {
            searchTimer = Timer.scheduledTimer(timeInterval: minKeyboardRestTimeToSearch, target:self, selector: #selector(CircleSearchView.notifyDelegateOfSearch(_:)), userInfo: result, repeats: false)
        }
        return true
    }
    
    internal func notifyDelegateOfSearch(_ timer:Timer)
    {
        var emptyResults = [CircleSearchResult<ResultType>]()
        searchChangedHandler(self, timer.userInfo as! String, &emptyResults){[weak self](results) in
            self?.searchResultsDidChange(searchResults: results)
        }
    }
    
    private func searchResultsDidChange(searchResults: [CircleSearchResult<ResultType>]) {
        self.searchResults = searchResults
        self.searchTableView.reloadData()
    }
    
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentOffset" {
            if let obj = object as? UIScrollView {
                updateState(from: obj.contentOffset, force: false)
            }
        }else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    private func updateState(from offset: CGPoint, force: Bool) {
        let currentContentTop = ((offset.y) + embeddingScrollView.contentInset.top)
        centerYConstraint.constant = currentContentTop - searchBarInsetY
        if viewState != .fullScreen || force{
            if currentContentTop > 0.0{
                animateTransition(to: .iconOnly)
            }else {
                animateTransition(to: .searchBar)
            }
        }
    }
    
    // MARK: UITableViewDataSource
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseId, for: indexPath)
        cell.textLabel?.text = searchResults[indexPath.row].title
        return cell
    }
    
    // MARK: UITableViewDelegate
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let result = searchResults[indexPath.row].result
        searchResultTappedHandler(self, result)
    }
    
    override public func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return searchTextField.frame.contains(point) ||
            searchButton.frame.contains(point) ||
            cancelButton.frame.contains(point) ||
            (searchTableView.frame.contains(point) && !searchTableView.isHidden)
    }
}

fileprivate class ViewStateConstraintPack {
    
    private let iconOnlyStateConstraints: [NSLayoutConstraint]
    private let searchBarStateConstraints: [NSLayoutConstraint]
    private let fullScreenStateConstraints: [NSLayoutConstraint]
    
    init(iconOnlyStateConstraints: [NSLayoutConstraint],
         searchBarStateConstraints: [NSLayoutConstraint],
         fullScreenStateConstraints: [NSLayoutConstraint]) {
        self.iconOnlyStateConstraints = iconOnlyStateConstraints
        self.searchBarStateConstraints = searchBarStateConstraints
        self.fullScreenStateConstraints = fullScreenStateConstraints
    }
    
    func constraintsToDeactivate() -> [NSLayoutConstraint] {
        return iconOnlyStateConstraints + searchBarStateConstraints + fullScreenStateConstraints
    }
    
    func constraintsToActivate(_ state: ViewState) -> [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint]!
        
        switch state {
        case .searchBar:
            constraints = searchBarStateConstraints
            break
        case .iconOnly:
            constraints = iconOnlyStateConstraints
            break
        case .fullScreen:
            constraints = fullScreenStateConstraints
            break
        }
        
        return constraints
    }
}


fileprivate extension UIView
{
    func addCornerRadiusAnimation(from: CGFloat, to: CGFloat, duration: CFTimeInterval)
    {
        let animation = CABasicAnimation(keyPath:"cornerRadius")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.fromValue = from
        animation.toValue = to
        animation.duration = duration
        self.layer.add(animation, forKey: "cornerRadius")
        self.layer.cornerRadius = to
    }
}

fileprivate extension String {
    func rangeFromNSRange(_ nsRange : NSRange) -> Range<String.Index>? {
        guard
            let from16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location, limitedBy: utf16.endIndex),
            let to16 = utf16.index(from16, offsetBy: nsRange.length, limitedBy: utf16.endIndex),
            let from = from16.samePosition(in: self),
            let to = to16.samePosition(in: self)
            else { return nil }
        return from ..< to
    }
    func NSRangeFromRange(_ range : Range<String.Index>) -> NSRange {
        let from = range.lowerBound.samePosition(in: utf16)
        let to = range.upperBound.samePosition(in: utf16)
        return NSRange(location: utf16.distance(from: utf16.startIndex, to: from),
                       length: utf16.distance(from: from, to: to))
    }
}

fileprivate extension UIColor {
    
    static func rgbColor(r: Int, g: Int, b: Int) -> UIColor{
        return rgbaColor(r: r, g: g, b: b, a: 255)
    }
    
    static func rgbaColor(r: Int, g: Int, b: Int, a: Int) -> UIColor{
        return UIColor(colorLiteralRed: Float(Double(r) / 255.0), green: Float(Double(g) / 255.0), blue: Float(Double(b) / 255.0), alpha: Float(Double(a) / 255.0))
    }
}

