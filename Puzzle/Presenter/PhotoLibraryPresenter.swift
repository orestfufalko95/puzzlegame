//
//  PhotoLibraryPresenter.swift
//  Puzzle
//
//  Created by Orest Fufalko on 3/26/19.
//  Copyright © 2019 Orest Fufalko. All rights reserved.
//

class PhotoLibraryPresenter: LibraryPresenter {

	typealias View = LibraryTableViewController
	typealias Model = PhotoLibraryModel

	private static let itemFetchCount = 10

	//TODO: is view needed??!!
	private weak var view: View?

	private var model: Model!

	init(model: Model) {
		self.model = model
	}

	func attachView(view: View) {
		self.view = view
	}

	func detachView() {
		self.view = nil
	}

	var itemsCount: Int {
		return model.itemsCount
	}

	func fetchNewItems() {
		self.model.downloadItems(from: itemsCount, count: PhotoLibraryPresenter.itemFetchCount)
	}

	func item(for index: Int) -> Model.Item {
		return self.model.item(for: index)
	}

}
