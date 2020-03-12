#!/bin/bash

process_yolo_results()
{
  local json=${1}.json
  local jpeg=${1}.jpg
  local result

  if [ -s "${json}" ] && [ -s "${jpeg}" ]; then
    local size=($(identify ${jpeg}  | awk '{ print $3 }' | sed 's/x/ /'))
    local image_width=${size[0]}
    local image_height=${size[1]}
    local colors=(yellow orange magenta cyan white green blue red)
    local count=0
    local output=
    local entities=$(jq '.results' ${json})
    local ids=$(echo "${entities:-null}" | jq -r '.[].id?')

    for t in ${ids}; do
      local entity=$(echo "${entities:-null}" | jq '.[]|select(.id=="'${t}'")')
      local center_x=$(echo "${entity:-null}" | jq -r '.center.x')
      local center_y=$(echo "${entity:-null}" | jq -r '.center.y')
      local width=$(echo "${entity:-null}" | jq -r '.width')
      local height=$(echo "${entity:-null}" | jq -r '.height')

      local half_width=$(echo "${width} / 2" | bc -l) && half_width=${half_width%%.*}
      local half_height=$(echo "${height} / 2" | bc -l) && half_height=${half_height%%.*}

      local top=$((center_y - half_height))
      local bottom=$((center_y + half_height))
      local left=$((center_x - half_width))
      local right=$((center_x + half_width))

      if [ ${top:-0} -lt 0 ]; then top=0; fi
      if [ ${left:-0} -lt 0 ]; then left=0; fi
      if [ ${bottom:-0} -gt ${image_height}  ]; then bottom=${image_height}; fi
      if [ ${right:-0} -gt ${image_width} ]; then right=${image_width}; fi

      if [ ${count} -eq 0 ]; then
        file=${jpeg%%.*}-${count}.jpg
        cp -f ${jpeg} ${file}
      else
        rm -f ${file}
        file=${output}
      fi
      output=${jpeg%%.*}-$((count+1)).jpg

      local name=$(echo "${entity:-null}" | jq -r '.entity')
      local confidence=$(echo "${entity:-null}" | jq -r '.confidence') && confidence="${confidence%%.*}%"

      convert -pointsize 16 -stroke ${colors[${count}]} -fill none -strokewidth 2 -draw "rectangle ${left},${top} ${right},${bottom} push graphic-context stroke ${colors[${count}]} fill ${colors[${count}]} translate ${right},${bottom} text 3,6 '${name} ${confidence}' pop graphic-context" ${file} ${output}

      if [ ! -s "${output}" ]; then
        echo "Failed"
        exit 1
      fi
      count=$((count+1))
      if [ ${count} -ge ${#colors[@]} ]; then count=0; fi
    done
    if [ ! -z "${output:-}" ]; then
      rm -f ${file}
      result=${jpeg%%.*}-yolo.jpg
      mv ${output} ${result}
    fi
  fi
  echo "${result:-null}"
}

if [ ! -z "${*}" ]; then
  process_yolo_results ${*}
else
  echo "Usage: ${0} <sample>; for example: ${0} ea7the" &> /dev/stderr
fi
