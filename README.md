# Swift-Change-Streams

This is a super-simple document browser for MongDB. It runs as a desktop client on MongoDB.

The app requests a [MongoDB connection string](https://www.mongodb.com/docs/manual/reference/connection-string/) from the user and then lets them browse the databases, collections, and documents in that cluster. 

If a document is added, changed, or deleted in the collection being viewed then then the change will be highlighted in the UI. This is a demonstration of how simple it is to use [MongoDB Change Streams](https://www.mongodb.com/docs/manual/changeStreams/).

## Running the App

1. Open `MongoDBSwift.xcodeproj` in Xcode
1. Change the `Team` value in the `Signings & Capabilities` tab in the target settings
1. Wait for the MongoDB Swift driver to download in the background
1. Build and run the app using `⌘R`
1. If using [MongoDB Atlas](https://www.mongodb.com/atlas/database), create a database user and add your IP address to the `Network Access` list
1. Copy the connection string for your MongoDB cluster, paste it into the app (remembering to include the username and password for your database user)

## Easter Egg

The app is also designed to demonstrate how the [MongoDB Swift driver](https://github.com/mongodb/mongo-swift-driver) can be used with MongoDB's single collection pattern. With this pattern, documents with different shapes are stored in the same collection - each with a field named "docType" which indicates what shape the structure should match. The pattern is also referred to as "polymorphic collections".

To try that polymorphic behavior out, add these documents to a collection called `Collection` in a database named `Single`:

```javascript
{ _id: 'basket1', docType: 'basket', customer: 'cust101' }
{ _id: 'basket1-item1', docType: 'item', name: 'Fish', quantity: 5 }
{ _id: 'basket1-item2', docType: 'item', name: 'Chips', quantity: 3 }
```
