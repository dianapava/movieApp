//
//  ViewController.swift
//  MoviesApp
//
//  Created by Diana Pava Avila on 5/05/23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let idTableView = "carouselMovies"
    let client = Client()
    var movies: [Movie] = []
    override func viewDidLoad() {
        let nib = UINib(nibName: "CarouselTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: idTableView)
        tableView.dataSource = self
        tableView.delegate = self
        callService()
    }
    
    private func callService() {
        let url = "https://api.themoviedb.org/3/movie/popular?api_key=99ca23b404a5dc4fd4a7cbf014a3c618"
        
        client.request(url: url) { (result: MovieResponse) in
//            for movie in result.results {
//                print(movie.original_title)
//                print(movie.overview)
//                print("\n")
//            }
            DispatchQueue.main.async {
                self.movies = result.results
                self.tableView.reloadData()
            }
          
        } onFailure: { error in
            print("Error = \(error)")
        }
    }
}

extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: idTableView, for: indexPath) as? CarouselTableViewCell else{
            return UITableViewCell()
        }
        cell.setModel(movies: movies)
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
