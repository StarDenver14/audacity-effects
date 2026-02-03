;nyquist plug-in
;version 4
;type process
;name "Giant"
;action "Applying giant effect..."
;author "Audacity Plugin"
;copyright "Public Domain"
;info "Deep, massive voice with slow attack and large space."

;control intensity "Effect Intensity" real "%" 50 0 100
;control pitch "Pitch Shift (semitones)" real "st" -12 -24 -6
;control attack "Slow Attack (ms)" real "ms" 50 0 200
;control reverb "Massive Reverb" real "" 0.7 0 1

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
       (ratio (pow 2 (/ (* t pitch) 12.0)))
       (pitched (resample *track* ratio))
       (smoothed (lowpass2 pitched (lerp 20000 800 (* t (/ attack 200.0)))))
       (room (add-echo smoothed (lerp 0.06 0.16 (* t reverb)) (lerp 0.2 0.7 (* t reverb))))
       (out (mix *track* room t)))
  out)
