function gacc
  git add .
  cargo fmt
  git commit -S -m $argv[1]
  git push -u origin HEAD
end
