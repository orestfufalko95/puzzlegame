//
// Created by Orest Fufalko on 2019-05-18.
// Copyright (c) 2019 Orest Fufalko. All rights reserved.
//

import UIKit

final class PhotoHistoryModel {
	private let imagesUrl = "https://picsum.photos/300/300?image="

	private let fileManager: FileManager = FileManager.default
	private let imageDir: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
			.first!
			.appendingPathComponent("puzzle", isDirectory: true)

	private let dispatchQueue = DispatchQueue.global(qos: .userInitiated)

	var output: PhotoLibraryModelOutput?
}

// MARK: -  Model Input methods
extension PhotoHistoryModel: PhotoLibraryModelInput {

	func updateItems() {
		print("History updateItems")
		let userDefaults = UserDefaults.standard

		guard let puzzleTimes: [Int] = userDefaults.array(forKey: AppDelegate.puzzleTimeKey) as? [Int] else {
			self.output?.handleItemsAdded(newPhotos: [])
			return
		}

		var completedPuzzleIndexes = [Int]()
		for (index, puzzleTime): (Int, Int) in puzzleTimes.enumerated() {
			print("Item \(index): \(puzzleTime)")

			if puzzleTime != 0 {
				completedPuzzleIndexes.append(index)
			}
		}

		dispatchQueue.async {
			let photos: [Photo] = completedPuzzleIndexes.map {
				let imagePath = self.imageDir.appendingPathComponent("\($0).jpg").path
				let photo = Photo(image: UIImage(contentsOfFile: imagePath) ?? UIImage())
				photo.puzzleTime = puzzleTimes[$0]
				return photo
			}

			DispatchQueue.main.async { [weak self] in
				self?.output?.handleItemsAdded(newPhotos: photos)
			}
		}
	}

	func fetchNewItems(startIndex: Int, count: Int) {
		print("History fetchNewItems")
		let userDefaults = UserDefaults.standard

		guard let puzzleTimes = userDefaults.array(forKey: AppDelegate.puzzleTimeKey) as? [Int] else {
			self.output?.handleItemsAdded(newPhotos: [])
			return
		}

		dispatchQueue.async {
			let imagePath = self.imageDir.appendingPathComponent("\(startIndex).jpg").path
			let photo = Photo(image: UIImage(contentsOfFile: imagePath) ?? UIImage())
			photo.puzzleTime = puzzleTimes[startIndex]

			DispatchQueue.main.async { [weak self] in
				self?.output?.handleItemsAdded(newPhotos: [photo])
			}
		}
	}

}
