# [fit] geobin.io
---

# Esri Portland R&D Center
__Courtland Fowler__
_@FowlerCourt_

__Josh Yaganeh__
_@hsoj_

__Ryan Arana__
_@aranasaurus_

__Nate Goldman__
_@ungoldman_

---

# [fit] It's like RequestBin
# [fit] + Geo

---

# [fit] Mini Demo

---

# [fit] Why did we make it?

- "RequestBin is cool, but..."
- Debugging/Visualizing the Geotrigger Service as we built other tools around it

![inline autoplay loop](http://media.esri.com/arcstream/2014/02/3112-ersi-geotrigger-service_960.mp4)

---

# [fit] Demo!

### Geotrigger Editor __>__ Faker __>__ Geobin

---

# [fit] Components

- Parsing Data
- Websockets
- Rate-limiting Middleware
- Mocking Redis for tests
- Build/deployment Process

---

# [fit] Parsing the Data

---

HTTP POST:

```json
[{
    "title": "I've got geojson",
    "data": { "message": "Standards rule!" },
    "geo": {
        "type": "Point",
        "coordinates": [-122.6763, 45.5218]
    }
}, {
    "title": "I've got my own geo data schema",
    "data": { "message": "ohai!" },
    "geo": { 
        "lat": 45.5218,
        "lng": -122.6763,
        "rad": 100
    }
}]
```

---

# Arbitrary JSON
### How we determine if an object has Geo Information in it

```javascript
{
  "foo": "bar",
  "x": -122.6366, // 'long', 'lng', 'longitude'
  "y": 45.5264,   // 'lat', 'latitude'
  "radius": 100   // 'accuracy', 'acc', 'distance', 'dist', 'rad'
}

// or...

{
  "geo": [-122.6366, 45.5264] // 'coord[s]', 'coordinate[s]', 'loc', 'location'
}
```

---

```
 XXX  XXX  XXX  XXX  XX                 +------------+               +-----------------------+
XXXXXXXXXXXXXXXXXXXXXXXX                |            |     YES       |                       |
XXX                  XXX                |  Is it     +-------------> |  Add to foundGeo set  |
 X   HTTP POST JSON   X +-------------> |  GeoJSON?  |               |           &           |
XXX                  XXX                |            | <----+        |  Save path to object  |
XXXXXXXXXXXXXXXXXXXXXXXX                +------+-----+      |        |                       |
 XXX  XXX  XXX  XXX  XX                        |            |        +-----------------------+
                               +---------------+            |
                               |       NO                   +------------------------+   ^
                               v                                                     |   |
                                                       +-----------------------+     |   |
                 +--------------------------+          |                       |     |   |
                 |                          |  +-------+ Save valid values for |     |   |
                 | Iterate through its keys +--+       | our flagged geo keys  |     |   |
                 |                          |  |       |                       |     |   |
                 +-------------+------------+  |       +-----------------------+     |   |
                               |               |                                     |   |
                               |               |   +------------------------------+  |   |
                               v               +---+ Value of key is object/array +--+   |
                                                   +------------------------------+      |
             +---------------------------------+                                         |
             |                                 |                                         |
             | Did we get at least an x and y? |                                         |
             |                                 |                                         |
             +---------------------------------+                                         |
                               |                                                         |
                               +---------------------------------------------------------+
                                  YES
```
![fit original](gophercloud.png)

---

# Channels

- WaitGroup and channel per request
- Fire up a goroutine that just waits for geo data to come in from the channel and adds it to an in-memory slice when it comes in.
- Parse method fires up a goroutine each time it's called and calls itself recursively to find any geo data in the object, sending it through the channel when it does.

---

# What was wrong with that?

- Race conditions!
- Goroutines sticking around forever because of unclosed channels.

---

# Mutex

- Each request calls Parse and then waits on the WaitGroup
- Parse method adds 1 to the WaitGroup then fires up a goroutine and parses the object it was given, recursively calling itself until it gets to all of the leaf nodes.
- This time, when it finds a geo object it calls a method which locks the mutex, appends to the found geo slice, unlocks and moves on.

---

# Websockets

---

# Redis mocking

---

# Rate limiting middleware

---

# Build/deployment process

---

# Questions?

![](http://img.thesun.co.uk/multimedia/archive/01690/download__7__1690117a.gif)

---

# Thanks!

- Ryan Arana
_@aranasaurus_
github.com/aranasaurus

- Josh Yaganeh
_@hsoj_
github.com/jyaganeh

- Courtland Fowler
_@FowlerCourt_
github.com/courtf

__http://geobin.io/__

