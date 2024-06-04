#Область ОбработчикиКомандФормы 
&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, ЭтоГруппа, Параметр)
	Отказ = Истина;
	ОткрытьФорму("Документ.TK_ЗапросЦенОтКлиента.Форма.ФормаЗагрузкиПоURL")
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

// СтандартныеПодсистемы.Печать 
&НаКлиенте 
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда) 
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Элементы.Список); 
КонецПроцедуры 
// Конец СтандартныеПодсистемы.Печать 
&НаКлиенте 
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда) 
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда); 
КонецПроцедуры 
#КонецОбласти 

// СтандартныеПодсистемы.ПодключаемыеКоманды 
&НаКлиенте 
Процедура Подключаемый_ВыполнитьКоманду(Команда) 
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список); 
КонецПроцедуры 
&НаСервере 
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) 
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат); 
КонецПроцедуры 
&НаКлиенте 
Процедура Подключаемый_ОбновитьКоманды() 
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список); 
КонецПроцедуры 
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды