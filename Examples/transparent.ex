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
­45.22