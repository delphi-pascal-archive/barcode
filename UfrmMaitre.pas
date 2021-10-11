unit UfrmMaitre;

// |===========================================================================|
// | unit UfrmMaitre                                                           |
// | Copyright © 2006 F.BASSO                                                  |
// |___________________________________________________________________________|
// | Unite de la fenêtre principale du programme codeDLT                       |
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

interface

uses
  Windows, SysUtils, Graphics, Forms,
  printers, StdCtrls, ExtCtrls, Dialogs, Controls, Classes, Buttons;

type
  Tcode = array [0..8] of byte;

  TdimCode = record
    Longueur     : single;              // longueur de l'étiquette
    Hauteur      : single;              // hauteur de l'étiquette
    margeL       : single;              // marge gauche et droite
    margeH       : single;              // Espace pour le texte
    LongueurCode : single;              // longueur du code barre
    HauteurCode  : single;              // hauteur du code barre
  end;

  TfrmMaitre = class(TForm)
    Previsu: TImage;
    PrinterSetupDialog1: TPrinterSetupDialog;
    rgModel: TRadioGroup;
    rgTypeDLT: TRadioGroup;
    rgTypeLTO: TRadioGroup;
    strDepart: TEdit;
    lblStrDepart: TLabel;
    rgIncrementation: TRadioGroup;
    cmdImprimer: TBitBtn;
    Label1: TLabel;
    procedure cmdImprimerClick(Sender: TObject);
    procedure strDepartChange(Sender: TObject);
    procedure strDepartKeyPress(Sender: TObject; var Key: Char);
    procedure rgTypeDLTClick(Sender: TObject);
    procedure rgTypeLTOClick(Sender: TObject);
    procedure rgModelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Déclarations privées }
    strtype : string;
    nbH,nbV : integer;
    strValeur : string;
    dimcode : TdimCode;
    surfaceDessin : TCanvas ;
    function  getCode( digit : char ) :Tcode ;
    procedure afficherCode;
    procedure dessinerCode (x,y : integer ; strTexte : string ;dessin  : tcanvas;dpiX,dpiY : integer);
    procedure incValeur(var strvaleur : string);
    function  mmToPixel (taille : real  ;DPI : integer) : integer;
  public
    { Déclarations publiques }
  end;

const
  tabtypeLTO : array[0..6] of string =
               ('LA','L1','LD','L2','LE','L3','LT');

  tabtypeDLT : array[0..5] of string =
               ('B','C','E','D','S','2');

  tabLettre  : string = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ-. *$/+%';

  tabCode : array[1..44]of Tcode =
             ((0,0,1,1,0, 0,1,0,0), // 0
             (1,0,0,0,1, 0,1,0,0),  // 1
             (0,1,0,0,1, 0,1,0,0),  // 2
             (1,1,0,0,0, 0,1,0,0),  // 3
             (0,0,1,0,1, 0,1,0,0),  // 4
             (1,0,1,0,0, 0,1,0,0),  // 5
             (0,1,1,0,0, 0,1,0,0),  // 6
             (0,0,0,1,1, 0,1,0,0),  // 7
             (1,0,0,1,0, 0,1,0,0),  // 8
             (0,1,0,1,0, 0,1,0,0),  // 9

             (1,0,0,0,1, 0,0,1,0),  // A
             (0,1,0,0,1, 0,0,1,0),  // B
             (1,1,0,0,0, 0,0,1,0),  // C
             (0,0,1,0,1, 0,0,1,0),  // D
             (1,0,1,0,0, 0,0,1,0),  // E
             (0,1,1,0,0, 0,0,1,0),  // F
             (0,0,0,1,1, 0,0,1,0),  // G
             (1,0,0,1,0, 0,0,1,0),  // H
             (0,1,0,1,0, 0,0,1,0),  // I
             (0,0,1,1,0, 0,0,1,0),  // J

             (1,0,0,0,1, 0,0,0,1),  // K
             (0,1,0,0,1, 0,0,0,1),  // L
             (1,1,0,0,0, 0,0,0,1),  // M
             (0,0,1,0,1, 0,0,0,1),  // N
             (1,0,1,0,0, 0,0,0,1),  // O
             (0,1,1,0,0, 0,0,0,1),  // P
             (0,0,0,1,1, 0,0,0,1),  // Q
             (1,0,0,1,0, 0,0,0,1),  // R
             (0,1,0,1,0, 0,0,0,1),  // S
             (0,0,1,1,0, 0,0,0,1),  // T

             (1,0,0,0,1, 1,0,0,0),  // U
             (0,1,0,0,1, 1,0,0,0),  // V
             (1,1,0,0,0, 1,0,0,0),  // W
             (0,0,1,0,1, 1,0,0,0),  // X
             (1,0,1,0,0, 1,0,0,0),  // y
             (0,1,1,0,0, 1,0,0,0),  // Z
             (0,0,0,1,1, 1,0,0,0),  // -
             (1,0,0,1,0, 1,0,0,0),  // .
             (0,1,0,1,0, 1,0,0,0),  // Espace
             (0,0,1,1,0, 1,0,0,0),  // *

             (0,0,0,0,0, 1,1,1,0),  // $
             (0,0,0,0,0, 1,1,0,1),  // /
             (0,0,0,0,0, 1,0,1,1),  // +
             (0,0,0,0,0, 0,1,1,1)); // %

// ****************************************************************************
// * Dimension des codes barres                                               *
// ****************************************************************************

  LTODim : TdimCode = (                // dimensions du  code LTO en millimètre
             Longueur     : 78.2;
             hauteur      : 15.5;
             margeL       : 4.3;
             margeH       : 5 ;
             longueurCode : 69.6;   // longueur - 2*margel
             hauteurCode  : 9.9);

  DLTDim : TdimCode = (                // dimensions du  code DLT en millimètre
             Longueur     : 57.2;
             hauteur      : 20.8;
             margeL       : 5.1;
             margeH       : 5;
             longueurCode : 47;   // longueur - 2*margel
             hauteurCode  : 15.2);

var
  frmMaitre: TfrmMaitre;

implementation

{$R *.dfm}

// #===========================================================================#
// #===========================================================================#
// #                                                                           #
// # Partie Privée                                                             #
// #                                                                           #
// #===========================================================================#
// #===========================================================================#

Function StrLectureVersion : String;

//  ___________________________________________________________________________
// | function  StrLectureVersion                                               |
// | _________________________________________________________________________ |
// || Permet d'avoir le numero de version de l'appli                          ||
// ||_________________________________________________________________________||
// || Sorties | Result : String                                               ||
// ||         |   Version de l'appli                                          ||
// ||_________|_______________________________________________________________||
// |___________________________________________________________________________|

Var
  S         : String;
  Taille    : DWord;
  Buffer    : PChar;
  VersionPC : PChar;
  VersionL  : DWord;

Begin
  Result:='';
  // On demande la taille des informations sur l'application
  S := Application.ExeName;
  Taille := GetFileVersionInfoSize(PChar(S), Taille);
  If Taille>0
  Then Try
  // Réservation en mémoire d'une zone de la taille voulue
    Buffer := AllocMem(Taille);
  // Copie dans le buffer des informations
    GetFileVersionInfo(PChar(S), 0, Taille, Buffer);
  // Recherche de l'information de version
    If VerQueryValue(Buffer, PChar('\StringFileInfo\040C04E4\FileVersion'), Pointer(VersionPC), VersionL)
      Then Result:=VersionPC;
  Finally
    FreeMem(Buffer, Taille);
  End;
End;

function  TfrmMaitre.mmToPixel (taille : real ;DPI : integer) : integer;

//  ___________________________________________________________________________
// | function TfrmMaitre.mmToPixel                                             |
// | _________________________________________________________________________ |
// || Permet de convertir une taille en millimètre en nombre de pixels en     ||
// || fonction de la résolution                                               ||
// ||_________________________________________________________________________||
// || Entrées | taille : real                                                 ||
// ||         |   Taille en millimètre à convertir                            ||
// ||         | DPI : integer                                                 ||
// ||         |   Résolution en pixel par pouce                               ||
// ||_________|_______________________________________________________________||
// || Sorties |  result : integer                                             ||
// ||         |    valeur en pixel                                            ||
// ||_________|_______________________________________________________________||
// |___________________________________________________________________________|

begin
  result := Trunc(taille / (25.4 / DPI));
end;

function TfrmMaitre.getCode( digit : char ) :Tcode ;

//  ___________________________________________________________________________
// | function TfrmMaitre.getCode                                               |
// | _________________________________________________________________________ |
// || Permet de convertir un caractère en sa representaion code 39            ||
// ||_________________________________________________________________________||
// || Entrées |  digit : char                                                 ||
// ||         |    caractère à convertir                                      ||
// ||_________|_______________________________________________________________||
// || Sorties |  Result : Tcode                                               ||
// ||         |    Representation en code 39 du caractère                     ||
// ||_________|_______________________________________________________________||
// |___________________________________________________________________________|

var
  index : integer;
  r2 : tcode;
begin
  index := pos(UpCase(Digit),tabLettre);
  if index <> 0 then
    result := tabcode[index]
  else
    raise ERangeError.Create(digit + ' N''est pas un caractère valide');
end;

procedure TfrmMaitre.afficherCode;

//  ___________________________________________________________________________
// | procedure TfrmMaitre.afficherCode                                         |
// | _________________________________________________________________________ |
// || Permet d'afficher dans la prévisualisation le code barre                ||
// ||_________________________________________________________________________||
// || Entrées |                                                               ||
// ||         |                                                               ||
// ||_________|_______________________________________________________________||
// || Sorties |                                                               ||
// ||         |                                                               ||
// ||_________|_______________________________________________________________||
// |___________________________________________________________________________|


begin
// ****************************************************************************
// * Redimensionnement de l'image de previsualisation                         *
// ****************************************************************************

  Previsu.Width  := mmToPixel(dimcode.Longueur ,300) div 2;
  Previsu.Height := mmToPixel(dimcode.hauteur ,300) div 2;
  Previsu.Picture.Bitmap.Width  := mmToPixel(dimcode.Longueur ,300);
  Previsu.Picture.Bitmap.Height := mmToPixel(dimcode.hauteur ,300);
  Previsu.Picture.Bitmap.PixelFormat := pf1bit ;
  Previsu.Picture.Bitmap.Canvas.Font.PixelsPerInch := 300;
// ****************************************************************************
// * Affichage du code barre                                                  *
// ****************************************************************************
  dessinerCode(0,0,strValeur , Previsu.Picture.Bitmap.Canvas  ,300,300);
end;

procedure TfrmMaitre.dessinerCode(x,y :integer;strTexte : string ; dessin : tcanvas ;dpiX,dpiY : integer) ;

//  ___________________________________________________________________________
// | procedure TfrmMaitre.dessinerCode                                         |
// | _________________________________________________________________________ |
// || Permet de dessinner un code barre sur un Tcanvas                        ||
// ||_________________________________________________________________________||
// || Entrées | x,y : integer                                                 ||
// ||         |   coordonnées en pixel ou placer le code barre                ||
// ||         | strTexte : string                                             ||
// ||         |   Texte a convertir en code barre                             ||
// ||         | dessin : tcanvas                                              ||
// ||         |   canvas sur le quel dessiner le code barre                   ||
// ||         | dpiX,dpiY : integer                                           ||
// ||         |   resolution du canvas en pouce par pixel                     ||
// ||_________|_______________________________________________________________||
// || Sorties |                                                               ||
// ||         |                                                               ||
// ||_________|_______________________________________________________________||
// |___________________________________________________________________________|

var
  ligneCode : timage;
  pligne    : ^TbyteArray;
  offset    : integer;
  nbChar    : integer;
  ii,j      : integer;
  recCode   : trect;
  recTexte  : trect;

  procedure ajouterChar(lettre : char);

  //  _________________________________________________________________________
  // | procedure ajouterChar                                                   |
  // | _______________________________________________________________________ |
  // || Permet de dessinner un caractère en code 39                           ||
  // ||_______________________________________________________________________||
  // || Entrées | lettre : char                                               ||
  // ||         |   caractère à dessiner                                      ||
  // ||_________|_____________________________________________________________||
  // || Sorties |                                                             ||
  // ||         |                                                             ||
  // ||_________|_____________________________________________________________||
  // |_________________________________________________________________________|

  var
    tmp : Tcode;
    i : integer;
    strtemp : string;
  begin
    tmp := getCode(lettre);
    for i := 0 to 4 do
    begin

// ****************************************************************************
// * Dessin du 0                                                              *
// ****************************************************************************

      if tmp[i] = 0 then
      begin
        pligne[offset] := clBlack ;
        offset := offset - 1;
      end else

// ****************************************************************************
// * Dessin du 1                                                              *
// ****************************************************************************

      begin
        pligne[offset]      := clblack ;
        pligne[offset - 1 ] := clblack;
        offset := offset - 2 ;
      end;

// ****************************************************************************
// * Dessin du blanc supplémentaire                                           *
// ****************************************************************************

      if tmp[i+5] = 1 then
      begin
        pligne[offset] := $ff;
        offset := offset -1;
      end;

// ****************************************************************************
// * Dessin du blanc si pas à la fin du code                                  *
// ****************************************************************************

      if offset > 0 then
      begin
        pligne[offset-1] := $ff;
        offset := offset -1;
      end;
    end;

// ****************************************************************************
// * Affichage du caractère dans la zonne de texte                            *
// ****************************************************************************

    if (ii > 1)and(ii<nbChar) then
    begin
      strtemp := lettre;
      i := recTexte.Right - rectexte.Left;
      if ii < 8 then
        dessin.Font.size := 10
      else

// ****************************************************************************
// * Si caractère corespond au type de bande on l'affiche en petit            *
// ****************************************************************************

      dessin.Font.size:=5;
      dessin.TextRect(recTexte,5+j,5,strtemp);
      j:=j+79;
      
// ****************************************************************************
// * Déplacement de la zone de texte                                          *
// ****************************************************************************

      rectexte.Left  := rectexte.Right;
      rectexte.Right := rectexte.Left + i;
    end;
  end;

begin
  j:=79;
  nbchar := length(strTexte );

// ****************************************************************************
// * Création du la zone de dessin du code barre                              *
// ****************************************************************************

  recCode.Left   := x + mmToPixel(dimcode.margel ,dpix);
  recCode.Top    := y + mmToPixel(dimcode.margeh ,dpiy);
  recCode.Right  := recCode.Left + mmToPixel(dimcode.longueurCode , dpix);
  recCode.Bottom := recCode.Top + mmToPixel(dimcode.hauteurCode , dpiy);

// ****************************************************************************
// * Création de la zonne de dessin du texte                                  *
// ****************************************************************************

  recTexte.Left   := recCode.Left;
  recTexte.Top    := y + 5 ;
  recTexte.Right  := recCode.Left + (recCode.Right-recCode.Left) div (nbChar-2);
  recTexte.Bottom := recCode.Top ;

// ****************************************************************************
// * Dessin du contour de l'étiquette                                         *
// ****************************************************************************

  dessin.Brush.Style := bsSolid;
  dessin.Brush.Color := clWhite;
  dessin.Rectangle(x,y,x+mmToPixel(dimcode.Longueur ,dpix),y+mmToPixel(dimcode.hauteur ,dpiy));

  offset := nbchar * 13 - 1 ;

// ****************************************************************************
// * Création de la ligne recevant le code barre                              *
// ****************************************************************************

  lignecode := TImage.Create(self);
  lignecode.Height := 1;
  lignecode.Width  := offset ;
  lignecode.Picture.Bitmap.Height := 1 ;
  ligneCode.Picture.Bitmap.PixelFormat := pf8bit ;
  lignecode.Picture.Bitmap.Width  := offset;
  offset := offset - 1;
  pligne := lignecode.Picture.Bitmap.ScanLine[0];

// ****************************************************************************
// * Dessin du code barre dans la ligne                                       *
// ****************************************************************************

  for ii := 1  to nbchar do
  begin
    ajouterChar(strtexte[ii]);
  end;

// ****************************************************************************
// * Agrandissement de la ligne à la taille de la zonne du code barre         *
// ****************************************************************************

  dessin.StretchDraw(recCode , lignecode.Picture.Bitmap );
  ligneCode.free;
end;

procedure TfrmMaitre.incValeur(var strvaleur : string);

//  ___________________________________________________________________________
// | procedure TfrmMaitre.incValeur                                            |
// | _________________________________________________________________________ |
// || Permet d'incrémenter une valeur alfanumérique                           ||
// ||_________________________________________________________________________||
// || Entrées |  var strvaleur : string                                       ||
// ||         |    Valeur à incrémenter                                       ||
// ||_________|_______________________________________________________________||
// || Sorties |  var strvaleur : string                                       ||
// ||         |    Valeur incrément&                                          ||
// ||_________|_______________________________________________________________||
// |___________________________________________________________________________|

var
  i      : integer;
  tmp    : string;
  digit  : char;
  retenu : boolean;
  index  : integer;
begin
  retenu := true;
  for i := 7 downto 2 do
    if retenu then
    begin
      digit := strvaleur[i];
      retenu := false;
      index  := pos(digit,tablettre );
      if index = 0 then
        raise ERangeError.Create('"'+digit+'" N''est pas un caractère valide');
      case index of
        1..8 : digit := tablettre[index+1];               // increment 0 .. 9
        9..15 : if rgIncrementation.ItemIndex = 0 then    // increment A .. F
                  digit := '0'
                else
                  digit := tablettre[index+1];
        16..35 : if rgIncrementation.ItemIndex <= 1 then  // increment G .. Z
                   digit := '0'
                 else
                   digit := tablettre[index+1];
        36     : digit := '0';

// ****************************************************************************
// * Les caractères spéciaux ne sont pas modifiés                             *
// *( '-' '.' ' ' '*' '$' '/' '+' '%')                                        *
// ****************************************************************************

        else retenu := true;
      end;
      if not retenu then retenu := digit = '0';
      strvaleur[i] := digit;
    end;
end;


// #===========================================================================#
// #===========================================================================#
// #                                                                           #
// # Partie Evenementiel                                                       #
// #                                                                           #
// #===========================================================================#
// #===========================================================================#

procedure TfrmMaitre.FormCreate(Sender: TObject);

//  ___________________________________________________________________________
// | procedure TfrmMaitre.FormCreate                                           |
// | _________________________________________________________________________ |
// || Permet au demarrage d'afficher la version du programme                  ||
// ||_________________________________________________________________________||
// || Entrées | Sender: TObject                                               ||
// ||         |   objet déclenchant l'événement                               ||
// ||_________|_______________________________________________________________||
// || Sorties |                                                               ||
// ||         |                                                               ||
// ||_________|_______________________________________________________________||
// |___________________________________________________________________________|

begin
  Caption := caption + ' V'+ StrLectureVersion;
  rgModelClick(self);
end;

procedure TfrmMaitre.rgModelClick(Sender: TObject);

//  ___________________________________________________________________________
// | procedure TfrmMaitre.rgModelClick                                         |
// | _________________________________________________________________________ |
// ||  Permet l'affichage de la boite à option corespondant au model de bande ||
// ||_________________________________________________________________________||
// || Entrées | Sender: TObject                                               ||
// ||         |   objet déclenchant l'événement                               ||
// ||_________|_______________________________________________________________||
// || Sorties |                                                               ||
// ||         |                                                               ||
// ||_________|_______________________________________________________________||
// |___________________________________________________________________________|

begin
  rgTypeDLT.Visible := rgModel.ItemIndex=0;
  rgTypeLTO.Visible := rgModel.ItemIndex=1;
  if rgModel.ItemIndex=0 then
  begin
    rgTypeDLTClick(self);
  end else
  begin
    rgTypeLTOClick(self);
  end;
end;

procedure TfrmMaitre.rgTypeLTOClick(Sender: TObject);

//  ___________________________________________________________________________
// | procedure TfrmMaitre.rgTypeLTOClick                                       |
// | _________________________________________________________________________ |
// ||  Permet d'afficher un aperçu du code LTO correspondant au choix         ||
// ||_________________________________________________________________________||
// || Entrées |                                                               ||
// ||         |                                                               ||
// ||_________|_______________________________________________________________||
// || Entrées | Sender: TObject                                               ||
// ||         |   objet déclenchant l'événement                               ||
// ||_________|_______________________________________________________________||
// |___________________________________________________________________________|

begin
  dimcode := LTODim ;
  strtype := tabtypeLTO[rgTypeLTO.Itemindex];
  strValeur  := '*' + strDepart.text + strtype + '*';
  afficherCode
end;

procedure TfrmMaitre.rgTypeDLTClick(Sender: TObject);

//  ___________________________________________________________________________
// | procedure TfrmMaitre.rgTypeDLTClick                                       |
// | _________________________________________________________________________ |
// ||  Permet d'afficher un aperçu du code DLT correspondant au choix         ||
// ||_________________________________________________________________________||
// || Entrées | Sender: TObject                                               ||
// ||         |   objet déclenchant l'événement                               ||
// ||_________|_______________________________________________________________||
// || Sorties |                                                               ||
// ||         |                                                               ||
// ||_________|_______________________________________________________________||
// |___________________________________________________________________________|

begin
  dimcode:= DLTDim ;
  strtype := tabtypeDLT[rgTypeDLT.Itemindex];
  strValeur := '*' + strDepart.text + strtype + '*';
  afficherCode
end;

procedure TfrmMaitre.strDepartKeyPress(Sender: TObject; var Key: Char);

//  ___________________________________________________________________________
// | procedure TfrmMaitre.strDepartKeyPress                                    |
// | _________________________________________________________________________ |
// ||  Permet de limiter la saisie dans la champ valeur de départ             ||
// ||_________________________________________________________________________||
// || Entrées | Sender: TObject                                               ||
// ||         |   objet déclenchant l'événement                               ||
// ||         | Key : Char                                                    ||
// ||         |   Code aschii de la touche pressée                            ||
// ||_________|_______________________________________________________________||
// || Sorties |                                                               ||
// ||         |                                                               ||
// ||_________|_______________________________________________________________||
// |___________________________________________________________________________|

var
  tablettre2 : string ;

begin
  tablettre2 := tablettre + #8;   // rajout touche retour arriere dans les caractères autorisés
  key := upcase(key);
  if pos(Key,tablettre2) = 0 then
    key := #0;
end;

procedure TfrmMaitre.strDepartChange(Sender: TObject);

//  ___________________________________________________________________________
// | procedure TfrmMaitre.strDepartChange                                      |
// | _________________________________________________________________________ |
// ||  Si il y a 9 caractères on régénére le code barre                       ||
// ||_________________________________________________________________________||
// || Entrées | Sender: TObject                                               ||
// ||         |   objet déclenchant l'événement                               ||
// ||_________|_______________________________________________________________||
// || Sorties |                                                               ||
// ||         |                                                               ||
// ||_________|_______________________________________________________________||
// |___________________________________________________________________________|

begin
  if length(strDepart.Text)= 6 then rgModelClick(self);
end;

procedure TfrmMaitre.cmdImprimerClick(Sender: TObject);

//  ___________________________________________________________________________
// | procedure TfrmMaitre.cmdImprimerClick                                     |
// | _________________________________________________________________________ |
// ||  Pemrmet de lancer l'impression                                         ||
// ||_________________________________________________________________________||
// || Entrées | Sender: TObject                                               ||
// ||         |   objet déclenchant l'événement                               ||
// ||_________|_______________________________________________________________||
// || Sorties |                                                               ||
// ||         |                                                               ||
// ||_________|_______________________________________________________________||
// |___________________________________________________________________________|

var
  i , j  : integer;
  largeur,hauteur : integer;
  resX , resY : integer;
  margeh,margev : integer;
begin
  if PrinterSetupDialog1.Execute then
  begin

// ****************************************************************************
// * Récupération de la résolution de l'imprimante                            *
// ****************************************************************************

    resX := GetDeviceCaps(Printer.Handle, LOGPIXELSX);
    resY := GetDeviceCaps(Printer.Handle, LOGPIXELSY);

// ****************************************************************************
// * Récupération de la taille de la page                                     *
// ****************************************************************************

    largeur := mmToPixel(dimcode.Longueur,resx);
    hauteur :=  mmToPixel(dimcode.Hauteur,resy) ;

// ****************************************************************************
// * Calcule du nombre de code barre que l'on peut dessiner sur lage          *
// ****************************************************************************

    nbh  := Printer.PageHeight div hauteur ;
    nbV  := Printer.PageWidth  div largeur ;

    strValeur  := '*' + strDepart.text + strtype + '*';

// ****************************************************************************
// * Calcule des marges de façon à centrer les code barre sur la page         *
// ****************************************************************************

    margeh := ( Printer.PageHeight - nbh * hauteur) div 2;
    margev := ( Printer.PageWidth - nbv * largeur) div 2 ;

// ****************************************************************************
// * Impressiondes code barre sur l'imprimante                                *
// ****************************************************************************

    printer.BeginDoc ;
    for j := 1 to nbv do
      for i := 1 to nbh do
      begin
        dessinerCode((j-1) * largeur + margev,(i-1) * hauteur + margeH,strValeur ,printer.canvas,resx,resy);
        incValeur(strvaleur);
      end;
    printer.EndDoc ;
  end;
end;




end.
