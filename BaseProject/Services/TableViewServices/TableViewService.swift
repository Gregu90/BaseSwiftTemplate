//
//  TableViewService.swift
//  BaseProject
//
//  Created by Admin on 10.05.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

struct Pagination
{
    var take: Int
    var skip: Int
    
    init(take: Int, skip: Int)
    {
        self.take = take
        self.skip = skip
    }
    
    init(takeTop: Int)
    {
        self.init(take: takeTop, skip: 0)
    }
    
    func queryParams() -> [String:Int]
    {
        return ["take":self.take, "skip": self.skip]
    }
}

struct IDBasedPagination
{
    var take: Int
    var coursor: String?
    var takeAbove = false
    
    init(takeTop: Int)
    {
        self.take = takeTop
    }
    
    init(take: Int, after: String)
    {
        self.take = take
        self.coursor = after
    }
    
    init(take: Int, before: String)
    {
        self.take = take
        self.coursor = before
        self.takeAbove = false
    }
    
    func queryParams() -> [String:Any]
    {
        let idKey = self.takeAbove ? "BeforeId" : "AfterId"
        var paramsDict: [String: Any] = ["take": self.take]
        if let skipID = self.coursor {
            paramsDict.updateValue(skipID, forKey: idKey)
        }
        return paramsDict
    }
}


protocol TableViewServiceDelegate: class, UIScrollViewDelegate
{
    //required
    func tableViewService(_ service: TableViewService, refreshTriggeredWithPagination pagination:Pagination, andCompletion completion: @escaping TableViewService.RefreshCompletion)
    
    //optional
    func tableViewService(showLoader service: TableViewService, type: AlertView.SpinnerType)
    func tableViewService(removeLoader service: TableViewService, errorMessage: String?)
    func tableViewService(_ service: TableViewService, routerToProcess: Routable)
    func tableViewService(showAlert message: String?, buttons: [String]?, handler: AlertView.AlertHandler?)
}

extension TableViewServiceDelegate
{
    func tableViewService(_ service: TableViewService, errorOcuredWithLocalizedMessage: String){}
    func tableViewService(showLoader service: TableViewService, type: AlertView.SpinnerType){}
    func tableViewService(removeLoader service: TableViewService, errorMessage: String?){}
    func tableViewService(_ service: TableViewService, routerToProcess: Routable){}
    func tableViewService(showAlert message: String?, buttons: [String]?, handler: AlertView.AlertHandler?){}
}

class TableViewService: NSObject, UITableViewDataSource, UITableViewDelegate, TableViewServiceSectionDelegate
{
    typealias RefreshCompletion = (_ elements: [Any]?, _ whenDone: (()->())?) -> ()
    
    var tableViewBackgroundColor = AppColor.defaultBackground.color
    weak var tableView: UITableView?
    weak var delegate: TableViewServiceDelegate?
    
    var cellHeightsDictionary: NSMutableDictionary = [:]
    
    fileprivate var refreshControl: UIRefreshControl?
    var refreshControntrolOffsetY: CGFloat = 0
    
    var refreshable = false {
        didSet {
            if refreshable && self.refreshControl == nil {
                self.refreshControl = UIRefreshControl()
                self.refreshControl?.addTarget(self, action: #selector(self.refreshTriggeredByRefreshControl), for: .valueChanged)
                var bounds = self.refreshControl!.bounds
                bounds.origin.y = self.refreshControntrolOffsetY
                self.refreshControl?.bounds = bounds
                self.tableView?.addSubview(self.refreshControl!)
                self.tableView?.sendSubview(toBack: self.refreshControl!)
            }else{
                self.refreshControl?.removeFromSuperview()
                self.refreshControl = nil
            }
        }
    }
    
    @objc func refreshTriggeredByRefreshControl()
    {
        self.refresh()
    }
    
    func refresh(_ removeAll: Bool = false)
    {
        if removeAll {
            self.elements.removeAll()
            self.sections.removeAll()
            self.tableView?.reloadData()
        }
        let pagination = Pagination(takeTop: self.batchSize)
        self.requestContentWithPagination(pagination)
    }
    
    fileprivate let refreshControlStandardHeight: CGFloat = 60
    
    fileprivate func beginRefreshing(_ completion:(()->Void)?)
    {
        if let refreshControl = self.refreshControl, let tableView = self.tableView {
            refreshControl.beginRefreshing()
            if (tableView.contentOffset.y == 0 ||
                -tableView.contentOffset.y == tableView.contentInset.top - self.refreshControlStandardHeight) {
                UIView.animate(withDuration: 0.25, animations: {
                    [weak self]() -> Void in
                    if let sself = self {
                        let refreshControlHeight = refreshControl.frame.size.height + sself.refreshControntrolOffsetY
                        sself.tableView?.contentOffset = CGPoint(x: 0, y: -refreshControlHeight)
                    }
                    }, completion: { (_) -> Void in
                        completion?()
                })
            }else{
                completion?()
            }
        }else{
            completion?()
        }
    }
    
    fileprivate func loadMore()
    {
        let pagination = Pagination(take: self.batchSize, skip: self.elements.count)
        self.requestContentWithPagination(pagination)
    }
    
    fileprivate func requestContentWithPagination(_ pagination: Pagination)
    {
        let request = {
            [weak self]()->Void in
            if let sself = self {
                sself.delegate?.tableViewService(sself, refreshTriggeredWithPagination: pagination, andCompletion: {
                    [weak sself](elements, doneClosure) -> () in
                    if let ssself = sself {
                        ssself.elementsAdded(elements, withPagination: pagination, whenDone: doneClosure)
                    }
                })
            }
        }
        self.isLoadingMoreContent = true
        if pagination.skip == 0 {
            self.beginRefreshing {
                request()
            }
        }else{
            request()
        }
        
    }
    
    fileprivate func elementsAdded(_ elements: [Any]?, withPagination pagination:Pagination, whenDone: (()->())? = nil)
    {
        let elementsCount = elements?.count ?? 0
        if elementsCount < self.batchSize {
            if self.autoEndPagination {
                self.hasPaginationEnded = true
            }
        }
        if let elements = elements {
            var newlyAddedSections = self.sectionsForElements(elements)
            
            
            if pagination.skip == 0 {
                if elements.count == self.batchSize {
                    if self.autoEndPagination {
                        self.hasPaginationEnded = false
                    }
                }

                self.elements = elements
                self.sections = newlyAddedSections
                self.reloadData({
                    [weak self]() -> Void in
                    if let sself = self {
                        if sself.reverseOrder {
                            sself.scrollToBottom()
                        }
                        whenDone?()
                    }
                })
            }else{
                if elements.count > 0 {
                    if self.reverseOrder {
                        self.elements.insert(contentsOf: elements, at: 0)
                        self.sections.insert(contentsOf: newlyAddedSections, at: 1)
                    }else{
                        self.elements.append(contentsOf: elements)
                        self.sections.insert(contentsOf: newlyAddedSections, at: self.sections.count-1)
                    }
                    self.updateTableView(newlyAddedSections)
                    whenDone?()
                }
            }
        }else{
            self.reloadData({
                whenDone?()
            })
        }
        self.isLoadingMoreContent = false
    }
    
    fileprivate func reloadData(_ completion:(()->())? = nil)
    {
        let duration: TimeInterval = 0.1
        if self.animateReload {
            self.animateTableViewAlpha(duration, whenHidden: {
                [weak self]()->Void in
                if let sself = self {
                    sself.tableView?.reloadData()
                }
            }) {
                completion?()
            }
        }else{
            self.tableView?.reloadData()
            completion?()
        }
        if self.refreshControl?.isRefreshing == true {
            delay(duration) {
                [weak self]()-> Void in
                if let sself = self {
                    sself.refreshControl?.endRefreshing()
                }
            }
        }
        
    }
    
    fileprivate func animateTableViewAlpha(_ duration: TimeInterval, whenHidden:@escaping ()->Void, completion:(()->Void)?)
    {
        let duration: TimeInterval = 0.1
        UIView.animate(withDuration: duration, animations: {
            [weak self]()->Void in
            if let sself = self {
                sself.tableView?.alpha = 0
            }
            }, completion: {
                (_) -> Void in
                whenHidden()
                UIView.animate(withDuration: duration, delay: duration/2, options: UIViewAnimationOptions(), animations: {
                    [weak self]()->Void in
                    if let sself = self {
                        sself.tableView?.alpha = 1
                    }
                }){
                    (_)->Void in
                    completion?()
                }
        })
    }

    fileprivate func updateTableView(_ newlyAddedSections: [TableViewServiceSection], whenDone: (()->())? = nil)
    {
        if newlyAddedSections.count > 0 {
            let indexes = self.indexesForSections(newlyAddedSections)
            if self.reverseOrder {
                UIView.setAnimationsEnabled(false)
                if let currentIndexPath = self.tableView?.indexPathsForVisibleRows?.last {
                    self.tableView?.selectRow(at: currentIndexPath, animated: false, scrollPosition: UITableViewScrollPosition.bottom)
                }
                self.tableView?.insertSections(indexes, with: .none)
                self.tableView?.scrollToNearestSelectedRow(at: UITableViewScrollPosition.bottom, animated: false)
                if let selecedRows = self.tableView?.indexPathsForSelectedRows {
                    for row in selecedRows {
                        self.tableView?.deselectRow(at: row, animated: false)
                    }
                }
                UIView.setAnimationsEnabled(true)
            }else{
                self.tableView?.insertSections(indexes, with: .bottom)
            }
            whenDone?()
        }
    }
    
    fileprivate func indexesForSections(_ sections:[TableViewServiceSection]) -> IndexSet
    {
        let indexes = NSMutableIndexSet()
        let firstSection = sections.first!
        let startIndex = self.sections.index(where: {$0 === firstSection})!
        indexes.add(in: NSMakeRange(startIndex, sections.count))
        return indexes as IndexSet
    }
    
    var paginatable = false
    
    var animateReload = true
    
    var autoEndPagination = true
    
    var hasPaginationEnded = false
    fileprivate var isLoadingMoreContent = false 
    var reverseOrder = false
    
    var batchSize = 9999
    
    var elements = [Any]()
    
    fileprivate func sectionsForElements(_ elements:[Any]) -> [TableViewServiceSection]
    {
        var sections = [TableViewServiceSection]()
        for item in elements {
            let section = TableViewServiceSectionBuilder.sectionWithItem(item)
            section.delegate = self
            self.registerNibsForSection(section)
            sections.append(section)
        }
        return sections
    }
    
    
    
    fileprivate var registeredNibs = [(String!, String!)]()
    
    fileprivate func registerNibsForSection(_ section: TableViewServiceSection)
    {
        for item in section.items {
            self.registerNibsForSectionRow(item)
        }
        if let header = section.headerItem {
            self.registerNibsForSectionRow(header)
        }
    }
    
    fileprivate func registerNibsForSectionRow(_ row: TableViewServiceSectionItem)
    {
        let nib = (row.nibName, row.reuseIdentifier)
        if !self.registeredNibs.contains(where: {
            (n) -> Bool in
            return n.0 == nib.0 && n.1 == nib.1
        }) {
            self.registeredNibs.append(nib)
            self.tableView?.register(UINib(nibName: row.nibName, bundle: nil), forCellReuseIdentifier: row.reuseIdentifier)
        }
    }
    
    fileprivate var sections = [TableViewServiceSection]()
    
    init(tableView: UITableView, delegate: TableViewServiceDelegate)
    {
        super.init()
        self.tableView = tableView
        self.delegate = delegate
        self.setup()
    }
    
    fileprivate func setup()
    {
        self.tableView?.tableFooterView = UIView()
        self.tableView?.backgroundColor = self.tableViewBackgroundColor
        self.tableView?.superview?.backgroundColor = self.tableViewBackgroundColor
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.tableView?.rowHeight = UITableViewAutomaticDimension
        self.tableView?.estimatedRowHeight = 44
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return self.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if self.sections.count > 0 {
            return self.sections[section].items.count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection sectionIndex: Int) -> UIView?
    {
        
        //        guard let section = self.sections[safe: sectionIndex], let title = section.headerTitle else {
        //            return nil
        //        }
        //
        //        let reuseID = "someReUse"
        //        var view = tableView.dequeueReusableHeaderFooterView(withIdentifier: reuseID)
        //        if view == nil {
        //            view = UITableViewHeaderFooterView(reuseIdentifier: reuseID)
        //        }
        //        view?.textLabel?.text = title
        //        section.modifyHeaderView(view!)
        //        return view
        
        guard let section = self.sections[safe: sectionIndex], let item = section.headerItem else {return nil}
        if let cell = tableView.dequeueReusableCell(withIdentifier: item.reuseIdentifier) {
            cell.frame.size.width = tableView.bounds.width
            item.setupCell(cell)
            let wrapper = UIView()
            wrapper.addSubview(cell)
            return wrapper
        }
        return nil
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection sectionIndex: Int) -> CGFloat
    {
        guard let section = self.sections[safe: sectionIndex], (section.headerTitle != nil || section.headerItem != nil) else {
            return 0
        }
        return section.headerHeight
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection sectionIndex: Int)
    {
        guard let section = self.sections[safe: sectionIndex], let view = view as? UITableViewHeaderFooterView else {
            return
        }
        section.modifyHeaderView(view)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
    {
        let height = self.cellHeightsDictionary.object(forKey: indexPath)
        if (height != nil) {
            return height as! CGFloat
        }
        return UITableViewAutomaticDimension;
        
        //return self.sections[indexPath.section].estimatedRowHeight(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = self.sections[indexPath.section].section(cellForRow:indexPath.row, forTableView: tableView)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: false)
        let section = self.sections[indexPath.section]
        if let router = section.defaultRouterForRow(indexPath.row) {
            self.delegate?.tableViewService(self, routerToProcess: router)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        self.cellHeightsDictionary.setObject(cell.frame.size.height, forKey: indexPath as NSCopying)
        let testIndexPath = self.reverseOrder ? self.firstIndexPath() : self.lastIndexPath()
        
        if self.elements.count > 0 && indexPath.section == testIndexPath.section && indexPath.row == testIndexPath.row && !self.isLoadingMoreContent && self.paginatable && !self.hasPaginationEnded {
            if !self.reverseOrder {
                self.loadMore()
            }
        }
    }

    func cell(forItemIndex itemIndex: Int, inSection section: TableViewServiceSection) -> UITableViewCell?
    {
        if let sectionIndex = self.sections.index(where: {$0 === section}) {
            return self.tableView?.cellForRow(at: IndexPath(row: itemIndex, section: sectionIndex))
        }else{
            return nil
        }
    }
    
    func routerTriggered(_ router: Routable, forSection section: TableViewServiceSection)
    {
        self.delegate?.tableViewService(self, routerToProcess: router)
    }
    
    func section(showLoader forSection: TableViewServiceSection, type: AlertView.SpinnerType)
    {
        self.delegate?.tableViewService(showLoader: self, type: type)
    }
    
    func section(removeLoader forSection: TableViewServiceSection, withErrorMessage message: String?)
    {
        self.delegate?.tableViewService(removeLoader: self, errorMessage: message)
    }
    
    func reloadSection(_ section: TableViewServiceSection)
    {
        self.reloadSection(section, withAnimation: .none)
    }
    
    func reloadSection(_ section: TableViewServiceSection, withAnimation animation: UITableViewRowAnimation)
    {
        let indexes = self.indexesForSections([section])
        self.registerNibsForSection(section)
        
        let reloadBlock = { self.tableView?.reloadSections(indexes, with: animation) }
        
        if animation == .none {
            UIView.performWithoutAnimation {
                reloadBlock()
            }
        } else {
            reloadBlock()
        }
    }
    
    func reloadItems(_ items: [TableViewServiceSectionItem], forSection section: TableViewServiceSection)
    {
        guard let sectionIndex = self.sections.index(where: {$0 === section}) else { return }
        var indexPaths: [IndexPath] = []
        for item in items {
            if let index = section.items.index(where: { $0 === item }) {
                let indexPath = IndexPath(item: index, section: sectionIndex)
                indexPaths.append(indexPath)
            }
        }
        if indexPaths.count > 0 && items.count > 0 {
            self.tableView?.reloadRows(at: indexPaths, with: .none)
        }
    }
    
    func scrollTo(_ item: TableViewServiceSectionItem, inSection section: TableViewServiceSection)
    {
        guard let sectionIndex = self.sections.index(where: {$0 === section}) else { return }
        guard let rowIndex = section.items.index(where: { $0 === item }) else { return }
        let indexPath = IndexPath(row: rowIndex, section: sectionIndex)
        self.scrollToCell(indexPath)
    }
    
    func scrollToCell(_ atIndexPath: IndexPath)
    {
        self.tableView?.scrollToRow(at: atIndexPath, at: .top, animated: true)
    }
    
    func showAlertWithButtons(_ message: String?, buttons: [String]?, handler: AlertView.AlertHandler?) {
        self.delegate?.tableViewService(showAlert:message, buttons: buttons, handler: handler)
    }
    
}

extension TableViewService: UIScrollViewDelegate
{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.delegate?.scrollViewDidScroll?(scrollView)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.delegate?.scrollViewDidEndDecelerating?(scrollView)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.delegate?.scrollViewDidEndDragging?(scrollView, willDecelerate: decelerate)
    }
}

extension TableViewService
{
    func lastIndexPath() -> IndexPath
    {
        let section = self.sections.count - 1
        let row = self.sections[section].items.count - 1
        return IndexPath(row: row, section: section)
    }
    
    func firstIndexPath() -> IndexPath
    {
        return IndexPath(row: 0, section: 0)
    }
    
    func scrollToBottom()
    {
        let indexpath = self.lastIndexPath()
        let delayValue: Double = 0.1
        delay(delayValue){
            self.scrollToIndexPath(indexpath)
            delay(delayValue){
                self.scrollToIndexPath(indexpath)
            }
        }
    }
    
    fileprivate func scrollToIndexPath(_ indexPath: IndexPath, animated: Bool = false)
    {
        self.tableView?.scrollToRow(at: indexPath, at: .bottom, animated:animated)
    }
    
    
    fileprivate func scrollToSection(_ sectionIndex: Int)
    {
        if let _ = self.sections[safe: sectionIndex], let sectionRect = self.tableView?.rect(forSection: sectionIndex) {
            var rectToScroll = sectionRect
            rectToScroll.size.height = self.tableView!.frame.size.height
            self.tableView?.scrollRectToVisible(rectToScroll, animated: true)
        }
    }
}
