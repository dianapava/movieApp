//
//  MovieCollectionViewCell.swift
//  MoviesApp
//
//  Created by Diana Pava Avila on 6/05/23.
//

import UIKit
import SDWebImage
class MovieCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var descriptionMovie: UILabel!
    @IBOutlet weak var imageMovie: UIImageView!

    
    func set(urlImage: String) {
        let url = "https://image.tmdb.org/t/p/w400" + urlImage
        imageMovie.sd_setImage(with: URL(string: url))
    }

}
