//
//  PhotoLibraryModel.swift
//  Puzzle
//
//  Created by Orest Fufalko on 3/26/19.
//  Copyright © 2019 Orest Fufalko. All rights reserved.
//

import UIKit

final class PhotoLibraryModel {

	private let imagesUrl = "https://picsum.photos/200/300?image="

	private let fileManager: FileManager = FileManager.default
	private let imageDir: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
			.first!
			.appendingPathComponent("puzzle", isDirectory: true)

	private let dispatchQueue = DispatchQueue.global(qos: .userInitiated)

	var output: PhotoLibraryModelOutput?
}

// MARK: -  Model Input methods
extension PhotoLibraryModel: PhotoLibraryModelInput {
	func updateItems() {
		dispatchQueue.async {
			var itemsCount = 0

			do {//TODO: check biggest index of image
				itemsCount = try self.fileManager.contentsOfDirectory(atPath: self.imageDir.path).count
			} catch {
				print("Unable to load data: \(error) index: \(index)")
			}

			var images = [PhotoEntity]()

			for index in 0..<itemsCount {
				let imagePath = self.imageDir.appendingPathComponent("\(index).jpg").path
				images.append(PhotoEntity(image: UIImage(contentsOfFile: imagePath) ?? UIImage()))
			}

			DispatchQueue.main.async { [weak self] in
				self?.output?.handleItemsAdded(newPhotos: images)
			}
		}
	}

	//TODO: check is already running or check is start index already downloaded
	func downloadNewItems(startIndex: Int, count: Int) {
		print("downloadNewItems index: \(startIndex)")
		let downloadGroup = DispatchGroup()

		var newPhotos = [PhotoEntity]()

		for index in startIndex..<(startIndex + count) {
			downloadGroup.enter()

			let workItem = DispatchWorkItem(flags: .inheritQoS) { [weak self] in
				do {
					newPhotos.append(PhotoEntity(image: try self?.downloadImage(index: index)))
					downloadGroup.leave()
				} catch {
					print("Unable to load data: \(error) index: \(index)")
					newPhotos.append(PhotoEntity(image: UIImage()))
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
private extension PhotoLibraryModel {

	func downloadImage(index: Int) throws -> UIImage? {
		if let imageDownloadUrl: URL = URL(string: self.imagesUrl + String(index)) {

			let imageData: Data = try Data(contentsOf: imageDownloadUrl)
			print("download completed index: \(index)")

			let image: UIImage? = UIImage(data: imageData)
			let imagePath = self.imageDir.appendingPathComponent("\(index).jpg").path
//			print("model imagePath: \(imagePath)")

			try self.saveImage(image: image, imagePath: imagePath)

			return image
		} else {
			return UIImage()
		}
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
