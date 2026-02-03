;nyquist plug-in
;version 4
;type process
;name "Cathedral"
;action "Applying cathedral effect..."
;author "Audacity Plugin"
;copyright "Public Domain"
;info "Massive reverberant space with airy harmonics."

;control intensity "Effect Intensity" real "%" 50 0 100
;control harmonics "Harmonics" real "" 0.2 0 1
;control decay "Decay Time (sec)" real "sec" 5.0 1.0 10.0
;control space "Space Size" real "" 0.7 0 1

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
       (echo (add-echo *track* (lerp 0.07 0.2 (* t space)) (lerp 0.3 0.8 (* t (/ decay 10.0)))))
       (harm (mult (highpass2 echo 2500) (* t harmonics)))
       (wet (sum echo harm))
       (out (mix *track* wet t)))
  out)
