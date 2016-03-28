local remote = Instance.new("RemoteEvent", game.ReplicatedStorage);
local service = game:GetService("DataStoreService"):GetGlobalDataStore();
remote.Name = "DataStore";
local count, set = 500, 0;
remote.OnServerEvent:connect(function(player, tab)
	if tab[2] == "Comment" then
		if count == 0 then wait(tick()-set) end; -- prevents overloading..
		local update = tab[3];
		local tab2 = service:GetAsync("Comments: "..tab[1]);

		local dataUpdate = function(tab3)
			print(#tab3);
			table.insert(tab3, update);
			print(#tab3)
			return tab3;
		end;
		
		if not(tab2) then
			if #update < 260000 then -- shouldn't really be an issue; will warn nonetheless.
				service:SetAsync("Comments: "..tab[1], {update});
				else error("Tried to update with too many characters. - Flatline115")
			end;
			else
			if #table.concat(tab2, "") + #update >= 260000 then
				error("Comments overfilled; Deleting oldest comments - Flatline115");
				while #table.concat(tab2, "") + #update >= 260000  do
					tab[1] = nil;
					wait(0.1);
				end;
				service:UpdateAsync("Comments: "..tab[1], dataUpdate);
			else
				service:UpdateAsync("Comments: "..tab[1], dataUpdate);
			end;
		end;
		
		elseif tab[2] == "LoadComments" then
			local info = service:GetAsync("Comments: "..tab[1]);
			remote:FireClient(player, info);
	end;
	
	
end);

while wait(60) do 
	count = 500  
	set = tick() 
end;