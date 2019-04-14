//
// Created by Orest Fufalko on 2019-04-08.
// Copyright (c) 2019 Orest Fufalko. All rights reserved.
//

import UIKit

final class PhotoPuzzleViewController: UIViewController {

	@IBOutlet private weak var collectionView: UICollectionView!

	var output: PhotoPuzzleViewControllerOutput?

	private lazy var cellSize: CGSize = {
		guard let height = self.output?.puzzlesCellHeight(containerHeight: Int(self.collectionView.frame.height)),
			  let width = self.output?.puzzlesCellHeight(containerHeight: Int(self.collectionView.frame.width)) else {

			return CGSize(width: self.collectionView.frame.width, height: self.collectionView.frame.height)
		}

		return CGSize(width: width, height: height)
	}()

	override func viewDidLoad() {
		super.viewDidLoad()

		self.collectionView.delegate = self
		self.collectionView.dataSource = self

		self.output?.handleViewLoaded()

		let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongGesture(gesture:)))
		self.collectionView.addGestureRecognizer(longPressGesture)
	}

	@objc func handleLongGesture(gesture: UILongPressGestureRecognizer) {
		switch (gesture.state) {

		case .began:
			guard let selectedIndexPath = self.collectionView.indexPathForItem(at: gesture.location(in: self.collectionView)) else {
				break
			}
			self.collectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
		case .changed:
			self.collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
		case .ended:
			self.collectionView.endInteractiveMovement()
		default:
			self.collectionView.cancelInteractiveMovement()
		}
	}
}

extension PhotoPuzzleViewController: PhotoPuzzleViewControllerInput {

	func reload() {
		self.collectionView.reloadData()
	}
}

extension PhotoPuzzleViewController: UICollectionViewDataSource {

	public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return self.output?.puzzlesCount ?? 0
	}

	public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoPuzzleCell.identifier, for: indexPath)

		if let puzzleCell = cell as? PhotoPuzzleCell {
			let puzzleEntity: PuzzleEntity! = self.output?.puzzleEntity(for: indexPath.row)
			let image: UIImage? = puzzleEntity?.image
			puzzleCell.photo?.image = image
			puzzleCell.coordinateLabel?.text = "\(puzzleEntity.x)-\(puzzleEntity.y)"
		}

		return cell
	}

	public func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
		return true
	}

	public func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
		print("Starting Index: \(sourceIndexPath.item)")
		print("Ending Index: \(destinationIndexPath.item)")

		self.output?.swap(fromIndex: sourceIndexPath.item, toIndex: destinationIndexPath.item)
	}
}

extension PhotoPuzzleViewController: UICollectionViewDelegateFlowLayout {

	public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return self.cellSize
	}
}
