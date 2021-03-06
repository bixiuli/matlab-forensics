function[BelT, PlT, BelN, PlN, Confl] = FiveToolFusion_NewIdea(A, Ra, B, Rb, C, Rc, D, Rd, E, Re, Apar, Bpar, Cpar, Dpar, Epar)%, plotFlag)
%CASO DI STUDIO: vedi M_5tools_ABCDE.bba
%A: detection del tool Double JPEG (Ta)
%B: detection del tool Single JPEG (Tb)
%C: detection del tool JPEG Ghost (Tc)
%D: detection del tool JPNA (Td)
%E: detecion del tool JPDQ (Te)

%Ra, Rb, Rc, Rd, Re confidenza a priori sui tool
%plotFlag: set to 'd' if you want to display the image, 's' to save figure,
%'n' to disable
%warning off
%Mapping from A -> AT,AN,ATN and the same for other variables...
%Mapping from Ra -> AR,AU,ARU and the same for other variables...

AR = Ra;
AN = 1-Ra;
BR = Rb;
BN = 1-Rb;
CR = Rc;
CN = 1-Rc;
DR = Rd;
DN = 1-Rd;
ER = Re;
EN = 1-Re;

%assert( (D<=1 && Rd<=1 && S<=1 && Rs<=1 && G<=1 && Rg<=1), 'Impossible probability assignment!');

% if nargin<7
%     Th.DJPG = 0.5;
%     Th.JPCH = 0.5;
%     Th.JPGH = 0.4;
%     Th.JPNA = 0.4;
%     Th.JPDQ = 0.5;
% else
%     Th.DJPG = ThDSG(1);
%     Th.JPCH = ThDSG(2);
%     Th.JPGH = ThDSG(3);
%     Th.JPNA = ThDSG(4);
%     Th.JPDQ = ThDSG(5);
% end

  display('Using TRAPEZOID-based BBA assignment');
% CURVES FOR INTERNAL-REGION-ONLY APPROACH
%     [AT, AN, ATN] = responseMapper_TRAP(A, 0, 0.5, 0.9,  1, 0.45);
%     [BT, BN, BTN] = responseMapper_TRAP(B, 0, 0.4, 0.95, 1, 0.45);
%     [CT, CN, CTN] = responseMapper_TRAP(C, 0, 0.35, 0.6, 1, 0.45);
%     [DT, DN, DTN] = responseMapper_TRAP(D, 0, 0.28, 0.4, 1, 0.1);
%     [ET, EN, ETN] = responseMapper_TRAP(E, 0, 0.63, 0.87,1, 0.1);

% CURVES FOR DIFFERENTIAL APPROACH
    [AT, AN, ATN] = responseMapper_TRAP(A, Apar(1), Apar(2), Apar(3),  Apar(4), Apar(5));    
    [BT, BN, BTN] = responseMapper_TRAP(B, Bpar(1), Bpar(2), Bpar(3),  Bpar(4), Bpar(5));
    [CT, CN, CTN] = responseMapper_TRAP(C, Cpar(1), Cpar(2), Cpar(3),  Cpar(4), Cpar(5));
    [DT, DN, DTN] = responseMapper_TRAP(D, Dpar(1), Dpar(2), Dpar(3),  Dpar(4), Dpar(5));        
    [ET, EN, ETN] = responseMapper_TRAP(E, Epar(1), Epar(2), Epar(3),  Epar(4), Epar(5));

    
CA = (1 - (AR .* AT + AR .* AN));
CB = (1 - (BR .* BT + BR .* BN));
CC = (1 - (CR .* CT + CR .* CN));
CD = (1 - (DR .* DT + DR .* DN));
CE = (1 - (ER .* ET + ER .* EN));

BBA = BBAparser('ABCDE_Tab.bba');

BelT = eval(getBelief(BBA, ...
    {...
    '(ta, tb, tc)';...
    '(ta, nb, nc)';...
    '(na, tb, tc)';...
    '(na, nb, tc)';...
    }));

BelN = eval(getBelief(BBA, ...
    {...
    '(na, nb, nc)';...
    }));

PlT = 1 - BelN;

PlN = 1 - BelT;
Confl = eval(BBA.K);
% fprintf('--------- Forensic_ICIP.m ---------\n');
% display(['Conflict: ',num2str(1-K)]);
% fprintf('Belief-Plausibility ranges are:\n');
% display(['T = [',num2str(BelT,3),' , ',num2str(PlT,3),']']);
% display(['N = [',num2str(BelN,3),' , ',num2str(PlN,3),']']);
% if nargin>7 && (strcmpi(plotFlag,'d')||strcmpi(plotFlag,'s'))
%     h=bar('v6',[BelT PlT; BelN PlN],'group');
%     set(gca,'XTickLabel',['T';'N']);
%     set(gca,'YLim',[0 1]);
%     legend('Belief', 'Plausibility');
%     title({['D:',num2str(D),'   S:',num2str(S),'   G:',num2str(G)];['Rd:',num2str(Rd),'   Rs:',num2str(Rs),'   Rg:',num2str(Rg)];['--> Conflict = ', num2str(1-K)]},'FontSize',12,'FontWeight','bold');
%     try
%         set(h(1),'facecolor',[K 0 0])
%         set(h(2),'facecolor',[0 0 K])
%         set(h(3),'facecolor',[K 0 0])
%         set(h(4),'facecolor',[0 0 K])
%     catch
%     end
%     %display(['Is tampered: ',num2str(BelT*K)]);
%     if strcmpi(plotFlag,'s')
%         file_name= sprintf('D_%1.2f__S_%1.2f__G_%1.2f__Rd_%1.2f__Rs_%1.2f__Rg_%1.2f',[D S G Rd Rs Rg]);
%         saveas(gca, fullfile('images',['DSMODEL_', file_name, '.png']), 'png');
%     end
% end

end

