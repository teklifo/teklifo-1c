#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Отказ = Истина;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)

	Если Не ПринудительноЗакрытьФорму Тогда

		Отказ = Истина;

		ПринудительноЗакрытьФорму = Истина;

		Объект.Прочитано = Истина;

		ОбщегоНазначенияУТКлиент.ЗаписатьИЗакрыть(ЭтотОбъект);

	КонецЕсли;

КонецПроцедуры

#КонецОбласти