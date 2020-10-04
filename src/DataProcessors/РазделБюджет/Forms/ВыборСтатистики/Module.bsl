
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Параметры.Свойство("КоличествоПериодовСтатистики", КоличествоПериодовСтатистики);
	
	КолонкиСтатистики = Неопределено;
	Параметры.Свойство("КолонкиСтатистики", КолонкиСтатистики);
	Если КолонкиСтатистики <> Неопределено Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, КолонкиСтатистики, СтрокаПоказателейСреднего());
	КонецЕсли;
	
КонецПроцедуры


#КонецОбласти


#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КоличествоПериодовСтатистикиПриИзменении(Элемент)
	
	Если КоличествоПериодовСтатистики < 0 Тогда
		КоличествоПериодовСтатистики = 0;
	КонецЕсли;
	
	Если КоличествоПериодовСтатистики > 10 Тогда
		КоличествоПериодовСтатистики = 10;
	КонецЕсли;
	
КонецПроцедуры



#КонецОбласти


#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	КолонкиСтатистики = Новый Структура(СтрокаПоказателейСреднего());
	ЗаполнитьЗначенияСвойств(КолонкиСтатистики, ЭтотОбъект);
	Закрыть(Новый Структура("КоличествоПериодовСтатистики, КолонкиСтатистики", КоличествоПериодовСтатистики, КолонкиСтатистики));
	
КонецПроцедуры



#КонецОбласти


#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Функция СтрокаПоказателейСреднего()

	Возврат "СуммаПлан,СуммаФакт,ОсталосьПоСтатье,Превышение";

КонецФункции
 

#КонецОбласти
