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
    let side: Side?
}

enum Side: String, Decodable {
    case left
    case right
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
    let carDriverSide: Side?
    let coatOfArmsURL: String?
    let timezones: [String]?
    let area: Double?
    
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
        case timezones
        case area
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
        timezones = try container.decodeIfPresent([String].self, forKey: .timezones)
        area = try container.decodeIfPresent(Double.self, forKey: .area)
    }
    
    init(
        flagURL: String,
        commonName: String,
        officialName: String,
        capital: String,
        region: String? = nil,
        subregion: String? = nil,
        languages: [String: String]? = nil,
        currencies: [String: Currency]? = nil,
        population: Int? = nil,
        carDriverSide: Side? = nil,
        coatOfArmsURL: String? = nil,
        timezones: [String]? = nil,
        area: Double? = nil
    ) {
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
        self.timezones = timezones
        self.area = area
    }
}

#if DEBUG
extension CountryDetail {
    static var mocked: Self {
        CountryDetail(
            flagURL: "https://flagcdn.com/w320/lv.png",
            commonName: "Latvia",
            officialName: "Official Name of Latvia",
            capital: "Riga",
            region: "Europe",
            subregion: "Nordics",
            languages: ["en": "English", "fr": "French"],
            currencies: ["USD": Currency(name: "US Dollar", symbol: "$")],
            population: 2456345,
            carDriverSide: .left,
            coatOfArmsURL: "https://mainfacts.com/media/images/coats_of_arms/lv.png",
            timezones: ["UTC: +2"]
        )
    }
}
#endif
