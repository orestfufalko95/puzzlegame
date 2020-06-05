//
//  PhotoDownloadsModel.swift
//  Puzzle
//
//  Created by Orest Fufalko on 3/26/19.
//  Copyright © 2019 Orest Fufalko. All rights reserved.
//

import UIKit

final class PhotoDownloadsModel {

	private let imagesUrl = "https://picsum.photos/300/300?image="

	private let fileManager: FileManager = FileManager.default
	private let imageDir: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
			.first!
			.appendingPathComponent("puzzle", isDirectory: true)

	private let dispatchQueue = DispatchQueue.global(qos: .userInitiated)

	var output: PhotoLibraryModelOutput?
}

// MARK: -  Model Input methods
extension PhotoDownloadsModel: PhotoLibraryModelInput {
	func updateItems() {
		dispatchQueue.async {
			var itemsCount = 0

			do {//TODO: check biggest index of image
				itemsCount = try self.fileManager.contentsOfDirectory(atPath: self.imageDir.path).count
			} catch {
				print("Unable to load data: \(error) index: \(index)")
			}

			var photos = [Photo]()

			for index in 0..<itemsCount {
				let imagePath = self.imageDir.appendingPathComponent("\(index).jpg").path
				photos.append(Photo(image: UIImage(contentsOfFile: imagePath) ?? UIImage(), id: index))
			}

			DispatchQueue.main.async { [weak self] in
				self?.output?.handleItemsAdded(newPhotos: photos)
			}
		}
	}

	//TODO: check is already running or check is start index already downloaded
	func fetchNewItems(startIndex: Int, count: Int) {
		print("downloadNewItems index: \(startIndex)")
		let downloadGroup = DispatchGroup()

		var newPhotos = [Photo]()

		for index in startIndex..<(startIndex + count) {
			downloadGroup.enter()

			let workItem = DispatchWorkItem(flags: .inheritQoS) { [weak self] in
				do {
					newPhotos.append(Photo(image: try self?.downloadImage(index: index) ?? UIImage(), id: index))
					downloadGroup.leave()
				} catch {
//					print("Unable to load data: \(error) index: \(index)")
					newPhotos.append(Photo(image: UIImage(), id: index))
					downloadGroup.leave()
				}
			}

			dispatchQueue.async(execute: workItem)
		}

		downloadGroup.notify(queue: DispatchQueue.main) { [weak self] in
			self?.output?.handleItemsAdded(newPhotos: newPhotos)
		}
	}
}

// MARK: - Helpers
private extension PhotoDownloadsModel {

	func downloadImage(index: Int) throws -> UIImage? {
		guard let imageDownloadUrl: URL = URL(string: self.imagesUrl + String(index)) else {
			return UIImage()
		}

		let imageData: Data = try Data(contentsOf: imageDownloadUrl)
		print("download completed index: \(index)")

		let image: UIImage? = UIImage(data: imageData)
		let imagePath = self.imageDir.appendingPathComponent("\(index).jpg").path

		try self.saveImage(image: image, imagePath: imagePath)

		return image
	}

	func saveImage(image: UIImage?, imagePath: String) throws {
		guard let imageData = image?.jpegData(compressionQuality: 1.0) else {
			return
		}

		if !fileManager.fileExists(atPath: self.imageDir.path) {
			try fileManager.createDirectory(atPath: imageDir.path, withIntermediateDirectories: true)
		}

		fileManager.createFile(atPath: imagePath, contents: imageData)
	}
}
