;nyquist plug-in
;version 4
;type process
;name "Robot Voice"
;action "Applying robot voice effect..."
;author "Audacity Plugin"
;copyright "Public Domain"
;info "Mechanical ring-modulated voice."

;control intensity "Effect Intensity" real "%" 50 0 100
;control ring "Ring Modulator (Hz)" real "Hz" 60 30 100
;control resonance "Metallic Resonance" real "" 0.5 0 1
;control formant "Formant Shift" real "" 0.3 0 1

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
       (carrier (osc (hz-to-step ring)))
       (ringed (mult *track* carrier))
       (metal (safe-bandpass ringed (lerp 200 600 (* t formant)) (lerp 4000 8000 (* t resonance))))
       (wet (mix ringed metal (* t resonance)))
       (out (mix *track* wet t)))
  out)
