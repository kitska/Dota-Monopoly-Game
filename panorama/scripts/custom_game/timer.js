var parentHUDElements = $.GetContextPanel().GetParent().GetParent().GetParent().FindChild("HUDElements");
$.GetContextPanel().SetParent(parentHUDElements);

function init()
{
	GameEvents.Subscribe('timer_progress', OnTimer)



	var GoldIcon = $.GetContextPanel().FindChildTraverse("GoldIcon");
	var MkbIcon = $.GetContextPanel().FindChildTraverse("MkbIcon");
	var Necro = $.GetContextPanel().FindChildTraverse("NecroWave");

 var text = $.Localize('#talent_disc_gold_info')

	GoldIcon.SetPanelEvent('onmouseover', function() {
    $.DispatchEvent('DOTAShowTextTooltip', GoldIcon, text) });
    
	GoldIcon.SetPanelEvent('onmouseout', function() {
    $.DispatchEvent('DOTAHideTextTooltip', GoldIcon);
});

 var text_mkb = $.Localize('#talent_disc_Mkb_info')

	MkbIcon.SetPanelEvent('onmouseover', function() {
    $.DispatchEvent('DOTAShowTextTooltip', MkbIcon, text_mkb) });
    
	MkbIcon.SetPanelEvent('onmouseout', function() {
    $.DispatchEvent('DOTAHideTextTooltip', MkbIcon);
});


 var text_necro = $.Localize('#necro_wave_tip')

	Necro.SetPanelEvent('onmouseover', function() {
    $.DispatchEvent('DOTAShowTextTooltip', Necro, text_necro) });
    
	Necro.SetPanelEvent('onmouseout', function() {
    $.DispatchEvent('DOTAHideTextTooltip', Necro);
});

}

init();



function MouseOver( panel , skill)
{
		panel.SetPanelEvent('onmouseover', function() {
    $.DispatchEvent('DOTAShowAbilityTooltip', panel, skill) });
    
panel.SetPanelEvent('onmouseout', function() {
    $.DispatchEvent('DOTAHideAbilityTooltip', panel);
});

}


function OnTimer( kv )
{
let units = kv.units
let units_max = kv.units_max
let time = kv.time
let max = kv.max
let name = kv.name
let skills = kv.skills 
let  reward = kv.reward
let  nwave = kv.number 
let gold = kv.gold
let mkb = kv.mkb
let necro = kv.necro
let upgrade = kv.upgrade





let hide = kv.hide 
if (hide == 1)
{

	var timer_panel = $.GetContextPanel().FindChildTraverse("AllTimer");

	if (timer_panel.BHasClass("AllTimer"))
	{
		timer_panel.RemoveClass("AllTimer")
		timer_panel.AddClass("AllTimer_hide")

		$.Schedule(0.4, function (){ timer_panel.style.visibility = "collapse" })


	}

}


	var Timer = $.GetContextPanel().FindChildTraverse("TimerTime");
	var TimerText = $.GetContextPanel().FindChildTraverse("TimerText");
	var EncounterSkill = $.GetContextPanel().FindChildTraverse("EncounterSkill");
	var SkillText = $.GetContextPanel().FindChildTraverse("EncounterSkillText");
	var WaveText = $.GetContextPanel().FindChildTraverse("EncounterWaveText");
	var RewardIcon = $.GetContextPanel().FindChildTraverse("RewardIcon");
	var GoldIcon = $.GetContextPanel().FindChildTraverse("GoldIcon");
	var MkbIcon = $.GetContextPanel().FindChildTraverse("MkbIcon");

	var Necro = $.GetContextPanel().FindChildTraverse("NecroWave")
	var Upgrade = $.GetContextPanel().FindChildTraverse("UpgradeWave")



	if (necro == true)
	{
		Necro.style.visibility = "visible"
	} else 
	{
		Necro.style.visibility = "collapse"
	}


	if (upgrade > 0)
	{
		Upgrade.style.visibility = "visible"
		var UpgradeText  = $.GetContextPanel().FindChildTraverse("UpgradeWaveText")
		if (UpgradeText)
		{
			UpgradeText.text = upgrade
		}

		var text_up = $.Localize('#upgrade_creeps_text') + String(upgrade)*10 + '%'

		Upgrade.SetPanelEvent('onmouseover', function() {
	    $.DispatchEvent('DOTAShowTextTooltip', Upgrade, text_up) });
	    
		Upgrade.SetPanelEvent('onmouseout', function() {
	    $.DispatchEvent('DOTAHideTextTooltip', Upgrade) });


	} else 
	{
		Upgrade.style.visibility = "collapse"
	}


	if (gold == true)
	{
		GoldIcon.style.visibility = "visible"
	} else 
	{
		GoldIcon.style.visibility = "collapse"
	}

	if (mkb == 1)
	{
		MkbIcon.style.visibility = "visible"
	} else 
	{
		MkbIcon.style.visibility = "collapse"
	}

	var SkillIcons = $.GetContextPanel().FindChildTraverse("SkillIcons");


	var SkillText = $.GetContextPanel().FindChildTraverse("EncounterSkillText");
	SkillText.text = $.Localize("#wave_skills")

	var RewardText = $.GetContextPanel().FindChildTraverse("RewardText");

	if (reward !== 0)
	{
		RewardText.text = $.Localize("#wave_reward")


		RewardIcon.style.backgroundImage = 'url("file://{images}/custom_game/icons/wave_icons/' + reward + '.png")';
		RewardIcon.style.backgroundSize = "contain";
	}
	else 
	{
		RewardText.text = ""
		RewardIcon.style.visibility = "collapse"
	}


	var icon = []
	var b_icon = null 
	var b_text = ''

for (var i = 1; i <= 4; i++) 

{
	b_icon = $.GetContextPanel().FindChildTraverse("SkillIcon"+i)
	if (skills[i] != null ) {
	
	b_icon.style.visibility = "visible"
	b_icon.abilityname = skills[i]
	MouseOver(b_icon, skills[i])

   } else 

   {


	b_icon.style.visibility = "collapse"

   }
}


if (time > 0) 
{
	let wave_text = $.Localize('#wave_name')
	WaveText.text =   '[' + String(nwave) + '] ' + wave_text   + ' ' + $.Localize('#wave_name_' + name)
 

var text = ''
var min = String( Math.trunc((max - time)/60) )
var sec_n =  (max - time) - 60*Math.trunc((max - time)/60)  
var sec = String(sec_n)
if (sec_n < 10) 
{
	sec = '0' + sec

}

	text = min  + ':' + sec


	TimerText.text = text
	var number = 0
	number = (time/(max-1)) * 100
	text = String(number)+'%'
	TimerText.style.align = 'right center'
	//if (Timer.BHasClass("TimerTimeGreen"))
	//{
		//Timer.RemoveClass("TimerTimeGreen")
		//Timer.AddClass("TimerTimeRed")
	//}

	if (reward !== 0)
	{

		RewardIcon.style.backgroundImage = 'url("file://{images}/custom_game/icons/wave_icons/' + reward + '.png")';
	}
	Timer.style.width = text
}
else 
{	

		let wave_text = $.Localize('#wave_name_current')
		WaveText.text = '[' + String(nwave) + '] ' + wave_text  + ' ' + $.Localize('#wave_name_' + name)

		//if (Timer.BHasClass("TimerTimeRed"))
		//{
			//Timer.RemoveClass("TimerTimeRed")
			//Timer.AddClass("TimerTimeGreen")
		//}

		text = ''
		text = String(units) + '/' + String(units_max)
		
		TimerText.style.align = 'center center'	
		TimerText.text = text

		var number = 0
		number = (units/(units_max)) * 100
		text = String(number)+'%'
		Timer.style.width = text

}

}	