//
//  ViewController.swift
//  MoviesApp
//
//  Created by Diana Pava Avila on 5/05/23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var searchMovie: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    let idTableView = "carouselMovies"
    let client = Client()
    var movies: [Movie] = []
    var sections: [SectionTitle] = []
    override func viewDidLoad() {
        let nib = UINib(nibName: "CarouselTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: idTableView)
        let nib2 = UINib(nibName: "RecommendedTableViewCell", bundle: nil)
        tableView.register(nib2, forCellReuseIdentifier: "recommendedMovie")
        tableView.dataSource = self
        tableView.delegate = self
        popularService()
    }
    
    private func popularService() {
        let url = "https://api.themoviedb.org/3/movie/popular?api_key=99ca23b404a5dc4fd4a7cbf014a3c618"
        
        client.request(url: url) { (result: MovieResponse) in
            self.getTopRatedMovies(popular: result.results)
        } onFailure: { error in
            print("Error = \(error)")
        }
        
        
    }
    
    private func getTopRatedMovies(popular: [Movie]) {
        client.request(url: "https://api.themoviedb.org/3/movie/top_rated?api_key=99ca23b404a5dc4fd4a7cbf014a3c618") { (result: MovieResponse) in
            DispatchQueue.main.async {
                self.sections = [
                    SectionTitle(title: "popular", movies: popular),
                    SectionTitle(title: "rated", movies: result.results)
                ]
                
                self.tableView.reloadData()
            }
          
        } onFailure: { error in
            print("Error = \(error)")
        }
    }
}

extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

            guard let cell = tableView.dequeueReusableCell(withIdentifier: idTableView, for: indexPath) as? CarouselTableViewCell else{
                return UITableViewCell()
            }
        let section = sections[indexPath.row]
        cell.setModel(movies: section.movies, title: section.title)
            return cell
        
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

struct SectionTitle {
    let title: String
    let movies: [Movie]
}
