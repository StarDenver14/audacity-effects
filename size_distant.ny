;nyquist plug-in
;version 4
;type process
;name "Distant"
;action "Applying distant effect..."
;author "Audacity Plugin"
;copyright "Public Domain"
;info "Far away voice with air loss and reverb."

;control intensity "Effect Intensity" real "%" 50 0 100
;control lowpass "Low-pass Cutoff (Hz)" real "Hz" 1000 500 4000
;control reverb "Reverb Amount" real "" 0.6 0 1
;control drop "Volume Drop (dB)" real "dB" -12 -24 0

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
       (lp (lerp 20000 lowpass t))
       (filtered (lowpass2 *track* lp))
       (room (add-echo filtered (lerp 0.04 0.12 (* t reverb)) (lerp 0.2 0.6 (* t reverb))))
       (gain (pow 10 (/ (* t drop) 20.0)))
       (wet (mult room gain))
       (out (mix *track* wet t)))
  out)
