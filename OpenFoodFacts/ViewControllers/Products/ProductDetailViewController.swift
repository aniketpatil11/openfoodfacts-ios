//
//  ProductDetailViewController.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 14/04/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Crashlytics

class ProductDetailViewController: ButtonBarPagerTabStripViewController {
    
    var product: Product!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonBarView.register(UINib(nibName: "ButtonBarView", bundle: nil), forCellWithReuseIdentifier: "Cell")
        buttonBarView.backgroundColor = .white
        settings.style.selectedBarBackgroundColor = .white
        buttonBarView.selectedBar.backgroundColor = self.view.tintColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Answers.logContentView(withName: "Product's detail", contentType: "product_detail", contentId: product.barcode, customAttributes: ["product_name": product.name ?? ""])
        
        navigationController?.navigationBar.isTranslucent = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.navigationBar.isTranslucent = true
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        var vcs = [UIViewController]()
        
        vcs.append(getSummaryVC())
        vcs.append(getIngredientsVC())
        vcs.append(getNutritionVC())
        vcs.append(getNutritionTableVC())
        
        return vcs
    }
    
    fileprivate func getSummaryVC() -> UIViewController {
        let summaryTitle = NSLocalizedString("product-detail.page-title.summary", comment: "Product detail, summary")
        
        var summaryInfoRows = [InfoRow]()
        
        if let barcode = product.barcode {
            summaryInfoRows.append(InfoRow(label: .barcode, value: barcode))
        }
        if let quantity = product.quantity {
            summaryInfoRows.append(InfoRow(label: .quantity, value: quantity))
        }
        if let array = product.packaging {
            summaryInfoRows.append(InfoRow(label: .packaging, value: array.joined(separator: ", ")))
        }
        if let array = product.brands {
            summaryInfoRows.append(InfoRow(label: .brands, value: array.joined(separator: ", ")))
        }
        if let manufacturingPlaces = product.manufacturingPlaces {
            summaryInfoRows.append(InfoRow(label: .manufacturingPlaces, value: manufacturingPlaces))
        }
        if let origins = product.origins {
            summaryInfoRows.append(InfoRow(label: .origins, value: origins))
        }
        if let array = product.categories {
            summaryInfoRows.append(InfoRow(label: .categories, value: array.joined(separator: ", ")))
        }
        if let array = product.labels {
            summaryInfoRows.append(InfoRow(label: .labels, value: array.joined(separator: ", ")))
        }
        if let citiesTags = product.citiesTags {
            summaryInfoRows.append(InfoRow(label: .citiesTags, value: citiesTags))
        }
        if let array = product.stores {
            summaryInfoRows.append(InfoRow(label: .stores, value: array.joined(separator: ", ")))
        }
        if let array = product.countries {
            summaryInfoRows.append(InfoRow(label: .countries, value: array.joined(separator: ", ")))
        }
        
        return ProductDetailPageViewController<SummaryHeaderTableViewCell, InfoRowTableViewCell>(product: product, localizedTitle: summaryTitle, infoRows: summaryInfoRows)
    }
    
    fileprivate func getIngredientsVC() -> UIViewController {
        let ingredientsTitle = NSLocalizedString("product-detail.page-title.ingredients", comment: "Product detail, ingredients")
        
        var ingredientsInfoRows = [InfoRow]()
        
        if let ingredientsList = product.ingredientsList {
            ingredientsInfoRows.append(InfoRow(label: .ingredientsList, value: ingredientsList))
        }
        if let allergens = product.allergens {
            ingredientsInfoRows.append(InfoRow(label: .allergens, value: allergens))
        }
        if let traces = product.traces {
            ingredientsInfoRows.append(InfoRow(label: .traces, value: traces))
        }
        if let additives = product.additives?.map({ $0.value.uppercased() }).joined(separator: ", ") {
            ingredientsInfoRows.append(InfoRow(label: .additives, value: additives))
        }
        if let array = product.palmOilIngredients {
            ingredientsInfoRows.append(InfoRow(label: .palmOilIngredients, value: array.joined(separator: ", ")))
        }
        if let array = product.possiblePalmOilIngredients {
            ingredientsInfoRows.append(InfoRow(label: .possiblePalmOilIngredients, value: array.joined(separator: ", ")))
        }
        
        return ProductDetailPageViewController<IngredientHeaderTableViewCell, InfoRowTableViewCell>(product: product, localizedTitle: ingredientsTitle, infoRows: ingredientsInfoRows)
    }
    
    fileprivate func getNutritionVC() -> UIViewController {
        let nutritionTitle = NSLocalizedString("product-detail.page-title.nutrition", comment: "Product detail, nutrition")
        
        var nutritionInfoRows = [InfoRow]()
        
        if let servingSize = product.servingSize {
            nutritionInfoRows.append(InfoRow(label: .servingSize, value: servingSize))
        }
        if let carbonFootprint = product.nutriments?.carbonFootprint, let unit = product.nutriments?.carbonFootprintUnit {
            nutritionInfoRows.append(InfoRow(label: .carbonFootprint, value:(String(carbonFootprint) + " " + unit)))
        }
        
        return ProductNutritionViewController(product: product, localizedTitle: nutritionTitle, infoRows: nutritionInfoRows)
    }
    
    fileprivate func getNutritionTableVC() -> UIViewController {
        let nutritionTableTitle = NSLocalizedString("product-detail.page-title.nutrition-table", comment: "Product detail, nutrition table")
        
        var nutritionTableInfoRows = [InfoRow]()
        
        if let nutriments = product.nutriments, let energy = nutriments.energy, let per100g = energy.per100g, let perServing = energy.perServing {
            nutritionTableInfoRows.append(InfoRow(label: .energy, value: String(per100g.twoDecimalRounded), secondaryValue: perServing, highlight: false))
        }
        
        return ProductDetailPageViewController<NutritionTableHeaderTableViewCell, NutritionTableRowTableViewCell>(product: product, localizedTitle: nutritionTableTitle, infoRows: nutritionTableInfoRows)
    }
}
