//
//  LibraryTableViewController.swift
//  Puzzle
//
//  Created by Orest Fufalko on 3/26/19.
//  Copyright © 2019 Orest Fufalko. All rights reserved.
//

import UIKit

class LibraryTableViewController: UITableViewController {

	var output: LibraryTableViewControllerOutput?

	private var activityIndicator: UIActivityIndicatorView?

	override func viewDidLoad() {
		super.viewDidLoad()

		self.title = self.output?.title

		activityIndicator = UIActivityIndicatorView(style: .gray)
		activityIndicator?.translatesAutoresizingMaskIntoConstraints = true
		activityIndicator?.hidesWhenStopped = true
		self.tableView.tableFooterView = activityIndicator

		self.output?.handleViewCreated()

		self.tableView.prefetchDataSource = (self.output?.isPrefetchEnabled ?? false) ? self : nil
	}
}

// MARK: -  View Input methods
extension LibraryTableViewController: LibraryTableViewControllerInput {
	func handleImagesUpdated() {
		self.tableView.reloadData()
	}

	func showLoading() {
		self.activityIndicator?.startAnimating()
	}

	func hideLoading() {
		self.activityIndicator?.stopAnimating()
	}
}

// MARK: - Table view data source prefetching
extension LibraryTableViewController: UITableViewDataSourcePrefetching {

	func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
		self.output?.prefetch(indexes: indexPaths.map({ $0.row }))
	}
}

// MARK: - Table view data source
extension LibraryTableViewController {

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.output?.itemsCount ?? 0
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: LibraryPhotoCell.identifier, for: indexPath)
		if let newCell = cell as? LibraryPhotoCell {
			guard let photo = self.output?.photo(index: indexPath.row) else {
				return cell
			}

			newCell.photo?.image = photo.image
			newCell.puzzleTimeLabel.isHidden = photo.puzzleTime == 0

			if photo.puzzleTime != 0 {
				let seconds: Int = photo.puzzleTime % 60
				let minutes: Int = (photo.puzzleTime / 60) % 60
				newCell.puzzleTimeLabel.text = String(format: "%02d:%02d", minutes, seconds)
			}
		}

		return cell
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		self.output?.photoSelected(index: indexPath.row)
	}
}
