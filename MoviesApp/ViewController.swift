//
//  ViewController.swift
//  MoviesApp
//
//  Created by Diana Pava Avila on 5/05/23.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    let idTableView = "carouselMovies"
    let idTableViewCell2 = "recommendedMovie"
    let client = Client()
    var movies: [Movie] = []
    var sections: [SectionTitle] = []
    
    private lazy var resultVC = ResultVC()
    
    private lazy var searchController: UISearchController = {
         UISearchController(searchResultsController: resultVC)
    }()
  
    override func viewDidLoad() {
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "escribre tu busqueda..."
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        let textField = searchController.searchBar.searchTextField
        textField.textColor = .white
        textField.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        textField.font = UIFont.boldSystemFont(ofSize: 16)
        
        let nib = UINib(nibName: "CarouselTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: idTableView)
        let nib2 = UINib(nibName: "RecommendedTableViewCell", bundle: nil)
        tableView.register(nib2, forCellReuseIdentifier: idTableViewCell2)
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
                    SectionTitle(type: .movies, title: "popular", movies: popular),
                    SectionTitle(type: .recommended,title: "rated", movies: result.results)
                ]
                
                self.tableView.reloadData()
            }
          
        } onFailure: { error in
            print("Error = \(error)")
        }
    }
    
    private func search(text: String) {
        let headers = [
          "accept": "application/json",
          "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI5OWNhMjNiNDA0YTVkYzRmZDRhN2NiZjAxNGEzYzYxOCIsInN1YiI6IjY0NWQ5M2JjZDZjMzAwMDEwM2Q3NmEwMyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.Gkve36chGL10Axzt_I3fzTRIQsciOIhf_agEKovjpeo"
        ]
        client.request(url: "https://api.themoviedb.org/3/search/movie?query=\(text)&include_adult=false&language=en-US&page=1", headers: headers) { (result: SearchReponse) in
            let titles = result.results.map { $0.original_title }
            DispatchQueue.main.async {
                self.resultVC.set(data: titles)
            }
        } onFailure: { error in
            print("Error = \(error)")
        }
    }
}

extension ViewController: UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].type == .movies ? 1 : sections[section].movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        switch section.type {
        case .recommended:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "recommendedMovie", for: indexPath) as? RecommendedTableViewCell
            else{
                return UITableViewCell()
            }
            cell.set(data: section.movies[indexPath.row])
            return cell
        case .movies:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: idTableView, for: indexPath) as? CarouselTableViewCell else{
                return UITableViewCell()
            }
            cell.setModel(movies: section.movies, title: section.title)
            return cell
        }
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        search(text: searchText)
    }
}

enum SectionType {
    case recommended
    case movies
}

struct SectionTitle {
    let type: SectionType
    let title: String
    let movies: [Movie]
}

class ResultVC: UIViewController {
    
    private lazy var tableView: UITableView = {
       let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        let nib2 = UINib(nibName: "RecommendedTableViewCell", bundle: nil)
        tableView.register(nib2, forCellReuseIdentifier: "recommendedMovie")
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }()
    
    private var items: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setTableViewConstraints()
    }
    
    private func setTableViewConstraints() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func set(data: [String]) {
        items = data
        tableView.reloadData()
    }
}

extension ResultVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "recommendedMovie", for: indexPath) as? RecommendedTableViewCell
        else{
            return UITableViewCell()
        }
        
        cell.nameMovie.text = items[indexPath.row]
        return cell
    }
}
