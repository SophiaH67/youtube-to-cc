import sh

url = "https://www.youtube.com/watch?v=0hXqwWuZ8iA"
monitor_height = 38
monitor_width = 79

print("Downloading...")
sh.yt_dlp(url, "-o", "tmp/sourceVideo.%(ext)s", "--merge-output-format", "mkv")

# Video section
from PIL import Image
from glob import glob
from nfp import img_to_nfp

print("Extracting Images...")
sh.ffmpeg("-i", "tmp/sourceVideo.mkv", "-vf", "fps=10", "tmp/img/img%05d.png")
frame=0
for img in glob("tmp/img/*.png"):
    im = Image.open(img)
    mfp_file = img_to_nfp(im, (monitor_width, monitor_height))

    padded_frame = str(frame).zfill(5)

    with open(f"out/{padded_frame}.nfp", "w") as f:
        f.write(mfp_file)
    frame+=1
print("Done extracting images")

# Audio section
print("Extracting Audio...")
sh.ffmpeg("-i", "tmp/sourceVideo.mkv", "-ac", "1", "out/audio.dfpwm") # Yes, it's that simple; Thanks ffmpeg lol
print("Done extracting audio")