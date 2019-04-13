//
// Created by Orest Fufalko on 2019-04-10.
// Copyright (c) 2019 Orest Fufalko. All rights reserved.
//

import UIKit

final class PhotoPuzzlePresenter {

	private static let puzzlesSize = 3

	private weak var view: (UIViewController & PhotoPuzzleViewControllerInput)?
	private let photo: PhotoEntity!

	private var puzzles: [PuzzleEntity] = []

	var model: PhotoPuzzleModelInput?

	init(view: (UIViewController & PhotoPuzzleViewControllerInput), photo: PhotoEntity) {
		self.view = view
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

	func handleViewLoaded() {
		self.model?.createPuzzles(photo: self.photo, puzzlesSize: PhotoPuzzlePresenter.puzzlesSize)
	}

	func puzzleEntity(for index: Int) -> PuzzleEntity {
		return self.puzzles[index]
	}

	func swap(fromIndex: Int, toIndex: Int) {
		self.puzzles.swapAt(fromIndex, toIndex)
	}
}
