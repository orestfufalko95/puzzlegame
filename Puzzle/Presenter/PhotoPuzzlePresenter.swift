//
// Created by Orest Fufalko on 2019-04-10.
// Copyright (c) 2019 Orest Fufalko. All rights reserved.
//

import UIKit

// collection view inset UIEdgeInset
// Back button on puzzle - normal name
// UICollectionLayout or FlowLayout
// uisegmentcontroll - asdd 3*3 4*4 5*5 puzzle size
// handle device rotation

final class PhotoPuzzlePresenter {

	private static let defaultPuzzlesSize = 3

	private let model: PhotoPuzzleModelInput
	private let photo: PhotoEntity

	private weak var view: (UIViewController & PhotoPuzzleViewControllerInput)?

	private var puzzles: [PuzzleEntity] = []

	init(view: (UIViewController & PhotoPuzzleViewControllerInput), model: PhotoPuzzleModelInput, photo: PhotoEntity) {
		self.view = view
		self.model = model
		self.photo = photo
	}
}

extension PhotoPuzzlePresenter: PhotoPuzzleModelOutput {

	func puzzlesCreated(puzzles: [PuzzleEntity]) {
		self.puzzles = puzzles

		self.view?.reload()
	}
}

extension PhotoPuzzlePresenter: PhotoPuzzleViewControllerOutput {

	var puzzlesCount: Int {
		return self.puzzles.count
	}

	var puzzlesSize: Int {
		if let size = self.view?.selectedPuzzleSize {
			return PhotoPuzzlePresenter.defaultPuzzlesSize + size
		} else {
			return PhotoPuzzlePresenter.defaultPuzzlesSize
		}
	}

	func handleViewLoaded() {
		self.model.createPuzzles(photo: self.photo, puzzlesSize: self.puzzlesSize)
	}

	func handlePuzzleSizeSelected() {
		self.handleViewLoaded()
	}

	func puzzleEntity(for index: Int) -> PuzzleEntity {
		return self.puzzles[index]
	}

	func swap(fromIndex: Int, toIndex: Int) {
		self.puzzles.swapAt(fromIndex, toIndex)
	}
}
