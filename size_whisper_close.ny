;nyquist plug-in
;version 4
;type process
;name "Whisper Close"
;action "Applying whisper close effect..."
;author "Audacity Plugin"
;copyright "Public Domain"
;info "Close whisper with breath and compression."

;control intensity "Effect Intensity" real "%" 50 0 100
;control proximity "Proximity Effect (dB)" real "dB" 8 0 12
;control breath "Breath Noise" real "" 0.3 0 1
;control compression "Compression Ratio" real ":1" 3 1 6

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
       (ratio-t (/ (- compression 1.0) 5.0))
       (compressed (soft-clip *track* (* t ratio-t)))
       (bass (lowpass2 compressed 200))
       (bass-gain (lerp 1.0 (pow 10 (/ proximity 20.0)) t))
       (with-bass (sum compressed (mult bass (- bass-gain 1.0))))
       (breath-noise (mult (highpass2 (noise (get-duration 1)) 3000) (* t breath)))
       (wet (sum with-bass breath-noise))
       (out (mix *track* wet t)))
  out)
