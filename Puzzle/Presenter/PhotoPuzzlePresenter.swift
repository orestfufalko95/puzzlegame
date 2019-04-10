//
// Created by Orest Fufalko on 2019-04-10.
// Copyright (c) 2019 Orest Fufalko. All rights reserved.
//

import UIKit

final class PhotoPuzzlePresenter {

	private static let puzzlesSize = 3

	private weak var view: (UIViewController & PhotoPuzzleViewControllerInput)?
	private let photo: PhotoEntity!

	private var puzzles: [UIImage] = []

	var model: PhotoPuzzleModelInput?

	init(view: (UIViewController & PhotoPuzzleViewControllerInput), photo: PhotoEntity) {
		self.view = view
		self.photo = photo

	}
}

extension PhotoPuzzlePresenter: PhotoPuzzleModelOutput {

}

extension PhotoPuzzlePresenter: PhotoPuzzleViewControllerOutput {

	var puzzlesCount: Int {
		return self.puzzles.count
	}

	func handleViewLoaded() {
		self.puzzles.removeAll()
		self.puzzles.reserveCapacity(PhotoPuzzlePresenter.puzzlesSize * PhotoPuzzlePresenter.puzzlesSize)

		let puzzleWidth = self.photo.image.size.width / CGFloat(PhotoPuzzlePresenter.puzzlesSize)
		let puzzleHeight = self.photo.image.size.height / CGFloat(PhotoPuzzlePresenter.puzzlesSize)
		let imageOrientation = self.photo.image.imageOrientation

		var startX = CGFloat(0)
		for _ in 0..<PhotoPuzzlePresenter.puzzlesSize {
			var startY = CGFloat(0)

			for _ in 0..<PhotoPuzzlePresenter.puzzlesSize {

				if let puzzle = self.photo.image.cgImage?.cropping(to: CGRect(origin: CGPoint(x: startX, y: startY),
						size: CGSize(width: puzzleWidth, height: puzzleHeight))) {
					self.puzzles.append(UIImage(cgImage: puzzle, scale: 1, orientation: imageOrientation))
				} else {
					self.puzzles.append(UIImage())
				}

				startY += puzzleHeight
			}

			startX += puzzleWidth
		}

		self.view?.reload()
	}

	func image(for index: Int) -> UIImage {
		return self.puzzles[index / PhotoPuzzlePresenter.puzzlesSize + index % PhotoPuzzlePresenter.puzzlesSize]
	}
}

//
//extension UIImage {
//	var topHalf: UIImage? {
//		guard let image = cgImage?
//				.cropping(to: CGRect(origin: .zero,
//						size: CGSize(width: size.width,
//								height: size.height / 2)))
//				else {
//			return nil
//		}
//		return UIImage(cgImage: image, scale: 1, orientation: imageOrientation)
//	}
//	var bottomHalf: UIImage? {
//		guard let image = cgImage?
//				.cropping(to: CGRect(origin: CGPoint(x: 0,
//						y: size.height - (size.height / 2).rounded()),
//						size: CGSize(width: size.width,
//								height: size.height -
//										(size.height / 2).rounded())))
//				else {
//			return nil
//		}
//		return UIImage(cgImage: image)
//	}
//	var leftHalf: UIImage? {
//		guard let image = cgImage?
//				.cropping(to: CGRect(origin: .zero,
//						size: CGSize(width: size.width / 2,
//								height: size.height)))
//				else {
//			return nil
//		}
//		return UIImage(cgImage: image)
//	}
//	var rightHalf: UIImage? {
//		guard let image = cgImage?
//				.cropping(to: CGRect(origin: CGPoint(x: size.width - (size.width / 2).rounded(), y: 0),
//						size: CGSize(width: size.width - (size.width / 2).rounded(),
//								height: size.height)))
//				else {
//			return nil
//		}
//		return UIImage(cgImage: image)
//	}
//}
