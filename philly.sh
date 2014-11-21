# Arch Street Meeting House
curl -X POST -H "Content-Type: application/json" -d '{ "y": 39.9523017, "x": -75.1462273 }' geobin.io/$BINID

# Ladder 15 
curl -X POST -H "Content-Type: application/json" -d '{ "y": 39.9502599, "x": -75.1669521}' geobin.io/$BINID

# Bars
curl -X POST -H "Content-Type: application/json" -d '[
    { "name": "Rays Happy Birthday Bar",
        "geojson": {
            "coordinates": [
                -75.158465,
                39.934128
            ],
            "type": "Point"
        }
    },
    { "name": "Ladder 15", "x": -75.1669521, "y": 39.9502599 },
    { "name": "National Mechanics",
        "loc": { "y": 39.949548, "x": -75.14594 }
    }
]' geobin.io/$BINID

# Museums
curl -X POST -H "Content-Type: application/json" -d '[
{
  "type": "FeatureCollection",
  "features": [
    {
      "type": "Feature",
      "properties": {
        "name": "Mutter Museum",
        "address": "19 S 22nd St, Philadelphia, PA 19103",
        "hours": "10a-5p"
      },
      "geometry": {
        "type": "Polygon",
        "coordinates": [
          [
            [
              -75.17675042152405,
              39.953497649942705
            ],
            [
              -75.17685234546661,
              39.953088486820924
            ],
            [
              -75.17634272575378,
              39.953028859830006
            ],
            [
              -75.17636686563492,
              39.95283969799747
            ],
            [
              -75.17612010240555,
              39.952808856344724
            ],
            [
              -75.17599403858185,
              39.953388677089094
            ],
            [
              -75.17675042152405,
              39.953497649942705
            ]
          ]
        ]
      }
    }
  ]
},
{
      "type": "Feature",
      "properties": {
        "name": "Barnes Foundation",
        "address": "2025 Benjamin Franklin Pkwy, Philadelphia, PA 19130",
        "hours": "10a-6p"
  },
      "geometry": {
        "type": "Point",
        "coordinates": [
            -75.17311871051788,
            39.96095673745211
        ]
      }
    }
]' geobin.io/$BINID
