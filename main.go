package main

import (
	"fmt"
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
		fmt.Printf("latitude:" + latitude + ", " + "lontitude:" + lontitude + ", " + "purpose:" + purpose)
	}else{
		fmt.Println("No data")
	}

    // レスポンスボディの書き込み
    w.Write([]byte(purpose))
    
}