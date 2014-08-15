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

---

# [fit] Parsing the Data

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
                                     |                              |                             
                                     |                              | NO                          
                                     |                              |                             
                                     |                              |                             
                                     +------------------------------+                             
                                                                                                  
                                       Iterate over keys sending                                  
                                       each value through the                                     
                                       process                                                    

---

# [fit] TODO:

Describe how we started with channels and ended up with a standard mutex lock.

---

# Websockets

---

# Redis mocking

---

# Rate limiting middleware

---

# Build/deployment process
