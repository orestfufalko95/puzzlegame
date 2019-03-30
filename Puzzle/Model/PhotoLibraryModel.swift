//
//  PhotoLibraryModel.swift
//  Puzzle
//
//  Created by Orest Fufalko on 3/26/19.
//  Copyright © 2019 Orest Fufalko. All rights reserved.
//

import UIKit

class PhotoLibraryModel: LibraryModel {
    func load(index: Int, completion: (UIImage?) -> ()) {
        self.downloadItem(index: index, completion: completion)
    }
    
    
    typealias Item = UIImage
    
    func getItems() -> [UIImage] {
        return []
    }
    
    private func downloadItem(index: Int, completion: @escaping (UIImage?) -> ()) {
        DispatchQueue.global(qos: .userInitiated).async {
            if let theProfileImageUrl = URL(string: "https://picsum.photos/200/300?image=\(index)") {
                do {
                    let imageData = try Data(contentsOf: theProfileImageUrl as URL)
                    let image = UIImage(data: imageData)
                    self.onActionCompleted(completion: completion, image: image)
                } catch {
                    print("Unable to load data: \(error)")
                    self.onActionCompleted(completion: completion, image: nil)
                }
            }
        }
    }
    
    private func onActionCompleted(completion: @escaping (UIImage?) -> (), image: UIImage?) {
        DispatchQueue.main.sync {
            completion(image)
        }
    }
}
