;nyquist plug-in
;version 4
;type process
;name "Phone Call Effect"
;action "Applying phone effect..."
;info "Makes audio sound like it's over a telephone call"

;control band-center "Band Center" real "Hz" 1850 300 4000
;control band-width "Band Width" real "Hz" 1550 500 3000
;control distortion "Distortion" real "Amount" 0.3 0 1
;control noise "Noise Level" real "Amount" 0.01 0 0.1

(defun phone-effect (s)
  (let* ((high-passed (highpass2 s (- band-center band-width)))
         (bandpass-result (lowpass2 high-passed (+ band-center band-width)))
         (distorted (diff bandpass-result (clip bandpass-result distortion)))
         (noise-signal (mult (noise (snd-length bandpass-result 1000000)) noise))
         (result (sim distorted noise-signal)))
    (mult result 0.9)))

(phone-effect *track*)