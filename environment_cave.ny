;nyquist plug-in
;version 4
;type process
;name "Cave"
;action "Applying cave effect..."
;author "Audacity Plugin"
;copyright "Public Domain"
;info "Long, damp cave echoes."

;control intensity "Effect Intensity" real "%" 50 0 100
;control decay "Reverb Decay (sec)" real "sec" 3.5 0.5 8.0
;control predelay "Pre-delay (ms)" real "ms" 80 0 200
;control damp "Dampening" real "" 0.4 0 1

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
       (delay-sec (/ predelay 1000.0))
       (echo (add-echo *track* (lerp 0.05 delay-sec t) (lerp 0.2 0.7 (* t (/ decay 8.0)))))
       (damped (lowpass2 echo (lerp 20000 3000 (* t damp))))
       (wet (mult damped (lerp 1.0 0.8 t)))
       (out (mix *track* wet t)))
  out)
