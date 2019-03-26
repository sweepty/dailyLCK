//
//  Converter.swift
//  LCKforYou
//
//  Created by Seungyeon Lee on 19/03/2019.
//  Copyright © 2019 Seungyeon Lee. All rights reserved.
//

import Foundation

extension String {
    func convertToInitialism() -> String {
        switch self {
        case "Afreeca":
            return "AF"
        case "DAMWON":
            return "DWG"
        case "Gen.G":
            return "GEN"
        case "Griffin":
            return "GRF"
        case "Hanwha":
            return "HLE"
        case "Jin Air":
            return "JAG"
        case "KT":
            return "KT"
        case "KING-ZONE":
            return "KZ"
        case "SANDBOX":
            return "SB"
        case "SKT":
            return "SKT"
        default:
            return ""
        }
    }
}

func changeShortName(_ name: String) -> String {
    switch name {
    case "Afreeca Freecs":
        return "Afreeca"
    case "DAMWON Gaming":
        return "DAMWON"
    case "Gen.G Esports":
        return "GEN.G"
    case "Griffin":
        return "Griffin"
    case "Hanwha Life Esports":
        return "Hanwha"
    case "JIN AIR Greenwings":
        return "JIN AIR"
    case "KT Rolster":
        return "KT"
    case "King-Zone Dragon X":
        return "King-Zone"
    case "SANDBOX Gaming":
        return "SANDBOX"
    case "SKT T1":
        return "SKT"
    default:
        return ""
    }
}

func changeFullName(name: String) -> String {
    switch name {
    case "AF":
        return "Afreeca Freecs"
    case "DWG":
        return "DAMWON Gaming"
    case "GEN":
        return "GEN.G"
    case "GRF":
        return "Griffin"
    case "HLE":
        return "Hanhwa Life Esports"
    case "JAG":
        return "JIN AIR Greenwings"
    case "KT":
        return "KT Rolster"
    case "KZ":
        return "KING-ZONE Dragon X"
    case "SB":
        return "SANDBOX Gaming"
    case "SKT":
        return "SKT T1"
    default:
        return ""
    }
}
