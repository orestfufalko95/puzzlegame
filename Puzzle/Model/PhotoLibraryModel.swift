//
//  PhotoLibraryModel.swift
//  Puzzle
//
//  Created by Orest Fufalko on 3/26/19.
//  Copyright © 2019 Orest Fufalko. All rights reserved.
//

import UIKit

class PhotoLibraryModel: LibraryModel {

	private let imagesUrl = "https://picsum.photos/200/300?image="

	private let manager: FileManager = FileManager.default
	private let imageDir: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
			.first!
			.appendingPathComponent("puzzle", isDirectory: true)

	typealias Item = UIImage

	func getItems() -> [UIImage] {
		return []
	}

	func load(index: Int, completion: @escaping (UIImage?) -> ()) {
		let url = imageDir.appendingPathComponent("\(index).jpg")
		let imagePath = url.path
//		print("model imagePath: \(imagePath)")

		if manager.fileExists(atPath: imagePath) {
			print("model cached file index: \(index)")
			self.completeWithSavedFile(completion: completion, imagePath: imagePath)
		} else {
			print("model download started index: \(index)")
			self.downloadItem(index: index, completion: completion, imageUrl: imagePath, url: url)
		}
	}

	private func completeWithSavedFile(completion: @escaping (UIImage?) -> (), imagePath: String) {
	    DispatchQueue.global(qos: .userInitiated).async {
			self.onActionCompleted(completion: completion, image: UIImage(contentsOfFile: imagePath))
		}
	}

	private func downloadItem(index: Int, completion: @escaping (UIImage?) -> (), imageUrl: String, url: URL) {
		DispatchQueue.global(qos: .userInitiated).async {
			if let imageDownloadUrl = URL(string: self.imagesUrl + String(index)) {
				do {
					let imageData: Data = try Data(contentsOf: imageDownloadUrl)
					print("download completed index: \(index)")

					let image: UIImage? = UIImage(data: imageData)

					try self.saveImage(completion: completion, image: image, imagePath: imageUrl, url: url)
				} catch {
					print("Unable to load data: \(error) index: \(index)")
					self.onActionCompleted(completion: completion, image: nil)
				}
			}
		}
	}

	private func saveImage(completion: @escaping (UIImage?) -> (), image: UIImage?, imagePath: String, url: URL) throws {
		defer {
			self.onActionCompleted(completion: completion, image: image)
		}

		guard let imageData = image?.jpegData(compressionQuality: 1.0) else {
			return
		}

		if !manager.fileExists(atPath: self.imageDir.path) {
			try manager.createDirectory(atPath: imageDir.path, withIntermediateDirectories: true)
		}

//		print("model saveImage url: \(url)")
		let b: Bool = manager.createFile(atPath: imagePath, contents: imageData)
//		print("model saveImage isCreated: \(b)")
	}

	private func onActionCompleted(completion: @escaping (UIImage?) -> (), image: UIImage?) {
//		print("model onActionCompleted ")
		DispatchQueue.main.async {
			completion(image)
		}
	}
}
