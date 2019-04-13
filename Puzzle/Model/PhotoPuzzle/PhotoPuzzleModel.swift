//
// Created by Orest Fufalko on 2019-04-10.
// Copyright (c) 2019 Orest Fufalko. All rights reserved.
//

import UIKit

final class PhotoPuzzleModel {

	private var output: PhotoPuzzleModelOutput?

	init(presenter: PhotoPuzzleModelOutput) {
		self.output = presenter
	}
}

extension PhotoPuzzleModel: PhotoPuzzleModelInput {

	func createPuzzles(photo: PhotoEntity, puzzlesSize: Int) {
		var puzzles = [UIImage]()
		let puzzleWidth = photo.image.size.width / CGFloat(puzzlesSize)
		let puzzleHeight = photo.image.size.height / CGFloat(puzzlesSize)
		let imageOrientation = photo.image.imageOrientation

		var startX = CGFloat(0)
		for _ in 0..<puzzlesSize {
			var startY = CGFloat(0)

			for _ in 0..<puzzlesSize {

				if let puzzle = photo.image.cgImage?.cropping(to: CGRect(origin: CGPoint(x: startX, y: startY),
						size: CGSize(width: puzzleWidth, height: puzzleHeight))) {
					puzzles.append(UIImage(cgImage: puzzle, scale: 1, orientation: imageOrientation))
				} else {
					puzzles.append(UIImage())
				}

				startY += puzzleHeight
			}

			startX += puzzleWidth
		}

		self.output?.puzzlesCreated(puzzles: puzzles)
	}

}
