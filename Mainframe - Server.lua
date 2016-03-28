local remote = Instance.new("RemoteEvent", game.ReplicatedStorage);
local service = game:GetService("DataStoreService"):GetGlobalDataStore();
remote.Name = "DataStore";
local count, set = 500, 0;
remote.OnServerEvent:connect(function(player, tab)
	if tab[2] == "Comment" then
		if count == 0 then wait(tick()-set) end; -- prevents overloading..
		local update = [["]]..tab[3][[" -]]..player.Name;
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
			remote:FireClient(player, {"Comments", info});
			
	elseif tab[2] == "Set_Count" then
		service:SetAsync("Goal_Amount", tab[1]);
		
	elseif tab[2] == "GetVet" then
		local data = service:GetAsync("Vet: "..tab[1]) or 0;
		local needed = service:GetAsync("Goal_Amount");
		if not(data == 0) then
			data = (data/needed) * 100
		end;
		remote:FireServer(player, {"Vet", data.."%"});
		
	elseif tab[2] == "AddVet" then
		local vet = service:GetAsync("Vet: "..tab[1]);
		if not vet then
			service:SetAsync("Vet: "..tab[1], 1);	
				else
			service:UpdateAsync("Vet: "..tab[1], function(oKey)
				return oKey + 1;
			end);
					
		end;
	end;
	
	
end);

while wait(60) do 
	count = 500  
	set = tick() 
end;