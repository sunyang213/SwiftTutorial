//
//  TableViewController.swift
//  SwiftTutorial
//
//  Created by Chang on 3/7/15.
//  Copyright (c) 2015 Chang. All rights reserved.
//
import UIKit

class TableViewController: UITableViewController, UISearchDisplayDelegate, UISearchBarDelegate {
    
    // Objects
    var candies = [Candy]()
    
    // Favorite Brands
    
    
    // Other Brands
    var _allBrandsDict: Dictionary<Character, [Brand]> = Dictionary<Character, [Brand]>()
    var _sectionSorted = [Character]()
    // Search
    var _hasFilter: Bool = false
    var _filteredBrands: Dictionary<Character, [Brand]> = Dictionary<Character, [Brand]>()
    var _filteredSectionSorted = [Character]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Initialize
        // Read/Write to .plist
        //deleteLocalPropertyListFile("Configuration")
        let configurationDict: NSMutableDictionary = loadPropertyListFile("Configuration")
        //configurationDict.setObject("testValue", forKey: "testKey")
        //saveLocalPropertyListFile("Configuration", configurationDict)
        //println(loadPropertyListFile("Configuration"))
        
        // Read FavorateBrands from plist
        let favoriteBrandsConfig: AnyObject? = configurationDict["FavoriteList"];
        
        
        // Read BrandList from plist
        let allBrandsConfig: AnyObject? = configurationDict["BrandList"]
        //var allBrandsDict :Dictionary<String,AnyObject!>
        
        if (allBrandsConfig != nil) {
            if let ocDictionary = allBrandsConfig as? NSDictionary {
                //allBrandsDict = Dictionary<String,AnyObject!>()
                for key : AnyObject in ocDictionary.allKeys{
                    // Key
                    let stringKey : String = key as String
                    // If Value exists
                    if let keyValue : AnyObject = ocDictionary[stringKey]{
                        var stringValue = keyValue as String
                        var brand = Brand(key: stringKey, name: stringValue)
                        var section: Character = stringValue.capitalizedString[0]
                        
                        if(_allBrandsDict[section] == nil) {
                            _allBrandsDict[section] = [brand]
                        }
                        else{
                            _allBrandsDict[section]?.append(brand)
                        }
                        
                    }
                }
            } else {
                //
            }
        }
        
        //_brandKeysSorted = Array(_allBrandsDict.keys).sorted(<)
        _sectionSorted = _allBrandsDict.keys.array.sorted(<)
        //println(_sectionSorted)
        
        //        for (key: Int, name: String) in configurationDict.valueForKey(key: "BrandList") {
        //            _allBrands.append(new Brand(key, name)
        //        }
        
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if tableView == self.searchDisplayController!.searchResultsTableView {
            return self._filteredSectionSorted.count
        } else{
            return self._sectionSorted.count
        }
    }
    
    override func sectionIndexTitlesForTableView(tableView: UITableView) -> [AnyObject] {
        var indexTitles = [String]()
        // Determine if there is a filter=
        var sections = [Character]()
        if tableView == self.searchDisplayController!.searchResultsTableView {
            sections = self._filteredSectionSorted
        } else{
            sections = self._sectionSorted
        }
        
        for char in sections{
            indexTitles.append(String(char))
        }
        return indexTitles
    }
    
    override func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {

        var selectedSection: Character = title[0]
        // Determine if there is a filter=
        var sections = [Character]()
        if tableView == self.searchDisplayController!.searchResultsTableView {
            sections = self._filteredSectionSorted
        } else{
            sections = self._sectionSorted
        }
        
        var selectionIndex = find(sections, selectedSection)!
        return selectionIndex
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection sectionIndex: Int) -> Int {
        // Determine if there is a filter=
        var sections = [Character]()
        var brands:Dictionary<Character, [Brand]> = Dictionary<Character, [Brand]>()
        if tableView == self.searchDisplayController!.searchResultsTableView {
            sections = self._filteredSectionSorted
            brands = self._filteredBrands
        } else{
            sections = self._sectionSorted
            brands = self._allBrandsDict
        }
        
        
        var currentSection:Character = sections[sectionIndex]
        var brandInSameSection: [Brand] = brands[currentSection]!
        return brandInSameSection.count
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection sectionIndex: Int) -> UIView? {
        let headerCell = self.tableView.dequeueReusableCellWithIdentifier("HeaderCell") as CustomHeaderCell
        headerCell.backgroundColor = UIColor.grayColor()
        
        // Determine if there is a filter
        var sections = [Character]()
        if tableView == self.searchDisplayController!.searchResultsTableView {
            sections = self._filteredSectionSorted
        } else{
            sections = self._sectionSorted
        }
        
        var section = sections[sectionIndex]
        headerCell.textLabel?.text = String(section)
        
        return headerCell
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        
        // Determine if there is a filter
        var sections = [Character]()
        var brands:Dictionary<Character, [Brand]> = Dictionary<Character, [Brand]>()
        if tableView == self.searchDisplayController!.searchResultsTableView {
            sections = self._filteredSectionSorted
            brands = self._filteredBrands
        } else{
            sections = self._sectionSorted
            brands = self._allBrandsDict
        }
        
        var currentSectionIndex: Int = indexPath.section
        var section: Character = sections[currentSectionIndex]
        var brandsArray: [Brand] = brands[section]!
        var brand: Brand = brandsArray[indexPath.row] //_allBrandsDict[brandKey]!.Name
        cell.textLabel?.text = brand.Name
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        return cell
    }
    


    /**************Search related*****************/
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchString searchString: String!) -> Bool {
        self.filterContentForSearchText(_allBrandsDict, searchText: searchString)
        return true
    }
    
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchScope searchOption: Int) -> Bool {
        self.filterContentForSearchText(_allBrandsDict, searchText: self.searchDisplayController!.searchBar.text)
        return true
    }
    
    // Apply filter to all brands and save filtered data
    func filterContentForSearchText(brands: Dictionary<Character, [Brand]>, searchText: String){
        
        for char in self._sectionSorted{
            self._filteredBrands[char] = brands[char]?.filter({(brand: Brand) -> Bool in
                let stringMatch = brand.Name.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
                return (stringMatch != nil)
            })
        }
        self._filteredSectionSorted = _filteredBrands.keys.array.sorted(<)
    }
    /**************Click table row to brand page*****************/
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("BrandPage", sender: tableView)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "BrandPage" {
            let brandPageViewController = segue.destinationViewController as ViewController_BrandPage
            if sender as UITableView == self.searchDisplayController!.searchResultsTableView {
                let indexPath = self.searchDisplayController!.searchResultsTableView.indexPathForSelectedRow()!
                //let cell = self.searchDisplayController!.searchResultsTableView.cellForRowAtIndexPath(indexPath)
                //let destinationTitle = cell?.textLabel?.text!
                let selectedSection: Character = self._filteredSectionSorted[indexPath.section]
                let sameSectionBrands : [Brand] = self._filteredBrands[selectedSection]!
                let selectedBrand: Brand = sameSectionBrands[indexPath.row]
                brandPageViewController.title = selectedBrand.Name
                brandPageViewController.selectedBrandId = selectedBrand.Key
            } else {
                let indexPath = self.tableView.indexPathForSelectedRow()!
                //let cell = self.tableView.cellForRowAtIndexPath(indexPath)
                //let destinationTitle = cell?.textLabel?.text!
                let selectedSection: Character = self._sectionSorted[indexPath.section]
                let sameSectionBrands : [Brand] = self._allBrandsDict[selectedSection]!
                let selectedBrand: Brand = sameSectionBrands[indexPath.row]
                brandPageViewController.title = selectedBrand.Name
                brandPageViewController.selectedBrandId = selectedBrand.Key
            }
        }
    }
    
}