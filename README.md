# EuWebUI

# ABOUT
EuWebUI is a wrapper of WebUI for the OpenEuphoria programming language. This uses Greg's FFI Library for Euphoria and must use the 64-bit version of Euphoria. 

# LICENSE

NOTE: That WebUI is licensed under MIT License

Copyright (c) <2026> <Andy P.>

This software is provided 'as-is', without any express or implied
warranty. In no event will the authors be held liable for any damages
arising from the use of this software.

Permission is granted to anyone to use this software for any purpose,
including commercial applications, and to alter it and redistribute it
freely, subject to the following restrictions:

1. The origin of this software must not be misrepresented; you must not
   claim that you wrote the original software. If you use this software
   in a product, an acknowledgment in the product documentation would be
   appreciated but is not required.
2. Altered source versions must be plainly marked as such, and must not be
   misrepresented as being the original software.
3. This notice may not be removed or altered from any source distribution.

# EXAMPLE
```euphoria
include std/ffi.e
include std/machine.e

include webui.e

public atom win = webui_new_window()

public function minimize()
	webui_minimize(win)
	return 0
end function

atom min_id = routine_id("minimize")
object min_cb = call_back(min_id)

public function maximize()
	webui_maximize(win)
	return 0
end function

atom max_id = routine_id("maximize")
object max_cb = call_back(max_id)

public function close_win()
	webui_close(win)
	puts(1,"Closing...\n")
	return 0
end function

atom close_id = routine_id("close_win")
object close_cb = call_back(close_id)

constant TRUE = 1, FALSE = 0

public procedure main()

	webui_bind(win,"minimize",min_cb)
	webui_bind(win,"maximize",max_cb)
	webui_bind(win,"close_win",close_cb)
	
	webui_set_size(win,800,600)
	webui_set_frameless(win,TRUE)
	webui_set_transparent(win,TRUE)
	webui_set_resizable(win,FALSE)
	webui_set_center(win)
	
	webui_show_wv(win,"transparent.html")
	webui_wait()
end procedure

main()
```
