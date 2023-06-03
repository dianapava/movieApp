//
//  ViewController.swift
//  MoviesApp
//
//  Created by Diana Pava Avila on 5/05/23.
//

import UIKit

class ViewController: UIViewController {

    var peliculasFiltradas: [String]!
    
    @IBOutlet weak var seachBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    let idTableView = "carouselMovies"
    let client = Client()
    var movies: [Movie] = []
    override func viewDidLoad() {
        let nib = UINib(nibName: "CarouselTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: idTableView)
        
        //Definir el delegado del searchbar
        seachBar.delegate = self
        
        //Definir los delegados de la tabla
        tableView.dataSource = self
        tableView.delegate = self
        callService()
    }
    
    private func callService() {
        let url = "https://api.themoviedb.org/3/movie/popular?api_key=99ca23b404a5dc4fd4a7cbf014a3c618"
        
        client.request(url: url) { (result: MovieResponse) in

            DispatchQueue.main.async {
                self.movies = result.results
                self.tableView.reloadData()
            }
          
        } onFailure: { error in
            print("Error = \(error)")
        }
    }
}
// MARK: - Searchbar Metodos

extension ViewController: UISearchBarDelegate{
    
    //identificar cuando el usuario comienza a escribir
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        peliculasFiltradas = []
        
        if searchText == "" {
            peliculasFiltradas =
        }else{
            for
        }
        // cada que cambie el texto necesito actualizar la tabla 
    }
}

// MARK: - UITableview Metodos
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





