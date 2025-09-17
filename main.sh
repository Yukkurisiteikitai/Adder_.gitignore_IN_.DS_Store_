for d in */; do
  if [ -d "$d/.git" ]; then
    echo "=== Entering $d ==="
    (
      cd "$d" || exit

      # .gitignore 作成
      if [ ! -f .gitignore ]; then
        echo ".gitignore not found -> creating with .DS_Store"
        echo ".DS_Store" > .gitignore
      
      # .gitignore　追記
      else
        if ! grep -qx ".DS_Store" .gitignore; then
          echo ".DS_Store not found in .gitignore -> appending"
          echo ".DS_Store" >> .gitignore
        else
          echo ".DS_Store already present in .gitignore"
        fi
      fi

      # Git のキャッシュから .DS_Store を削除（git add した場合に消しとばすもの）
      git rm -r --cached .DS_Store 2>/dev/null

      # コミット (削除＋.gitignore 修正)
      git add .gitignore
      git commit -m "Remove cached .DS_Store and update .gitignore" || echo "No changes to commit"

      git status
    )
    echo
  fi
done
