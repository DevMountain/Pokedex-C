//
//  DVMPokemonViewController.swift
//  Pokedex-C
//
//  Created by Karl Pfister on 5/4/20.
//  Copyright © 2020 Karl Pfister. All rights reserved.
//

import UIKit

class DVMPokemonViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var pokemonSearchBar: UISearchBar!
    @IBOutlet weak var pokemonNameLabel: UILabel!
    @IBOutlet weak var pokemonIDLabel: UILabel!
    @IBOutlet weak var pokemonAbilitiesLabel: UILabel!
    @IBOutlet weak var pokemonSpriteImageView: UIImageView!
    
    //MARK: - Properties
    var pokemon: DVMPokemon?
    var spriteImage: UIImage?
    
    //MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        pokemonSearchBar.delegate = self
        fetchPokemon(searchTerm: "146")
    }
    
    //MARK: - Helper Functions
    func updateViews() {
        guard let pokemon = pokemon, let sprite = spriteImage else {return}
        pokemonNameLabel.text = pokemon.name
        pokemonIDLabel.text = "ID: \(pokemon.identifier)"
        pokemonAbilitiesLabel.text = "Abilities: " + (pokemon.abilities.joined(separator: ", "))
        pokemonSpriteImageView.image = sprite
    }
    
    func fetchPokemon(searchTerm: String) {
        DVMPokemonController.fetchPokemon(forSearchTerm: searchTerm) { (pokemon) in
            DVMPokemonController.fetchSpriteImage(for: pokemon) { (sprite) in
                DispatchQueue.main.async {
                    self.pokemon = pokemon
                    self.spriteImage = sprite
                    self.updateViews()
                }
            }
        }
    }
}

//MARK: - Extensions
extension DVMPokemonViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.fetchPokemon(searchTerm: searchText)
    }
}
