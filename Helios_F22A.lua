
--[[	
												GENERIC INTERFACE ELEMENTS TABLE

QUANTITY		TYPE							NAME		 DEVICE		  BUTTON			   SEND ID		FORMAT			VALUES
																				
	199		Network Values					NetworkValue 				   		   			   1 to 199		%0.3f		numeric
	199		FlagValues						FlagValue 					 					1001 to 1199	%1d			0,1
	199		PushButtons 					PB 					1		3001 to 3199		2001 to 2199	%0.1f		0.0,1.0
	249		Toggle switches 				TSwitch 			2		3001 to 3249		3001 to 3249  	%1d			1,0
	249		Toggles witches B				TSwitch_B 			12		3001 to 3249		4001 to 4249  	%1d			1,-1
	99		Three way switches A			3WSwitch_A 			3		3001 to 3099		5001 to 5099 	%1d			1,0,-1
	99		Three way switches B			3WSwitch_B 			3		3101 to 3199		5101 to 5199 	%0.1f		0.0,0.1,0.2
	99		Three way switches C			3WSwitch_C 			3		3201 to 3299		5201 to 5299 	%0.1f		0,0.5,1
	99		Axis A							Axis_A 				4		3001 to 3099		6001 to 6099 	%0.2f		0.1
	99		Axis B 							Axis_B 				4		3101 to 3199		6101 to 6199 	%0.2f		0.05
	49		Multiposition Switch 6 pos 		Multi6PosSwitch 	5		3001 to 3049		7001 to 7049  	%0.1f		0.0,0.1,0.2,0.3,0.4,0.5
	49		Multiposition Switch 11 pos		Multi11PosSwitch	5		3051 to 3099	 	7051 to 7099  	%0.1f		0.0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0
	20		Multiposition Switch 21	pos		Multi21PosSwitch	5		3101 to 3120	 	7101 to 7120  	%0.2f		0.0,0.05,0.1,0.15,0.2,0.25,0.3,0.35,0.4,0.45,0.5,0.55,0.6,0.65,0.7,0.75,0.8,0.85,0.9,0.95,1.0
	49		Rocker A						Rocker_A 			7		3001 to 3049		8001 to 8049 	%1d			ABCC
	49		Rocker B						Rocker_B 			8		3050 to 3099		8050 to 8099 	%1d			ABAB
	49		Rocker C						Rocker_C 			10		3101 to 3149		8101 to 8149 	%1d			AABB
	49		Rotator Encoder A 				RotEncoder_A 		9		3001 to 3049		9001 to 9049 	%0.2f		0.1
	49		Rotator Encoder B 				RotEncoder_B 		9		3051 to 3099		9051 to 9099 	%0.2f		0.05
	99		Indicator Push Button			Ind_PButton 		11		3001 to 3099	   10001 to 10099	%0.1f		0.0,0.1 / 0,1




Usefull functions:

Helios_Util.ValueConvert(value,{0, 0.37, 1},{-1, 0.0, 1.0}) convert the value from one input scale to output scale, Used in non lineal instruments values 
Helios_Util.Convert_Lamp (value)    convert value to 1 if value is bigger than 0.1, Usually used for lamps values
Helios_Util.Split(string,",")   split a string into several string using the character as divider
Helios_Util.GetListIndicator(value)   return the strings on the indicator
]]--




Helios_F22A = {} -- replace the name of this array with the name of your airplane, for example: Helios_F-5E

Helios_F22A.Name = "F-22A" -- this is the internal name of the airplane in DCS, you need to found it! for the F-5E for example is "F-5E-3"
											   -- You can use several names separated by ; in case you want to use the profile for several models of the airplane, for example "L-39C;L-39ZA" 
Helios_F22A.FlamingCliffsAircraft = false

Helios_F22A.ExportArguments = {}


----------------------------------------------------------------------- SEND HIGHT IMPORTANCE DATA TO HELIOS
--- usually to send instruments data and lamps

function Helios_F22A.HighImportance(data)

	local MainPanel = GetDevice(0)

	-- Pilot console instruments
		--Helios_Udp.Send("1", string.format("%0.3f",  MainPanel:get_argument_value(7) ) )
	



	Helios_Udp.Flush()
end

----------------------------------------------------------------------- SEND LOW IMPORTANCE DATA TO HELIOS
---- usually to send switches, levers, buttons etc

function Helios_F22A.LowImportance(MainPanel)

	-- switches
		--Helios_Udp.Send("3001", string.format("%1d", MainPanel:get_argument_value(497) ) ) -- Standby Generator Switch, ON/OFF >> TSwitch_1

		Helios_Udp.Send("5001", string.format("%1d",  MainPanel:get_argument_value(701))) -- APU
		Helios_Udp.Send("3001", string.format("%1d",  MainPanel:get_argument_value(700))) -- BATTERY_PNT
		Helios_Udp.Send("3002", string.format("%1d",  MainPanel:get_argument_value(702))) -- LGEN_PNT
		Helios_Udp.Send("3003", string.format("%1d",  MainPanel:get_argument_value(703))) -- RGEN_PNT

		Helios_Udp.Send("3004", string.format("%1d",  MainPanel:get_argument_value(999))) -- Left Engine Start
		Helios_Udp.Send("3005", string.format("%1d",  MainPanel:get_argument_value(999))) -- Right Engine Start



	Helios_Udp.Flush()
end


------------------------------------------------------------------------ SEND OUTPUT VALUES TO DCS TABLE
--  Format:
--  Helios_F22A.ExportArguments["GENERIC DEVICE,GENERIC BUTTON"] ="AIRPLANE DEVICE, AIRPLANE BUTTON,MULTIPLIER"
--  arguments with multiplier >100  are special conversion cases, and are computed in different way, you can see the convertion data in the function bellow


	--Helios_F22A.ExportArguments["1,3001"] ="1, 3022,1" --  CB Group 1 ON    882

	--F22-A Device Ids
	--AVIONICS			 --01
	--ELECTRICAL_SYSTEM	 --02
	--ENGINE_SYSTEM		 --03
	--WEAPON_SYSTEM	 	 --04
	--MFD_SYSTEM		 --05
	--PMFD_SYSTEM	 	 --06
	--ICP_SYSTEM		 --07
	--FCS	  		 	 --08
	--CLOCK_GMT		 	 --09
	--CLOCK_LOCAL		 --10
	--MISSION_TIMER	 	 --11
	--NAVIGATION		 --12

	Helios_F22A.ExportArguments["3,3001"] ="3, 3002,1" --  APU Switch 701 3002
	Helios_F22A.ExportArguments["2,3001"] ="3, 3001,1" --  BATTERY_PNT 3001
	Helios_F22A.ExportArguments["2,3002"] ="3, 3003,1" --  LGEN_PNT 3003
	Helios_F22A.ExportArguments["2,3003"] ="3, 3004,1" --  RGEN_PNT 3004
	Helios_F22A.ExportArguments["2,3004"] ="3, 3009,1" --  L_ENG 
	Helios_F22A.ExportArguments["2,3005"] ="3, 3010,1" --  R_ENG 

	--Center MFD Buttons

	Helios_F22A.ExportArguments["1,3001"] ="5, 3041,1" -- OSB OB1
	Helios_F22A.ExportArguments["1,3002"] ="5, 3042,1" -- OSB OB2
	Helios_F22A.ExportArguments["1,3003"] ="5, 3043,1" -- OSB OB3
	Helios_F22A.ExportArguments["1,3004"] ="5, 3044,1" -- OSB OB4
	Helios_F22A.ExportArguments["1,3005"] ="5, 3045,1" -- OSB OB5
	Helios_F22A.ExportArguments["1,3006"] ="5, 3046,1" -- OSB OB6
	Helios_F22A.ExportArguments["1,3007"] ="5, 3047,1" -- OSB OB7
	Helios_F22A.ExportArguments["1,3008"] ="5, 3048,1" -- OSB OB8
	Helios_F22A.ExportArguments["1,3009"] ="5, 3049,1" -- OSB OB9
	Helios_F22A.ExportArguments["1,3010"] ="5, 3050,1" -- OSB OB10
	Helios_F22A.ExportArguments["1,3011"] ="5, 3051,1" -- OSB OB11
	Helios_F22A.ExportArguments["1,3012"] ="5, 3052,1" -- OSB OB12
	Helios_F22A.ExportArguments["1,3013"] ="5, 3053,1" -- OSB OB13
	Helios_F22A.ExportArguments["1,3014"] ="5, 3054,1" -- OSB OB14
	Helios_F22A.ExportArguments["1,3015"] ="5, 3055,1" -- OSB OB15
	Helios_F22A.ExportArguments["1,3016"] ="5, 3056,1" -- OSB OB16
	Helios_F22A.ExportArguments["1,3017"] ="5, 3057,1" -- OSB OB17
	Helios_F22A.ExportArguments["1,3018"] ="5, 3058,1" -- OSB OB18
	Helios_F22A.ExportArguments["1,3019"] ="5, 3059,1" -- OSB OB19
	Helios_F22A.ExportArguments["1,3020"] ="5, 3060,1" -- OSB OB20


	-- PMFD Buttons
	Helios_F22A.ExportArguments["1,3021"] ="6, 3001,1" -- OSB OB1
	Helios_F22A.ExportArguments["1,3022"] ="6, 3002,1" -- OSB OB2
	Helios_F22A.ExportArguments["1,3023"] ="6, 3003,1" -- OSB OB3
	Helios_F22A.ExportArguments["1,3024"] ="6, 3004,1" -- OSB OB4
	Helios_F22A.ExportArguments["1,3025"] ="6, 3005,1" -- OSB OB5
	Helios_F22A.ExportArguments["1,3026"] ="6, 3006,1" -- OSB OB6
	Helios_F22A.ExportArguments["1,3027"] ="6, 3007,1" -- OSB OB7
	Helios_F22A.ExportArguments["1,3028"] ="6, 3008,1" -- OSB OB8
	Helios_F22A.ExportArguments["1,3029"] ="6, 3009,1" -- OSB OB9
	Helios_F22A.ExportArguments["1,3030"] ="6, 3010,1" -- OSB OB10
	Helios_F22A.ExportArguments["1,3031"] ="6, 3011,1" -- OSB OB11
	Helios_F22A.ExportArguments["1,3032"] ="6, 3012,1" -- OSB OB12
	Helios_F22A.ExportArguments["1,3033"] ="6, 3013,1" -- OSB OB13
	Helios_F22A.ExportArguments["1,3034"] ="6, 3014,1" -- OSB OB14
	Helios_F22A.ExportArguments["1,3035"] ="6, 3015,1" -- OSB OB15
	Helios_F22A.ExportArguments["1,3036"] ="6, 3016,1" -- OSB OB16
	Helios_F22A.ExportArguments["1,3037"] ="6, 3017,1" -- OSB OB17
	Helios_F22A.ExportArguments["1,3038"] ="6, 3018,1" -- OSB OB18
	Helios_F22A.ExportArguments["1,3039"] ="6, 3019,1" -- OSB OB19
	Helios_F22A.ExportArguments["1,3040"] ="6, 3020,1" -- OSB OB20

	--ICP Buttons

	Helios_F22A.ExportArguments["7,3041"] ="5, 3001,1" -- ICP_COM1_PNT
	Helios_F22A.ExportArguments["7,3042"] ="5, 3002,1" -- ICP_COM2_PNT
	Helios_F22A.ExportArguments["7,3043"] ="5, 3003,1" -- ICP_NAV_PNT
	Helios_F22A.ExportArguments["7,3044"] ="5, 3004,1" -- ICP_STPT_PNT
	Helios_F22A.ExportArguments["7,3045"] ="5, 3005,1" -- ICP_ALT_PNT
	Helios_F22A.ExportArguments["7,3046"] ="5, 3006,1" -- ICP_HUD_PNT
	Helios_F22A.ExportArguments["7,3047"] ="5, 3007,1" -- ICP_OTHR_PNT
	Helios_F22A.ExportArguments["7,3048"] ="5, 3008,1" -- ICP_OP1_PNT
	Helios_F22A.ExportArguments["7,3049"] ="5, 3009,1" -- ICP_OP2_PNT
	Helios_F22A.ExportArguments["7,3050"] ="5, 3010,1" -- ICP_OP3_PNT
	Helios_F22A.ExportArguments["7,3051"] ="5, 3011,1" -- ICP_OP4_PNT
	Helios_F22A.ExportArguments["7,3052"] ="5, 3012,1" -- ICP_OP5_PNT
	Helios_F22A.ExportArguments["7,3053"] ="5, 3013,1" -- ICP_UP_PNT
	Helios_F22A.ExportArguments["7,3054"] ="5, 3014,1" -- ICP_DWN_PNT
	Helios_F22A.ExportArguments["7,3055"] ="5, 3015,1" -- ICP_AP_PNT
	Helios_F22A.ExportArguments["7,3056"] ="5, 3016,1" -- unused
	Helios_F22A.ExportArguments["7,3057"] ="5, 3017,1" -- ICP_1_PNT
	Helios_F22A.ExportArguments["7,3058"] ="5, 3018,1" -- ICP_2_PNT
	Helios_F22A.ExportArguments["7,3059"] ="5, 3019,1" -- ICP_3_PNT
	Helios_F22A.ExportArguments["7,3060"] ="5, 3020,1" -- ICP_4_PNT
	Helios_F22A.ExportArguments["7,3061"] ="5, 3021,1" -- ICP_5_PNT
	Helios_F22A.ExportArguments["7,3062"] ="5, 3022,1" -- ICP_6_PNT
	Helios_F22A.ExportArguments["7,3063"] ="5, 3023,1" -- ICP_7_PNT
	Helios_F22A.ExportArguments["7,3064"] ="5, 3024,1" -- ICP_8_PNT
	Helios_F22A.ExportArguments["7,3065"] ="5, 3025,1" -- ICP_9_PNT
	Helios_F22A.ExportArguments["7,3066"] ="5, 3026,1" -- ICP_CLR_PNT
	Helios_F22A.ExportArguments["7,3067"] ="5, 3027,1" -- ICP_0_PNT
	Helios_F22A.ExportArguments["7,3068"] ="5, 3028,1" -- ICP_UNDO_PNT






------------------------------------------------------------------------ PROCESS INPUT DATA
function Helios_F22A.ProcessInput(data)
    local lCommand, lCommandArgs, lDevice, lArgument, lLastValue
    local sIndex, lConvDevice
	local valor_axis, absoluto, min_clamp
	
	lCommand = string.sub(data,1,1)
	
	if lCommand == "R" then
		Helios_Udp.ResetChangeValues()
	end

	if (lCommand == "C") then
		lCommandArgs = Helios_Util.Split(string.sub(data,2),",")
		sIndex = lCommandArgs[1]..","..lCommandArgs[2]
		lConvDevice = Helios_F22A.ExportArguments[sIndex] 	
		lArgument = Helios_Util.Split(string.sub(lConvDevice,1),",")
		min_clamp = 0
		max_clamp = 1
		
				
		lDevice = GetDevice(lArgument[1])    -- data conversions between switches extended and the NewAirplane
		if type(lDevice) == "table" then
		
			if lArgument[3]=="100" then   -- convert 0.2 0.1 0.0 to 1 0 -1
			 local temporal= lCommandArgs[3]
				lCommandArgs[3] = ((temporal)*10)-1
				lArgument[3] = 1
			end
			if lArgument[3]=="101" then   -- convert 1 0.5 0.0 to 1 0 -1
			 local temporal= lCommandArgs[3]
				lCommandArgs[3] = (temporal*2)-1
				lArgument[3] = 1
			end
			if lArgument[3]=="102" then   -- convert 1 0 to 1 -1
			 local temporal= lCommandArgs[3]
				lCommandArgs[3] = (temporal*2)-1
				lArgument[3] = 1
			end
			if lArgument[3]=="103" then   -- convert 1 0 -1 to 1 0.5 0.0
			 local temporal= lCommandArgs[3]
				lCommandArgs[3] = (temporal+1)/2
				lArgument[3] = 1
			end
			if lArgument[3]=="104" then   -- convert 0.2 0.1 0.0 to 0.2 0.1 0.3
			 --local temporal= lCommandArgs[3]

				if lCommandArgs[3] <= "0.05" then
				 lCommandArgs[3] = 0.3
				end
				lArgument[3] = 1
			end
			if lArgument[3]=="105" then   -- convert 0.0 0.1 0.2 0.3 0.4  to -0.1 0.0 0.1 0.2 0.3
			 local temporal= lCommandArgs[3]
				lCommandArgs[3] = temporal - 0.1
				lArgument[3] = 1
				
			end
			if lArgument[3]=="106" then   -- convert 0.2 0.1 0.0  to 1.0 0.5 0.0
			 local temporal= lCommandArgs[3]
				lCommandArgs[3] = temporal*5
				lArgument[3] = 1
				
			end
			
			lDevice:performClickableAction(lArgument[2],lCommandArgs[3]*lArgument[3])
		end
	end
end










