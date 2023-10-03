import Foundation
import SwiftyJSON

class SizeClass : NSObject {

    var sizeId : Int!
    var sizeName : String!

    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        sizeId = json["SizeId"].intValue
        sizeName = json["SizeName"].stringValue
    }
}


class MilkTypeClass : NSObject{
    
    var milkId : Int!
    var milkName : String!
    var categoryId: Int!
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        milkId = json["MilkId"].intValue
        milkName = json["MilkName"].stringValue
        categoryId = json["CategoryId"].intValue
    }
}

class SugarTypeClass : NSObject{

    var categoryId : Int!
    var sugarType : String!
    var sugarTypeId : Int!

    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        categoryId = json["CategoryId"].intValue
        sugarType = json["SugarType"].stringValue
        sugarTypeId = json["SugarTypeId"].intValue
    }
}

class ToppingTypeClass : NSObject{

    var categoryId : Int!
    var toppingId : Int!
    var toppingType : String!

    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        categoryId = json["CategoryId"].intValue
        toppingId = json["ToppingId"].intValue
        toppingType = json["ToppingType"].stringValue
    }

}
