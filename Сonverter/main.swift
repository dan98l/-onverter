//
//  main.swift
//  Сonverter
//
//  Created by Daniil G on 03.12.2020.
//  Copyright © 2020 Daniil G. All rights reserved.
//

import Foundation

enum InfoCollageData {
    static let title = "Giant Collage"
    static let pathFile = "/Users/daniil/Downloads/Giant.csv"
}

struct Frames: Encodable {
    var Title: String?
    var FrameTemplates: [CollageData]
}

struct CollageData: Encodable {
    var id: String?
    var `Type`: String?
    var isVip: Bool?
    var allowedAspects: String?
    var Frames: [String?]
}

var csvString: String?

do {
    csvString = try String(contentsOfFile: InfoCollageData.pathFile)
} catch {
    print(error)
}

if let csvString = csvString {
    var rows = csvString.components(separatedBy: "\n")
    rows.remove(at: 0)

    var frames = [[String]]()
    var frame = [String]()

    var id = [String]()
    var type = [String]()
    var isVip = [String]()

    var allowedAspects = [String?]()

    for row in rows {
        var separatedRows: [String] = row.components(separatedBy: ["\""])
        separatedRows = separatedRows.filter(){$0 != "\r"}
        separatedRows = separatedRows.filter(){$0 != ""}
        separatedRows = separatedRows.filter(){$0 != ","}

        if let first = separatedRows.first {
            let сomponents: [String]  = first.components(separatedBy: [","])

            if сomponents.first != "" {
                id.append(сomponents.first!)
                type.append(сomponents[1])
                isVip.append(сomponents[2])

                frames.append(frame)
                frame = []
                frame.append(separatedRows.last!.filter(){$0 != " "})


                if separatedRows.count == 3 {
                     allowedAspects.append(separatedRows[2])
                } else {
                    allowedAspects.append(nil)
                }

            } else {
                frame.append(separatedRows.last!.filter(){$0 != " "})
            }
        }

    }
    frames.remove(at: 0)
    frames.append(frame)


    var frameTemplates = [CollageData]()

    for i in 0...id.count-1 {
        var isVipTemp: Bool?

        if isVip[i] == "1" {
            isVipTemp = true
        } else if isVip[i] == "0" {
            isVipTemp = false
        } else {
             isVipTemp = nil
        }

        let data = CollageData(id: id[i], Type: type[i], isVip: isVipTemp, allowedAspects: allowedAspects[i], Frames: frames[i])
        frameTemplates.append(data)
    }

    let collageData = [Frames(Title: InfoCollageData.title, FrameTemplates: frameTemplates)]

    let encoder = PropertyListEncoder()
    encoder.outputFormat = .xml

    let path = FileManager.default.urls(for: .documentDirectory, in: .allDomainsMask)[0].appendingPathComponent("Frames.plist")

    do {
        let data = try encoder.encode(collageData)
        try data.write(to: path)
    } catch {
        print(error)
    }
}
