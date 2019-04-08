//
//  PhotoLibraryPresenter.swift
//  Puzzle
//
//  Created by Orest Fufalko on 3/26/19.
//  Copyright © 2019 Orest Fufalko. All rights reserved.
//

import UIKit

final class PhotoLibraryPresenter {

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
		self.view?.showLoading()
		self.model?.updateItems()
	}

	func prefetch(index: Int) {
		if index > (itemsCount - PhotoLibraryPresenter.startPrefetchBeforeItemsShown) {
			self.view?.showLoading()
			self.model?.downloadNewItems(startIndex: self.photos.count, count: PhotoLibraryPresenter.itemsPerRequest)
		}
	}

	func photo(index: Int) -> PhotoEntity {
		return self.photos[index]
	}

	func photoSelected(index: Int) {
		let controller = ScreenBuilder.picturePuzzleView(photo: self.photos[index])
		self.view?.show(controller, sender: nil)
	}
}

// MARK: -  Model Output methods
extension PhotoLibraryPresenter: PhotoLibraryModelOutput {

	func handleItemsAdded(newPhotos: [PhotoEntity]) {
		//TODO: check network
		if self.photos.isEmpty && newPhotos.isEmpty {
			self.prefetch(index: 0)
			return
		}

		self.photos.append(contentsOf: newPhotos)
		self.view?.hideLoading()
		self.view?.handleImagesUpdated()
	}


}
