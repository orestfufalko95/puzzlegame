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

		let model = PhotoLibraryModel()
		let presenter = PhotoLibraryPresenter(view: controller, model: model)

		model.output = presenter
		controller.output = presenter

		return controller
	}

	static func picturePuzzleView(photo: Photo) -> UIViewController {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let controller = storyboard.instantiateViewController(withIdentifier: "PhotoPuzzleViewController") as! PhotoPuzzleViewController

		let model: PhotoPuzzleModel = PhotoPuzzleModel()
		let presenter = PhotoPuzzlePresenter(view: controller, model: model, photo: photo)

		model.output = presenter
		controller.output = presenter

		return controller
	}
}
