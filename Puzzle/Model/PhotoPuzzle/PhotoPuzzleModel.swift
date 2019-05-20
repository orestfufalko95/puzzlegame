//
// Created by Orest Fufalko on 2019-04-10.
// Copyright (c) 2019 Orest Fufalko. All rights reserved.
//

import UIKit

final class PhotoPuzzleModel {

	var output: PhotoPuzzleModelOutput?
}

extension PhotoPuzzleModel: PhotoPuzzleModelInput {

	func createPuzzles(photo: Photo, puzzlesSize: Int) {
		let puzzleWidth: Int = Int(photo.image.size.width) / puzzlesSize
		let puzzleHeight: Int = Int(photo.image.size.height) / puzzlesSize
		let imageOrientation: UIImage.Orientation = photo.image.imageOrientation
		let image: CGImage? = photo.image.cgImage

		var puzzles = [Puzzle]()
		puzzles.reserveCapacity(puzzlesSize * puzzlesSize)

		for yCoordinate in 0..<puzzlesSize {

			for xCoordinate in 0..<puzzlesSize {

				let startX = puzzleWidth * xCoordinate
				let startY = puzzleHeight * yCoordinate

				if let puzzle = image?.cropping(to: CGRect(x: startX, y: startY, width: puzzleWidth, height: puzzleHeight)) {

					let puzzleImage = UIImage(cgImage: puzzle, scale: 1, orientation: imageOrientation)
					puzzles.append(Puzzle(image: puzzleImage, x: xCoordinate, y: yCoordinate))
				} else {
					puzzles.append(Puzzle(image: UIImage(), x: xCoordinate, y: yCoordinate))
				}
			}
		}

		self.output?.puzzlesCreated(puzzles: puzzles)
	}

	func saveCompletedPuzzle(photo: Photo, index: Int) {
		let userDefaults = UserDefaults.standard

		var puzzleTimes: [Int]?

		puzzleTimes = userDefaults.array(forKey: AppDelegate.puzzleTimeKey) as? [Int]

		if (puzzleTimes == nil) {
			puzzleTimes = [Int](repeating: 0, count: index + 1)
		}

		if puzzleTimes!.count <= index {
			puzzleTimes!.append(contentsOf: [Int](repeating: 0, count: index - puzzleTimes!.count + 1))
		}

		puzzleTimes?[index] = photo.puzzleTime

		userDefaults.set(puzzleTimes, forKey: AppDelegate.puzzleTimeKey)
		userDefaults.synchronize()

		let userInfo: [String: Int] = [AppDelegate.puzzlePhotoIndex: index]
		NotificationCenter.default.post(name: Notification.Name.newPuzzleCompleted, object: self, userInfo: userInfo)
	}
}
