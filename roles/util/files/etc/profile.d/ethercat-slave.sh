sleep 3

if [ $(ethercat sl | wc -l) -ne 0 ]
then
  ethercat sl
  printf "\n"
fi
