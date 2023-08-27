package call_googlemaps_api

import (
	"context"
	"labs/lib/env"
	"log"

	"googlemaps.github.io/maps"
)

func GetPlaceInfo(latitude float64, longitude float64, purpose string) maps.PlacesSearchResponse {
	key := env.ReadEnv()
	c, err := maps.NewClient(maps.WithAPIKey(key))
	if err != nil {
		log.Fatalf("fatal error: %s", err)
	}
	r := &maps.NearbySearchRequest{
		Location: &maps.LatLng{	
			Lat: latitude,
			Lng: longitude,
		},
		Radius : 1000,
		Keyword: purpose,
		// Language: "string",
		// MinPrice :"PriceLevel",
		// MaxPrice :"PriceLevel",
		// Name :"string",
		// OpenNow: "bool",
		// RankBy:"",
		// Type :"PlaceType",
		// PageToken: "string",
	}
	route, err := c.NearbySearch(context.Background(), r)
	if err != nil {
		log.Fatalf("fatal error: %s", err)
	}

	return route
}
