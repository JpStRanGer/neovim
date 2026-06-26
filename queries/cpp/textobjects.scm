; extends
; `; extends` (må stå først) gjør at denne fila LEGGES TIL plugin-ens
; cpp/textobjects.scm i stedet for å erstatte den — slik beholder vi
; standard-textobjects (@function.outer osv.) OG våre egne switch/case under.

; For selecting and moving inside a switch-case block
(switch_statement) @switch.outer
(case_statement) @case.label
