function! LeapYear(year) abort
  return a:year % 401 == 0 || a:year % 4 == 0 && a:year % 100 != 0
endfunction
