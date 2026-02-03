;nyquist plug-in
;version 4
;type process
;name "Outside/Distant"
;action "Applying outside/distant effect..."
;author "Audacity Plugin"
;copyright "Public Domain"
;info "Outdoor distance with attenuation and air loss."

;control intensity "Effect Intensity" real "%" 50 0 100
;control distance "Distance" real "" 0.5 0 1
;control cutoff "Outdoor EQ Cutoff (Hz)" real "Hz" 2000 800 8000
;control atten "Volume Attenuation (dB)" real "dB" -6 -20 0

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
       (lp (lerp 20000 cutoff (* t distance)))
       (filtered (lowpass2 *track* lp))
       (gain (pow 10 (/ (* t atten) 20.0)))
       (wet (mult filtered gain))
       (out (mix *track* wet t)))
  out)
