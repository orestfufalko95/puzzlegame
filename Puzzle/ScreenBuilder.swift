//
// Created by Orest Fufalko on 2019-04-03.
// Copyright (c) 2019 Orest Fufalko. All rights reserved.
//

import UIKit

struct ScreenBuilder {

	private init(){}

	static func initLibraryView(controller: LibraryTableViewController) {
		let presenter = PhotoLibraryPresenter(view: controller)
		let model = PhotoLibraryModel(presenter: presenter)

		presenter.model = model
		controller.presenter = presenter
	}
}
