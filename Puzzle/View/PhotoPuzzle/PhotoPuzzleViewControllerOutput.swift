//
// Created by Orest Fufalko on 2019-04-10.
// Copyright (c) 2019 Orest Fufalko. All rights reserved.
//

protocol PhotoPuzzleViewControllerOutput: class {

	var puzzlesCount: Int { get }

	var puzzlesSize: Int { get }

	func handleViewLoaded()

	func handlePuzzleSizeSelected()

	func puzzleEntity(for index: Int) -> PuzzleEntity

	func swap(fromIndex: Int, toIndex: Int )
}
