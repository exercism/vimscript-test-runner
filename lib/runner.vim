" Orchestrates a Vader run and writes Exercism test-runner v2 JSON.
set nocompatible

let s:arguments = v:argv[index(v:argv, '--') + 1 :]
let s:solution_file = s:arguments[0]
let s:test_file = s:arguments[1]
let s:results_file = s:arguments[2]
let s:input_dir = s:arguments[3]
let s:vader_path = s:arguments[4]

function! s:run() abort
  try
    if !filereadable(s:solution_file)
      call s:error('Solution file not found: '.s:solution_file)
      return
    endif
    if !filereadable(s:test_file)
      call s:error('Test file not found: '.s:test_file)
      return
    endif
    if !isdirectory(s:vader_path)
      call s:error('Vader test framework is not installed.')
      return
    endif

    execute 'set runtimepath^='.fnameescape(s:vader_path)
    runtime plugin/vader.vim

    execute 'source '.fnameescape(s:solution_file)
    try
      let cases = vader#parser#parse(s:test_file, 1, 0)
    catch
      call s:error('Vader test file syntax error.')
      return
    endtry

    execute 'silent Vader '.fnameescape(s:test_file)
    let report = split(get(g:, 'vader_report', ''), "\n")
    let errors_by_line = {}
    for vader_error in get(g:, 'vader_errors', [])
      let errors_by_line[string(vader_error.lnum)] = vader_error
    endfor

    let tests = []
    let all_errors = 1
    let failed = 0
    for case in cases
      let test = {
            \ 'name': s:case_name(case),
            \ 'status': 'pass',
            \ 'test_code': join(case.execute, "\n"),
            \ }
      let vader_error = get(errors_by_line, string(case.lnum), {})
      if !empty(vader_error)
        let message = s:failure_message(vader_error, report)
        let test.status = s:failure_status(message)
        let test.message = s:clean_message(message)
      endif
      let all_errors = all_errors && test.status ==# 'error'
      let failed = failed || test.status !=# 'pass'
      call add(tests, test)
    endfor

    if empty(tests)
      call s:error('No Vader test cases were executed.')
    elseif all_errors
      call s:error(get(tests[0], 'message', 'All Vader test cases errored.'))
    else
      call s:write({
            \ 'version': 2,
            \ 'status': failed ? 'fail' : 'pass',
            \ 'message': v:null,
            \ 'tests': tests,
            \ })
    endif
  catch
    call s:error(v:exception)
  endtry
endfunction

function! s:write(document) abort
  call writefile([json_encode(a:document)], s:results_file)
endfunction

function! s:clean_message(message) abort
  if !empty(s:input_dir)
    return substitute(a:message, '\V'.escape(s:input_dir, '\\').'\m', '<solution-dir>', 'g')
  endif
  return a:message
endfunction

function! s:error(message) abort
  call s:write({
        \ 'version': 2,
        \ 'status': 'error',
        \ 'message': s:clean_message(a:message),
        \ 'tests': [],
        \ })
endfunction

function! s:case_name(case) abort
  let name = get(a:case.comment, 'execute', '')
  return empty(name) ? printf('Test at line %d', a:case.lnum) : name
endfunction

function! s:failure_message(vader_error, report) abort
  let report_line = matchstr(get(a:vader_error, 'text', ''), '(#\zs\d\+\ze)')
  if !empty(report_line) && report_line >= 1 && report_line <= len(a:report)
    let message = a:report[report_line - 1]
    return substitute(message, '^\s*(\d\+/\d\+) \[[^]]*\] (X) ', '', '')
  endif
  return get(a:vader_error, 'text', 'Test failed.')
endfunction

function! s:failure_status(message) abort
  return a:message =~# '^Vim\%(([^)]*)\)\?:' ? 'error' : 'fail'
endfunction

call s:run()
qa!
