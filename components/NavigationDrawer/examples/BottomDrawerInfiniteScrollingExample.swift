// Copyright 2018-present the Material Components for iOS authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import UIKit
import MaterialComponents.MaterialBottomAppBar
import MaterialComponents.MaterialNavigationDrawer
import MaterialComponents.MaterialNavigationDrawer_Theming 
import MaterialComponents.MaterialColorScheme

class BottomDrawerInfiniteScrollingExample: UIViewController {
  @objc var containerScheme: MDCContainerScheming = MDCContainerScheme()
  let bottomAppBar = MDCBottomAppBarView()

  let headerViewController = DrawerHeaderViewController()
  let contentViewController = DrawerContentTableViewController()

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = containerScheme.colorScheme.backgroundColor
    contentViewController.colorScheme = containerScheme.colorScheme as? MDCSemanticColorScheme
    bottomAppBar.isFloatingButtonHidden = true
    let barButtonLeadingItem = UIBarButtonItem()
    let menuImage = UIImage(named: "ic_menu")?.withRenderingMode(
      .alwaysTemplate)
    barButtonLeadingItem.image = menuImage
    barButtonLeadingItem.target = self
    barButtonLeadingItem.action = #selector(presentNavigationDrawer)
    barButtonLeadingItem.accessibilityIdentifier = "BottomDrawer.button"
    bottomAppBar.leadingBarButtonItems = [barButtonLeadingItem]

    bottomAppBar.barTintColor = containerScheme.colorScheme.surfaceColor
    let barItemTintColor = containerScheme.colorScheme.onSurfaceColor.withAlphaComponent(0.6)
    bottomAppBar.leadingBarItemsTintColor = barItemTintColor
    bottomAppBar.trailingBarItemsTintColor = barItemTintColor
    bottomAppBar.floatingButton.setBackgroundColor(
      containerScheme.colorScheme.primaryColor, for: .normal)
    bottomAppBar.floatingButton.setTitleColor(
      containerScheme.colorScheme.onPrimaryColor, for: .normal)
    bottomAppBar.floatingButton.setImageTintColor(
      containerScheme.colorScheme.onPrimaryColor, for: .normal)

    view.addSubview(bottomAppBar)
  }

  private func layoutBottomAppBar() {
    let size = bottomAppBar.sizeThatFits(view.bounds.size)
    var bottomBarViewFrame = CGRect(
      x: 0,
      y: view.bounds.size.height - size.height,
      width: size.width,
      height: size.height)
    bottomBarViewFrame.size.height += view.safeAreaInsets.bottom
    bottomBarViewFrame.origin.y -= view.safeAreaInsets.bottom
    bottomAppBar.frame = bottomBarViewFrame
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()

    layoutBottomAppBar()
  }

  @objc private func presentNavigationDrawer() {
    let bottomDrawerViewController = MDCBottomDrawerViewController()
    bottomDrawerViewController.maximumInitialDrawerHeight = 400
    bottomDrawerViewController.contentViewController = contentViewController
    contentViewController.drawerVC = bottomDrawerViewController
    bottomDrawerViewController.setTopCornersRadius(12, for: .collapsed)
    bottomDrawerViewController.headerViewController = headerViewController
    bottomDrawerViewController.trackingScrollView = contentViewController.tableView
    bottomDrawerViewController.shouldIncludeSafeAreaInContentHeight = true
    bottomDrawerViewController.isTopHandleHidden = false
    bottomDrawerViewController.applyTheme(withScheme: containerScheme)
    bottomDrawerViewController.maximumDrawerHeight = 600
    present(bottomDrawerViewController, animated: true, completion: nil)
  }
}

class DrawerContentTableViewController: UITableViewController {
  @objc var colorScheme: MDCSemanticColorScheme!
  weak var drawerVC: MDCBottomDrawerViewController!

  override var preferredContentSize: CGSize {
    get {
      return CGSize(width: view.bounds.width, height: tableView.contentSize.height)
    }
    set {
      super.preferredContentSize = newValue
    }
  }

  var supportScrollToTop = true

  var numberOfRows = 10

  init() {
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
    -> UITableViewCell
  {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    cell.textLabel?.text = "cell #\(indexPath.item)"
    cell.backgroundColor = colorScheme.surfaceColor
    print(cell.textLabel?.text ?? "")
    return cell
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if supportScrollToTop == false {
      return numberOfRows
    }
    return 100
  }

  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    if supportScrollToTop == false {
      toggleNumberOfRows()
      tableView.reloadData()
      self.preferredContentSize = tableView.contentSize
    } else {
      drawerVC.setContentOffsetY(0, animated: false)
    }
  }

  private func toggleNumberOfRows() {
    numberOfRows = (numberOfRows == 10) ? 14 : 10
  }

}

extension BottomDrawerInfiniteScrollingExample {

  @objc class func catalogMetadata() -> [String: Any] {
    return [
      "breadcrumbs": ["Navigation Drawer", "Bottom Drawer Infinite Scrolling"],
      "description": "Navigation Drawer",
      "presentable": true,
    ]
  }
}
