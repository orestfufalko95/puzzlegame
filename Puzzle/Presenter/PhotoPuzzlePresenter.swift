//
// Created by Orest Fufalko on 2019-04-10.
// Copyright (c) 2019 Orest Fufalko. All rights reserved.
//

import UIKit

final class PhotoPuzzlePresenter {

	private static let defaultPuzzlesSize = 3

	private let model: PhotoPuzzleModelInput
	private let photoIndex: Int
	private var photo: Photo

	private weak var view: (UIViewController & PhotoPuzzleViewControllerInput)?

	private var puzzles: [Puzzle] = []
	private var seconds: Int = 0

	private var timer: Timer? = nil

	init(view: (UIViewController & PhotoPuzzleViewControllerInput), model: PhotoPuzzleModelInput, photo: Photo, photoIndex: Int) {
		self.view = view
		self.model = model
		self.photo = photo
		self.photoIndex = photoIndex
	}

	private func resetView() {
		self.timer?.invalidate()
		self.timer = nil

		self.view?.setStartView()
	}
}

extension PhotoPuzzlePresenter: PhotoPuzzleModelOutput {

	func puzzlesCreated(puzzles: [Puzzle]) {
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
		self.resetView()
		self.handleViewLoaded()
	}

	func puzzleEntity(for index: Int) -> Puzzle {
		return self.puzzles[index]
	}

	func swap(fromIndex: Int, toIndex: Int) {
		let changedPuzzle = self.puzzles.remove(at: fromIndex)
		self.puzzles.insert(changedPuzzle, at: toIndex)

		if self.puzzles.reduce(into: true, { $0 = $0 && (self.puzzles.firstIndex(of: $1) == $1.y * puzzlesSize + $1.x) }) {

			self.resetView()
			self.photo.puzzleTime = self.seconds

			self.model.saveCompletedPuzzle(photo: self.photo, index: self.photoIndex)

			let alertController = UIAlertController(title: "Puzzle Completed in \(seconds) seconds", message: nil, preferredStyle: .alert)
			alertController.addAction(UIAlertAction(title: "OK", style: .default))
			self.view?.present(alertController, animated: true)
		}
	}

	func startGame() {
		self.seconds = 0

		self.puzzles.shuffle()
		self.view?.reload()

		self.view?.setTimerView()
		self.view?.setTime(seconds: self.seconds)

		self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] _ in
			self?.seconds += 1

			self?.view?.setTime(seconds: self?.seconds ?? 0)
		})
		self.timer?.fire()
	}
}
