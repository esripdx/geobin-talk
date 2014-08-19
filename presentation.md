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

# GeoJSON
### Any valid GeoJSON object

```json
{
  "type": "Point",
  "coordinates": [125.6, 10.1]
}
```

```json
{
  "type": "Polygon",
  "coordinates": [
    [ [100.0, 0.0], [101.0, 0.0], [101.0, 1.0], [100.0, 1.0], [100.0, 0.0] ],
    [ [100.2, 0.2], [100.8, 0.2], [100.8, 0.8], [100.2, 0.8], [100.2, 0.2] ]
  ]
}
```

---

# Arbitrary JSON
### Look for an object with geo information in it

```javascript
{
  "foo": "bar",
  "x": -122.6366, // 'long', 'lng', 'longitude'
  "y": 45.5264,   // 'lat', 'latitude'
  "radius": 100   // 'accuracy', 'acc', 'distance', 'dist', 'rad'
}

// or...

{
  "coords": [-122.6366, 45.5264] // 'coordinates', 'geo', 'loc', 'location'
}
```

---

     XXX  XXX  XXX  XXX  XX                                              +-----------------------+
    XXXXXXXXXXXXXXXXXXXXXXXX                +------------+               |                       |
    XXX                  XXX                |            |     YES       |  Add to foundGeo set  |
     X   HTTP POST JSON   X ---------+----> |  GeoJSON?  +-------------> |           &           |
    XXX                  XXX         |      |            |               |  Save path to object  |
    XXXXXXXXXXXXXXXXXXXXXXXX         |      +--------+---+               |                       |
     XXX  XXX  XXX  XXX  XX          |               |                   +-----------------------+
                                     |               | NO                            ^             
                                     |               |                               |            
                                     |               v                               |            
                                     |    +----------------------------------+       |            
                                     |    |                                  |       |            
                                     |    |  Does this object contain the    |  YES  |            
                                     |    |  information required to create  +-------+            
                                     |    |  a GeoJSON object?               |                    
                                     |    |                                  |                    
                                     |    +-------------------------+--------+                    
                                     |                              |                             
                                     |                              | NO                          
                                     |                              |                             
                                     +------------------------------+                             
                                       Iterate over keys sending                                  
                                       each value through the                                     
                                       process                                                    
![original](gophercloud.png)                                                                                                 

---

# [fit] TODO:

Describe how we started with channels and ended up with a standard mutex lock.

---

# Websockets (yay!)
[github.com/gorilla/websocket](http://www.gorillatoolkit.org/pkg/websocket)

---

# [fit] socket struct
```golang
s := &s{
    name:      name,
    ws:        ws,
    send:      make(chan []byte, 256),
    shutdown:  make(chan bool),
    closed:    false,
    closeLock: &sync.Mutex{},
    onRead:    or,
    onClose:   oc,
}

go s.writePump()
go s.readPump()
return s
```

---

# [fit] trimming down the interface
```golang
// S exposes some methods for interacting with a websocket
type Socket interface {
    // Submits a payload to the web socket as a text message.
    Write([]byte)
    // return the provided name
    GetName() string
    // Close the socket.
    Close()
}
```

---

# [fit] keeping track of sockets
```golang
type SocketMap interface {
    Add(binName, socketUUID string, s Socket)
    Get(binName, socketUUID string) (Socket, bool)
    Delete(binName, socketUUID string) error
    Send(binName string, payload []byte) error
}
```

---

# [fit] concurrency with redis!
```golang
// redis client
client := redis.NewTCPClient(&redis.Options{
    Addr:     conf.RedisHost,
    Password: conf.RedisPass,
    DB:       conf.RedisDB,
})

// redis pubsub connection
ps := client.PubSub()

// prepare a socketmap
sm := NewSocketMap(ps)

// loop for receiving messages from Redis pubsub, and forwarding them on to relevant ws connection
go redisPump(ps, sm)

defer func() {
    ps.Close()
    client.Close()
}()
```

---

# [fit] redis mocking

* Recall Francesc's best practices!

[12 Go best practices](http://talks.golang.org/2013/bestpractices.slide#24)

---

# [fit] interfaces making testing easier!
```golang
// mock our use of redis pubsub for modularity/testing purposes
type PubSubber interface {
    Subscribe(channels ...string) error
    Unsubscribe(channels ...string) error
}

// mock our use of redis client for modularity/testing purposes
type RedisClient interface {
    ZAdd(key string, members ...redis.Z) (int64, error)
    ZCount(key, min, max string) (int64, error)
    Expire(key string, dur time.Duration) (bool, error)
    Publish(channel, message string) (int64, error)
    ZRevRange(key, start, stop string) ([]string, error)
    Exists(key string) (bool, error)
    Get(key string) (string, error)
    Incr(key string) (int64, error)
}
```

---

# [fit] tests without dependencies
```golang
type MockRedis struct {
    sync.Mutex
    bins  map[string][]string
    incrs map[string]string
}

type MockPubSub struct{}

func NewMockRedis() *MockRedis {
    return &MockRedis{
        bins:  make(map[string][]string),
        incrs: make(map[string]string),
    }
}
```

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

