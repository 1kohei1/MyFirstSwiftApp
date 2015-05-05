//
//  Album.swift
//  MyFirstSwiftApp
//
//  Created by Kohei Arai on 5/5/15.
//  Copyright (c) 2015 Kohei Arai. All rights reserved.
//

import Foundation

struct Album {
    let title: String
    let price: String
    let thumanailImageURL: String
    let largeImageURL: String
    let itemURL: String
    let artistURL: String
    
    init(name: String, price: String, thumbnailImageURL: String, largeImageURL: String, itemURL: String, artistURL: String) {
        self.title = name
        self.price = price
        self.thumanailImageURL = thumbnailImageURL
        self.largeImageURL = largeImageURL
        self.itemURL = itemURL
        self.artistURL = artistURL
    }
    
    static func albumWithJSON(results: NSArray) -> [Album] {
        var albums = [Album]()
        
        if results.count > 0 {
            for result in results {
                var name = result["trackName"] as? String
                if name == nil {
                    name = result["collectionName"] as? String
                }
                
                var price = result["formattedPrice"] as? String
                if price == nil {
                    price = result["collectionPrice"] as? String
                    if price == nil {
                        var priceFloat: Float? = result["collectionPrice"] as? Float
                        var nf: NSNumberFormatter = NSNumberFormatter()
                        nf.maximumFractionDigits = 2
                        if priceFloat != nil {
                            price = "$\(nf.stringFromNumber(priceFloat!)!)"
                        }
                    }
                }
                
                var thumbnailURL = result["artworkUrl60"] as? String ?? ""
                var imageURL = result["artworkUrl100"] as? String ?? ""
                var artistURL = result["artistViewUrl"] as? String ?? ""
                
                var itemURL = result["collectionViewUrl"] as? String
                if itemURL == nil {
                    itemURL = result["trackViewUrl"] as? String
                }
                
                var newAlbum = Album(
                    name: name!,
                    price: price!,
                    thumbnailImageURL: thumbnailURL,
                    largeImageURL: imageURL,
                    itemURL: itemURL!,
                    artistURL: artistURL
                )
                albums.append(newAlbum)
            }
        }
        
        return albums
    }
}