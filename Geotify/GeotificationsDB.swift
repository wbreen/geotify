//
//  GeotificationsDB.swift
//  Geotify
//
//  Created by William Breen on 10/31/16.
//  Copyright © 2016 William Breen. All rights reserved.
//

import SQLite
import CoreLocation

class GeotificationsDB {
    //singleton pattern
    static let instance = GeotificationsDB()
    
    //the database
    private var db: Connection? = nil
    
    //the table and expressions
    private let geotifications = Table("geotifications")
    private let id = Expression<Int64>("id")
    //id makes sure each row in the table is unique
    
    private let latitude = Expression<Double>("latitude")
    private let longitude = Expression<Double>("longitude")
    private let radius = Expression<Double>("radius")
    private let note = Expression<String>("note")
    private let onEntry = Expression<Bool>("onEntry")
    
    //figure out if there there is an existing database or if a new one is needed
        //so need to determine the path to the file
    private init() {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        
        do{
            db = try Connection("\(path)/gotifications.sqlite")
            createTable()
        } catch {
            print("GEOTIFY: Unable to open the database")
        }
    }
    
    //Create the table if this is the first time we're opening this database
    func createTable() {
        do {
            try db!.run(geotifications.create { table in
                table.column(id, primaryKey: true)
                table.column(latitude)
                table.column(longitude)
                table.column(radius)
                table.column(note)
                table.column(onEntry)
            })
        } catch {
            print("GEOTIFY: Unable to create table")
        }
    }
    
    //to add something to the table
    func add(geotification: Geotification) -> Int64? {
        do {
            let insert = geotifications.insert(
                latitude <- geotification.coordinate.latitude,
                longitude <- geotification.coordinate.longitude,
                radius <- geotification.radius,
                note <- geotification.note,
                onEntry <- geotification.onEntry)
                        // the "<-" is shorthand for closures, return values from inside Geotification and assigning them to the Expressions created above
            let id = try db!.run(insert)
                        //attempting to insert row into table called "geotifications"
            return id
                        //going to need id in future, so return it
        } catch {
            print("GEOTIFY: Insert failed")
            return nil
        }
    }
    
    //to delete something from the table
    func deleteGeotification(aId: Int64) {
        do {
            let geotification = geotifications.filter(id == aId)
            let _ = try db!.run(geotification.delete())
        } catch {
            print("GEOTIFY: Delete failed")
        }
    }
    
    //get all geotifications to populate the map
    func getGeotifications() -> [Geotification] {
        var geotifications: [Geotification] = []
        
        do {
            for geotification in try db!.prepare(self.geotifications) {
                geotifications.append(
                    Geotification(id: geotification[id],
                        coordinate: CLLocationCoordinate2D(
                            latitude: geotification[latitude],
                            longitude: geotification[longitude]),
                            radius: geotification[radius],
                            note: geotification[note],
                            onEntry: geotification[onEntry]))
            }
        } catch {
            print("GEOTIFY: Unable to read the table")
        }
        return geotifications
    }
}










