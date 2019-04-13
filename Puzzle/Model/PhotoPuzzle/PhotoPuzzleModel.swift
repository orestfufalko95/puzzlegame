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
		var puzzles = [PuzzleEntity]()
		let puzzleWidth: Int = Int(photo.image.size.width) / puzzlesSize
		let puzzleHeight: Int = Int(photo.image.size.height) / puzzlesSize
		let imageOrientation = photo.image.imageOrientation
		let image: CGImage? = photo.image.cgImage

		for xCoord in 0..<puzzlesSize {

			for yCoord in 0..<puzzlesSize {

				let startX = puzzleWidth * xCoord
				let startY = puzzleHeight * yCoord

				if let puzzle = image?.cropping(to: CGRect(x: startX, y: startY, width: puzzleWidth, height: puzzleHeight)) {

					let puzzleImage = UIImage(cgImage: puzzle, scale: 1, orientation: imageOrientation)
					puzzles.append(PuzzleEntity(image: puzzleImage, x: xCoord, y: yCoord))
				} else {
					puzzles.append(PuzzleEntity(image: UIImage(), x: xCoord, y: yCoord))
				}
			}
		}

		self.output?.puzzlesCreated(puzzles: puzzles)
	}

}
