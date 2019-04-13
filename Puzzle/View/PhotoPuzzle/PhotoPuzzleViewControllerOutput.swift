//
// Created by Orest Fufalko on 2019-04-10.
// Copyright (c) 2019 Orest Fufalko. All rights reserved.
//

import UIKit

protocol PhotoPuzzleViewControllerOutput: class {

	var puzzlesCount: Int { get }

	func handleViewLoaded()

	func puzzleEntity(for index: Int) -> PuzzleEntity

	func swap(fromIndex: Int, toIndex: Int )
}
