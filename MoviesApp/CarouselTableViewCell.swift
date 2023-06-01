//
//  CarouselTableViewCell.swift
//  MoviesApp
//
//  Created by Diana Pava Avila on 6/05/23.
//

import UIKit

class CarouselTableViewCell: UITableViewCell {

    @IBOutlet weak var sectionTitleLabel: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var collectionView: UICollectionView!
    let idCollection = "movieCollection"
    var movies: [Movie] = []
    override func awakeFromNib() {
        let nib = UINib(nibName: "MovieCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: idCollection)
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    func setModel(movies: [Movie], title: String){
        sectionTitleLabel.text = title
        self.movies = movies
        pageControl.numberOfPages = movies.count
        collectionView.reloadData()
    }
}

extension CarouselTableViewCell: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCollection", for: indexPath) as!
        MovieCollectionViewCell
        
        cell.set(urlImage: movies[indexPath.row].poster_path)
        cell.descriptionMovie.text = movies[indexPath.row].original_title
        return cell
    
    }
}

extension CarouselTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        pageControl.currentPage = indexPath.row
    }
}
