//
//  PhotoLibraryPresenter.swift
//  Puzzle
//
//  Created by Orest Fufalko on 3/26/19.
//  Copyright © 2019 Orest Fufalko. All rights reserved.
//

import UIKit

class PhotoLibraryPresenter {

	private weak var view: (UIViewController & ViewInput)?

	var model: ModelInput?

	init(view: (UIViewController & ViewInput)) {
		self.view = view
	}
}

// MARK: -  View Output methods
extension PhotoLibraryPresenter: ViewOutput {
	func handleViewCreated() {
		self.model?.updateItems()
	}
}

// MARK: -  Model Output methods
extension PhotoLibraryPresenter: ModelOutput {
	func handleItemsUpdated(images: [UIImage]) {
		self.view?.handleImagesUpdated(images: images)
	}
}

//	typealias View = LibraryTableViewController
//	typealias Model = PhotoLibraryModel
//
//	private static let itemFetchCount = 10
//
//	//TODO: is view needed??!!
//	private weak var view: View?
//
//	private var model: Model!
//
//	init(model: Model) {
//		self.model = model
//	}
//
//	func attachView(view: View) {
//		self.view = view
//	}
//
//	func detachView() {
//		self.view = nil
//	}
//
//	var itemsCount: Int {
//		return model.itemsCount
//	}
//
//	func fetchNewItems() {
//		self.model.downloadItems(from: itemsCount, count: PhotoLibraryPresenter.itemFetchCount)
//	}
//
//	func item(for index: Int) -> Model.Item {
//		return self.model.item(for: index)
//	}
//
//}
