function asl
# Simply function to alias aws sso login
# Argiment for profile is optional
  if test (count $argv) -eq 0
    aws sso login
  else
    aws sso login --profile $argv[1]
  end
end
