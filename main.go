package main

import (
	"fmt"
	"net/http"
)
func main() {
    http.HandleFunc("/hello", HelloServer)
	http.HandleFunc("/good", HelloServer2)
	fmt.Println("start server")
    http.ListenAndServe("localhost:8080", nil)
}
func HelloServer(w http.ResponseWriter, r *http.Request) {
    fmt.Fprintf(w, "Hello, %s", r.URL.Query().Get("lat"))
}
func HelloServer2(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "good, %s", r.URL.Path[:])
}
