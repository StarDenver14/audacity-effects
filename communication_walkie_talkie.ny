;nyquist plug-in
;version 4
;type process
;name "Walkie-Talkie"
;action "Applying walkie-talkie effect..."
;author "Audacity Plugin"
;copyright "Public Domain"
;info "Band-limited radio with static and compression."

;control intensity "Effect Intensity" real "%" 50 0 100
;control bandpass-low "Bandpass Low (Hz)" real "Hz" 300 200 800
;control bandpass-high "Bandpass High (Hz)" real "Hz" 3000 1500 6000
;control static-amount "Static Amount" real "" 0.05 0 0.5
;control compression "Compression Ratio" real ":1" 4 1 10

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
       (low (lerp 20.0 bandpass-low t))
       (high (lerp 20000.0 bandpass-high t))
       (filtered (safe-bandpass *track* low high))
       (noise-src (noise (get-duration 1)))
       (static (mult (safe-bandpass noise-src low high) (* t static-amount)))
       (with-static (sum filtered static))
       (ratio-t (/ (- compression 1.0) 9.0))
       (compressed (soft-clip with-static (* t ratio-t)))
       (wet (mult compressed 0.95))
       (out (mix *track* wet t)))
  out)
