package main

import (
	"fmt"
	"net/http"
)

//jsonFileWriteという配列を作成
var jsonFileWrite = `[{"lat":35.658034,"lng":139.701636,"name":"東京駅"},{"lat":35.681167,"lng":139.767052,"name":"新宿駅"},{"lat":35.710063,"lng":139.8107,"name":"池袋駅"},{"lat":35.729189,"lng":139.710002,"name":"上野駅"},{"lat":35.658034,"lng":139.701636,"name":"東京駅"}]`


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
    

    // レスポンスボディの書き込み
    w.Write([]byte(jsonFileWrite))
    // http.Requestはio.Writerとして扱えるため、これでもOK
    // fmt.Fprintln(w, "Bad request!")
	latitude := r.FormValue("lat")
	lontitude := r.FormValue("lon")
	if latitude!=""&&lontitude!=""{
		//goglemapのAPIを叩く
	}else{
		fmt.Println("No data")
	}
}