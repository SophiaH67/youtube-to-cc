base_path = "/out/"
fps = 10
time_between_frames_ms = 1000/fps

function video()
    -- Loop through all .nfp files in base_path, display them for 1/fps seconds
    files = fs.list(base_path)
    local mon = peripheral.find("monitor")
    local old_term = term.current()
    mon.setTextScale(0.5)
    
    for i = 1, #files do
        if string.sub(files[i], -4) == ".nfp" then
            local image = paintutils.loadImage(base_path .. files[i])
            local start = os.epoch("local")
            term.redirect(mon)
            term.clear()
            paintutils.drawImage(image, 0, 0)
            term.redirect(old_term)
            time_taken = os.epoch("local") - start
            print("Displayed " .. files[i])
            sleep(0) -- Yield to other threads
            while time_taken < time_between_frames_ms do
                sleep(0)
                time_taken = os.epoch("local") - start
            end
            print("Time taken: " .. time_taken)
        end
    end
end

function audio()
    local dfpwm = require("cc.audio.dfpwm")
    local speaker = peripheral.find("speaker")
    local decoder = dfpwm.make_decoder()

    for input in io.lines(base_path .. "audio.dfpwm", 16 * 1024) do
        local decoded = decoder(input)
        while not speaker.playAudio(decoded) do
            os.pullEvent("speaker_audio_empty")
        end
    end
end

parallel.waitForAny(video, audio)
print("Done")
