print("Better Respawn > sv_bresp.lua Loaded!")

local nets = {
	"deathscreen_sendDeath",
	"deathscreen_removeDeath",
}

for k,v in pairs(nets) do
	util.AddNetworkString(v)
end

hook.Add("PlayerDeathThink", "NoNormalRespawn", function(ply)
    if not timer.Exists(ply:SteamID().. "respawnTime") then
		if ply:KeyPressed(IN_JUMP) then
			timer.Simple(0.1,function()
				ply:SetPos(SpawnPos)
			end)
		else 
			return
		end
    else
        return false
    end
end)
hook.Add("PlayerDeath", "DeathscreenHandleDeath", function( victim, inflictor, attacker )
	local DeadPly = victim
	SpawnPos = DeadPly:GetPos()
	EmitSound("player/pl_drown1.wav", victim:GetPos(), -1,CHAN_AUTO,1,100,SND_NOFLAGS,100,2)

	net.Start("deathscreen_sendDeath")
	net.Send(victim)
	timer.Create(victim:SteamID() .. "respawnTime", 6, 1, function() end)
end)
hook.Add("PlayerSpawn", "DeathscreenRemove", function(ply)
	net.Start("deathscreen_removeDeath")
	net.Send(ply)	
end)
hook.Add("PlayerDeathSound", "DisableDeathSound", function()
	return true
end)