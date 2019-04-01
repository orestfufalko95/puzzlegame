//
//  PhotoLibraryModel.swift
//  Puzzle
//
//  Created by Orest Fufalko on 3/26/19.
//  Copyright © 2019 Orest Fufalko. All rights reserved.
//

import UIKit

//TODO: download 10 images once per request and only then call callback DispatchGroup

class PhotoLibraryModel: LibraryModel {

	private let imagesUrl = "https://picsum.photos/200/300?image="

	private let fileManager: FileManager = FileManager.default
	private let imageDir: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
			.first!
			.appendingPathComponent("puzzle", isDirectory: true)

	typealias Item = UIImage

	var itemsCount: Int {
		do {
			return try fileManager.contentsOfDirectory(atPath: imageDir.path).count
		} catch {
			print("Unable to load data: \(error) index: \(index)")
			return 0
		}
	}

	func load(index: Int, completion: @escaping (UIImage?) -> ()) {
		let url = imageDir.appendingPathComponent("\(index).jpg")
		let imagePath = url.path
//		print("model imagePath: \(imagePath)")

		if fileManager.fileExists(atPath: imagePath) {
			print("model cached file index: \(index)")
			self.completeWithSavedFile(completion: completion, imagePath: imagePath)
		} else {
			print("model download started index: \(index)")
			self.downloadItem(index: index, completion: completion, imageUrl: imagePath)
		}
	}

}

// MARK - Helpers
private extension PhotoLibraryModel {

	private func completeWithSavedFile(completion: ((UIImage?) -> ())?, imagePath: String) {
		DispatchQueue.global(qos: .userInitiated).async {
			self.handleComplete(completion: completion, image: UIImage(contentsOfFile: imagePath))
		}
	}

	private func downloadItem(index: Int, completion: ((UIImage?) -> ())?, imageUrl: String) {
		//TODO move to property DispatchQueue
		DispatchQueue.global(qos: .userInitiated).async {
			if let imageDownloadUrl: URL = URL(string: self.imagesUrl + String(index)) {
				do {
					let imageData: Data = try Data(contentsOf: imageDownloadUrl)
					print("download completed index: \(index)")

					let image: UIImage? = UIImage(data: imageData)

					try self.saveImage(completion: completion, image: image, imagePath: imageUrl)
				} catch {
					print("Unable to load data: \(error) index: \(index)")
					self.handleComplete(completion: completion, image: nil)
				}
			}
		}
	}

	//TODO: completion: ((UIImage) -> ())? - throw custom error if image nil
	//TODO: saveImage() -> UIImage
	private func saveImage(completion: ((UIImage?) -> ())?, image: UIImage?, imagePath: String) throws {
		defer {
			self.handleComplete(completion: completion, image: image)
		}

		guard let imageData = image?.jpegData(compressionQuality: 1.0) else {
			return
		}

		if !fileManager.fileExists(atPath: self.imageDir.path) {
			try fileManager.createDirectory(atPath: imageDir.path, withIntermediateDirectories: true)
		}

		fileManager.createFile(atPath: imagePath, contents: imageData)
	}

	private func handleComplete(completion: ((UIImage?) -> ())?, image: UIImage?) {
//		print("model onActionCompleted ")
		DispatchQueue.main.async {
			completion?(image)
		}
	}
}
