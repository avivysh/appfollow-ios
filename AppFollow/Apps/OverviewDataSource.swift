//
//  OverviewDataSource.swift
//  AppFollow
//
//  Created by Alexandr Gavrishev on 02/04/2018.
//  Copyright © 2018 Anodsplace. All rights reserved.
//

import UIKit

private struct OverviewItem {
    let title: String
    let subtitle: String
    let action: (() -> Void)
    
    init(title: String, subtitle: String) {
        self.init(title: title, subtitle: subtitle, action: {})
    }
    
    init(title: String, subtitle: String, action: @escaping () -> Void) {
        self.title = title
        self.subtitle = subtitle
        self.action = action
    }
}

class OverviewDataSource: NSObject, AppSectionDataSource {
    
    weak var delegate: AppSectionDataSourceDelegate?
    weak var viewController: UIViewController?
    
    private let app: App
    private var data = [OverviewItem]()
    
    init(app: App) {
        self.app = app
        super.init()
        self.data = self.prepareItems()
    }
    
    func reload() {
        self.delegate?.dataSourceCompleteRefresh()
    }
    
    func activate() {
        self.delegate?.dataSourceCompleteRefresh()
    }
    
    func didSelectRowAt(indexPath: IndexPath) {
        self.data[indexPath.row].action()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubtitleTableCell", for: indexPath) as! SubtitleTableCell
        let item = self.data[indexPath.row]
        cell.bind(title: item.title, subtitle: item.subtitle)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Overview"
    }
    
    // MARK: Private
    
    private func prepareItems() -> [OverviewItem] {
        return [
            OverviewItem(title: "Store", subtitle: app.store),
            OverviewItem(title: "External ID", subtitle: app.extId.value),
            OverviewItem(title: "Number of reviews", subtitle: "\(app.reviewsCount)"),
            OverviewItem(title: "Number of what's new", subtitle: "\(app.whatsNewCount)"),
            OverviewItem(title: "Country", subtitle: app.details.country),
            OverviewItem(title: "Genre", subtitle: app.details.genre),
            OverviewItem(title: "In-app purchases", subtitle: "\(app.details.hasIap)"),
            OverviewItem(title: "Kind", subtitle: app.details.kind),
            OverviewItem(title: "Language", subtitle: app.details.lang),
            OverviewItem(title: "Publisher", subtitle: app.details.publisher),
            OverviewItem(title: "Release date", subtitle: app.details.released.isValid ? app.details.released.ymd : ""),
            OverviewItem(title: "Size", subtitle: "\(app.details.size.value)"),
            OverviewItem(title: "Version", subtitle: "\(app.details.version)"),
            OverviewItem(title: "Url", subtitle: "\(app.details.url)", action: { self.openUrl(self.app.details.url) }),
        ]
    }
    
    private func openUrl(_ dest: String) {
        if let url = URL(string: dest), !dest.isEmpty {
            self.viewController?.present(url: url)
        }
    }
}
