package get_photo_data

import (
	"fmt"
	"labs/lib/call_googlemaps_api"
)

type PlaceDetail struct {
	// Name string `json:"name"`
	Photos []struct{
		PhotoReference string `json:"photo_reference"`
	} `json:"photos, omitempty"`
}

func ReturnPhotoReference(place_id string) []PlaceDetail {
	PlaceDetailData := call_googlemaps_api.GetPlaceDetail(place_id)
	PlaceDetailList := []PlaceDetail{}
	for _, place := range PlaceDetailData.Photos {
		PlaceDetailList = append(PlaceDetailList, PlaceDetail{Photos: []struct{
			PhotoReference string `json:"photo_reference"`
		}{{place.PhotoReference}}})
	}
	return PlaceDetailList
}

