//
// Created by Orest Fufalko on 2019-04-03.
// Copyright (c) 2019 Orest Fufalko. All rights reserved.
//

import UIKit

struct ScreenBuilder {

	private init(){}

	static func initLibraryView() -> UIViewController {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let controller = storyboard.instantiateViewController(withIdentifier: "LibraryTableViewController") as! LibraryTableViewController

		let presenter = PhotoLibraryPresenter(view: controller)
		let model = PhotoLibraryModel(presenter: presenter)

		presenter.model = model
		controller.output = presenter

		return controller
	}

	static func picturePuzzleView(photo: PhotoEntity) -> UIViewController {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let controller = storyboard.instantiateViewController(withIdentifier: "PhotoPuzzleViewController") as! PhotoPuzzleViewController

		let presenter = PhotoPuzzlePresenter(view: controller)
		let model = PhotoPuzzleModel(presenter: presenter)

		presenter.model = model
		controller.output = presenter

		return controller
	}
}
