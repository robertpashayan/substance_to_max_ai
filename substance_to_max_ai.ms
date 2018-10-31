try(destroydialog SubstancetoArnold_UI)catch()
global SubstancetoArnold_UI
rollout SubstancetoArnold_UI "Substance to Arnold" width:335 height:535
(
	GroupBox 'grp_slots' "Slots" pos:[10,7] width:315 height:309 align:#left
	GroupBox 'grp2' "Diffuse" pos:[22,30] width:290 height:50 align:#left
	edittext 'edt_diffuse' "" pos:[29,50] width:135 height:20 align:#left
	button 'btn_reset_diffuse' "R" pos:[282,48] width:22 height:22 align:#left
	GroupBox 'grp7' "Normal" pos:[22,85] width:290 height:50 align:#left
	edittext 'edt_normal' "" pos:[29,105] width:135 height:20 align:#left
	button 'btn_reset_normal' "R" pos:[282,103] width:22 height:22 align:#left
	GroupBox 'grp8' "Height" pos:[22,140] width:290 height:50 align:#left
	edittext 'edt_height' "" pos:[29,160] width:135 height:20 align:#left
	button 'btn_reset_height' "R" pos:[282,158] width:22 height:22 align:#left
	GroupBox 'grp9' "Metalness" pos:[22,195] width:290 height:50 align:#left
	edittext 'edt_metalness' "" pos:[29,215] width:135 height:20 align:#left
	button 'btn_reset_metalness' "R" pos:[282,213] width:22 height:22 align:#left
	GroupBox 'grp10' "Roughness" pos:[22,250] width:290 height:50 align:#left
	edittext 'edt_roughness' "" pos:[29,270] width:135 height:20 align:#left
	button 'btn_reset_roughness' "R" pos:[282,268] width:22 height:22 align:#left
	GroupBox 'grp_file_path' "File Path" pos:[10,325] width:315 height:55 align:#left
	button 'btn_build_arnold_material' "Build Arnold Material" pos:[10,440] width:315 height:85 align:#left
	edittext 'edt_path_pattern' "" pos:[17,346] width:298 height:24 align:#left
	dropdownList 'ddl_diffuse' "" pos:[177,49] width:93 height:21 align:#left
	dropdownList 'ddl_normal' "" pos:[177,104] width:93 height:21 align:#left
	dropdownList 'ddl_height' "" pos:[177,159] width:93 height:21 align:#left
	dropdownList 'ddl_metalness' "" pos:[177,214] width:93 height:21 align:#left
	dropdownList 'ddl_roughness' "" pos:[177,269] width:93 height:21 align:#left
	checkButton 'ckb_use_normal' "Use Normal" pos:[10,388] width:157 height:36 align:#left checked:true
	checkButton 'ckb_use_bump' "Use Bump" pos:[167,388] width:157 height:36 align:#left
	
	local colorspace_array = #("auto", "linear", "sRGB", "rec709")
	local file_paths = #()
	local title = "Substance to Arnold"
	local bump_type = 1
	local diffuse_path
	local normal_path
	local height_path
	local metalness_path
	local roughness_path
	
	local exemple_text = "\nexemple : '' x:\my_folder\my_file_*_<udim>.exr ''\nwhere '' * '' is replacing the map type('Diffuse') and '' <udim> '' the UDIM number section('1001')."
	
	local diffuse_default_value = "BaseColor"
	local normal_default_value = "Normal"
	local height_default_value = "Height"
	local metalness_default_value = "Metalness"
	local roughness_default_value = "Roughness"
	
	local error_message = ""
	
	
	fn normal_bump_switcher id state =
	(
		list = #(ckb_use_normal,ckb_use_bump)
		bump_type = id
		for i=1 to 2 do
		(
			if i == id then list[i].checked = state
			else list[i].checked = not state
		)
		
	)
	
	
	fn get_files =
	(
		local path_card = edt_path_pattern.text
		if path_card.count > 0 then
		(			
			path_card = substitutestring (tolower path_card) "<udim>" "*"
			file_paths = getFiles path_card
		)
	)
	
	fn sort_in_slots =
	(
		if file_paths.count > 0 then
		(
			local path_card = edt_path_pattern.text
			
			local diffuse_path_ = substitutestring path_card "*" (edt_diffuse.text)
					
			local diffuse_path_card = substitutestring (tolower diffuse_path_) "<udim>" "*"
			local diffuse_files = #()
			if findstring  diffuse_path_card (edt_diffuse.text) != undefined then diffuse_files =  getFiles diffuse_path_card
			if diffuse_files.count > 0 then
			(
				diffuse_path = diffuse_path_
			)
			else
			(
				diffuse_path_ = undefined
				error_message += "File for Diffuse slot couldn't be detected.\n"
			)
			
			local normal_path_ = substitutestring path_card "*" (edt_normal.text)
			local normal_path_card = substitutestring (tolower normal_path_) "<udim>" "*"
			local normal_files = #()
			if findstring  normal_path_card (edt_normal.text) != undefined then normal_files = getFiles normal_path_card
			if normal_files.count > 0 then
			(
				normal_path = normal_path_
			)
			else
			(
				normal_path = undefined
				error_message += "File for Normal slot couldn't be detected.\n"
			)
			
			local height_path_ = substitutestring path_card "*" (edt_height.text)
			local height_path_card = substitutestring (tolower height_path_) "<udim>" "*"
			local height_files = #()
			if findstring  height_path_card (edt_height.text) != undefined then height_files =  getFiles height_path_card
			if height_files.count > 0 then
			(
				height_path = height_path_
			)
			else
			(
				height_path = undefined
				error_message += "File for Height slot couldn't be detected.\n"
			)
			
			
			local metalness_path_ = substitutestring path_card "*" (edt_metalness.text)
			local metalness_path_card = substitutestring (tolower metalness_path_) "<udim>" "*"
			local metalness_files = #()
			if findstring  metalness_path_card (edt_metalness.text) != undefined then metalness_files =  getFiles metalness_path_card
			if metalness_files.count > 0 then
			(
				metalness_path = metalness_path_
			)
			else
			(
				metalness_path = undefined
				error_message += "File for Metalness slot couldn't be detected.\n"
			)
			
			
			local roughness_path_ = substitutestring path_card "*" (edt_roughness.text)
			local roughness_path_card = substitutestring (tolower roughness_path_) "<udim>" "*"
			local roughness_files = #()
			if findstring  roughness_path_card (edt_roughness.text) != undefined then roughness_files =  getFiles roughness_path_card
			if roughness_files.count > 0 then
			(
				roughness_path = roughness_path_
			)
			else
			(
				roughness_path = undefined
				error_message += "File for Roughness slot couldn't be detected.\n"
			)
		)
	)
	
	fn set_arnold_image path_ color_space_id =
	(
		local arnold_image
		if path_!= undefined then
		(
			arnold_image = try(ai_image())catch(undefined)
			if arnold_image != undefined then
			(
				arnold_image.filename = path_
				arnold_image.color_space = color_space_id - 1
			)
		)
		return arnold_image
	)
	
	fn set_arnold_bump normal_ nrm_color_space_id height_ height_color_space_id =
	(
		local arnold_bump
		local arnold_image
		if bump_type == 1 then
		(
			arnold_image = set_arnold_image normal_ nrm_color_space_id
			if arnold_image != undefined then
			(
				arnold_bump = try(ai_normal_map())catch(undefined)
				if arnold_bump!= undefined then	
				(
					arnold_bump.input_shader = arnold_image
				)
			)
		)
		else
		(
			arnold_image = set_arnold_image height_ height_color_space_id
			if arnold_image != undefined then
			(
				arnold_bump = try(ai_bump2d())catch(undefined)
				if arnold_bump!= undefined then	
				(
					arnold_bump.bump_map_shader = arnold_image
				)
			)
		)
		return arnold_bump
	)
	
	fn build_arnold_std_surface =
	(
		arnold_std = try(ai_standard_surface())catch(undefined)
		if arnold_std != undefined then
		(
			arnold_std.base_color_shader  = set_arnold_image diffuse_path (ddl_diffuse.selection)
			arnold_std.normal_shader  = set_arnold_bump normal_path (ddl_normal.selection) height_path (ddl_height.selection)
			arnold_std.metalness_shader  = set_arnold_image metalness_path (ddl_diffuse.selection)
			arnold_std.specular_roughness_shader  = set_arnold_image roughness_path (ddl_diffuse.selection)
		)
		return arnold_std
	)
	
	fn show_material_in_slate material_ =
	(
		if not sme.IsOpen() then sme.Open() 
		sme_view = sme.GetView (sme.activeView)
		if sme_view == undefined then
		(
			sme.CreateView title
			sme_view = sme.GetView (sme.activeView)
		)
		sme_view.CreateNode material_ [0,100]
		sme_view.SetSelectedNodes #(material_)
		sme_view.ZoomExtents type:2
		
	)

	
	
	on SubstancetoArnold_UI open do
	(
		edt_diffuse.text = diffuse_default_value
		edt_normal.text = normal_default_value
		edt_height.text = height_default_value
		edt_metalness.text = metalness_default_value
		edt_roughness.text = roughness_default_value
		
		ddl_diffuse.items = colorspace_array
		ddl_normal.items = colorspace_array
		ddl_height.items = colorspace_array
		ddl_metalness.items = colorspace_array
		ddl_roughness.items = colorspace_array
		
		ddl_normal.selection = 2
		
	)
	on btn_reset_diffuse pressed do
	(
		edt_diffuse.text = diffuse_default_value
		ddl_diffuse.selection = 1
		
	)
	on btn_reset_normal pressed do
	(
		edt_normal.text = normal_default_value
		ddl_normal.selection = 2
		
	)
	on btn_reset_height pressed do
	(
		edt_height.text = height_default_value
		ddl_height.selection = 1
		
	)
	on btn_reset_metalness pressed do
	(
		edt_metalness.text = metalness_default_value
		ddl_metalness.selection = 1
		
	)
	on btn_reset_roughness pressed do
	(
		edt_roughness.text = roughness_default_value
		ddl_roughness.selection = 1
	)
	on btn_build_arnold_material pressed do
	(
		error_message = ""
		get_files()
		if file_paths.count > 0 then
		(
			sort_in_slots()
			local material_ = build_arnold_std_surface()
			if material_ != undefined then show_material_in_slate material_
			if error_message.count > 0 then
			(
				messagebox ("Some errors were encountered:\n" + error_message) title:title
			)
		)
		else
		(
			messagebox ("Couldn't collect the files, check the integrity of the path card!" + exemple_text) title:title
		)
	
	)
	
	on ckb_use_normal changed state do
	(
		normal_bump_switcher 1 state
	)
	on ckb_use_bump changed state do
	(
		normal_bump_switcher 2 state
	)
)
createdialog SubstancetoArnold_UI
---------------------------------------------------------------
