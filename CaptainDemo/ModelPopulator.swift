//
//  ModelPopulator.swift
//  CaptainDemo
//
//  Created by Vincent Esche on 6/1/18.
//  Copyright © 2018 Vincent Esche. All rights reserved.
//

import Foundation
import CoreData

class ModelPopulator {
    var continentIdentifier: Int64 = 0
    var countryIdentifier: Int64 = 0
    var oceanIdentifier: Int64 = 0
    var seaIdentifier: Int64 = 0

    func populate(managedObjectContext context: NSManagedObjectContext) {
        self.populateContinents(managedObjectContext: context)
        self.populateOceans(managedObjectContext: context)

        for ocean in Ocean.all(context: context) {
            let continents = self.continentsBy(ocean: ocean)
            ocean.addToContinents(Set(continents) as NSSet)

            let countries = self.countriesBy(ocean: ocean)
            ocean.addToCountries(Set(countries) as NSSet)
        }
    }

    func populateContinents(managedObjectContext context: NSManagedObjectContext) {
        let countriesByContinent = [
            "Africa": [
                "Algeria", "Angola", "Benin", "Botswana", "Burkina", "Burundi", "Cameroon", "Cape Verde", "Central African Republic", "Chad", "Comoros", "Congo", "Djibouti", "Egypt", "Equatorial Guinea", "Eritrea", "Ethiopia", "Gabon", "Gambia", "Ghana", "Guinea", "Guinea-Bissau", "Ivory Coast", "Kenya", "Lesotho", "Liberia", "Libya", "Madagascar", "Malawi", "Mali", "Mauritania", "Mauritius", "Morocco", "Mozambique", "Namibia", "Niger", "Nigeria", "Rwanda", "Sao Tome and Principe", "Senegal", "Seychelles", "Sierra Leone", "Somalia", "South Africa", "South Sudan", "Sudan", "Swaziland", "Tanzania", "Togo", "Tunisia", "Uganda", "Zambia", "Zimbabwe",
            ],
            "Antarctica": [
                // none.
            ],
            "Asia": [
                "Afghanistan", "Bahrain", "Bangladesh", "Bhutan", "Brunei", "Myanmar", "Cambodia", "China", "East Timor", "India", "Indonesia", "Iran", "Iraq", "Israel", "Japan", "Jordan", "Kazakhstan", "North Korea", "South Korea", "Kuwait", "Kyrgyzstan", "Laos", "Lebanon", "Malaysia", "Maldives", "Mongolia", "Nepal", "Oman", "Pakistan", "Philippines", "Qatar", "Russia", "Saudi Arabia", "Singapore", "Sri Lanka", "Syria", "Taiwan", "Tajikistan", "Thailand", "Turkey", "Turkmenistan", "United Arab Emirates", "Uzbekistan", "Vietnam", "Yemen",
            ],
            "Oceania": [
                "Australia", "Fiji", "Kiribati", "Marshall Islands", "Micronesia", "Nauru", "New Zealand", "Palau", "Papua New Guinea", "Samoa", "Solomon Islands", "Tonga", "Tuvalu", "Vanuatu",
            ],
            "Europe": [
                "Albania", "Andorra", "Armenia", "Austria", "Azerbaijan", "Belarus", "Belgium", "Bosnia and Herzegovina", "Bulgaria", "Croatia", "Cyprus", "Czech Republic", "Denmark", "Estonia", "Finland", "France", "Georgia", "Germany", "Greece", "Hungary", "Iceland", "Ireland", "Italy", "Latvia", "Liechtenstein", "Lithuania", "Luxembourg", "Macedonia", "Malta", "Moldova", "Monaco", "Montenegro", "Netherlands", "Norway", "Poland", "Portugal", "Romania", "San Marino", "Serbia", "Slovakia", "Slovenia", "Spain", "Sweden", "Switzerland", "Ukraine", "United Kingdom", "Vatican City",
            ],
            "North America": [
                "Antigua and Barbuda", "Bahamas", "Barbados", "Belize", "Canada", "Costa Rica", "Cuba", "Dominica", "Dominican Republic", "El Salvador", "Grenada", "Guatemala", "Haiti", "Honduras", "Jamaica", "Mexico", "Nicaragua", "Panama", "Saint Kitts and Nevis", "Saint Lucia", "Saint Vincent and the Grenadines", "Trinidad and Tobago", "United States",
            ],
            "South America": [
                "Argentina", "Bolivia", "Brazil", "Chile", "Colombia", "Ecuador", "Guyana", "Paraguay", "Peru", "Suriname", "Uruguay", "Venezuela",
            ],
        ]
        for (continentName, countryNames) in countriesByContinent {
            self.continentIdentifier += 1
            let continent = Continent(entity: Continent.entity(), insertInto: context)
            continent.id = self.continentIdentifier
            continent.name = continentName
            for countryName in countryNames {
                self.countryIdentifier += 1
                let country = Country(entity: Country.entity(), insertInto: context)
                country.id = self.countryIdentifier
                country.name = countryName
                continent.addToCountries(country)
            }
        }
    }

    func populateOceans(managedObjectContext context: NSManagedObjectContext) {
        let seasByOcean = [
            "Pacific Ocean": [
                "Bering Sea", "Chilean Sea", "Sea of Chiloé", "Gulf of Alaska", "Gulf of California", "Mar de Grau", "Salish Sea", "Asia and Oceania", "Arafura Sea", "Bali Sea", "Banda Sea", "Bismarck Sea", "Bohai Sea", "Bohol Sea", "Camotes Sea", "Celebes Sea", "Ceram Sea", "Coral Sea", "East China Sea", "Flores Sea", "Gulf of Carpentaria", "Gulf of Thailand", "Halmahera Sea", "Java Sea", "Koro Sea", "Molucca Sea", "Philippine Sea", "Savu Sea", "Sea of Japan", "Sea of Okhotsk", "Seto Inland Sea", "Sibuyan Sea", "Solomon Sea", "South China Sea", "Sulu Sea", "Tasman Sea", "Visayan Sea", "Yellow Sea",
            ],
            "Atlantic Ocean": [
                "Davis Strait", "Labrador Sea", "Gulf of St. Lawrence", "Gulf of Maine", "Nantucket Sound", "Vineyard Sound", "Buzzards Bay", "Narragansett Bay", "Rhode Island Sound", "Block Island Sound", "Fishers Island Sound", "Long Island Sound", "New York Bay", "Jamaica Bay", "Raritan Bay", "Sandy Hook Bay", "Delaware Bay", "Chesapeake Bay", "Albemarle Sound", "Pamlico Sound", "Gulf of Mexico", "Caribbean Sea", "Argentine Sea",
            ],
            "Indian Ocean": [
                "Andaman Sea", "Arabian Sea", "Bay of Bengal", "Gulf of Aden", "Gulf of Oman", "Laccadive Sea", "Mozambique Channel", "Persian Gulf", "Red Sea", "Timor Sea",
            ],
            "Southern Ocean": [
                "Amundsen Sea", "Bass Strait", "Bellingshausen Sea", "Cooperation Sea", "Cosmonauts Sea", "Davis Sea", "D'Urville Sea", "Drake Passage", "Great Australian Bight", "Gulf St Vincent", "Investigator Strait", "King Haakon VII Sea", "Lazarev Sea", "Mawson Sea", "Riiser-Larsen Sea", "Ross Sea", "Scotia Sea", "Somov Sea", "Spencer Gulf", "Weddell Sea",
            ],
            "Arctic Ocean": [
                "Chukchi Sea", "East Siberian Sea", "Laptev Sea", "Kara Sea", "Barents Sea", "Queen Victoria Sea", "Wandel Sea", "Greenland Sea", "Lincoln Sea", "Baffin Bay", "The Northwest Passages", "Hudson Strait", "Hudson Bay", "Beaufort Sea",
            ],
        ]
        for (oceanName, seaNames) in seasByOcean {
            self.oceanIdentifier += 1
            let ocean = Ocean(entity: Ocean.entity(), insertInto: context)
            ocean.id = self.oceanIdentifier
            ocean.name = oceanName
            for seaName in seaNames {
                self.seaIdentifier += 1
                let sea = Sea(entity: Sea.entity(), insertInto: context)
                sea.id = self.seaIdentifier
                sea.name = seaName
                ocean.addToSeas(sea)
            }
        }
    }

    func continentsBy(ocean: Ocean) -> [Continent] {
        let continentsByOcean = [
            "Pacific Ocean": [
                "Asia", "North America", "South America", "Oceania",
            ],
            "Atlantic Ocean": [
                "Africa", "Asia", "Europe", "North America", "South America",
            ],
            "Indian Ocean": [
                "Africa", "Asia", "Oceania",
            ],
            "Southern Ocean": [

            ],
            "Arctic Ocean": [

            ],
        ]
        guard let oceanName = ocean.name else {
            fatalError("Expected `ocean.name`, found `nil`.")
        }
        guard let continentNames = continentsByOcean[oceanName] else {
            fatalError("No ocean found with name \"\(oceanName)\"")
        }
        guard let context = ocean.managedObjectContext else {
            fatalError("Expected `self.managedObjectContext`, found `nil`.")
        }
        let fetchRequest: NSFetchRequest<Continent> = Continent.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name IN %@", continentNames)
        let continents: [Continent]
        do {
            continents = try context.fetch(fetchRequest)
        } catch let error {
            fatalError("Error: \(error)")
        }
        return continents
    }

    func countriesBy(ocean: Ocean) -> [Country] {
        let countriesByOcean = [
            "Pacific Ocean": [
                "Australia", "Brunei", "Cambodia", "Canada", "Chile", "China", "Colombia", "Costa Rica", "Ecuador", "El Salvador", "Micronesia", "Fiji", "Guatemala", "Honduras", "Indonesia", "Japan", "Kiribati", "North Korea", "South Korea", "Malaysia", "Marshall Islands", "Mexico", "Nauru", "Nicaragua", "New Zealand", "Palau", "Panama", "Papua New Guinea", "Peru", "Philippines", "Russia", "Samoa", "Singapore", "Solomon Islands", "Taiwan", "Thailand", "East Timor", "Tonga", "Tuvalu", "United States", "Vanuatu", "Vietnam",
            ],
            "Atlantic Ocean": [
                "Albania", "Belgium", "Bosnia and Herzegovina", "Bulgaria", "Croatia", "Cyprus", "Denmark", "Estonia", "Finland", "France", "Georgia", "Germany", "Greece", "Iceland", "Ireland", "Italy", "Latvia", "Lithuania", "Malta", "Monaco", "Montenegro", "Netherlands", "Norway", "Poland", "Portugal", "Romania", "Slovenia", "Spain", "Sweden", "Turkey", "Ukraine", "United Kingdom", "Algeria", "Angola", "Benin", "Cameroon", "Cape Verde", "Congo", "Egypt", "Equatorial Guinea", "Gabon", "Gambia", "Ghana", "Guinea", "Guinea-Bissau", "Ivory Coast", "Liberia", "Libya", "Mauritania", "Morocco", "Namibia", "Nigeria", "Senegal", "Sierra Leone", "South Africa", "Togo", "Tunisia", "Cyprus", "Egypt", "Georgia", "Israel", "Lebanon", "Russia", "Syria", "Turkey", "Argentina", "Brazil", "Chile", "Colombia", "Guyana", "Suriname", "Uruguay", "Venezuela", "France", "Belize", "Canada", "Costa Rica", "Guatemala", "Honduras", "Mexico", "Nicaragua", "Panama", "United States", "Antigua and Barbuda", "Bahamas", "Barbados", "Cuba", "Dominica", "Dominican Republic", "Grenada", "Haiti", "Jamaica", "Saint Kitts and Nevis", "Saint Lucia", "Saint Vincent and the Grenadines", "Trinidad and Tobago",
            ],
            "Indian Ocean": [
                "South Africa", "Mozambique", "Madagascar", "France", "Mauritius", "Comoros", "Tanzania", "Seychelles", "Kenya", "Somalia", "Djibouti", "Eritrea", "Sudan", "Egypt", "Israel", "Jordan", "Saudi Arabia", "Yemen", "Oman", "United Arab Emirates", "Qatar", "Bahrain", "Kuwait", "Iraq", "Iran", "Pakistan", "India", "Maldives", "Sri Lanka", "Bangladesh", "Myanmar", "Thailand", "Malaysia", "Singapore", "Indonesia", "East Timor", "Indonesia", "Australia",
            ],
            "Southern Ocean": [

            ],
            "Arctic Ocean": [
                "Russia", "Norway", "Iceland", "Denmark", "Canada", "United States",
            ],
        ]
        guard let oceanName = ocean.name else {
            fatalError("Expected `ocean.name`, found `nil`.")
        }
        guard let countryNames = countriesByOcean[oceanName] else {
            fatalError("No ocean found with name \"\(oceanName)\"")
        }
        guard let context = ocean.managedObjectContext else {
            fatalError("Expected `self.managedObjectContext`, found `nil`.")
        }
        let fetchRequest: NSFetchRequest<Country> = Country.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name IN %@", countryNames)
        let countries: [Country]
        do {
            countries = try context.fetch(fetchRequest)
        } catch let error {
            fatalError("Error: \(error)")
        }

        return countries
    }
}
