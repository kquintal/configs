function gbc --description 'Delete all local branches except main and master'
  git branch | grep -v -E 'main|master' | xargs git branch -D $argv
end
