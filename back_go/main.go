package main

import (
	"encoding/json"
	"fmt"
	"labs/lib/call_googlemaps_api"
	"labs/lib/get_photo_data"
	"log"
	"net/http"
	"os"
	"strconv"
)

// 店舗情報を格納する構造体
type PlaceInfo struct {
	// 店舗名
	Name string `json:"name"`

	// 店舗ID
	PlaceID string `json:"place_id"`

	// 写真URL
	PhotoURLs []string `json:"photo_urls"`
}

// 経路情報を格納する構造体
type PlaceRoute struct {
	// 出発地点と目的地
	Legs struct{
		StartLocation struct{
			Lat float64 `json:"lat"`
			Lng float64 `json:"lng"`
		} `json:"start_location"`
		EndLocation struct{
			Lat float64 `json:"lat"`
			Lng float64 `json:"lng"`
		} `json:"end_location"`
	} `json:"legs"`

	// 方向性(道順)
	OverviewPolyline struct{
		Points string `json:"points"`
	} `json:"overview_polyline"`

	// 表示境界枠
	Bounds struct {
		Northeast struct {
			Lat float64 `json:"lat"`
			Lng float64 `json:"lng"`
		} `json:"northeast"`
		Southwest struct {
			Lat float64 `json:"lat"`
			Lng float64 `json:"lng"`
		} `json:"southwest"`
	} `json:"bounds"`
}

func main() {
	// 店舗情報の取得
	http.HandleFunc("/gps", gps_handler)
	// 経路情報の取得
	http.HandleFunc("/route", route_handler)

	port := os.Getenv("PORT")
	if port == "" {
		port = "3000"
	}
	fmt.Println("port: " + port)
	fmt.Println("start server")
	if err := http.ListenAndServe(":"+port, nil); err != nil {
		log.Fatal(err)
	}
	// http.ListenAndServe(":" + port, nil)
}

// 店舗情報の取得
func gps_handler(w http.ResponseWriter, r *http.Request) {
    // レスポンスヘッダの設定
    w.Header().Set("Access-Control-Allow-Origin", "*")

    // ステータスコードの設定
    // この後でレスポンスヘッダの設定はできない
    latitude := r.FormValue("lat")
	longitude := r.FormValue("lon")
	purpose := r.FormValue("purpose")

	// 文字列をfloat64に変換(緯度経度)
	lat64, err := strconv.ParseFloat(latitude, 64)
	if err != nil {
        fmt.Printf("%s\n", err.Error())
		w.WriteHeader(http.StatusBadRequest)
        return
    }
	lng64, err := strconv.ParseFloat(longitude, 64)
	if err != nil {
		fmt.Printf("%s\n", err.Error())
		w.WriteHeader(http.StatusBadRequest)
		return
	}

	// 各値が空でないか確認
	if latitude!=""&&longitude!=""&&purpose!=""{
		// googlemapsのAPIを叩く準備完了
		fmt.Printf("latitude: %s, longitude: %s, purpose: %s\n", latitude, longitude, purpose)
	}
	if purpose==""{
		fmt.Printf("purposeが空です\n")
		w.WriteHeader(http.StatusBadRequest)
		return
	}

    // レスポンスボディの書き込み
	PlaceInfoData :=  call_googlemaps_api.GetPlaceInfo(lat64,lng64,purpose)
	PlaceInfoList := []PlaceInfo{}
	//// PlaceID := []string{}
	// リストPlaceInfoListに店舗名、店舗IDをfor文で格納
	for i := 0; i < len(PlaceInfoData.Results); i++ {
		// 写真URLリストのリセット
		url_list := []string{}
		// 写真情報ごとに
		for _, place := range get_photo_data.ReturnPhotoReference(PlaceInfoData.Results[i].PlaceID) {
			// 写真URLを取得してリストに追加
			for _, photo := range place.Photos {
				url_list = append(url_list, get_photo_data.ReturnPhotoDataURL(photo.PhotoReference))
			}
		}
		placeInfo := PlaceInfo{
			Name:      PlaceInfoData.Results[i].Name,
			PlaceID:   PlaceInfoData.Results[i].PlaceID,
			PhotoURLs: url_list,
		}
		PlaceInfoList = append(PlaceInfoList, placeInfo)
	}

	// json形式に変換
	InfoJsonBytes, err := json.Marshal(PlaceInfoList)
	if err != nil {
		fmt.Println("JSON Marshal error:", err)
		return
	}

    w.Write(InfoJsonBytes)
}

//経路情報の取得
func route_handler(w http.ResponseWriter, r *http.Request) {
    // レスポンスヘッダの設定
    w.Header().Set("Access-Control-Allow-Origin", "*")

    // ステータスコードの設定
    // この後でレスポンスヘッダの設定はできない
	latitude := r.FormValue("lat")
	longitude := r.FormValue("lon")
	place_id := r.FormValue("place_id")

	// 文字列をfloat64に変換(緯度経度)
	lat64, err := strconv.ParseFloat(latitude, 64)
	if err != nil {
        fmt.Printf("%s\n", err.Error())
		w.WriteHeader(http.StatusBadRequest)
        return
    }
	lng64, err := strconv.ParseFloat(longitude, 64)
	if err != nil {
		fmt.Printf("%s\n", err.Error())
		w.WriteHeader(http.StatusBadRequest)
		return
	}

	// 各値が空でないか確認
	if latitude!=""&&longitude!=""&&place_id!=""{
		// googlemapsのAPIを叩く準備完了
		fmt.Printf("latitude: %s, longitude: %s, place_id: %s\n", latitude, longitude, place_id)
	}
	if place_id==""{
		fmt.Printf("place_idが空です\n")
		w.WriteHeader(http.StatusBadRequest)
		return
	}

    // レスポンスボディの書き込み
	PlaceRouteData := call_googlemaps_api.GetPlaceRoute(lat64,lng64,place_id)
	PlaceRouteList := []PlaceRoute{}
	
	// リストPlaceRouteListに出発地点と目的地、方向性(道順)、表示境界枠を格納
	for _, v := range PlaceRouteData {
		PlaceRouteList = append(PlaceRouteList, PlaceRoute{
			Legs: struct{
				StartLocation struct{
					Lat float64 `json:"lat"`
					Lng float64 `json:"lng"`
				} `json:"start_location"`
				EndLocation struct{
					Lat float64 `json:"lat"`
					Lng float64 `json:"lng"`
				} `json:"end_location"`
			}{
				StartLocation: struct{
					Lat float64 `json:"lat"`
					Lng float64 `json:"lng"`
				}{
					Lat: v.Legs[0].StartLocation.Lat,
					Lng: v.Legs[0].StartLocation.Lng,
				},
				EndLocation: struct{
					Lat float64 `json:"lat"`
					Lng float64 `json:"lng"`
				}{
					Lat: v.Legs[0].EndLocation.Lat,
					Lng: v.Legs[0].EndLocation.Lng,
				},
			},

			OverviewPolyline: struct{
				Points string `json:"points"`
			}{
				Points: v.OverviewPolyline.Points,
			},

			Bounds: struct {
				Northeast struct {
					Lat float64 `json:"lat"`
					Lng float64 `json:"lng"`
				} `json:"northeast"`
				Southwest struct {
					Lat float64 `json:"lat"`
					Lng float64 `json:"lng"`
				} `json:"southwest"`
			}{
				Northeast: struct {
					Lat float64 `json:"lat"`
					Lng float64 `json:"lng"`
				}{
					Lat: v.Bounds.NorthEast.Lat,
					Lng: v.Bounds.NorthEast.Lng,
				},
				Southwest: struct {
					Lat float64 `json:"lat"`
					Lng float64 `json:"lng"`
				}{
					Lat: v.Bounds.SouthWest.Lat,
					Lng: v.Bounds.SouthWest.Lng,
				},
			},
		})
	}
	
	// json形式に変換
	RouteJsonBytes, err := json.Marshal(PlaceRouteList)
	if err != nil {
		fmt.Println("JSON Marshal error:", err)
		return
	}

	// pretty.Println(PlaceRouteList[0].Legs.StartLocation.Lat)
    w.Write(RouteJsonBytes)
}