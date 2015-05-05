//
//  Track.swift
//  MyFirstSwiftApp
//
//  Created by Kohei Arai on 5/5/15.
//  Copyright (c) 2015 Kohei Arai. All rights reserved.
//

import Foundation

struct Track {
    let title: String
    let price: String
    let previewUrl: String
    
    init(title: String, price: String, previewUrl: String) {
        self.title = title
        self.price = price
        self.previewUrl = previewUrl
    }
    
    static func tracksWithJSON(results: NSArray) -> [Track] {
        var tracks = [Track]()
        
        for trackInfo in results {
            if let kind = trackInfo["kind"] as? String {
                if kind == "song" {
                    var trackPrice = trackInfo["trackPrice"] as? String
                    var trackTitle = trackInfo["trackName"] as? String
                    var trackPreviewUrl = trackInfo["previewUrl"] as? String
                    
                    if trackTitle == nil {
                        trackTitle = "Unknown"
                    }
                    if trackPrice == nil {
                        println("No trackPrice in \(trackInfo)")
                        trackPrice = "?"
                    }
                    if trackPreviewUrl == nil {
                        trackPreviewUrl = ""
                    }
                    
                    var track = Track(
                        title: trackTitle!,
                        price: trackPrice!,
                        previewUrl: trackPreviewUrl!
                    )
                    tracks.append(track)
                }
            }
        }
        return tracks
    }
}