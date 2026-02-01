include std/ffi.e
include std/machine.e

include webui.e

public function close_app()
	webui_exit()
	puts(1,"Closing...\n")
	return 0
end function

atom close_id = routine_id("close_app")
object close_cb = call_back(close_id)

public procedure main()
	atom win = webui_new_window()
	
	webui_bind(win,"close_app",close_cb)
	
	webui_set_center(win)
	
	webui_show(win,"index.html")
	
	webui_wait()
	
	webui_clean()
end procedure

main()
­20.22