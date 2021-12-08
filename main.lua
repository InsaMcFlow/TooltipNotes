local TN_TargetName
local TN_SavingNote
local TN_MouseoverName
local TN_InputName
local TN_SavingName
local TN_FunctionUsed

local Login_EventFrame = CreateFrame("Frame")
Login_EventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
Login_EventFrame:SetScript("OnEvent",
	function(self, event, ...)
	
		--parent box
		local TN_InputBox = CreateFrame("Frame","TN_InputBox",UIParent,"BackdropTemplate")
		TN_InputBox:SetSize(255,255)
		TN_InputBox:SetPoint("CENTER", 0, 100);
		TN_InputBox:SetBackdrop({
						bgFile = "Interface/DialogFrame/UI-DialogBox-Background-Dark",
						edgeFile = "Interface/DialogFrame/UI-DialogBox-Border",
						tile = true,
						tileSize = 32,
						edgeSize = 32,
						insets = { left = 10, right = 10, top = 10, bottom = 10 }
					});
		TN_InputBox:SetScript("OnHide", function(s)
								TN_TargetName = ""
								TN_InputName = ""
							 end)
							 
		--make it draggable					 
		TN_InputBox:SetMovable(true)
		TN_InputBox:EnableMouse(true)
		TN_InputBox:RegisterForDrag("LeftButton")
		TN_InputBox:SetScript("OnDragStart", TN_InputBox.StartMoving)
		TN_InputBox:SetScript("OnDragStop", TN_InputBox.StopMovingOrSizing)					 
		
		tinsert(UISpecialFrames,"TN_InputBox");
		
		--input box for the character name
		TN_NameBox = CreateFrame("EditBox","TN_NameBox",TN_InputBox,"InputBoxTemplate")
        TN_NameBox:SetSize(155,24)
		TN_NameBox:SetPoint("TOP", "TN_InputBox", 20, -10);
        TN_NameBox:SetAutoFocus(false)
        
		TN_NameBox:SetScript("OnShow", function(s)	
								TN_InputName = nil
								if TN_FunctionUsed == true then
									TN_NameBox:SetText("")
									if TN_TargetName ~= nil then
										TN_NameBox:SetText(TN_TargetName)
										TN_InputName = TN_TargetName
										TN_NoteBox:SetFocus()
									end
								
									if TN_TargetName == nil then
										TN_NameBox:SetFocus()
									end
								end
							end)
                   
		TN_NameBox:SetScript("OnEnterPressed",function(s)
								TN_InputName = (s:GetText())
								TN_NoteBox:SetFocus()
							end)
							
		TN_NameBox:SetScript("OnTabPressed",function(s)
								TN_InputName = (s:GetText())
								TN_NoteBox:SetFocus()
							end)
		
		TN_NameBox:SetScript("OnEscapePressed",function(s)
								TN_InputBox:Hide()
							end)
                   
        TN_NameBox:SetScript("OnEditFocusLost", function(s)
								TN_InputName = (s:GetText())
							end)
					
		TN_NameBox:CreateFontString("TN_NameText", OVERLAY, "GameFontNormal")
		TN_NameText:SetPoint("CENTER", "TN_NameBox", -115, 0);
		TN_NameText:SetText("Name:")
		
		--styling frame for the note box
		TN_StyleFrame = CreateFrame("Frame",nil,TN_InputBox,"BackdropTemplate")
		TN_StyleFrame:SetPoint("TOPLEFT", "TN_NameBox", "BOTTOMLEFT", -5, 0);
		TN_StyleFrame:SetSize(160,134)
		TN_StyleFrame:SetBackdrop({
            bgFile = nil, 
			edgeFile = "Interface/Tooltips/UI-Tooltip-Border", 
			tile = false,
			tileSize = 16,
			edgeSize = 16,
			insets = { left = 4, right = 4, top = 4, bottom = 4 }
        })	
		
		--scrollbar for the note box
		TN_ScrollFrame = CreateFrame("ScrollFrame","TN_NoteBoxScrollFrame",TN_StyleFrame,"UIPanelScrollFrameTemplate")
		TN_ScrollFrame:SetPoint("CENTER", "TN_StyleFrame", 0, 0);
		TN_ScrollFrame:SetSize(150,120)

		--note box
		TN_NoteBox = CreateFrame("EditBox","TN_NoteBox",TN_ScrollFrame,"BackdropTemplate")
		TN_NoteBox:SetMultiLine(true)
		TN_NoteBox:SetPoint("CENTER", "TN_ScrollFrame", "CENTER", 100, 5);
		TN_NoteBox:SetWidth(150)
		TN_NoteBox:SetFontObject(ChatFontNormal)
		
		TN_ScrollFrame:SetScrollChild(TN_NoteBox)
			
		TN_ScrollFrame:SetScript("OnMouseDown",function(s)
								TN_NoteBox:SetFocus()
							end)	
							
        TN_NoteBox:SetScript("OnShow", function(s)
								TN_NoteBox:SetText("")
								if TN_TargetName ~= nil then
									TN_NoteBox:SetFocus()
			
								end
								if TN_FunctionUsed == true and TN_TargetName ~= nil then
									TN_NoteBox:SetText("")
									if TN_Database[TN_TargetName] then
										TN_NoteBox:SetText(TN_Database[TN_TargetName])
									end
								end
							end)
							
							
		TN_NoteBox:SetScript("OnTabPressed",function(s)
								TN_NameBox:SetFocus()
							end)
		
		TN_NoteBox:SetScript("OnEscapePressed",function(s)
								TN_InputBox:Hide()
							end)
												
        TN_NoteBox:SetScript("OnEditFocusGained", function(s)
								TN_InputNote = (s:GetText())
								if TN_InputName == nil then
									TN_NoteBox:SetText("")
								end
								if TN_InputNote == "" or TN_InputNote == nil then
									if TN_Database[TN_InputName] then
										TN_NoteBox:SetText("")
										TN_NoteBox:SetText(TN_Database[TN_InputName])
									end
								end
									if TN_FunctionUsed == true and TN_TargetName ~= nil then
										if TN_Database[TN_TargetName] ~= nil then
											TN_NoteBox:SetText("")
											TN_NoteBox:SetText(TN_Database[TN_TargetName])
										else TN_NoteBox:SetText("")
										end
									end
								--TN_FunctionUsed = false
							end)
	
		TN_InputBox:CreateFontString("TN_NoteText", OVERLAY, "GameFontNormal")
		TN_NoteText:SetPoint("TOPLEFT", "TN_NameText", "BOTTOMLEFT", 0, -5);
		TN_NoteText:SetText("Note:")	
			
		--Button to save the current note
		local button = CreateFrame("Button","TN_SaveButton",TN_InputBox)
		button:SetPoint("BOTTOM", TN_InputBox, "BOTTOM", 0, 60)
		button:SetWidth(75)
		button:SetHeight(25)
		
		button:SetText("Save Note")
		button:SetNormalFontObject("GameFontNormal")
		
		button:SetScript("OnClick", function()
					    TN_SavingNote = (TN_NoteBox:GetText())
						TN_SavingName = TN_NameBox:GetText()
							if TN_SavingName ~= "" then
								
								for i = 1,8 do
									TN_SavingNote = string.gsub(TN_SavingNote,"{rt"..i.."}",ICON_LIST[i].."0|t")
								end
								
								TN_Database[strtrim(TN_SavingName)] = TN_SavingNote
								TN_InputBox:Hide()
								UIErrorsFrame:AddMessage("Note Saved", 255, 209, 0)
							else
								UIErrorsFrame:AddMessage("You cannot save a note without a name.", 255, 0, 0)
								TN_NameBox:SetFocus()
							end
						end)
		
		local ntex = button:CreateTexture()
		ntex:SetTexture("Interface/Buttons/UI-Panel-Button-Up")
		ntex:SetTexCoord(0, 0.625, 0, 0.6875)
		ntex:SetAllPoints()	
		button:SetNormalTexture(ntex)
		
		local htex = button:CreateTexture()
		htex:SetTexture("Interface/Buttons/UI-Panel-Button-Highlight")
		htex:SetTexCoord(0, 0.625, 0, 0.6875)
		htex:SetAllPoints()
		button:SetHighlightTexture(htex)
		
		local ptex = button:CreateTexture()
		ptex:SetTexture("Interface/Buttons/UI-Panel-Button-Down")
		ptex:SetTexCoord(0, 0.625, 0, 0.6875)
		ptex:SetAllPoints()
		button:SetPushedTexture(ptex)
		
		--Button to close the interface panel
		local button = CreateFrame("Button","TN_CancelButton",TN_InputBox)
		button:SetPoint("CENTER", TN_SaveButton, "CENTER", 75, 0)
		button:SetWidth(75)
		button:SetHeight(25)
		
		button:SetText("Cancel")
		button:SetNormalFontObject("GameFontNormal")
		
		button:SetScript("OnClick", function()
					TN_InputBox:Hide()
					end)
		
		local ntex = button:CreateTexture()
		ntex:SetTexture("Interface/Buttons/UI-Panel-Button-Up")
		ntex:SetTexCoord(0, 0.625, 0, 0.6875)
		ntex:SetAllPoints()	
		button:SetNormalTexture(ntex)
		
		local htex = button:CreateTexture()
		htex:SetTexture("Interface/Buttons/UI-Panel-Button-Highlight")
		htex:SetTexCoord(0, 0.625, 0, 0.6875)
		htex:SetAllPoints()
		button:SetHighlightTexture(htex)
		
		local ptex = button:CreateTexture()
		ptex:SetTexture("Interface/Buttons/UI-Panel-Button-Down")
		ptex:SetTexCoord(0, 0.625, 0, 0.6875)
		ptex:SetAllPoints()
		button:SetPushedTexture(ptex)
		
		--Button to clear the input boxes
		local button = CreateFrame("Button","TN_CancelButton",TN_InputBox)
		button:SetPoint("CENTER", TN_SaveButton, "CENTER", -75, 0)
		button:SetWidth(75)
		button:SetHeight(25)
		
		button:SetText("Clear")
		button:SetNormalFontObject("GameFontNormal")
		
		button:SetScript("OnClick", function()
						TN_NoteBox:SetText("")
						TN_NoteBox:SetFocus()
						end)
		
		local ntex = button:CreateTexture()
		ntex:SetTexture("Interface/Buttons/UI-Panel-Button-Up")
		ntex:SetTexCoord(0, 0.625, 0, 0.6875)
		ntex:SetAllPoints()	
		button:SetNormalTexture(ntex)
		
		local htex = button:CreateTexture()
		htex:SetTexture("Interface/Buttons/UI-Panel-Button-Highlight")
		htex:SetTexCoord(0, 0.625, 0, 0.6875)
		htex:SetAllPoints()
		button:SetHighlightTexture(htex)
		
		local ptex = button:CreateTexture()
		ptex:SetTexture("Interface/Buttons/UI-Panel-Button-Down")
		ptex:SetTexCoord(0, 0.625, 0, 0.6875)
		ptex:SetAllPoints()
		button:SetPushedTexture(ptex)
		
		--Checkbox frames/text			
		TN_InputBox:CreateFontString("TN_CheckBoxText", OVERLAY, "GameFontNormal")
		TN_CheckBoxText:SetPoint("CENTER", "TN_SaveButton", 0, -20);
		TN_CheckBoxText:SetText("Shift-clicking a player's name in chat:")
		
		TN_InputBox:CreateFontString("TN_ShowFrameText", OVERLAY, "GameFontNormal")
		TN_ShowFrameText:SetPoint("LEFT","TN_CheckBoxText", 0, -15);
		TN_ShowFrameText:SetText("Opens this menu:")
		
		TN_InputBox:CreateFontString("TN_ShowPrintText", OVERLAY, "GameFontNormal")
		TN_ShowPrintText:SetPoint("LEFT","TN_ShowFrameText", 0, -15);
		TN_ShowPrintText:SetText("Shows the player's note in chat:")
		
		f=TN_ShowFrameCheckBox or CreateFrame("CheckButton", "TN_ShowFrameCheckBox", TN_InputBox, "ChatConfigCheckButtonTemplate");
		f:SetPoint("RIGHT","TN_ShowFrameText", 23, -1);
		f:SetScript("OnClick", function()
					isChecked = TN_ShowFrameCheckBox:GetChecked()
						if isChecked == true then
							TN_ShowFrameOnClick = true
						end
						if isChecked == false then
							TN_ShowFrameOnClick = false
						end
					end)

			
		if TN_ShowFrameOnClick == true then
			TN_ShowFrameCheckBox:SetChecked(true)
		end

					
		f=TN_ShowPrintCheckBox or CreateFrame("CheckButton", "TN_ShowPrintCheckBox", TN_InputBox, "ChatConfigCheckButtonTemplate");
		f:SetPoint("RIGHT","TN_ShowPrintText", 23, -1);
		f:SetScript("OnClick", function()
					isChecked = TN_ShowPrintCheckBox:GetChecked()
						if isChecked == true then
							TN_ShowPrintOnClick = true
						end
						if isChecked == false then
							TN_ShowPrintOnClick = false
						end
					end)
					
		if TN_ShowPrintOnClick == true then
			TN_ShowPrintCheckBox:SetChecked(true)
		end

		TN_InputBox:Hide()
end)

SLASH_TN_Commands1 = "/tn"
SlashCmdList["TN_Commands"] = function(msg)
	
	TN_TargetName = UnitName("target")
	TN_FunctionUsed = true
	TN_NameBox:ClearFocus()
	TN_InputBox:Show()
	--print("TN_TargetName:" .. tostring(TN_TargetName))
	--print("TN_FunctionUsed: " .. tostring(TN_FunctionUsed))
	if TN_FunctionUsed == true then
		TN_NameBox:SetFocus()
	end
end

local function testDropdownMenuButton(self)
	if self.value == "TN_MenuButton" then
		TN_FunctionUsed = true
		TN_NameBox:ClearFocus()
		TN_InputBox:Show()
		--print(TN_TargetName)
		--print(TN_FunctionUsed)
		if TN_FunctionUsed == true then
			TN_NameBox:SetFocus()
		end
	end
end


hooksecurefunc("ChatFrame_OnHyperlinkShow", function(chatFrame, link, text, button)
if (IsModifiedClick("CHATLINK")) then
  if (link and button) then

    local args = {};
    for v in string.gmatch(link, "[^:]+") do
      table.insert(args, v);
    end
		if (args[1] and args[1] == "player") then
			args[2] = Ambiguate(args[2], "short")
			TN_TargetName = args[2]
			TN_FunctionUsed = true
			TN_NameBox:ClearFocus()
			if TN_ShowFrameOnClick == true then
				TN_NameBox:ClearFocus()
				TN_InputBox:Show()
				if TN_FunctionUsed == true then
					TN_NameBox:SetFocus()
				end
			end
			if TN_InputName == "" or TN_InputName == nil then
				TN_NameBox:ClearFocus()
				if TN_FunctionUsed == true then
					TN_NameBox:SetFocus()
				end
			else
				TN_FunctionUsed = false
			end
			if TN_ShowPrintOnClick == true then
				if TN_Database[TN_TargetName] and TN_Database[TN_TargetName] ~= "" then
					DEFAULT_CHAT_FRAME:AddMessage('Note on ' .. TN_TargetName .. ':\n' .. TN_Database[TN_TargetName] , 255, 209, 0)
				end
			end
		end
	end
end
end)

hooksecurefunc("UnitPopup_ShowMenu", function(dropdownMenu, which, unit, name, userData)

TN_TargetName = dropdownMenu.name
	
	if (UIDROPDOWNMENU_MENU_LEVEL > 1) then
	return
	end
		local info = UIDropDownMenu_CreateInfo()
			info.text = "Edit Tooltip Note"
			info.owner = which
			info.notCheckable = 1
			info.func = testDropdownMenuButton 
			info.value = "TN_MenuButton"
			UIDropDownMenu_AddButton(info)
end)

GameTooltip:HookScript("OnTooltipSetUnit", function(self)
  local _, unit = self:GetUnit()
  if UnitExists(unit) then
    TN_MouseoverName = UnitName(unit)
    if TN_Database[TN_MouseoverName] and TN_Database[TN_MouseoverName] ~= "" then
        GameTooltip:AddLine(TN_Database[TN_MouseoverName], 255, 209, 0)
        GameTooltip:Show()
    end
  end
end)

local Addon_EventFrame = CreateFrame("Frame")
Addon_EventFrame:RegisterEvent("ADDON_LOADED")
Addon_EventFrame:SetScript("OnEvent",
	function(self, event, addon)
		if addon == "TooltipNotes" then
			TN_Database = TN_Database or {}
		end
end)