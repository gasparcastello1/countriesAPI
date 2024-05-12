//
//  CountryAPIModel.swift
//  ContriesAPI
//
//  Created by Gaspar Castello on 04/05/2024.
//

import Foundation

struct Name: Decodable {
    let common: String
    let official: String
    let nativeName: [String: [String: String]]?
}

struct Flags: Decodable {
    let png: String
    let svg: String?
    let alt: String?
}

struct Currency: Decodable {
    let name: String?
    let symbol: String?
}

struct Car: Decodable {
    let signs: [String]?
    let side: String?
}

struct CoatOfArms: Decodable {
    let png: String?
    let svg: String?
}

//struct Country: Identifiable, Decodable {
//    let id = UUID()
//    let flagURL: String
//    let commonName: String
//    let officialName: String
//    let capital: [String]
//    
//    enum CodingKeys: String, CodingKey {
//        case flags
//        case name
//        case capital
//    }
//    
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        let flagContainer = try container.decodeIfPresent(Flags.self, forKey: .flags) ?? Flags(png: "", svg: "", alt: "")
//        let nameContainer = try container.decode(Name.self, forKey: .name)
//        
//        flagURL = flagContainer.png
//        commonName = nameContainer.common
//        officialName = nameContainer.official
//        capital = try container.decodeIfPresent([String].self, forKey: .capital) ?? []
//    }
//}

struct CountryDetail: Identifiable, Equatable, Decodable, Hashable {
    static func == (lhs: CountryDetail, rhs: CountryDetail) -> Bool {
        lhs.officialName == rhs.officialName
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    let id = UUID()
    let flagURL: String
    let commonName: String
    let officialName: String
    let capital: String
    let region: String?
    let subregion: String?
    let languages: [String: String]?
    let currencies: [String: Currency]?
    let population: Int?
    let carDriverSide: String?
    let coatOfArmsURL: String?
    
    enum CodingKeys: String, CodingKey {
        case flags
        case name
        case capital
        case region
        case subregion
        case languages
        case currencies
        case population
        case car
        case coatOfArms
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let flagContainer = try container.decodeIfPresent(Flags.self, forKey: .flags) ?? Flags(png: "", svg: "", alt: "")
        let nameContainer = try container.decode(Name.self, forKey: .name)
        let carContainer = try container.decode(Car.self, forKey: .car)
        let coatOfArms = try container.decode(CoatOfArms.self, forKey: .coatOfArms)
        
        flagURL = flagContainer.png
        commonName = nameContainer.common
        officialName = nameContainer.official
        capital = try container.decodeIfPresent([String].self, forKey: .capital)?.first ?? ""
        region = try container.decodeIfPresent(String.self, forKey: .region) ?? ""
        subregion = try container.decodeIfPresent(String.self, forKey: .subregion) ?? ""
        languages = try container.decodeIfPresent([String: String].self, forKey: .languages) ?? [:]
        currencies = try container.decodeIfPresent([String: Currency].self, forKey: .currencies) ?? [:]
        population = try container.decodeIfPresent(Int.self, forKey: .population) ?? 0
        carDriverSide = carContainer.side
        coatOfArmsURL = coatOfArms.png
    }
    
    init(flagURL: String,
         commonName: String,
         officialName: String,
         capital: String,
         region: String? = nil,
         subregion: String? = nil,
         languages: [String: String]? = nil,
         currencies: [String: Currency]? = nil,
         population: Int? = nil,
         carDriverSide: String? = nil,
         coatOfArmsURL: String? = nil) {
        self.flagURL = flagURL
        self.commonName = commonName
        self.officialName = officialName
        self.capital = capital
        self.region = region
        self.subregion = subregion
        self.languages = languages
        self.currencies = currencies
        self.population = population
        self.carDriverSide = carDriverSide
        self.coatOfArmsURL = coatOfArmsURL
    }
}

#if DEBUG
extension CountryDetail {
    static var mocked: Self {
        CountryDetail(
            flagURL: "https://example.com/flag.png",
            commonName: "Country",
            officialName: "Official Name",
            capital: "Capital City",
            region: "Region",
            subregion: "Subregion",
            languages: ["en": "English", "fr": "French"],
            currencies: ["USD": Currency(name: "US Dollar", symbol: "$")],
            population: 1000000,
            carDriverSide: "Left",
            coatOfArmsURL: "https://example.com/coat_of_arms.png"
        )
    }
}
#endif
