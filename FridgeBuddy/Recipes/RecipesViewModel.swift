//
//  RecipesViewModel.swift
//  FridgeBuddy
//
//  Created by Amandeep on 2022-07-20.
//

import Foundation
import SwiftUI

@MainActor final class RecipesViewModel : ObservableObject{
    @Published var recipes : [Recipes] = [Recipes()]
    @Published var ingredients = ["eggs","milk","cucumber"]
    
    func getRecipes(completion: @escaping (Result<[Recipes], Error>) -> Void) {
        let app_key = "8cb1284a79mshb55362ef0785034p1ca656jsn954f7a35aad6"  // x-app-key
        let app_host = "spoonacular-recipe-food-nutrition-v1.p.rapidapi.com"    //x-app-host
        guard let url = URL(string: "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/findByIngredients?ingredients=" + allIngredients(ingredients: self.ingredients) + "&number=20&ignorePantry=true&ranking=1") else{
            fatalError("Fatal Error")
        }
        print(url)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(app_key, forHTTPHeaderField: "X-RapidAPI-Key")
        request.setValue(app_host, forHTTPHeaderField: "X-RapidAPI-Host")
        URLSession.shared.dataTask(with: request as URLRequest){ data, response , error in
            guard let data = data else{return}
            do{
                let httpResponse = response as? HTTPURLResponse
                print(httpResponse!)
                let decodedData = try JSONDecoder().decode([Recipe].self, from: data)
                //print(decodedData)
                print(decodedData.count)
                self.recipes.removeAll()
                for i in decodedData{
                    let r = Recipes(r_id: i.id, t: i.title, img: i.image, uIng: i.usedIngredientCount, mIng: i.missedIngredientCount, lik: i.likes)
                    self.recipes.append(r)
                }
                completion(.success(self.recipes))
            } catch let error {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func setIngredients(items:[Item]){
        var i : [Item] = items
        for it in i {
            self.ingredients.append(it.name)
        }
        print(self.ingredients)
    }
    
    func allIngredients( ingredients : [String]) -> String{
        var ingredient : String = ""
        var pickHead : Bool = true
        for i in ingredients{
            let originalString = i
            let escapedString = originalString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
            if(pickHead){
                ingredient =  escapedString!
                pickHead = false
            }
            else{
                ingredient =  ingredient + ",+" + escapedString!
            }
        }
        print(ingredient)
        return ingredient
    }
}
