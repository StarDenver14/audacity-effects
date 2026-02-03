;nyquist plug-in
;version 4
;type process
;name "PA System"
;action "Applying pa system effect..."
;author "Audacity Plugin"
;copyright "Public Domain"
;info "Large public address with distance and reverb."

;control intensity "Effect Intensity" real "%" 50 0 100
;control stadium-size "Stadium Size" real "" 0.6 0 1
;control distance "Distance" real "" 0.3 0 1
;control bandwidth "Bandwidth (Hz)" real "Hz" 5000 3000 8000

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
       (low (lerp 80 200 t))
       (high (lerp 20000 bandwidth t))
       (filtered (safe-bandpass *track* low high))
       (room (add-echo filtered (lerp 0.08 0.18 (* t stadium-size)) (lerp 0.2 0.6 (* t stadium-size))))
       (atten (lerp 1.0 0.6 (* t distance)))
       (wet (mult room atten))
       (out (mix *track* wet t)))
  out)
