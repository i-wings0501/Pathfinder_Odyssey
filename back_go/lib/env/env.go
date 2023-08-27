package env

import (
	"fmt"
	"os"

	// 参照：https://zenn.dev/a_ichi1/articles/c9f3870350c5e2
	"github.com/joho/godotenv"
)

// 参照：https://zenn.dev/a_ichi1/articles/c9f3870350c5e2
func ReadEnv() string {
	// envファイル全体を読み込み。
	// envファイルがない場合はエラーになる。
	err := godotenv.Load(".env")
	
	// もし err がnilではないなら、"読み込み出来ませんでした"が出力
	if err != nil {
		fmt.Printf("読み込み出来ませんでした: %v", err)
	} 
	
	// API_keyの値を取得
	message := os.Getenv("API_key")

	return message
}
