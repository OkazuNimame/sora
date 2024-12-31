import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CustomErrorDialog {
  static void showErrorDialog({
    required BuildContext context,
    
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Lottieアニメーションを使ったアイコン
                Lottie.asset(
                  'assets/error.json', // エラー用のアニメーションファイル
                  width: 100,
                  height: 100,
                  repeat: false,
                ),
                const SizedBox(height: 16),
                // エラーメッセージのタイトル
                Text(
                  'エラーが発生しました',
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontSize: 20,
                    fontFamily: "mincho",
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                // エラーメッセージの詳細
                Text(
                  "科目名とそのコマ数、レポート数を正しく入力してください\n0は無効です",
                  style: TextStyle(
                    color: Colors.black87,
                    fontFamily: "mincho",
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                // 閉じるボタン
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    '閉じる',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class CustomErrorDialog2 {
  static void showErrorDialog({
    required BuildContext context,
    
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Lottieアニメーションを使ったアイコン
                Lottie.asset(
                  'assets/error.json', // エラー用のアニメーションファイル
                  width: 100,
                  height: 100,
                  repeat: false,
                ),
                const SizedBox(height: 16),
                // エラーメッセージのタイトル
                Text(
                  'エラーが発生しました',
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontSize: 20,
                    fontFamily: "mincho",
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                // エラーメッセージの詳細
                Text(
                  "無効な数字を検出しました",
                  style: TextStyle(
                    color: Colors.black87,
                    fontFamily: "mincho",
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                // 閉じるボタン
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    '閉じる',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

