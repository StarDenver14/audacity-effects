;nyquist plug-in
;version 4
;type process
;name "Through Wall"
;action "Applying through wall effect..."
;author "Audacity Plugin"
;copyright "Public Domain"
;info "Muffled voice as if through a wall."

;control intensity "Effect Intensity" real "%" 50 0 100
;control low "Bandpass Low (Hz)" real "Hz" 200 80 500
;control high "Bandpass High (Hz)" real "Hz" 2500 800 4000
;control muffle "Muffle Amount" real "" 0.6 0 1
;control thump "Structural Thump" real "" 0.2 0 0.6

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
       (filtered (safe-bandpass *track* (lerp 20 low t) (lerp 20000 high t)))
       (muffled (lowpass2 filtered (lerp 20000 1200 (* t muffle))))
       (th (mult (lowpass2 *track* 120) (* t thump)))
       (wet (sum muffled th))
       (out (mix *track* wet t)))
  out)
