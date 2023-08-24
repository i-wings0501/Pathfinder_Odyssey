package main

import (
	"fmt"
	"io"
	"labs/lib/env"
	"net/http"
)


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
	lontitude := r.FormValue("lon")
	purpose := r.FormValue("purpose")
	if latitude!=""&&lontitude!=""&&purpose!=""{
		//goglemapのAPIを叩く
		fmt.Printf("latitude: %s, lontitude: %s, purpose: %s\n", latitude, lontitude, purpose)
	}else{
		fmt.Println("No data")
	}

    // レスポンスボディの書き込み
	info := getGps(latitude,lontitude,purpose)
    w.Write([]byte(info))
    
}

func getGps(latitude string, lontitude string, purpose string) []byte {
	API_key := env.ReadEnv()
	res, _ := http.Get(fmt.Sprintf("https://maps.googleapis.com/maps/api/place/nearbysearch/json?keyword=%s&language=ja&location=%s,%s&radius=1500&type=restaurant&key=%s",purpose,latitude,lontitude,API_key))
	defer res.Body.Close()
	body, _ := io.ReadAll(res.Body)
	return body
}