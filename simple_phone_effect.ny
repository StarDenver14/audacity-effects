;nyquist plug-in
;version 4
;type process
;name "Simple Phone Effect"
;action "Applying phone filter..."

;control low-cut "Low Cut" real "Hz" 300 200 500
;control high-cut "High Cut" real "Hz" 3400 2000 5000

(let* ((hp (highpass2 *track* low-cut))
       (bp (lowpass2 hp high-cut))
       (result (mult bp 0.95)))
  result)