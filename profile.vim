" add to end of .vimrc
" outputs key timings for each key pair
" remove when done as uses up processor

 " ================= profiler ==================
	augroup profiler
		autocmd!
		autocmd TextChangedI * :call ProfilerTextChanged()
		autocmd CursorHoldI, InsertEnter * :call ProfilerReset()
		autocmd BufWritePost * :call ProfilerWrite()
	augroup END

	function ProfilerTextChanged()
		let info=timer_info(s:timerID)
		let remain=info[0].remaining
		" remaining time counts down
		let delay= s:lasttime - remain
		" get last char typed
		let l:last = strpart(getline('.'),col('.')-2,1)
		" skip delays >= 1 second to avoid spurious times
		if delay < 1000
			let l:pair = s:lastkey . l:last
			if has_key(s:keycount, l:pair)
				let s:keycount[l:pair] = s:keycount[l:pair] + 1 
				let s:keytimes[l:pair] = s:keytimes[l:pair] + delay 
			endif
		endif
		let s:lasttime = remain
		let s:lastkey = l:last
	endfunction

	function ProfilerReset()
		" echom "lastkey: " . s:lastkey
		" echom "lasttime: " . s:lasttime
		let s:lastkey = ""
	endfunction

	function ProfilerTimeOut()
		echom "profiler timeout - shouldnt get here"
	endfunction

	function ProfilerInit()
		let s:lastkey = ""
		let s:keycount = {}
		let s:keytimes = {}
		let l:len = strlen(s:charsString) 
		let i = 0
		while i < l:len
			let c = strpart( s:charsString, i, 1)
			let i += 1
			let j = 0
			while j < l:len
				let c2 = strpart( s:charsString, j, 1)
				let j += 1
				let pair =  c . c2
				let s:keycount[l:pair] = 0 
				let s:keytimes[l:pair] = 0 
			endwhile
		endwhile
		" only way to get millisecond timer
		let s:timerID= timer_start(1000 * 60 * 24, function('ProfilerTimeOut'), {'repeat': -1})
		" timer still counts down when paused, just doesn't trigger
		call timer_pause(s:timerID,1)
		let s:lasttime = 0
	endfunction

	function ProfilerWrite()
		" initialisation
		let l:count = ""
		let l:times =  ""
		let beforecount = {}
		let beforetimes = {}
		let l:len = strlen(s:charsString) 
		let j = 0
		while j < l:len
			let beforecount[j] = 0
			let beforetimes[j] = 0
			let j += 1
		endwhile

		let total = 0
		let i = 0
		while i < l:len
			let c = strpart( s:charsString, i, 1)
			let j = 0
			while j < l:len
				let c2 = strpart( s:charsString, j, 1)
				let pair =  c . c2
				let total += s:keycount[l:pair] 
				let l:count =l:count . "," .  s:keycount[l:pair] 
				let l:times =l:times . "," .  s:keytimes[l:pair] 
				" count delays before each key - but only if not on own (ie not reset before key)
				let beforecount[j] = beforecount[j] +  s:keycount[l:pair] 
				let beforetimes[j] = beforetimes[j] +  s:keytimes[l:pair] 
				let j += 1
			endwhile
			let i += 1
		endwhile
		" only write if enough keypresses so not just editing
		if total > 100
			let j = 0
			let beforecs=""
			let beforets=""
			while j < l:len
				let beforecs=beforecs . "," . beforecount[j] 
				let beforets=beforets . "," . beforetimes[j] 
				let j += 1
			endwhile
			let l:count =l:count . "\n"
			let l:times =l:times . "\n"
			let beforecs=beforecs . "\n"
			let beforets=beforets . "\n"
			if writefile([l:count],expand("~/.vim/keycount.csv"),"a")
				echom 'write error'
			endif
			if writefile([l:times],expand("~/.vim/keytimes.csv"),"a")
				echom 'write error'
			endif
			if writefile([beforecs],expand("~/.vim/beforecount.csv"),"a")
				echom 'write error'
			endif
			if writefile([beforets],expand("~/.vim/beforetimes.csv"),"a")
				echom 'write error'
			endif
		endif
	endfunction

	" keys we want to record pairs of
	let s:charsString = "abcdefghijklmnopqrstuvwxyz!\";',. "
	call	ProfilerInit()

