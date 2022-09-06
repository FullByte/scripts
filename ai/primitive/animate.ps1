# Source:
# https://github.com/fogleman/primitive

# Requirements
# Install Go: choco install -y golang
# Install ffmpeg: choco install -y ffmpeg
# Install primitive: go get -u github.com/fogleman/primitive

# Run Tool
$picture = "input.png"
$pictures = 100
for($i = 0; $i -lt $pictures; $i++){primitive -i $picture -o ("output" + ("{0:d6}" -f $i)+ ".png") -n 100 -v}
ffmpeg -framerate 30 -start_number 0 -i "output%6d.png" -c:v libx264 "output.mp4"
ffmpeg -i output.mp4 -vf "scale=-2:480" -c:v libx264 -preset slow -crf 21 -profile:v baseline -level 3.0 -pix_fmt yuv420p -r 25 -g 50 -c:a aac -b:a 160k -r:a 44100 -f mp4 output2.mp4
