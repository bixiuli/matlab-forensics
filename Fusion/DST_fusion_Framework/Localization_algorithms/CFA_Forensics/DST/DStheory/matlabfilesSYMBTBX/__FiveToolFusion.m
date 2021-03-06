function[BelT, PlT, BelN, PlN, Confl] = FiveToolFusion(A, Ra, B, Rb, C, Rc, D, Rd, E, Re)%, plotFlag)
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
    [AT, AN, ATN] = responseMapper_TRAP(A, 0, 0.5, 0.9,  1, 0.45);
    [BT, BN, BTN] = responseMapper_TRAP(B, 0, 0.4, 0.95, 1, 0.45);
    [CT, CN, CTN] = responseMapper_TRAP(C, 0, 0.35, 0.6, 1, 0.45);
    [DT, DN, DTN] = responseMapper_TRAP(D, 0, 0.28, 0.4, 1, 0.1);
    [ET, EN, ETN] = responseMapper_TRAP(E, 0, 0.63, 0.87,1, 0.1);
    
CA = (1 - (AR .* AT + AR .* AN));
CB = (1 - (BR .* BT + BR .* BN));
CC = (1 - (CR .* CT + CR .* CN));
CD = (1 - (DR .* DT + DR .* DN));
CE = (1 - (ER .* ET + ER .* EN));

Kold = 1 - ( AR.*AT .* BR.*BN .* CR.*CT + AR.*AN .* BR.*BT .* CR.*CN + CA .* BR.*BT .* CR.*CN + AR.*AT .* BR.*BT .*CR.*CN );

Knew = ...
(AR.*AT .* BR.*BT .* CR.*CT + AR.*AT .* BR.*BT .* CC + AR.*AT .* CB .* CR.*CT) .* DR.*DT .* ER.*EN + ...
(AR.*AT .* BR.*BT .* CR.*CT + AR.*AT .* BR.*BT .* CC + AR.*AT .* CB .* CR.*CT) .* DR.*DN .* ER.*ET + ...
(AR.*AT .* BR.*BT .* CR.*CT + AR.*AT .* BR.*BT .* CC + AR.*AT .* CB .* CR.*CT) .* DR.*DN .* ER.*EN + ...
(AR.*AT .* BR.*BT .* CR.*CT + AR.*AT .* BR.*BT .* CC + AR.*AT .* CB .* CR.*CT) .* DR.*DN .* CE + ...
(AR.*AT .* BR.*BT .* CR.*CT + AR.*AT .* BR.*BT .* CC + AR.*AT .* CB .* CR.*CT) .* CD .* ER.*EN + ... 
(AR.*AT .* BR.*BN .* CR.*CN + AR.*AT .* BR.*BN .* CC + AR.*AT .* CB .* CR.*CN) .* DR.*DT .* ER.*ET +  ...
(AR.*AT .* BR.*BN .* CR.*CN + AR.*AT .* BR.*BN .* CC + AR.*AT .* CB .* CR.*CN) .* DR.*DN .* ER.*ET + ...
(AR.*AT .* BR.*BN .* CR.*CN + AR.*AT .* BR.*BN .* CC + AR.*AT .* CB .* CR.*CN) .* DR.*DN .* ER.*EN + ...
(AR.*AT .* BR.*BN .* CR.*CN + AR.*AT .* BR.*BN .* CC + AR.*AT .* CB .* CR.*CN) .* DR.*DN .* CE + ...
(AR.*AT .* BR.*BN .* CR.*CN + AR.*AT .* BR.*BN .* CC + AR.*AT .* CB .* CR.*CN) .* CD .* ER.*ET + ...
(AR.*AT .* CB .* CC) .* DR.*DT .* ER.*ET +  ...
(AR.*AT .* CB .* CC) .* DR.*DN .* ER.*ET + ...
(AR.*AT .* CB .* CC) .* DR.*DN .* ER.*EN + ...
(AR.*AT .* CB .* CC) .* DR.*DN .* CE + ...
(AR.*AN .* BR.*BT .* CR.*CT + AR.*AN .* BR.*BT .* CC) .* DR.*DT .* ER.*ET + ...
(AR.*AN .* BR.*BT .* CR.*CT + AR.*AN .* BR.*BT .* CC) .* DR.*DT .* ER.*EN + ...
(AR.*AN .* BR.*BT .* CR.*CT + AR.*AN .* BR.*BT .* CC) .* DR.*DT .* CE + ...
(AR.*AN .* BR.*BT .* CR.*CT + AR.*AN .* BR.*BT .* CC) .* DR.*DN .* ER.*EN + ...
(AR.*AN .* BR.*BT .* CR.*CT + AR.*AN .* BR.*BT .* CC) .* CD .* ER.*EN +	 ...
(AR.*AN .* BR.*BN .* CR.*CT + CA .* BR.*BN .* CR.*CT) .* DR.*DT .* ER.*ET + ...
(AR.*AN .* BR.*BN .* CR.*CT + CA .* BR.*BN .* CR.*CT) .* DR.*DT .* ER.*EN + ...
(AR.*AN .* BR.*BN .* CR.*CT + CA .* BR.*BN .* CR.*CT) .* DR.*DT .* CE + ...
(AR.*AN .* BR.*BN .* CR.*CT + CA .* BR.*BN .* CR.*CT) .* DR.*DN .* ER.*ET + ...
(AR.*AN .* BR.*BN .* CR.*CT + CA .* BR.*BN .* CR.*CT) .* CD .* ER.*ET + ...
(AR.*AN .* BR.*BN .* CR.*CN + AR.*AN .* CB .* CR.*CN) .* DR.*DT .* ER.*ET + ...
(AR.*AN .* BR.*BN .* CR.*CN + AR.*AN .* CB .* CR.*CN) .* DR.*DT .* ER.*EN + ...
(AR.*AN .* BR.*BN .* CR.*CN + AR.*AN .* CB .* CR.*CN) .* DR.*DT .* CE + ...
(AR.*AN .* BR.*BN .* CR.*CN + AR.*AN .* CB .* CR.*CN) .* DR.*DN .* ER.*ET + ...
(AR.*AN .* BR.*BN .* CR.*CN + AR.*AN .* CB .* CR.*CN) .* CD .* ER.*ET + ...
(AR.*AN .* BR.*BN .* CC) .* DR.*DT .* ER.*ET + ...
(AR.*AN .* BR.*BN .* CC) .* DR.*DT .* ER.*EN + ...
(AR.*AN .* BR.*BN .* CC) .* DR.*DT .* CE + ...
(AR.*AN .* BR.*BN .* CC) .* DR.*DN .* ER.*ET + ...
(AR.*AN .* BR.*BN .* CC) .* CD .* ER.*ET + ...
(AR.*AN .* CB .* CR.*CT) .* DR.*DT .* ER.*ET + ...
(AR.*AN .* CB .* CR.*CT) .* DR.*DT .* ER.*EN + ...
(AR.*AN .* CB .* CR.*CT) .* DR.*DT .* CE + ...
(AR.*AN .* CB .* CC) .* DR.*DT .* ER.*ET + ...
(AR.*AN .* CB .* CC) .* DR.*DT .* ER.*EN + ...
(AR.*AN .* CB .* CC) .* DR.*DT .* CE + ...
(CA .* BR.*BT .* CR.*CT + CA .* BR.*BT .* CC) .* DR.*DT .* ER.*EN + ...
(CA .* BR.*BT .* CR.*CT + CA .* BR.*BT .* CC) .* DR.*DN .* ER.*EN + ...
(CA .* BR.*BT .* CR.*CT + CA .* BR.*BT .* CC) .* CD .* ER.*EN + ...
(CA .* BR.*BN .* CR.*CN + CA .* CB .* CR.*CN) .* DR.*DT .* ER.*ET + ...
(CA .* BR.*BN .* CR.*CN + CA .* CB .* CR.*CN) .* DR.*DN .* ER.*ET + ...
(CA .* BR.*BN .* CR.*CN + CA .* CB .* CR.*CN) .* CD .* ER.*ET + ...
(CA .* BR.*BN .* CC) .* DR.*DT .* ER.*ET + ...
(CA .* BR.*BN .* CC) .* DR.*DN .* ER.*ET + ...
(CA .* BR.*BN .* CC) .* CD .* ER.*ET + ...
(CA .* CB .* CR.*CT) .* DR.*DT .* ER.*EN;


K = Kold .* (1- Knew);

% totMasse = (DR.*DT .* SR.*ST .* GR.*GT + DR.*DT .* SR.*ST .* CG + DR.*DT .* CS .* GR.*GT +...
% 		DR.*DT .* SR.*SN .* GR.*GN + DR.*DT .* SR.*SN .* CG + DR.*DT .* CS .* GR.*GN+...
% 		DR.*DT .* CS .* CG+...
% 		DR.*DN .* SR.*ST .* GR.*GT + DR.*DN .* SR.*ST .* CG+...
% 		DR.*DN .* SR.*SN .* GR.*GT + CD .* SR.*SN .* GR.*GT+...
% 		DR.*DN .* SR.*SN .* GR.*GN + DR.*DN .* CS .* GR.*GN+...
% 		DR.*DN .* SR.*SN .* CG+...
% 		DR.*DN .* CS .* GR.*GT+...
% 		DR.*DN .* CS .* CG+...
% 		CD .* SR.*ST .* GR.*GT + CD .* SR.*ST .* CG+...
% 		CD .* SR.*SN .* GR.*GN + CD .* CS .* GR.*GN+...
% 		CD .* SR.*SN .* CG+...
% 		CD .* CS .* GR.*GT+...
% 		CD .* CS .* CG)/K;
%     if totMasse~=1
%         display(num2str(totMasse-1));
%     end

Confl = 1-K;

BelT =	((AR.*AT .* BR.*BT .* CR.*CT + AR.*AT .* BR.*BT .* CC + AR.*AT .* CB .* CR.*CT) .* DR.*DT .* ER.*ET + ...
	(AR.*AT .* BR.*BT .* CR.*CT + AR.*AT .* BR.*BT .* CC + AR.*AT .* CB .* CR.*CT) .* DR.*DT .* CE + ...	
	(AR.*AT .* BR.*BT .* CR.*CT + AR.*AT .* BR.*BT .* CC + AR.*AT .* CB .* CR.*CT) .* CD .* ER.*ET	+ ...
	(AR.*AT .* BR.*BT .* CR.*CT + AR.*AT .* BR.*BT .* CC + AR.*AT .* CB .* CR.*CT) .* CD .* CE + ...
	(AR.*AT .* CB .* CC) .* CD .* ER.*ET + ...
	(CA .* BR.*BT .* CR.*CT + CA .* BR.*BT .* CC) .* DR.*DT .* ER.*ET + ...
	(CA .* BR.*BT .* CR.*CT + CA .* BR.*BT .* CC) .* DR.*DT .* CE + ...
	(CA .* CB .* CR.*CT) .* DR.*DT .* ER.*ET + ...
	(CA .* CB .* CR.*CT) .* DR.*DT .* CE + ...
	(CA .* CB .* CC) .* DR.*DT .* ER.*ET + ...
	(AR.*AT .* BR.*BN .* CR.*CN + AR.*AT .* BR.*BN .* CC + AR.*AT .* CB .* CR.*CN) .* DR.*DT .* ER.*EN + ...
	(AR.*AT .* BR.*BN .* CR.*CN + AR.*AT .* BR.*BN .* CC + AR.*AT .* CB .* CR.*CN) .* DR.*DT .* CE + ...
	(AR.*AT .* BR.*BN .* CR.*CN + AR.*AT .* BR.*BN .* CC + AR.*AT .* CB .* CR.*CN) .* CD .* ER.*EN + ...
	(AR.*AT .* BR.*BN .* CR.*CN + AR.*AT .* BR.*BN .* CC + AR.*AT .* CB .* CR.*CN) .* CD .* CE + ...
	(AR.*AT .* CB .* CC) .* DR.*DT .* ER.*EN + ...
	(AR.*AT .* CB .* CC) .* DR.*DT .* CE + ...
	(AR.*AT .* CB .* CC) .* CD .* ER.*EN + ...
	(CA .* BR.*BN .* CR.*CN + CA .* CB .* CR.*CN) .* DR.*DT .* ER.*EN + ...
	(CA .* BR.*BN .* CR.*CN + CA .* CB .* CR.*CN) .* DR.*DT .* CE + ...
	(CA .* BR.*BN .* CC) .* DR.*DT .* ER.*EN + ...
	(CA .* BR.*BN .* CC) .* DR.*DT .* CE + ...
	(CA .* CB .* CC) .* DR.*DT .* ER.*EN + ...
	(AR.*AN .* BR.*BT .* CR.*CT + AR.*AN .* BR.*BT .* CC) .* DR.*DN .* ER.*ET + ...
	(AR.*AN .* BR.*BT .* CR.*CT + AR.*AN .* BR.*BT .* CC) .* DR.*DN .* CE + ...
	(AR.*AN .* BR.*BT .* CR.*CT + AR.*AN .* BR.*BT .* CC) .* CD .* ER.*ET + ...
	(AR.*AN .* BR.*BT .* CR.*CT + AR.*AN .* BR.*BT .* CC) .* CD .* CE + ...
	(AR.*AN .* CB .* CR.*CT) .* DR.*DN .* ER.*ET + ...
	(AR.*AN .* CB .* CC) .* DR.*DN .* ER.*ET + ...
	(AR.*AN .* CB .* CR.*CT) .* CD .* ER.*ET + ...
	(AR.*AN .* CB .* CC) .* CD .* ER.*ET + ...
	(CA .* BR.*BT .* CR.*CT + CA .* BR.*BT .* CC) .* DR.*DN .* ER.*ET + ...
	(CA .* BR.*BT .* CR.*CT + CA .* BR.*BT .* CC) .* DR.*DN .* CE + ...
	(CA .* CB .* CR.*CT) .* DR.*DN .* ER.*ET + ...
	(CA .* CB .* CC) .* DR.*DN .* ER.*ET + ...
	(AR.*AN .* BR.*BN .* CR.*CT + CA .* BR.*BN .* CR.*CT) .* DR.*DN .* ER.*EN + ...
	(AR.*AN .* BR.*BN .* CR.*CT + CA .* BR.*BN .* CR.*CT) .* DR.*DN .* CE + ...
	(AR.*AN .* BR.*BN .* CR.*CT + CA .* BR.*BN .* CR.*CT) .* CD .* ER.*EN + ...
	(AR.*AN .* BR.*BN .* CR.*CT + CA .* BR.*BN .* CR.*CT) .* CD .* CE + ...
	(AR.*AN .* CB .* CR.*CT) .* DR.*DN .* ER.*EN + ...
	(CA .* CB .* CR.*CT) .* CD .* ER.*EN + ...
	(AR.*AN .* CB .* CR.*CT) .* CD .* ER.*EN + ...
	(AR.*AT .* CB .* CC) .* CD .* CE + ...
	(CA .* CB .* CC) .* DR.*DT .* CE	+ ...
	(AR.*AN .* CB .* CR.*CT) .* DR.*DN .* CE + ...
	(AR.*AN .* CB .* CR.*CT) .* CD .* CE + ...
	(CA .* CB .* CR.*CT) .* DR.*DN .* CE + ...
	(CA .* BR.*BT .* CR.*CT + CA .* BR.*BT .* CC) .* CD .* ER.*ET + ...
	(CA .* BR.*BT .* CR.*CT + CA .* BR.*BT .* CC) .* CD .* CE + ...
	(CA .* CB .* CR.*CT) .* CD .* ER.*ET + ...
	(CA .* CB .* CC) .* CD .* ER.*ET + ...
	(CA .* CB .* CR.*CT) .* CD .* CE ...
    )./K;

BelN = ((AR.*AN .* BR.*BN .* CR.*CN + AR.*AN .* CB .* CR.*CN) .* DR.*DN .* ER.*EN + ...
	(AR.*AN .* BR.*BN .* CR.*CN + AR.*AN .* CB .* CR.*CN) .* DR.*DN .* CE + ...
	(CA .* BR.*BN .* CR.*CN + CA .* CB .* CR.*CN) .* DR.*DN .* ER.*EN + ...
	(CA .* BR.*BN .* CR.*CN + CA .* CB .* CR.*CN) .* DR.*DN .* CE + ...
	(CA .* CB .* CR.*CT) .* DR.*DN .* ER.*EN )./K;

PlT = 1 - BelN;

PlN = 1 - BelT;

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

