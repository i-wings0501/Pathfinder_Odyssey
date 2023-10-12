// https://pkg.go.dev/googlemaps.github.io/maps
package call_googlemaps_api

import (
	"context"
	"labs/lib/env"
	"log"
	"strconv"

	"googlemaps.github.io/maps"
)

// 店舗情報取得関数
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
		Language: "ja",
		// MinPrice :"PriceLevel",
		// MaxPrice :"PriceLevel",
		// Name :"string",
		OpenNow: true,
		// RankBy:"",
		// Type :"PlaceType",
		// PageToken: "string",
	}
	place_info, err := c.NearbySearch(context.Background(), r)
	if err != nil {
		log.Fatalf("fatal error: %s", err)
	}

	return place_info
}

func GetPlaceRoute(latitude float64, longitude float64, place_id string) []maps.Route {
	key := env.ReadEnv()
	c, err := maps.NewClient(maps.WithAPIKey(key))
	if err != nil {
		log.Fatalf("fatal error: %s", err)
	}
	r := &maps.DirectionsRequest{
		Origin:      strconv.FormatFloat(latitude,'f',-1,64) + "," + strconv.FormatFloat(longitude,'f',-1,64),
		Destination: "place_id:" + place_id,
		Language: "ja",
	}
	place_route, _, err := c.Directions(context.Background(), r)
	if err != nil {
		log.Fatalf("fatal error: %s", err)
	}

	return place_route
}

// 店舗詳細情報取得関数
func GetPlaceDetail(place_id string) maps.PlaceDetailsResult{
	key := env.ReadEnv()
	c, err := maps.NewClient(maps.WithAPIKey(key))
	if err != nil {
		log.Fatalf("fatal error: %s", err)
	}
	r := &maps.PlaceDetailsRequest{
		PlaceID:  place_id,
		Language: "ja",
	}
	place_detail, err := c.PlaceDetails(context.Background(), r)
	if err != nil {
		log.Fatalf("fatal error: %s", err)
	}

	return place_detail
}

func GetPlacePhoto(photo_reference string) maps.PlacePhotoResponse{
	key := env.ReadEnv()
	c, err := maps.NewClient(maps.WithAPIKey(key))
	if err != nil {
		log.Fatalf("fatal error: %s", err)
	}
	r := &maps.PlacePhotoRequest{
		PhotoReference:  photo_reference,
		MaxHeight:250,
	}
	place_photo, err := c.PlacePhoto(context.Background(), r)
	if err != nil {
		log.Fatalf("fatal error: %s", err)
	}

	return place_photo
}
