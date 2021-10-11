program codeDLT;

// |===========================================================================|
// | PROGRAM codeDLT                                                           |
// | Copyright © 2006 F.BASSO                                                  |
// |___________________________________________________________________________|
// | Logiciel premetant d'imprimer des codes barres pour les cartouche de      |
// | sauvegarde de type DLT et LTO                                             |
// |___________________________________________________________________________|
// | Ce programme est libre, vous pouvez le redistribuer et ou le modifier     |
// | selon les termes de la Licence Publique Générale GNU publiée par la       |
// | Free Software Foundation .                                                |
// | Ce programme est distribué car potentiellement utile,                     |
// | mais SANS AUCUNE GARANTIE, ni explicite ni implicite,                     |
// | y compris les garanties de commercialisation ou d'adaptation              |
// | dans un but spécifique.                                                   |
// | Reportez-vous à la Licence Publique Générale GNU pour plus de détails.    |
// |                                                                           |
// | anbasso@wanadoo.fr                                                        |
// |===========================================================================|


uses
  Forms,
  UfrmMaitre in 'UfrmMaitre.pas' {frmMaitre};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMaitre, frmMaitre);
  Application.Run;
end.
