--EuWebUI
--Written by Andy P.
--Copyright (c) 2026
--Must use 64-Bit Euphoria

include std/ffi.e
include std/machine.e
include std/os.e

public atom web

ifdef WINDOWS then
	web = open_dll("webui-2.dll")
	elsifdef LINUX or FREEBSD then
	web = open_dll("libwebui-2.so")
	elsifdef OSX then
	web = open_dll("libwebui-2.dylib")
end ifdef

if web = 0 then
	puts(1,"Failed to load WebUI-2!\n")
	abort(0)
end if

--printf(1,"%d",{web}) --For testing

public constant WEBUI_VERSION = "2.5.0-beta.4"

public constant WEBUI_MAX_IDS = 65535

public constant WEBUI_MAX_ARG = 16

public enum type webui_browser
	NoBrowser = 0,  --// 0. No web browser
    AnyBrowser = 1, --// 1. Default recommended web browser
    Chrome,         --// 2. Google Chrome
    Firefox,        --// 3. Mozilla Firefox
    Edge,           --// 4. Microsoft Edge
    Safari,         --// 5. Apple Safari
    Chromium,       --// 6. The Chromium Project
    Opera,          --// 7. Opera Browser
    Brave,          --// 8. The Brave Browser
    Vivaldi,       -- // 9. The Vivaldi Browser
    Epic,          -- // 10. The Epic Browser
    Yandex,         --// 11. The Yandex Browser
    ChromiumBased,  --// 12. Any Chromium based browser
    Webview        --// 13. WebView (Non-web-browser)
end type

public enum type webui_runtime
	None = 0, --// 0. Prevent WebUI from using any runtime for .js and .ts files
    Deno,     --// 1. Use Deno runtime for .js and .ts files
    NodeJS,   --// 2. Use Nodejs runtime for .js files
    Bun      --// 3. Use Bun runtime for .js and .ts files
end type

public enum type webui_event
	WEBUI_EVENT_DISCONNECTED = 0, --// 0. Window disconnection event
    WEBUI_EVENT_CONNECTED,        --// 1. Window connection event
    WEBUI_EVENT_MOUSE_CLICK,      --// 2. Mouse click event
    WEBUI_EVENT_NAVIGATION,       --// 3. Window navigation event
    WEBUI_EVENT_CALLBACK        --// 4. Function call event
end type

public enum type webui_config
	show_wait_connection = 0,
	ui_event_blocking,
	folder_monitor,
	multi_client,
	use_cookies,
	asynchronous_response
end type

public constant webui_event_t = define_c_struct({
	C_SIZE_T, --window
	C_SIZE_T, --event_type
	C_STRING, --element
	C_SIZE_T, --event_number
	C_SIZE_T, --bind_id
	C_SIZE_T, --client_id,
	C_SIZE_T, --connection_id
	C_STRING  --cookies
})

public enum type webui_logger_level
	WEBUI_LOGGER_LEVEL_DEBUG = 0, --// 0. All logs with all details
    WEBUI_LOGGER_LEVEL_INFO, --// 1. Only general logs
    WEBUI_LOGGER_LEVEL_ERROR --// 2. Only fatal error logs
end type

public constant xwebui_new_window = define_c_func(web,"+webui_new_window",{},C_SIZE_T)

public function webui_new_window()
	return c_func(xwebui_new_window,{})
end function

public constant xwebui_new_window_id = define_c_func(web,"+webui_new_window_id",{C_SIZE_T},C_SIZE_T)

public function webui_new_window_id(atom window_number)
	return c_func(xwebui_new_window_id,{window_number})
end function

public constant xwebui_get_new_window_id = define_c_func(web,"+webui_get_new_window_id",{},C_SIZE_T)

public function webui_get_new_window_id()
	return c_func(xwebui_get_new_window_id,{})
end function

public constant xwebui_set_context = define_c_proc(web,"+webui_set_context",{C_SIZE_T,C_STRING,C_POINTER})

public procedure webui_set_context(atom window,sequence element,object context)
	c_proc(xwebui_set_context,{window,element,context})
end procedure

public constant xwebui_get_context = define_c_func(web,"+webui_get_context",{C_POINTER},C_POINTER)

public function webui_get_context(atom e)
	return c_func(xwebui_get_context,{e})
end function

public constant xwebui_get_best_browser = define_c_func(web,"+webui_get_best_browser",{C_SIZE_T},C_SIZE_T)

public function webui_get_best_browser(atom window)
	return c_func(xwebui_get_best_browser,{window})
end function

public constant xwebui_show = define_c_func(web,"+webui_show",{C_SIZE_T,C_STRING},C_BOOL)

public function webui_show(atom window,sequence content)
	return c_func(xwebui_show,{window,content})
end function

public constant xwebui_show_client = define_c_func(web,"+webui_show_client",{C_POINTER,C_STRING},C_BOOL)

public function webui_show_client(atom e,sequence content)
	return c_func(xwebui_show_client,{e,content})
end function

public constant xwebui_wait = define_c_proc(web,"+webui_wait",{})

public procedure webui_wait()
	c_proc(xwebui_wait,{})
end procedure

public constant xwebui_clean = define_c_proc(web,"+webui_clean",{})

public procedure webui_clean()
	c_proc(xwebui_clean,{})
end procedure

public constant xwebui_show_browser = define_c_func(web,"+webui_show_browser",{C_SIZE_T,C_STRING,C_SIZE_T},C_BOOL)

public function webui_show_browser(atom window,sequence content,atom browser)
	return c_func(xwebui_show_browser,{window,content,browser})
end function

public constant xwebui_start_server = define_c_func(web,"+webui_start_server",{C_SIZE_T,C_STRING},C_STRING)

public function webui_start_server(atom window,sequence content)
	return c_func(xwebui_start_server,{window,content})
end function

public constant xwebui_show_wv = define_c_func(web,"+webui_show_wv",{C_SIZE_T,C_STRING},C_BOOL)

public function webui_show_wv(atom window,sequence content)
	return c_func(xwebui_show_wv,{window,content})
end function

public constant xwebui_set_kiosk = define_c_proc(web,"+webui_set_kiosk",{C_SIZE_T,C_BOOL})

public procedure webui_set_kiosk(atom window,atom status)
	c_proc(xwebui_set_kiosk,{window,status})
end procedure

public constant xwebui_set_custom_parameters = define_c_proc(web,"+webui_set_custom_parameters",{C_SIZE_T,C_STRING})

public procedure webui_set_custom_parameters(atom window,sequence params)
	c_proc(xwebui_set_custom_parameters,{window,params})
end procedure

public constant xwebui_set_high_contrast = define_c_proc(web,"+webui_set_high_contrast",{C_SIZE_T,C_BOOL})

public procedure webui_set_high_contrast(atom window,atom status)
	c_proc(xwebui_set_high_contrast,{window,status})
end procedure

public constant xwebui_set_resizable = define_c_proc(web,"+webui_set_resizable",{C_SIZE_T,C_BOOL})

public procedure webui_set_resizable(atom window,atom status)
	c_proc(xwebui_set_resizable,{window,status})
end procedure

public constant xwebui_is_high_contrast = define_c_func(web,"+webui_is_high_contrast",{},C_BOOL)

public function webui_is_high_contrast()
	return c_func(xwebui_is_high_contrast,{})
end function

public constant xwebui_browser_exist = define_c_func(web,"+webui_browser_exist",{C_SIZE_T},C_BOOL)

public function webui_browser_exist(atom browser)
	return c_func(xwebui_browser_exist,{browser})
end function

public constant xwebui_wait_async = define_c_func(web,"+webui_wait_async",{},C_BOOL)

public function webui_wait_async()
	return c_func(xwebui_wait_async,{})
end function

public constant xwebui_minimize = define_c_proc(web,"+webui_minimize",{C_SIZE_T})

public procedure webui_minimize(atom window)
	c_proc(xwebui_minimize,{window})
end procedure

public constant xwebui_maximize = define_c_proc(web,"+webui_maximize",{C_SIZE_T})

public procedure webui_maximize(atom window)
	c_proc(xwebui_maximize,{window})
end procedure

public constant xwebui_close = define_c_proc(web,"+webui_close",{C_SIZE_T})

public procedure webui_close(atom window)
	c_proc(xwebui_close,{window})
end procedure

public constant xwebui_close_client = define_c_proc(web,"+webui_close_client",{C_POINTER})

public procedure webui_close_client(atom e)
	c_proc(xwebui_close_client,{e})
end procedure

public constant xwebui_destroy = define_c_proc(web,"+webui_destroy",{C_SIZE_T})

public procedure webui_destroy(atom window)
	c_proc(xwebui_destroy,{window})
end procedure

public constant xwebui_bind = define_c_func(web,"+webui_bind",{C_SIZE_T,C_STRING,C_POINTER},C_SIZE_T)

public function webui_bind(atom window,sequence element,object func)
	return c_func(xwebui_bind,{window,element,func})
end function

public constant xwebui_exit = define_c_proc(web,"+webui_exit",{})

public procedure webui_exit()
	c_proc(xwebui_exit,{})
end procedure

public constant xwebui_set_root_folder = define_c_func(web,"+webui_set_root_folder",{C_SIZE_T,C_STRING},C_BOOL)

public function webui_set_root_folder(atom window,sequence path)
	return c_func(xwebui_set_root_folder,{window,path})
end function

public constant xwebui_set_browser_folder = define_c_proc(web,"+webui_set_browser_folder",{C_STRING})

public procedure webui_set_browser_folder(sequence path)
	c_proc(xwebui_set_browser_folder,{path})
end procedure

public constant xwebui_set_default_root_folder = define_c_func(web,"+webui_set_default_root_folder",{C_STRING},C_BOOL)

public function webui_set_default_root_folder(sequence path)
	return c_func(xwebui_set_default_root_folder,{path})
end function

public constant xwebui_set_close_handler_wv = define_c_proc(web,"+webui_set_close_handler_wv",{C_SIZE_T,C_POINTER})

public procedure webui_set_close_handler_wv(atom window,object close_handler)
	c_proc(xwebui_set_close_handler_wv,{window,close_handler})
end procedure

public constant xwebui_set_file_handler = define_c_proc(web,"+webui_set_file_handler",{C_SIZE_T,C_POINTER})

public procedure webui_set_file_handler(atom window,object handler)
	c_proc(xwebui_set_file_handler,{window,handler})
end procedure

public constant xwebui_set_file_handler_window = define_c_proc(web,"+webui_set_file_handler_window",{C_SIZE_T,C_POINTER})

public procedure webui_set_file_handler_window(atom window,object handler)
	c_proc(xwebui_set_file_handler_window,{window,handler})
end procedure

public constant xwebui_interface_set_response_file_handler = define_c_proc(web,"+webui_interface_set_response_file_handler",{C_SIZE_T,C_POINTER,C_INT})

public procedure webui_interface_set_response_file_handler(atom window,object response,atom len)
	c_proc(xwebui_interface_set_response_file_handler,{window,response,len})
end procedure

public constant xwebui_is_shown = define_c_func(web,"+webui_is_shown",{C_SIZE_T},C_BOOL)

public function webui_is_shown(atom window)
	return c_func(xwebui_is_shown,{window})
end function

public constant xwebui_set_timeout = define_c_proc(web,"+webui_set_timeout",{C_SIZE_T})

public procedure webui_set_timeout(atom second)
	c_proc(xwebui_set_timeout,{second})
end procedure

public constant xwebui_set_icon = define_c_proc(web,"+webui_set_icon",{C_SIZE_T,C_STRING,C_STRING})

public procedure webui_set_icon(atom window,sequence icon,sequence icon_type)
	c_proc(xwebui_set_icon,{window,icon,icon_type})
end procedure

public constant xwebui_encode = define_c_func(web,"+webui_encode",{C_STRING},C_STRING)

public function webui_encode(sequence str)
	return c_func(xwebui_encode,{str})
end function

public constant xwebui_decode = define_c_func(web,"+webui_decode",{C_STRING},C_STRING)

public function webui_decode(sequence str)
	return c_func(xwebui_decode,{str})
end function

public constant xwebui_free = define_c_proc(web,"+webui_free",{C_POINTER})

public procedure webui_free(object ptr)
	c_proc(xwebui_free,{ptr})
end procedure

public constant xwebui_malloc = define_c_func(web,"+webui_malloc",{C_SIZE_T},C_POINTER)

public function webui_malloc(atom size)
	return c_func(xwebui_malloc,{size})
end function

public constant xwebui_memcpy = define_c_proc(web,"+webui_memcpy",{C_POINTER,C_POINTER,C_SIZE_T})

public procedure webui_memcpy(object dest,object src,atom count)
	c_proc(xwebui_memcpy,{dest,src,count})
end procedure

public constant xwebui_send_raw = define_c_proc(web,"+webui_send_raw",{C_SIZE_T,C_STRING,C_POINTER,C_SIZE_T})

public procedure webui_send_raw(atom window,sequence func,object raw,atom size)
	c_proc(xwebui_send_raw,{window,func,raw,size})
end procedure

public constant xwebui_send_raw_client = define_c_proc(web,"+webui_send_raw_client",{C_POINTER,C_STRING,C_POINTER,C_SIZE_T})

public procedure webui_send_raw_client(atom e,sequence func,object raw,atom size)
	c_proc(xwebui_send_raw_client,{e,func,raw,size})
end procedure

public constant xwebui_set_hide = define_c_proc(web,"+webui_set_hide",{C_SIZE_T,C_BOOL})

public procedure webui_set_hide(atom window,atom status)
	c_proc(xwebui_set_hide,{window,status})
end procedure

public constant xwebui_set_size = define_c_proc(web,"+webui_set_size",{C_SIZE_T,C_UINT,C_UINT})

public procedure webui_set_size(atom window,atom width,atom height)
	c_proc(xwebui_set_size,{window,width,height})
end procedure

public constant xwebui_set_minimum_size = define_c_proc(web,"+webui_set_minimum_size",{C_SIZE_T,C_UINT,C_UINT})

public procedure webui_set_minimum_size(atom window,atom width,atom height)
	c_proc(xwebui_set_minimum_size,{window,width,height})
end procedure

public constant xwebui_set_position = define_c_proc(web,"+webui_set_position",{C_SIZE_T,C_UINT,C_UINT})

public procedure webui_set_position(atom window,atom x,atom y)
	c_proc(xwebui_set_position,{window,x,y})
end procedure

public constant xwebui_set_center = define_c_proc(web,"+webui_set_center",{C_SIZE_T})

public procedure webui_set_center(atom window)
	c_proc(xwebui_set_center,{window})
end procedure

public constant xwebui_set_profile = define_c_proc(web,"+webui_set_profile",{C_SIZE_T,C_STRING,C_STRING})

public procedure webui_set_profile(atom window,sequence name,sequence path)
	c_proc(xwebui_set_profile,{window,name,path})
end procedure

public constant xwebui_set_proxy = define_c_proc(web,"+webui_set_proxy",{C_SIZE_T,C_STRING})

public procedure webui_set_proxy(atom window,sequence proxy_server)
	c_proc(xwebui_set_proxy,{window,proxy_server})
end procedure

public constant xwebui_get_url = define_c_func(web,"+webui_get_url",{C_SIZE_T},C_STRING)

public function webui_get_url(atom window)
	return c_func(xwebui_get_url,{window})
end function

public constant xwebui_open_url = define_c_proc(web,"+webui_open_url",{C_STRING})

public procedure webui_open_url(sequence url)
	c_proc(xwebui_open_url,{url})
end procedure

public constant xwebui_set_public = define_c_proc(web,"+webui_set_public",{C_SIZE_T,C_BOOL})

public procedure webui_set_public(atom window,atom status)
	c_proc(xwebui_set_public,{window,status})
end procedure

public constant xwebui_navigate = define_c_proc(web,"+webui_navigate",{C_SIZE_T,C_STRING})

public procedure webui_navigate(atom window,sequence url)
	c_proc(xwebui_navigate,{window,url})
end procedure

public constant xwebui_navigate_client = define_c_proc(web,"+webui_navigate_client",{C_POINTER,C_STRING})

public procedure webui_navigate_client(atom e,sequence url)
	c_proc(xwebui_navigate_client,{e,url})
end procedure

public constant xwebui_delete_all_profiles = define_c_proc(web,"+webui_delete_all_profiles",{})

public procedure webui_delete_all_profiles()
	c_proc(xwebui_delete_all_profiles,{})
end procedure

public constant xwebui_delete_profile = define_c_proc(web,"+webui_delete_profile",{C_SIZE_T})

public procedure webui_delete_profile(atom window)
	c_proc(xwebui_delete_profile,{window})
end procedure

public constant xwebui_get_parent_process_id = define_c_func(web,"+webui_get_parent_process_id",{C_SIZE_T},C_SIZE_T)

public function webui_get_parent_process_id(atom window)
	return c_func(xwebui_get_parent_process_id,{window})
end function

public constant xwebui_get_child_process_id = define_c_func(web,"+webui_get_child_process_id",{C_SIZE_T},C_SIZE_T)

public function webui_get_child_process_id(atom window)
	return c_func(xwebui_get_child_process_id,{window})
end function

public constant xwebui_win32_get_hwnd = define_c_func(web,"+webui_win32_get_hwnd",{C_SIZE_T},C_POINTER)

public function webui_win32_get_hwnd(atom window)
	return c_func(xwebui_win32_get_hwnd,{window})
end function

public constant xwebui_get_hwnd = define_c_func(web,"+webui_get_hwnd",{C_SIZE_T},C_POINTER)

public function webui_get_hwnd(atom window)
	return c_func(xwebui_get_hwnd,{window})
end function

public constant xwebui_get_port = define_c_func(web,"+webui_get_port",{C_SIZE_T},C_SIZE_T)

public function webui_get_port(atom window)
	return c_func(xwebui_get_port,{window})
end function

public constant xwebui_set_port = define_c_func(web,"+webui_set_port",{C_SIZE_T,C_SIZE_T},C_BOOL)

public function webui_set_port(atom window,atom port)
	return c_func(xwebui_set_port,{window,port})
end function

public constant xwebui_get_free_port = define_c_func(web,"+webui_get_free_port",{},C_SIZE_T)

public function webui_get_free_port()
	return c_func(xwebui_get_free_port,{})
end function

public constant xwebui_set_logger = define_c_proc(web,"+webui_set_logger",{C_POINTER,C_POINTER})

public procedure webui_set_logger(object func,object user_data)
	c_proc(xwebui_set_logger,{func,user_data})
end procedure

public constant xwebui_set_config = define_c_proc(web,"+webui_set_config",{C_INT,C_BOOL})

public procedure webui_set_config(webui_config option,atom status)
	c_proc(xwebui_set_config,{option,status})
end procedure

public constant xwebui_set_event_blocking = define_c_proc(web,"+webui_set_event_blocking",{C_SIZE_T,C_BOOL})

public procedure webui_set_event_blocking(atom window,atom status)
	c_proc(xwebui_set_event_blocking,{window,status})
end procedure

public constant xwebui_set_frameless = define_c_proc(web,"+webui_set_frameless",{C_SIZE_T,C_BOOL})

public procedure webui_set_frameless(atom window,atom status)
	c_proc(xwebui_set_frameless,{window,status})
end procedure

public constant xwebui_set_transparent = define_c_proc(web,"+webui_set_transparent",{C_SIZE_T,C_BOOL})

public procedure webui_set_transparent(atom window,atom status)
	c_proc(xwebui_set_transparent,{window,status})
end procedure

public constant xwebui_get_mime_type = define_c_func(web,"+webui_get_mime_type",{C_STRING},C_STRING)

public function webui_get_mime_type(sequence file)
	return c_func(xwebui_get_mime_type,{file})
end function

public constant xwebui_set_tls_certificate = define_c_func(web,"+webui_set_tls_certificate",{C_STRING,C_STRING},C_BOOL)

public function webui_set_tls_certificate(sequence certificate_pem,sequence private_key_pem)
	return c_func(xwebui_set_tls_certificate,{certificate_pem,private_key_pem})
end function

public constant xwebui_run = define_c_proc(web,"+webui_run",{C_SIZE_T,C_STRING})

public procedure webui_run(atom window,sequence script)
	c_proc(xwebui_run,{window,script})
end procedure

public constant xwebui_run_client = define_c_proc(web,"+webui_run_client",{C_POINTER,C_STRING})

public procedure webui_run_client(atom e,sequence script)
	c_proc(xwebui_run_client,{e,script})
end procedure

public constant xwebui_script = define_c_func(web,"+webui_script",{C_SIZE_T,C_STRING,C_SIZE_T,C_STRING,C_SIZE_T},C_BOOL)

public function webui_script(atom window,sequence script,atom timeout,object buffer,atom buffer_len)
	return c_func(xwebui_script,{window,script,timeout,buffer,buffer_len})
end function

public constant xwebui_script_client = define_c_func(web,"+webui_script_client",{C_POINTER,C_STRING,C_SIZE_T,C_STRING,C_SIZE_T},C_BOOL)

public function webui_script_client(atom e,sequence script,atom timeout,object buffer,atom buffer_len)
	return c_func(xwebui_script_client,{e,script,timeout,buffer,buffer_len})
end function

public constant xwebui_set_runtime = define_c_proc(web,"+webui_set_runtime",{C_SIZE_T,C_SIZE_T})

public procedure webui_set_runtime(atom window,atom runtime)
	c_proc(xwebui_set_runtime,{window,runtime})
end procedure

public constant xwebui_get_count = define_c_func(web,"+webui_get_count",{C_POINTER},C_SIZE_T)

public function webui_get_count(atom e)
	return c_func(xwebui_get_count,{e})
end function

public constant xwebui_get_int_at = define_c_func(web,"+webui_get_int_at",{C_POINTER,C_SIZE_T},C_LONGLONG)

public function webui_get_int_at(atom e,atom index)
	return c_func(xwebui_get_int_at,{e,index})
end function

public constant xwebui_get_int = define_c_func(web,"+webui_get_int",{C_POINTER},C_LONGLONG)

public function webui_get_int(atom e)
	return c_func(xwebui_get_int,{e})
end function

public constant xwebui_get_float_at = define_c_func(web,"+webui_get_float_at",{C_POINTER,C_SIZE_T},C_DOUBLE)

public function webui_get_float_at(atom e,atom index)
	return c_func(xwebui_get_float_at,{e,index})
end function

public constant xwebui_get_float = define_c_func(web,"+webui_get_float",{C_POINTER},C_DOUBLE)

public function webui_get_float(atom e)
	return c_func(xwebui_get_float,{e})
end function

public constant xwebui_get_string_at = define_c_func(web,"+webui_get_string_at",{C_POINTER,C_SIZE_T},C_STRING)

public function webui_get_string_at(atom e,atom index)
	return c_func(xwebui_get_string_at,{e,index})
end function

public constant xwebui_get_string = define_c_func(web,"+webui_get_string",{C_POINTER},C_STRING)

public function webui_get_string(atom e)
	return c_func(xwebui_get_string,{e})
end function

public constant xwebui_get_bool_at = define_c_func(web,"+webui_get_bool_at",{C_POINTER,C_SIZE_T},C_BOOL)

public function webui_get_bool_at(atom e,atom index)
	return c_func(xwebui_get_bool_at,{e,index})
end function

public constant xwebui_get_bool = define_c_func(web,"+webui_get_bool",{C_POINTER},C_BOOL)

public function webui_get_bool(atom e)
	return c_func(xwebui_get_bool,{e})
end function

public constant xwebui_get_size_at = define_c_func(web,"+webui_get_size_at",{C_POINTER,C_SIZE_T},C_SIZE_T)

public function webui_get_size_at(atom e,atom index)
	return c_func(xwebui_get_size_at,{e,index})
end function

public constant xwebui_get_size = define_c_func(web,"+webui_get_size",{C_POINTER},C_SIZE_T)

public function webui_get_size(atom e)
	return c_func(xwebui_get_size,{e})
end function

public constant xwebui_return_int = define_c_proc(web,"+webui_return_int",{C_POINTER,C_LONGLONG})

public procedure webui_return_int(atom e,atom n)
	c_proc(xwebui_return_int,{e,n})
end procedure

public constant xwebui_return_float = define_c_proc(web,"+webui_return_float",{C_POINTER,C_DOUBLE})

public procedure webui_return_float(atom e,atom f)
	c_proc(xwebui_return_float,{e,f})
end procedure

public constant xwebui_return_string = define_c_proc(web,"+webui_return_string",{C_POINTER,C_STRING})

public procedure webui_return_string(atom e,sequence s)
	c_proc(xwebui_return_string,{e,s})
end procedure

public constant xwebui_return_bool = define_c_proc(web,"+webui_return_bool",{C_POINTER,C_BOOL})

public procedure webui_return_bool(atom e,atom b)
	c_proc(xwebui_return_bool,{e,b})
end procedure

public constant xwebui_get_last_error_number = define_c_func(web,"+webui_get_last_error_number",{},C_SIZE_T)

public function webui_get_last_error_number()
	return c_func(xwebui_get_last_error_number,{})
end function

public constant xwebui_get_last_error_message = define_c_func(web,"+webui_get_last_error_message",{},C_STRING)

public function webui_get_last_error_message()
	return c_func(xwebui_get_last_error_message,{})
end function

public constant xwebui_interface_bind = define_c_func(web,"+webui_interface_bind",{C_SIZE_T,C_STRING,C_POINTER},C_SIZE_T)

public function webui_interface_bind(atom window,sequence element,object func)
	return c_func(xwebui_interface_bind,{window,element,func})
end function

public constant xwebui_interface_set_response = define_c_proc(web,"+webui_interface_set_response",{C_SIZE_T,C_SIZE_T,C_STRING})

public procedure webui_interface_set_response(atom window,atom event_number,sequence response)
	c_proc(xwebui_interface_set_response,{window,event_number,response})
end procedure

public constant xwebui_interface_is_app_running = define_c_func(web,"+webui_interface_is_app_running",{},C_BOOL)

public function webui_interface_is_app_running()
	return c_func(xwebui_interface_is_app_running,{})
end function

public constant xwebui_interface_get_window_id = define_c_func(web,"+webui_interface_get_window_id",{C_SIZE_T},C_SIZE_T)

public function webui_interface_get_window_id(atom window)
	return c_func(xwebui_interface_get_window_id,{window})
end function

public constant xwebui_interface_get_string_at = define_c_func(web,"+webui_interface_get_string_at",{C_SIZE_T,C_SIZE_T,C_SIZE_T},C_STRING)

public function webui_interface_get_string_at(atom window,atom event_number,atom index)
	return c_func(xwebui_interface_get_string_at,{window,event_number,index})
end function

public constant xwebui_interface_get_int_at = define_c_func(web,"+webui_interface_get_int_at",{C_SIZE_T,C_SIZE_T,C_SIZE_T},C_LONGLONG)

public function webui_interface_get_int_at(atom window,atom event_number,atom index)
	return c_func(xwebui_interface_get_int_at,{window,event_number,index})
end function

public constant xwebui_interface_get_float_at = define_c_func(web,"+webui_interface_get_float_at",{C_SIZE_T,C_SIZE_T,C_SIZE_T},C_DOUBLE)

public function webui_interface_get_float_at(atom window,atom event_number,atom index)
	return c_func(xwebui_interface_get_float_at,{window,event_number,index})
end function

public constant xwebui_interface_get_bool_at = define_c_func(web,"+webui_interface_get_bool_at",{C_SIZE_T,C_SIZE_T,C_SIZE_T},C_BOOL)

public function webui_interface_get_bool_at(atom window,atom event_number,atom index)
	return c_func(xwebui_interface_get_bool_at,{window,event_number,index})
end function

public constant xwebui_interface_get_size_at = define_c_func(web,"+webui_interface_get_size_at",{C_SIZE_T,C_SIZE_T,C_SIZE_T},C_SIZE_T)

public function webui_interface_get_size_at(atom window,atom event_number,atom index)
	return c_func(xwebui_interface_get_size_at,{window,event_number,index})
end function

public constant xwebui_interface_show_client = define_c_func(web,"+webui_interface_show_client",{C_SIZE_T,C_SIZE_T,C_STRING},C_BOOL)

public function webui_interface_show_client(atom window,atom event_number,sequence content)
	return c_func(xwebui_interface_show_client,{window,event_number,content})
end function

public constant xwebui_interface_close_client = define_c_proc(web,"+webui_interface_close_client",{C_SIZE_T,C_SIZE_T})

public procedure webui_interface_close_client(atom window,atom event_number)
	c_proc(xwebui_interface_close_client,{window,event_number})
end procedure

public constant xwebui_interface_send_raw_client = define_c_proc(web,"+webui_interface_send_raw_client",{C_SIZE_T,C_SIZE_T,C_STRING,C_POINTER,C_SIZE_T})

public procedure webui_interface_send_raw_client(atom window,atom event_number,sequence func,object raw,atom size)
	c_proc(xwebui_interface_send_raw_client,{window,event_number,func,raw,size})
end procedure

public constant xwebui_interface_navigate_client = define_c_proc(web,"+webui_interface_navigate_client",{C_SIZE_T,C_SIZE_T,C_STRING})

public procedure webui_interface_navigate_client(atom window,atom event_number,sequence url)
	c_proc(xwebui_interface_navigate_client,{window,event_number,url})
end procedure

public constant xwebui_interface_run_client = define_c_proc(web,"+webui_interface_run_client",{C_SIZE_T,C_SIZE_T,C_STRING})

public procedure webui_interface_run_client(atom window,atom event_number,sequence script)
	c_proc(xwebui_interface_run_client,{window,event_number,script})
end procedure

public constant xwebui_interface_script_client = define_c_func(web,"+webui_interface_script_client",{C_SIZE_T,C_SIZE_T,C_STRING,C_SIZE_T,C_STRING,C_SIZE_T},C_BOOL)

public function webui_interface_script_client(atom window,atom event_number,sequence script,atom timeout,object buffer,atom buffer_len)
	return c_func(xwebui_interface_script_client,{window,event_number,script,timeout,buffer,buffer_len})
end function
­741.25