//
// Created by Orest Fufalko on 2019-04-08.
// Copyright (c) 2019 Orest Fufalko. All rights reserved.
//

import UIKit

final class PhotoPuzzleViewController: UIViewController {

	@IBOutlet private weak var collectionView: UICollectionView!

    var output: PhotoPuzzleViewControllerOutput?

	override func viewDidLoad() {
		super.viewDidLoad()

		self.collectionView.dataSource = self

		self.output?.handleViewLoaded()
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
			let image: UIImage? = self.output?.image(for: indexPath.row)
			puzzleCell.photo?.image = image
		}

		return cell
	}
}
