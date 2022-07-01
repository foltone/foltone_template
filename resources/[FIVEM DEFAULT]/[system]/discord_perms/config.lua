Config = {
	DiscordToken = "ODA2Mjc3MTMyMjI5NjczMDEx.YBnGGA.8TcZe5HHWbCQN-02s5-Y2pca1Cs",
	GuildId = "797142367404163114",

	-- Format: ["Role Nickname"] = "Role ID" You can get role id by doing \@RoleName
	Roles = {
		["TestRole"] = "Some Role ID" -- This would be checked by doing exports.discord_perms:IsRolePresent(user, "TestRole")
	}
}
