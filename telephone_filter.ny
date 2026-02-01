;nyquist plug-in
;version 4
;type process
;name "Telephone Filter"
;action "Applying telephone filter..."
;author "Audacity Plugin"
;copyright "Public Domain"

;control phone-type "Phone Type" choice "Landline,Cellphone,Radio,Old Telephone" 0
;custom-presets "Presets" choice "Default,Vintage,Distorted,Clear" 0
;control custom-low "Low Cutoff (Hz)" real "Low" 300 200 500
;control custom-high "High Cutoff (Hz)" real "High" 3400 2000 5000

(defun get-limits (type)
  (case type
    (0 '(300 3400))   ; Landline
    (1 '(300 4000))   ; Cellphone
    (2 '(400 3000))   ; Radio
    (3 '(400 2500)))) ; Old Telephone

(defun telephone-filter (s low high)
  (let* ((bandpass-result (lowpass2 (highpass2 s low) high))
         (result (mult bandpass-result 0.95)))
    result))

(let ((limits (get-limits phone-type)))
  (telephone-filter *track* (nth 0 limits) (nth 1 limits)))