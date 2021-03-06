function[new_model, varn] = extendModel(old_model, newVariables)
%newVariables: cell array, the i-th row contains:
%-> newVariables{i,1}='A' %(name of the varible)
%-> newVariables{i,2}=1xN cell array, each element is one of the possible values of the variable
%-> Example: newVariable{1}='A'; newVariable{1,2}=[{'ta'};{'na'}];
    
new_model = old_model;
varn=size(newVariables,1);
%while size(newVariables,1)
while varn>1
%    display('recurse');
    [old_model, varn] = extendModel(new_model,newVariables(1:end-1,:));
end
%    display('core');
    el=1;
    for i=1:numel(old_model.EventList)
                tmp = extendEvent(old_model.EventList(i), newVariables{end,2});
                for z=1:size(tmp,1)
                   new_model.EventList(el).EventName = tmp{z};
                   new_model.EventList(el).EventId = el;                   
                   el=el+1;
                end
    end
    
    for i=1:length(new_model.EventList)
        mask = [repmat('0',1, length(new_model.EventList))];
        mask(new_model.EventList(i).EventId)='1';
        new_model.EventList(i).EventMask = mask;
    end
    new_model.Nelev = length(new_model.EventList);
end


function[ext]=extendEvent(event, newVarVal)
    k=1;
    for i=1:size(newVarVal,1)
        %extend name:
        %strip right bracket
            trimmed = strtrim(event.EventName);
            stripped = trimmed(1:end-1);
        %add new value to the end and replace bracket
            ext{k,1} = [stripped, ', ',newVarVal{i},')'];
            k=k+1;         
    end
end