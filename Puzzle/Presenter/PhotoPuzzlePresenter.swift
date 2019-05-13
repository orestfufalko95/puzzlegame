//
// Created by Orest Fufalko on 2019-04-10.
// Copyright (c) 2019 Orest Fufalko. All rights reserved.
//

import UIKit

final class PhotoPuzzlePresenter {

	private static let defaultPuzzlesSize = 3

	private let model: PhotoPuzzleModelInput
	private let photo: Photo

	private weak var view: (UIViewController & PhotoPuzzleViewControllerInput)?

	private var puzzles: [Puzzle] = []

	init(view: (UIViewController & PhotoPuzzleViewControllerInput), model: PhotoPuzzleModelInput, photo: Photo) {
		self.view = view
		self.model = model
		self.photo = photo
	}
}

extension PhotoPuzzlePresenter: PhotoPuzzleModelOutput {

	func puzzlesCreated(puzzles: [Puzzle]) {
		self.puzzles = puzzles.shuffled()

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

	func puzzleEntity(for index: Int) -> Puzzle {
		return self.puzzles[index]
	}

	func swap(fromIndex: Int, toIndex: Int) {
		let changedPuzzle = self.puzzles.remove(at: fromIndex)
		self.puzzles.insert(changedPuzzle, at: toIndex)

		if self.puzzles.reduce(into: true, { $0 = $0 && (self.puzzles.firstIndex(of: $1) == $1.y * puzzlesSize + $1.x) }) {
			let alertController = UIAlertController(title: "Puzzle Completed", message: nil, preferredStyle: .alert)
			alertController.addAction(UIAlertAction(title: "OK", style: .default))
			self.view?.present(alertController, animated: true)
		}
	}
}
