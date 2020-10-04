
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Форма            = ПараметрыВыполненияКоманды.Источник;
	НомерПоСостоянию = 2;
	
	// Устаналиваем отбор и обновляем заголовок и пометки команд меню
	ДеньгиКлиентСервер.УстановитьОтборСпискаОперацийПоСостояниюДокумента(Форма, НомерПоСостоянию);
	// Если от отбора зависят другие данные, они должны быть обновлены в обработке оповещения
	Оповестить("ИзмененОтборСписка", Новый Структура("ИдентификаторФормы, НомерОтбораПоСостоянию", Форма.УникальныйИдентификатор, НомерПоСостоянию));
	
КонецПроцедуры
