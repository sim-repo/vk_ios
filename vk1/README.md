<H1>Описание</H1>

<H3>Модули и их подмодули:</H3> 
1. Новостной блок (News, Comment, Likes)<br/>
2. Список друзей (Friend, FriendWall)<br/>
3. Список групп (MyGroups, Groups)<br/>
4. Настройки (Profile)<br/>


<H3>Инициализация Presenters:</H3>
1. Отношение Presenter-View: 1-1  ( FriendPresenter, Friend_ViewController)<br/>
2. Каждый Presenter может инициализироваться в любой точке приложения<br/>
3. Порядок инциализации: сначала Presenter, потом возможно View<br/>
4. создается как singleton  фабричным классом Services->Factory->PresenterFactory<br/>
5. связи между view-presenter описывается типом enum: Services->Factory->ModuleEnum<br/>



<H3>Поведение Presenters:</H3>
1. есть два базовых класса Presenter: PlainBasePresenter и SectionedBasePresenter, поддерживающие работу с TableView, CollectionView без секций и с секциями соотвественно<br/>
2.  Базовые классы описывают:<br/>
∙ инциализацию "naked initial" и вместе с view-контроллером + валидация<br/>
∙ хранят  объект datasource, добавляют в нее данные + сортировка + валидация<br/>
3. Модульные Presenters <br/>
∙ наследуются от базового + ModelOwnerPresenterProtocol, который нужен для привязки презентера к модулю<br/>
∙ переопределяют функцию enrichData, когда требуется специфичная мутация datasource<br/>
∙ могут быть дочерними, тогда имплементируют протокол DetailPresenterProtocol (например, PostLikesPresenter)<br/>
∙ могут поддерживать пагинацию, тогда имплементация на PaginationPresenterProtocol (пример, NewsPresenter)<br/>


<H3>Протоколы Presenters:</H3><br/>
1. PullPlainPresenterProtocol - содержит методы, вызываемые из view<br/>
2. SynchronizedPresenterProtocol - соответственно вызывается из синхронайзеров (Services->Synchronizers)<br/>
3. PushPlainViewProtocol - описание view-методов, которые "дергает" презентер<br/>

<H3>Синхронизаторы:</H3><br/>
1. прослойка, между презенторами и сетевым слоем, принимающая решение нужно ли создавать сетевой запрос или брать данные из локальной БД (пример, Services->Synchronizer->SyncModule->SyncNews)<br/>
2. поддерживает обновление в background-режиме приложения (Services->Synchronizer->SyncModule->SyncMgt+Common метод scheduleNextSync)<br/>

