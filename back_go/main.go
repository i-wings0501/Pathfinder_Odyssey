package main

import (
	"encoding/json"
	"fmt"
	"labs/lib/call_googlemaps_api"
	"net/http"
	"strconv"
)


type Place struct {
	Name string `json:"name"`
	PlaceID string `json:"place_id"`
}

func main() {
	http.HandleFunc("/gps", handler)
	fmt.Println("start server")
    http.ListenAndServe("localhost:3000", nil)
}


func handler(w http.ResponseWriter, r *http.Request) {
    // レスポンスヘッダの設定
    w.Header().Set("Access-Control-Allow-Origin", "*")

    // ステータスコードの設定
    // この後でレスポンスヘッダの設定はできない
    latitude := r.FormValue("lat")
	longitude := r.FormValue("lon")
	purpose := r.FormValue("purpose")

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

	if latitude!=""&&longitude!=""&&purpose!=""{
		//googlemapsのAPIを叩く
		fmt.Printf("latitude: %s, longitude: %s, purpose: %s\n", latitude, longitude, purpose)
	}
	if purpose==""{
		fmt.Printf("purposeが空です\n")
		w.WriteHeader(http.StatusBadRequest)
		return
	}

    // レスポンスボディの書き込み
	data := call_googlemaps_api.GetPlaceInfo(lat64,lng64,purpose)
	PlaceList := []Place{}
	// PlaceID := []string{}
	//リスト名ResultNameとして、data.Results[i].Nameの要素をfor文で取得
	for i := 0; i < len(data.Results); i++ {
		PlaceList = append(PlaceList,Place{data.Results[i].Name, data.Results[i].PlaceID});
	}

	// json形式に変換
	jsonBytes, err := json.Marshal(PlaceList)
	if err != nil {
		fmt.Println("JSON Marshal error:", err)
		return
	}

    w.Write(jsonBytes)
    
}

