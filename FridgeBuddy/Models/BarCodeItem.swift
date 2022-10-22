import Foundation

struct BarCodeItem: Codable {
    var food_name: String
    var brand_name : String
    var serving_qty : Int?
    var serving_unit: String?
    var serving_weight_grams : Int?
    var nf_calories : Int?
    var nf_total_fat : Float?
    var nf_saturated_fat : Float?
    var nf_cholestrol : Float?
    var nf_sodium : Int?
    var nf_total_carbohydrate : Int?
    var dietary_fiber : Int?
    var nf_sugars : Int?
    var nf_protein : Int?
    var potassium : Int?
    var nf_p : Int?
    var full_nutrients : [Nutrient]?
    var nix_brand_name : String
    var nix_brand_id : String
    var nix_item_name : String
    var nix_item_id : String
    var metadata : Metadata?
    var source :Int?
    var ndb_no : Int?
    var tags : [String]?
    var alt_measures : String?
    var lat : String?
    var lng : String?
    var photo : Photo?
    var note : String?
    var class_code : String?
    var brick_code : String?
    var tag_id : String?
    var updated_at : String?
    var nf_ingredient_statement: String?
    
    init() {
        self.food_name = ""
        self.brand_name = ""
        self.nix_item_name = ""
        self.nix_item_id = ""
        self.nix_brand_id = ""
        self.nix_brand_name = ""
    }

    init(f_name : String, b_name : String, nix_b_name : String, nix_b_id : String, nix_i_name : String, nix_i_id : String) {
        self.food_name = f_name
        self.brand_name = b_name
        self.nix_brand_name = nix_b_name
        self.nix_brand_id = nix_b_id
        self.nix_item_id = nix_i_id
        self.nix_item_name = nix_i_name
    }
}

struct Results : Codable{
    var foods : [BarCodeItem]?
}

struct Metadata: Codable{
    var message : String?
}

struct Nutrient : Codable{
    var attr_id : Int?
    var value : Float?
}

struct Photo : Codable{
    var thumb : String?
    var highres : String?
    var is_user_uploaded : Bool?
}
