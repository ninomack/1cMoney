
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	РаботаСФормамиСправочников.УстановитьУсловноеОформлениеФормыСписка(ЭтотОбъект, "Список", Истина);
	Если ТипЗнч(Параметры.Отбор) = Тип("Структура") И Параметры.Отбор.Свойство("Владелец") Тогда
		Заголовок = Строка(Параметры.Отбор.Владелец);
	КонецЕсли;
	
КонецПроцедуры
