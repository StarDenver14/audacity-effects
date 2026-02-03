;nyquist plug-in
;version 4
;type process
;name "Film Noir"
;action "Applying film noir effect..."
;author "Audacity Plugin"
;copyright "Public Domain"
;info "Classic noir telephone quality with room ambience."

;control intensity "Effect Intensity" real "%" 50 0 100
;control telephone "Telephone Quality" real "" 0.6 0 1
;control reverb "Room Reverb" real "" 0.3 0 1
;control eq "1940s EQ" real "" 0.5 0 1

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
       (bp (safe-bandpass *track* (lerp 80 400 (* t telephone)) (lerp 20000 2800 (* t telephone))))
       (room (add-echo bp (lerp 0.02 0.06 (* t reverb)) (lerp 0.1 0.4 (* t reverb))))
       (eqed (lowpass2 room (lerp 20000 3000 (* t eq))))
       (out (mix *track* eqed t)))
  out)
