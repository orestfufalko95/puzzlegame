//
// Created by Orest Fufalko on 2019-04-03.
// Copyright (c) 2019 Orest Fufalko. All rights reserved.
//

import UIKit

struct ScreenBuilder {

	private init() {
	}

	static func initDownloadsView() -> UIViewController {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let controller = storyboard.instantiateViewController(withIdentifier: "LibraryTableViewController") as! LibraryTableViewController

		let model = PhotoDownloadsModel()
		let presenter = PhotoLibraryPresenter(view: controller, model: model, title: "Downloads", isPrefetchEnabled: true)

		model.output = presenter
		controller.output = presenter

		return controller
	}

	static func initHistoryView() -> UIViewController {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let controller = storyboard.instantiateViewController(withIdentifier: "LibraryTableViewController") as! LibraryTableViewController

		let model = PhotoHistoryModel()
		let presenter = PhotoLibraryPresenter(view: controller, model: model, title: "History", isPrefetchEnabled: false)

		model.output = presenter
		controller.output = presenter

		return controller
	}

	static func picturePuzzleView(photo: Photo, index: Int) -> UIViewController {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let controller = storyboard.instantiateViewController(withIdentifier: "PhotoPuzzleViewController") as! PhotoPuzzleViewController

		let model: PhotoPuzzleModel = PhotoPuzzleModel()
		let presenter = PhotoPuzzlePresenter(view: controller, model: model, photo: photo, photoIndex: index)

		model.output = presenter
		controller.output = presenter

		return controller
	}

	static func mainView() -> UIViewController {
		let tabBarController = UITabBarController()

		let downloadsNavigationController = UINavigationController(rootViewController: initDownloadsView())
		downloadsNavigationController.tabBarItem = UITabBarItem(tabBarSystemItem: .downloads, tag: 0)

		let historyNavigationController = UINavigationController(rootViewController: initHistoryView())
		historyNavigationController.tabBarItem = UITabBarItem(tabBarSystemItem: .history, tag: 1)

		tabBarController.setViewControllers([
			downloadsNavigationController,
			historyNavigationController,
		], animated: true)

		return tabBarController
	}
}
