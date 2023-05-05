program alsars;

type complex=record
 Re:real;
 Im:real;
end;

var
  formulaChoose: integer;
  
  RaznyExp:complex;
  
  sigFreq: integer;
  railLagre: real;
  
  APobs: complex;
  APobs1: complex;
  APobs1Rpn: complex;
  BPobs: complex;
  
  shuntLarge: real;
  
  railResist: real;
  railResistNum: integer;
  
  amperNorm: real;
  amperNormResult: complex;
  
  rpn: real;
  
  yModule: real;
  yArg: real;
  yCompl: complex;
  yExp: complex;
  yExpMinus: complex;
  
  
  ZvModule: real;
  ZvArg: real;
  ZvCompl: complex;
  
  BrlCompl: complex;
  DrlCompl: complex;
  
  ZpCounter: integer;
  
  Ug: complex;
  UgChoose: real;
  
  rad:real;
  
     //pobsы модули
  PobsModule: array[1..6, 1..3] of real = (
        (75, 38, 1.26),
        (125, 38, 1.27),
        (175, 38, 1.29),
        (225, 38, 1.32),
        (275, 38.02, 1.35),
        (325, 38.03, 1.38));
        
        //pobsы аргумент
  PobsArg: array[1..6, 1..3] of real = (
        (75, -1, 8.5),
        (125, -1, 12.6),
        (175, -1, 16.7),
        (225, -1, 19.7),
        (275, -1, 21.7),
        (325, -1, 24.8));
  
  ZpModule: array[1..6, 1..2] of real = (
        (75, 1.07),
        (125, 1.53),
        (175, 1.97),
        (225, 2.53),
        (275, 3.19),
        (325, 3.74));
  
  ZpArg: array[1..6, 1..2] of real = (
        (75, 68),
        (125, 70),
        (175, 72),
        (225, 75),
        (275, 77),
        (325, 78));
        
  procedure cmple(m,a:real;var res:complex);
  begin
    
  rad:=180/pi;
    
    Res.Re:=m*cos(a/rad);
    Res.Im:=m*sin(a/rad);
  end;
  
  procedure cMul(Left,Right:complex;var Res:complex);
{ Умножение в алгебраической форме }
begin
  Res.Re:=Left.Re*Right.Re-Left.Im*Right.Im;
  Res.Im:=Left.Re*Right.Im+Left.Im*Right.Re;
end;

procedure cDiv(Left,Right:complex;var Res:complex);
var d:real;
begin
  d:=sqr(Right.Re)+sqr(Right.Im);
  Res.Re:=(Left.Re*Right.Re+Left.Im*Right.Im)/d;
  Res.Im:=(Left.Im*Right.Re-Left.Re*Right.Im)/d;
end;

procedure cExp(z:complex;var Res:complex);
{ Экспонента комплексного числа }
var h:real;
begin
 h:=exp(z.Re);
 Res.Re:=h*cos(z.Im);
 Res.Im:=h*sin(z.Im);
end;

function cabs(z:complex):real;
{ Модуль комплексного числа }
begin
 cabs:=sqrt(sqr(z.Re)+sqr(z.Im));
end;


label L0, L1, L2, L3, L4, L5, L6, L7;

begin
  sigFreq := 0;
 
  rpn := 0.28;
  
  rad:=180/pi;  
  
  L0: Writeln('Что надо найти:');
      
     Writeln('1 - Напряжение');
     Writeln('2 - Ток');
     
     try
        ReadLn(formulaChoose);
      
     except
        formulaChoose := 999;
     end;
     
     if (formulaChoose < 0) or (formulaChoose > 2) then 
      begin
        writeln('Число введено с ошибкой');
        goto L0;
      end;
      
      if (formulaChoose = 2) then 
        begin
         goto L2; 
        end
      else
        begin
          goto L2;
        end;     
  
  L2: Writeln('Выберите частоту несущего сигнала АЛС-АРС:');
  for Var I := 1 to 6 do
  begin
    Write(I);
    Write(' - частота ');
    Write(25 + 50 * I);
    Writeln(' Гц;');
  end;
  
  try
    ReadLn(sigFreq);
  
  except
    sigFreq := 999;
  end;
  
  if (sigFreq < 0) or (sigFreq > 6) then 
  begin
    writeln('Число введено с ошибкой');
    goto L2;
  end;
  Writeln('Выбрана частота ', 25 + 50 * sigFreq, ' Гц.');
  
  ZpCounter := sigFreq;
  
  L3: Writeln('Введите длину рельсовой цепи:');
  
  try
    ReadLn(railLagre);
  
  except
    railLagre := -1;
  end;
  
  if railLagre < 1 then 
  begin
    writeln('Число введено с ошибкой');
    goto L3;
  end;
  
  Writeln('Введена длина рельсовой цепи: ', railLagre:0:1, ' м');
  
  L4: Writeln('Введите длину зоны дополнительного шунтирования');
  
  try
    ReadLn(shuntLarge);
  
  except
    shuntLarge := -1;
  end;
  
  if (shuntLarge < 1) or (shuntLarge > 25) then 
  begin
    writeln('Число введено с ошибкой');
    goto L4;
  end;
  Writeln('Введена длина зоны дополнительного шунтирования: ', shuntLarge:0:1, ' м');
  
  L5: Writeln('Выберите cопротивление изоляции рельсов:');
  
  Writeln('1 - сопротивление 0.1 Ом*км');
  Writeln('2 - сопротивление 0.5 Ом*км');
  Writeln('3 - сопротивление 1 Ом*км');
  Writeln('4 - сопротивление 2 Ом*км');
  Writeln('5 - сопротивление 5 Ом*км');
  Writeln('6 - сопротивление 50 Ом*км');
  
  
  try
    ReadLn(railResistNum);
  
  except
    railResistNum := -1;
  end;
  
  if (railResistNum < 0) or (railResistNum > 6) then 
  begin
    writeln('Число введено с ошибкой');
    goto L5;
  end;
  
  // Выбор сопротивления
 
  if (railResistNum = 1) then
  begin 
    writeln('Выбрано сопротивление: 0.1 Ом*км');
    railResist := 0.1;
  end
  else if (railResistNum = 2) then 
  begin 
    writeln('Выбрано сопротивление: 0.5 Ом*км');
    railResist := 0.5;
  end
  else if (railResistNum = 3) then 
  begin 
    writeln('Выбрано сопротивление: 1 Ом*км');
    railResist := 1;
  end
  else if (railResistNum = 4) then 
  begin 
    writeln('Выбрано сопротивление: 2 Ом*км');
    railResist := 2;
  end
  else if (railResistNum = 5) then 
  begin 
    writeln('Выбрано сопротивление: 5 Ом*км');
    railResist := 5;
  end
  else if (railResistNum = 6) then 
  begin 
    writeln('Выбрано сопротивление: 50 Ом*км');
    railResist := 50;
  end;
  
  
  if (formulaChoose = 1) then 
  begin
      L6: Writeln('Введите нормативный ток на шунте :');
      
      try
        ReadLn(amperNorm);
      
      except
        amperNorm := -1;
      end;
      
      if (amperNorm < 0) or (amperNorm > 10) then 
      
      begin
        writeln('Число введено с ошибкой');
        goto L6;
      end;
      
      Writeln('Введен нормативный ток на шунте :', amperNorm:0:1, 'A');  
  end
  
  else
  
  begin
    L1: Writeln('Введите напряжение');
       try
        ReadLn(UgChoose);
      
         except
            UgChoose := -1;
         end;
     
     if (UgChoose < 0) or (UgChoose > 170) then 
      begin
        writeln('Число введено с ошибкой');
        goto L1;
      end; 
      
      UgChoose:= UgChoose;
      
      Writeln('Напряжение введено ', UgChoose:0:1);  
  end;      
  
  L7: 
    //Получили комплексное число Zв
  ZvModule := sqrt (ZpModule[ZpCounter, 2] * railResist);
  ZvArg := ZpArg[ZpCounter, 2] / 2;
  cmple(ZvModule, ZvArg, ZvCompl);
  
  yModule:= sqrt (ZpModule[ZpCounter, 2] / railResist);
  yArg:= ZpArg[ZpCounter, 2] / 2; 
    
   yModule:= yModule * ((railLagre/1000) + (shuntLarge/1000));
   cmple(yModule, yArg, yCompl);
   cmple(-yModule, yArg, yExpMinus);
   
   cExp(yCompl, yExp);
   cExp(yExpMinus, yExpMinus);
   
   
  DrlCompl.Re:= (yExp.Re + yExpMinus.Re)/2;
  DrlCompl.Im:= (yExp.Im + yExpMinus.Im)/2;
  
  RaznyExp.Re:= (yExp.Re - yExpMinus.Re)/2;
  RaznyExp.Im:= (yExp.Im - yExpMinus.Im)/2;
  
  cMul(RaznyExp,ZvCompl,BrlCompl);
  
  

  cmple(PobsModule[ZpCounter,2]*rpn, PobsArg[ZpCounter,2], APobs1);
  cmple(PobsModule[ZpCounter,3], PobsArg[ZpCounter,3], BPobs);
  
  cmple(PobsModule[ZpCounter,2], PobsArg[ZpCounter,2], APobs);
  
  APobs1.Re:= APobs1.Re + BPobs.Re;
  APobs1.Im:= APobs1.Im + BPobs.Im;
  
  APobs1Rpn:= APobs1;
  
  cDiv(APobs1,ZvCompl,APobs1);
  
  APobs1.Re:= APobs1.Re + APobs.Re;
  APobs1.Im:= APobs1.Im + APobs.Im;
  
  
  
  // First Slagaemoe
  cMul(APobs1,BrlCompl,APobs1);
  
  //Second Slagaemoe
  cMul(APobs1Rpn,DrlCompl,APobs1Rpn);
  
  if (formulaChoose = 1) then 
        begin
          Ug.Re:= (APobs1.Re + APobs1Rpn.Re) * amperNorm;
          Ug.Im:= (APobs1.Im + APobs1Rpn.Im) * amperNorm;
          
          writeln('Напряжение: ',cabs(Ug):0:1); 
          writeln('Напряжение: ',Ug);
          
        end
      else
        begin
          amperNormResult.Re:= UgChoose / (APobs1.Re + APobs1Rpn.Re);
          
          writeln('Нормативный ток на шунте: ',cabs(amperNormResult):0:1);
        end;
  
end.
