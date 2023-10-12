package get_photo_data

import (
	b64 "encoding/base64"
	"fmt"
	"io"
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

func ReturnPhotoDataURL(photo_reference string) string {
	PlacePhotoData := call_googlemaps_api.GetPlacePhoto(photo_reference)
	photoBytes, err := io.ReadAll(PlacePhotoData.Data)
	if err != nil {
		fmt.Println(err)
	}
	sEnc := b64.StdEncoding.EncodeToString(photoBytes)
	dataUrl := fmt.Sprintf("data:%s;base64,%s", PlacePhotoData.ContentType, sEnc)
	
	return dataUrl
}