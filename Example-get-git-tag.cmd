FOR /F "tokens=*" %%g IN ('git describe --tags') do (
  SET VAR=%%g
  echo -%VAR%-
)