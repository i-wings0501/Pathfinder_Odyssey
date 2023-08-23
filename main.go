package main

import (
	"fmt"
	"net/http"
)

//jsonFileWriteという配列を作成
var jsonFileWrite = `conect success`


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
	porpose := r.FormValue("porpose")
	if latitude!=""&&lontitude!=""&&porpose!=""{
		//goglemapのAPIを叩く
		fmt.Printf("latitude:" + latitude +", " + "lontitude:" + lontitude + ", " + "porpose:" + porpose)
	}else{
		fmt.Println("No data")
	}
}