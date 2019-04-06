//
//  PhotoLibraryPresenter.swift
//  Puzzle
//
//  Created by Orest Fufalko on 3/26/19.
//  Copyright © 2019 Orest Fufalko. All rights reserved.
//

import UIKit

class PhotoLibraryPresenter {

	private static let startPrefetchBeforeItemsShown = 3
	private static let itemsPerRequest = 10

	private weak var view: (UIViewController & LibraryTableViewControllerInput)?

	private var photos = [PhotoEntity]()

	var model: PhotoLibraryModelInput?

	init(view: (UIViewController & LibraryTableViewControllerInput)) {
		self.view = view
	}
}

// MARK: -  View Output methods
extension PhotoLibraryPresenter: LibraryTableViewControllerOutput {

	var itemsCount: Int {
		return self.photos.count
	}

	func handleViewCreated() {
		self.model?.updateItems()
	}

	func prefetchIndex(index: Int) {
		if index > (itemsCount - PhotoLibraryPresenter.startPrefetchBeforeItemsShown) {
			self.model?.downloadNewItems(startIndex: self.photos.count, count: PhotoLibraryPresenter.itemsPerRequest)
		}
	}

	func photo(index: Int) -> PhotoEntity {
		return self.photos[index]
	}
}

// MARK: -  Model Output methods
extension PhotoLibraryPresenter: PhotoLibraryModelOutput {

	func handleItemsAdded(newPhotos: [PhotoEntity]) {
		//TODO: check network
		if self.photos.isEmpty && newPhotos.isEmpty {
			self.prefetchIndex(index: 0)
			return
		}

		self.photos.append(contentsOf: newPhotos)
		self.view?.handleImagesUpdated()
	}
}
