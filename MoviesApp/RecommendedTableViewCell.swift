//
//  RecommendedTableViewCell.swift
//  MoviesApp
//
//  Created by Diana Pava Avila on 28/05/23.
//

import UIKit

class RecommendedTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var scoreImage: UIImageView!
    @IBOutlet weak var descriptionMovie: UILabel!
    @IBOutlet weak var nameMovie: UILabel!
    @IBOutlet weak var imageMovie: UIImageView!

    
    func set(data: Movie) {
        let url = "https://image.tmdb.org/t/p/w400" + data.poster_path
        imageMovie.sd_setImage(with: URL(string: url))
        nameMovie.text = data.original_title
        descriptionMovie.text = String(data.vote_average)
    }
}
