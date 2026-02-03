;nyquist plug-in
;version 4
;type process
;name "Interdimensional Being Recipe"
;action "Applying interdimensional being recipe effect..."
;author "Audacity Plugin"
;copyright "Public Domain"
;info "Alien, dream, and cathedral combined."

;control intensity "Effect Intensity" real "%" 50 0 100
;control comp1 "Component 1" real "" 0.6 0 1
;control comp2 "Component 2" real "" 0.5 0 1
;control comp3 "Component 3" real "" 0.4 0 1

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
       (alien (safe-bandpass *track* (lerp 100 300 (* t comp1)) (lerp 8000 12000 (* t comp1))))
       (dream (lowpass2 (resample alien (lerp 1.0 0.85 (* t comp2))) 1600))
       (space (add-echo dream (lerp 0.08 0.18 (* t comp3)) (lerp 0.2 0.7 (* t comp3))))
       (out (mix *track* space t)))
  out)
