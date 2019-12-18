//
//  HeroesTableViewController.swift
//  HeroisMarvel
//
//  Created by Eric Brito on 22/10/17.
//  Copyright © 2017 Eric Brito. All rights reserved.
//

import UIKit

class HeroesTableViewController: UITableViewController {

    var name: String?
    lazy var heroes: [Hero] = {
        return []
    }()
    
    var label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    lazy var loadingHeroes: Bool = {
        return false
    }()
    
    lazy var currentPage: Int = {
        return 0
    }()
    
    lazy var total: Int = {
        return 0
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = "Carregando Herois, aguarde ...."
        loadHeroes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    func loadHeroes(){
        loadingHeroes = true
        MarvelAPI.loadHeros(name: name, page: currentPage) { (info) in
            if let info = info {
                self.heroes += info.data.results
                self.total = info.data.total
                print("Total: ",self.total,"-já incluídos:", self.heroes.count)
                DispatchQueue.main.async {
                    self.loadingHeroes = false
                    self.label.text = "Não foram encontrados Heróis com o nome \(self.name!)"
                    self.tableView.reloadData()
                }
            }
        }
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.backgroundView = heroes.count == 0 ? label : nil
        return heroes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HeroTableViewCell
        
        let hero = heroes[indexPath.row]
        cell.prepareCell(with: hero)
        

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let heroController = segue.destination as! HeroViewController
        heroController.hero =  heroes[tableView.indexPathForSelectedRow!.row]
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    
        if indexPath.row == heroes.count - 10 && !loadingHeroes && heroes.count != total {
            
            currentPage += 1
            loadHeroes()
            print("Carregando mais herois")
        }
    }
    

   

}
