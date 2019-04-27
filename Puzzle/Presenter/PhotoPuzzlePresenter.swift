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

	private static let puzzlesSize = 3

	private weak var view: (UIViewController & PhotoPuzzleViewControllerInput)?
	private let photo: PhotoEntity!

	//TODO OF: why can not be let
	private var model: PhotoPuzzleModelInput!

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

	func puzzlesCellHeight(containerHeight: Int) -> Int {
		return containerHeight / PhotoPuzzlePresenter.puzzlesSize
	}

	func puzzlesCellWidth(containerWidth: Int) -> Int {//TODO: why?? extra padding margin bound?
		return containerWidth / PhotoPuzzlePresenter.puzzlesSize * 19 / 20
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
