&НаКлиенте
Процедура КомандаСкопироватьСсылкуВБуфер(Команда)
	TK_ОбщегоНазначенияКлиент.УстановитьТекстВБуферОбмена(СсылкаНаДокумент);
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Параметры.Свойство("ДокументСсылка") Тогда
		ДокументСсылка = Параметры.ДокументСсылка;
		СсылкаНаДокумент = TK_ОбщегоНазначенияСервер.ПолучитьВнешнююСсылкуНаДокументЗаказаЦенПоставщикам(ДокументСсылка);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СсылкаНаДокументНажатие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;

	Если ЗначениеЗаполнено(СсылкаНаДокумент) Тогда
		ЗапуститьПриложение(СсылкаНаДокумент);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура КомандаОк(Команда)
	Закрыть();
КонецПроцедуры