//
//  PhotoLibraryPresenter.swift
//  Puzzle
//
//  Created by Orest Fufalko on 3/26/19.
//  Copyright © 2019 Orest Fufalko. All rights reserved.
//

import UIKit

final class PhotoLibraryPresenter {

	private static let startPrefetchBeforeItemsShown: Int = 3
	private static let itemsPerRequest: Int = 10

	private let model: PhotoLibraryModelInput

	private weak var view: (UIViewController & LibraryTableViewControllerInput)?

	private var photos: [Photo] = [Photo]()

	private var isFetchingItems: Bool = false

	let title: String
	let isPrefetchEnabled: Bool

	init(view: (UIViewController & LibraryTableViewControllerInput), model: PhotoLibraryModelInput, title: String, isPrefetchEnabled: Bool) {
		self.view = view
		self.model = model
		self.title = title
		self.isPrefetchEnabled = isPrefetchEnabled
	}
}

// MARK: -  View Output methods
extension PhotoLibraryPresenter: LibraryTableViewControllerOutput {

	var itemsCount: Int {
		return self.photos.count
	}

	func handleViewCreated() {
		print("PhotoLibraryPresenter handleViewCreated")
		self.view?.showLoading()
		self.model.updateItems()

		if !self.isPrefetchEnabled {
			self.subscribeToNotifications()
		}
	}

	func prefetch(indexes: [Int]) {
		if isFetchingItems {
			return
		}

		let maxIndex = indexes.reduce(0, ({ return $0 > $1 ? $0 : $1 }))

		if maxIndex > (itemsCount - PhotoLibraryPresenter.startPrefetchBeforeItemsShown) {
			self.isFetchingItems = true
			self.view?.showLoading()
			self.model.fetchNewItems(startIndex: self.photos.count, count: PhotoLibraryPresenter.itemsPerRequest)
		}
	}

	func photo(index: Int) -> Photo {
		return self.photos[index]
	}

	func photoSelected(index: Int) {
		let controller = ScreenBuilder.picturePuzzleView(photo: self.photos[index], index: index)
		self.view?.show(controller, sender: nil)
	}
}

// MARK: -  Model Output methods
extension PhotoLibraryPresenter: PhotoLibraryModelOutput {

	func handleItemsAdded(newPhotos: [Photo]) {
		self.isFetchingItems = false

		//TODO: check network
		if self.photos.isEmpty && newPhotos.isEmpty && self.isPrefetchEnabled {
			self.prefetch(indexes: [0])
			return
		}

		self.photos.append(contentsOf: newPhotos)
		self.view?.hideLoading()
		self.view?.handleImagesUpdated()
	}
}

extension Notification.Name {

	static let newPuzzleCompleted = Notification.Name(AppDelegate.puzzleCompletedNotification)
}

// MARK: -  Helpers
private extension PhotoLibraryPresenter {

	func subscribeToNotifications() {
		NotificationCenter.default.addObserver(self, selector: #selector(self.fetchNewItem(notification:)),
				name: Notification.Name.newPuzzleCompleted, object: nil)
	}

	@objc func fetchNewItem(notification: Notification) {
		if let photoIndex: Int = notification.userInfo![AppDelegate.puzzlePhotoIndex] as? Int {
			self.model.fetchNewItems(startIndex: photoIndex, count: 1)
		}
	}
}
