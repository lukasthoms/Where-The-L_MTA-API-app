# Where-The-L_MTA-API-app
A basic app to find your nearest L train station and return it's real-time schedule.

Where the L's basic dataflow looks like this:

The Parse server requests the entire real-time L train schedule every minute and stores it. >
Where The L app opens, querying Parse for the latest data and finding the current location. >
Where the L locates the closest station, uses MapKit to retrieve the walking time to it and parses the raw protocol buffer L train data to get the schedule for that station.

Thanks to these Cocoapods for making Where the L possible to implement in a weekend:

Parse-iOS-SDK

FlatUIKit

ProtocolBuffers

