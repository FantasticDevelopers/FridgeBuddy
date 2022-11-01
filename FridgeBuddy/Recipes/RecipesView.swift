//
//  RecipesView.swift
//  FridgeBuddy
//
//  Created by Amandeep on 2022-07-20.
//

import SwiftUI

struct RecipesView: View {
    @EnvironmentObject var recipesViewModel : RecipesViewModel
    
    var body: some View{
        NavigationView{
            ScrollView{
                RecipesList(recipes: recipesViewModel.recipes)
            }
            .navigationTitle("Recipes")
        }
        .navigationViewStyle(.stack)
    }
}

struct RecipesView_Previews: PreviewProvider {
    static var previews: some View {
        RecipesView()
    }
}
struct RecipesList: View{
    @EnvironmentObject var recipesViewModel : RecipesViewModel
    var recipes : [Recipes]
    
    
    var body: some View {
        VStack{
            HStack{
                Text("\(recipes.count) \(recipes.count>1 ? "recipes" : "recipe")")
                    .font(.headline)
                    .fontWeight(.medium)
                    .opacity(0.7)
                Spacer()
            }
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 160), spacing: 15)], spacing: 15){
                ForEach(recipes) {recipe in
                    NavigationLink {
                        RecipeWebView(url: URL(string: "https://www.youtube.com/results?search_query=" + recipe.title.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)!)
                    } label: {
                        RecipeCard(recipe: recipe)
                    }
                }
            }.padding(.top)
        }
        .padding(.horizontal)
    }
}
