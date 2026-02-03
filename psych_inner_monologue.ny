;nyquist plug-in
;version 4
;type process
;name "Inner Monologue"
;action "Applying inner monologue effect..."
;author "Audacity Plugin"
;copyright "Public Domain"
;info "Intimate, close-mic narration."

;control intensity "Effect Intensity" real "%" 50 0 100
;control proximity "Close-mic Proximity (dB)" real "dB" 4 0 8
;control room "Room Tone" real "" 0.2 0 0.5
;control compression "Compression Ratio" real ":1" 2 1 4

(defun clamp (x lo hi)
  (max lo (min hi x)))

(defun lerp (a b t)
  (+ a (* t (- b a))))

(defun mix (dry wet t)
  (sum (mult dry (- 1 t)) (mult wet t)))

(defun safe-bandpass (s low high)
  (let* ((lo (max 20.0 low))
         (hi (min 20000.0 high))
         (hi (if (<= hi lo) (+ lo 10.0) hi)))
    (lowpass2 (highpass2 s lo) hi)))

(defun soft-clip (s amount)
  (let* ((a (clamp amount 0.0 1.0))
         (threshold (lerp 1.0 0.4 a)))
    (clip s (- threshold) threshold)))

(defun add-echo (s delay-sec feedback)
  (let* ((d (max 0.01 delay-sec))
         (f (clamp feedback 0.0 0.9))
         (e1 (delay s d))
         (e2 (delay s (* 2 d)))
         (e3 (delay s (* 3 d))))
    (sum s (mult e1 f) (mult e2 (* f f)) (mult e3 (* f f f)))))

(let* ((t (/ intensity 100.0))
       (ratio-t (/ (- compression 1.0) 3.0))
       (compressed (soft-clip *track* (* t ratio-t)))
       (bass (lowpass2 compressed 250))
       (bass-gain (lerp 1.0 (pow 10 (/ proximity 20.0)) t))
       (with-bass (sum compressed (mult bass (- bass-gain 1.0))))
       (room-noise (mult (noise (get-duration 1)) (* t room 0.02)))
       (wet (sum with-bass room-noise))
       (out (mix *track* wet t)))
  out)
