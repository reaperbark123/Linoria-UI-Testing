local httpService = game:GetService('HttpService')
local ThemeManager = {} do
	ThemeManager.Folder = 'ReaperS_Business'
	ThemeManager.Library = nil
	ThemeManager.BuiltInThemes = {
        ['Default']         = { 1, httpService:JSONDecode('{"FontColor":"d0d0d0","MainColor":"1c1c1c","AccentColor":"8700ff","BackgroundColor":"141414","OutlineColor":"000000"}') },
		['Dracula'] 		= { 2, httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"232533","AccentColor":"6271a5","BackgroundColor":"1b1c27","OutlineColor":"7c82a7"}') },
		['Bitch Bot'] 		= { 3, httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"1e1e1e","AccentColor":"7e48a3","BackgroundColor":"232323","OutlineColor":"141414"}') },
		['Kiriot Hub'] 		= { 4, httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"30333b","AccentColor":"ffaa00","BackgroundColor":"1a1c20","OutlineColor":"141414"}') },
		['Fatality'] 		= { 5, httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"1e1842","AccentColor":"c50754","BackgroundColor":"191335","OutlineColor":"3c355d"}') },
		['Green'] 			= { 6, httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"141414","AccentColor":"00ff8b","BackgroundColor":"1c1c1c","OutlineColor":"3c3c3c"}') },
		['Jester'] 			= { 7, httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"242424","AccentColor":"db4467","BackgroundColor":"1c1c1c","OutlineColor":"373737"}') },
		['Mint'] 			= { 8, httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"242424","AccentColor":"3db488","BackgroundColor":"1c1c1c","OutlineColor":"373737"}') },
		['Tokyo Night'] 	= { 9, httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"191925","AccentColor":"6759b3","BackgroundColor":"16161f","OutlineColor":"323232"}') },
		['Ubuntu'] 			= { 10, httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"3e3e3e","AccentColor":"e2581e","BackgroundColor":"323232","OutlineColor":"191919"}') },
        ['Linoria'] 		= { 11, httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"1c1c1c","AccentColor":"0055ff","BackgroundColor":"141414","OutlineColor":"323232"}') },
	}
    
	function ThemeManager:ApplyTheme(theme)
		local data = self.BuiltInThemes[theme]

		if not data then return end

		local scheme = data[2]
		for idx, col in next, scheme do
			self.Library[idx] = Color3.fromHex(col)
			
			if Options[idx] then
				Options[idx]:SetValueRGB(Color3.fromHex(col))
			end
		end

		self:ThemeUpdate()
	end

	function ThemeManager:ThemeUpdate()
		self.Library.FontColor = Options.FontColor.Value
		self.Library.MainColor = Options.MainColor.Value
		self.Library.AccentColor = Options.AccentColor.Value
		self.Library.BackgroundColor = Options.BackgroundColor.Value
		self.Library.OutlineColor = Options.OutlineColor.Value

		self.Library.AccentColorDark = self.Library:GetDarkerColor(self.Library.AccentColor);
		self.Library:UpdateColorsUsingRegistry()
	end

	function ThemeManager:CreateThemeManager(groupbox)
		groupbox:AddLabel('Background color'):AddColorPicker('BackgroundColor', { Default = self.Library.BackgroundColor });
		groupbox:AddLabel('Main color')	:AddColorPicker('MainColor', { Default = self.Library.MainColor });
		groupbox:AddLabel('Accent color'):AddColorPicker('AccentColor', { Default = self.Library.AccentColor });
		groupbox:AddLabel('Outline color'):AddColorPicker('OutlineColor', { Default = self.Library.OutlineColor });
		groupbox:AddLabel('Font color')	:AddColorPicker('FontColor', { Default = self.Library.FontColor });

		local ThemesArray = {}
		for Name, Theme in next, self.BuiltInThemes do
			table.insert(ThemesArray, Name)
		end

		table.sort(ThemesArray, function(a, b) return self.BuiltInThemes[a][1] < self.BuiltInThemes[b][1] end)

		groupbox:AddDivider()
		groupbox:AddDropdown('ThemeManager_ThemeList', { Text = 'Theme list', Values = ThemesArray, Default = 1 })

		Options.ThemeManager_ThemeList:OnChanged(function()
			self:ApplyTheme(Options.ThemeManager_ThemeList.Value)
		end)
        
		local function UpdateTheme()
			self:ThemeUpdate()
		end

		Options.BackgroundColor:OnChanged(UpdateTheme)
		Options.MainColor:OnChanged(UpdateTheme)
		Options.AccentColor:OnChanged(UpdateTheme)
		Options.OutlineColor:OnChanged(UpdateTheme)
		Options.FontColor:OnChanged(UpdateTheme)
	end

	function ThemeManager:SetLibrary(lib)
		self.Library = lib
	end

	function ThemeManager:CreateGroupBox(tab)
		assert(self.Library, 'Must set ThemeManager.Library first!')
		return tab:AddRightGroupbox('Theme Manager')
	end

	function ThemeManager:ApplyToTab(tab)
		assert(self.Library, 'Must set ThemeManager.Library first!')
		local groupbox = self:CreateGroupBox(tab)
		self:CreateThemeManager(groupbox)
	end
    
	function ThemeManager:ApplyToGroupbox(groupbox)
		assert(self.Library, 'Must set ThemeManager.Library first!')
		self:CreateThemeManager(groupbox)
	end
end
return ThemeManager
