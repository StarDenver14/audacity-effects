;nyquist plug-in
;version 4
;type process
;name "Possessed"
;action "Applying possessed effect..."
;author "Audacity Plugin"
;copyright "Public Domain"
;info "Dual-voice demonic layer with detune."

;control intensity "Effect Intensity" real "%" 50 0 100
;control dual "Dual Voice" real "" 0.7 0 1
;control detune "Detune Amount (cents)" real "cents" -20 -50 50
;control spread "Stereo Spread" real "" 0.8 0 1

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
       (ratio (pow 2 (/ (* t detune) 1200.0)))
       (layer (resample *track* ratio))
       (mixed (sum *track* (mult layer (* t dual))))
       (dark (lowpass2 mixed (lerp 20000 2000 (* t spread))))
       (out (mix *track* dark t)))
  out)
