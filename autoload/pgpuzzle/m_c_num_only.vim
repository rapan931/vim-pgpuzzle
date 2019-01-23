" https://teratail.com/questions/11046
"
" NOTE: Not use list.
"
"  000
"  |||
"  ||+- missionary
"  |+-- cannibal
"  +--- dst
"
"  and go to dst(1), or go to src(0) bit
"
" example: src[missionary * 1, and cannibal*2], dst[missionary*2 and cannibal*1] and go to dst
"   0010100101011011101
"       |
"       V
"   001 010 010 101 101 110 1
"   -+- -+- -+- -+- -+- -+- +-- go to dst
"    |   |   |   |   |   +----- dst cannibal(No.1)
"    |   |   |   |   +--------- dst missionary(No.1)
"    |   |   |   +------------- dst missionary(No.2)
"    |   |   +----------------- src cannibal(No.2)
"    |   +--------------------- src cannibal(No.3)
"    +------------------------- src missionary(No.3)

" SEE: plugin/pgpuzzle.vim
let pgpuzzle#m_c_num_only#dummy = 1

function! s:combination(ary, is_uniq) abort
  let ret = []
  let i = 1
  for s:value in a:ary
    for s:value2 in a:ary[i:-1]
      call add(ret, [s:value, s:value2])
    endfor let i += 1
  endfor
  if a:is_uniq
    return uniq(sort(ret))
  else
    return ret
  endif
endfunction

function! s:print(result) abort
  let c = 0
  echomsg "result"
  echomsg "-----------------------"
  for src_and_dst in a:result
    echomsg ""
    echomsg "  No." . c
    echomsg "    src:"join(sort(src_and_dst[0]), " ")
    echomsg "    ～～～～～～～～～～～～"
    echomsg "     | "
    echomsg "    ～～～～～～～～～～～～"
    echomsg "    dst:"join(sort(src_and_dst[1]), " ")
    echomsg ""
    echomsg ""
    let c += 1
  endfor
endfunction

function! s:is_finish(dst) abort
  return count(a:dst, 1) == 3
endfunction

function! s:validate(src, dst, src_to_dst_flg, process) abort
  for target in [a:src, a:dst]
    let marder_count = count(target, 9)
    let human_count = count(target, 1)
    if human_count != 0 && marder_count > human_count
      return 0
    endif
  endfor

  if index(a:process, [a:src, a:dst, a:src_to_dst_flg ? 0 : 1]) != -1
    return 0
  endif

  return 1
endfunction

function! s:start(src, dst, src_to_dst_flg, process) abort
  let combinations = s:combination(a:src_to_dst_flg ? a:src[0:-1] : a:dst[0:-1], 1) + uniq(sort(map((a:src_to_dst_flg ? [] : a:dst[0:-1]), {k, v -> [v]})))
  for s:v in combinations
    let tmp_src = a:src[:]
    let tmp_dst = a:dst[:]
    for s:v2 in s:v
      if a:src_to_dst_flg
        call remove(tmp_src, index(tmp_src, s:v2))
        call add(tmp_dst, s:v2)
        call sort(tmp_dst)
      else
        call remove(tmp_dst, index(tmp_dst, s:v2))
        call add(tmp_src, s:v2)
        call sort(tmp_src)
      endif
    endfor

    if s:validate(tmp_src, tmp_dst, a:src_to_dst_flg, a:process)
      if s:is_finish(tmp_dst)
        call s:print(a:process + [[tmp_src, tmp_dst]])
      else
        call s:start(tmp_src, tmp_dst, a:src_to_dst_flg ? 0 : 1, a:process + [[tmp_src, tmp_dst, a:src_to_dst_flg ? 0 : 1]])
      endif
    else
      continue
    endif
  endfor
endfunction

function! pgpuzzle#m_c#start() abort
  call s:start([1, 1, 1, 9, 9, 9], [], 1, [[[1, 1, 1, 9, 9, 9], [], 1]])
endfunction

" vim:set spell
