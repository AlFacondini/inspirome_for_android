# TODO

Ricordarsi di:

API Inspirome

serializzazione JSON 

persistenza su disco 

# inspirome_for_android

Alberto Facondini - 329370

## Indice

* [Introduzione](#introduzione)
* [Casi d'uso](#casi-duso)
* [Esperienza utente](#esperienza-utente)

## Introduzione

InspiroBot è un servizio che tramite il suo sito dedicato, la sua API o svariati bot di Discord fornisce immagini contenenti citazioni fasulle, che dovrebbero ispirare il lettore, create dalla sua AI.

Queste immagini, che il più delle volte falliscono nel loro intento originale e risultano invece incomprensibili o divertenti, prendono il nome di "inspirome", dal comando di Discord più comunemente usato per generarle (!inspirome).

Questo progetto si propone di creare un'applicazione che permetta di generare, salvare, catalogare e rendere comodo condividere gli inspirome.

## Casi d'uso

Dopo la scomparsa della schermata di caricamento con il titolo dell'applicazione, l'utente si ritrova nella home page e visualizza l'ultimo inspirome preferito o un primo nuovo inspirome se la lista dei preferiti è vuota. È possibile navigare tra gli inspirome facendo scorrere il dito sull'immagine: scorrendo da sinistra a destra si visualizzano in ordine i nuovi inspirome generati durante la sessione corrente e i vecchi preferiti. Scorrendo da destra a sinistra si può navigare la lista in ordine inverso e una volta raggiunta la fine di quest'ultima scorrere ulteriormente porta alla generazione di nuove immagini.

Premere il bottone galleggiante con il cuore permette di aggiungere l'inspirome corrente tra i preferiti o di rimuoverlo da essi. Tenere premuto il dito sull'inspirome permette di copiare l'url dell'immagine negli appunti, mentre premere l'immagine una volta fa accedere alla schermata di modifica.

Dalla schermata di modifica è possibile togliere e aggiungere l'inspirome tra i preferiti tramite il bottone con il cuore, dare all'immagine un voto tra 1 e 5 attraverso un bottone segmentato e modificare la lista delle tag attraverso un campo di testo.

Dalla home page si può accedere al drawer di navigazione tramite il pulsante hamburger in alto a sinistra. Dal drawer si può tornare alla home page o muoversi verso la pagina dei preferiti o verso quella della ricerca per tag.

Nella pagina dei preferiti vengono visualizzati gli inspirome preferiti in ordine di voto. È possibile passare dall'ordine ascendente al discendente e vice versa tramite il bottone con la freccia, localizzato nella appbar in modalità verticale e in basso a destra in un bottone galleggiante in modalità orizzontale.

Nella pagina di ricerca per tag è possibile visualizzare tutte le immagini preferite che hanno una certa tag. La tag viene scelta tramite menu a tendina in modalità verticale o tramite una lista di pulsanti in modalità orizzontale. 

In tutte le pagine rimane la funzione di copiatura del link all'immagine tramite pressione prolungata e di apertura della pagina di modifica tramite tocco.

## Esperienza utente

L'interfaccia grafica dell'applicazione si adatta alle visualizzazioni in orizzontale e verticale.

| | | 
| --- | --- | 
| <img src="/images/homepage-portrait.png"> | <img src="/images/homepage-landscape.png"> |

La versione verticale dell'homepage fa uso dell'*appbar* e di un *floating action button*. Nella versione orizzontale si è preferito togliere l'*appbar* per guadagnare spazio verticale e si è spostato il pulsante hamburger in un *floating action button*. La pagina contiene un *gesture detector* per la navigazione, mentre l'immagine è un widget composito chiamato *inspiring image viewer* che contiene il widget di visualizzazione dell'inspirome e il *gesture detector* per il tap e il long press sull'immagine.

| | | 
| --- | --- | 
| <img src="/images/editing-portrait.png"> | <img src="/images/editing-landscape.png"> | 

La pagina di editing contiene l'*appbar*, l'*inspiring image viewer*, un *elevated button*, un *segmented button* e un *tags textfield* dall'omonimo pacchetto. In verticale tutti gli elementi sono racchiusi in un *single child scroll view* mentre in orizzontale l'immagine non lo è. Il *single child scroll view* permette all'interfaccia di adattarsi quando compare la tastiera a seguito dell'interazione con il *tags textfield*. 

| | | 
| --- | --- | 
| <img src="/images/favourites-portrait.png"> | <img src="/images/favourites-landscape.png"> | 

La pagina dei preferiti contiene, nella parte principale, una *gridview* per mostrare e rendere scrollabili le *inspiring image viewer*. Nella versione verticale viene utilizzata l'appbar per il tasto di uscita dalla pagina e di inversione dell'ordine delle immagini, mentre nella versione orizzontale l'appbar è eliminata per motivi di spazio e i bottoni spostati in due *floating action button*. La *gridview* presenta due colonne in verticale e una sola riga in orizzontale.  

| | | 
| --- | --- | 
| <img src="/images/tags-portrait.png"> | <img src="/images/tags-landscape.png"> |

Nella pagina della ricerca per tag ancora una volta l'*appbar* viene eliminata nella modalità orizzontale e il suo bottone spostato in un *floating action button*. Il selezionamento della tag avviene tramite *dropdown menu* in verticale e *custom scroll view* contenente *elevated button* in orizzontale. Entrambi cambiano lo stato interno della pagina modificando le immagini mostrate dalla *gridview*, che altrimenti si comporta come nella pagina dei preferiti. 

