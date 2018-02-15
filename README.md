# hydrological_modelling

##Autoregresnı́ model
Autoregresnı́ model vyjadřuje průtok jako lineárnı́ kombinace předešlých  
$$ Q(t) = \beta_{1}\cdot Q(t-1) + \beta_{2}\cdot Q(t-2) + \beta_{3}\cdot Q(t-3) +  ... + \beta_{h}\cdot Q(t-h) $$  
                           
###Postup

1. Vytvořte funkci, která spočte hodnotu $\gamma_h$ pomocí následující rovnice, argumenty funkce jsou vektor průtoků $Q$ a časový posun $h$
$$ \gamma_{h} = \frac{1}{N-h}\sum_{t=1}^{N-h}(Q_{t}-\bar{Q})\cdot (Q_{t-h}-\bar{Q}) $$       
2. Vytvořte funkci, která spočte vektor $\gamma$ opakovaným volánı́m funkce vytvořené v prvnı́k kroku. Argumenty funkce jsou vektor průtoků $Q$ a sekvence průtokové historie $1:h$
$$ \gamma = \begin{pmatrix} \gamma_{1} \\  \gamma_{2} \\  \gamma_{3} \\ \vdots \\ \gamma_{h} \end{pmatrix} $$  
3. Vytvořte funkci, která naplní matici $\Gamma$ opakovaným volánı́m funkce vytvořené v prvnı́ kroku. Argumenty funkce jsou vektor průtoků $Q$ a sekvence průtokové historie $0:h-1$
$$ \Gamma = \begin{pmatrix} \gamma_{0}  & \gamma_{1} &  \gamma_{2}& \cdots & \gamma_{h-1} \\ \gamma_{1} & \gamma_{0} & & & \gamma_{h-2} \\ \gamma_{2}  & & \gamma_{0} & & \gamma_{h-3} \\ \vdots & & & \ddots & \vdots  \\ \gamma_{h-1} & \gamma_{h-2} & \gamma_{h-3} &  \cdots & \gamma_{0} \end{pmatrix} $$  
4. Vytvořte funkci, která spočte následující rovnici pro různou délku průtokové historie
$$ \beta=\Gamma^{-1}\cdot \gamma $$  
5. Vytvořte funkci, která Vám spočte hledaná průtoková data. Vstupem jsou odhadnuté parametry $\beta$ a vektor průtoků $\overrightarrow{Q}$
$$Q = \beta \cdot \overrightarrow{Q}$$  
6. Vytvořte funkci na vizualizaci výsledků  

##Lineární model  
###Postup  
1. Vytvořte funkci, která vytvořı́ matici \boldsymbol{A}. Parametry funkce jsou vektory vstupnı́ch měřených dat a jejich historie použı́vané při predikci  
$$ \boldsymbol{A} = \left(\begin{array}{ccc|cc|c}
Q_{3}  & Q_{2} &  Q_{1} & P_{3} & P_{2} & E_{3} \\
Q_{4}  & Q_{3} &  Q_{2} & P_{4} & P_{3} & E_{4} \\
Q_{5}  & Q_{4} &  Q_{3} & P_{5} & P_{4} & E_{5} \\
\vdots  & \vdots &  \vdots & \vdots & \vdots & \vdots \\
Q_{n-1}  & Q_{n-2} &  Q_{n-3} & P_{n-1} & P_{n-2} & E_{n-1} \\
\end{array}\right)$$  
2. Vytvořte funkci, která stanovı́ parametry $\beta$ 
$$ \beta = ( \boldsymbol{A}^{T} \cdot \boldsymbol{A})^{-1} \cdot ( \boldsymbol{A}^{T} \cdot \overrightarrow{Q}) $$  
3. Vytvořte funkci, která provede simulaci průtoků za použitı́m matice \boldsymbol{A} a vektoru parametrů \beta 
$$Q = \beta \cdot \boldsymbol{A} $$  
4. Vytvořte funkci na vizualizaci výsledků  
  
  
**Pozn. 1:** Uvedený postup je závislý na počtu použité historie při výpočtu a vstupnı́ch datech. Celkový počet historie použitých dat určuje počet sloupců v matici \boldsymbol{A}. Počet řádků je určen historiií a počtem použitých měřených dat průtoků $Q$.  
  
**Pozn. 2:** U modelu LM P–Q: vstupnı́ dat jsou pouze srážková, u modelu LM PQ–Q: vstupnı́ data jsou srážky a průtoky a u modelu LM PQI–Q: vstupnı́ data jsou srážky, průtoky a dalšı́ informace. U modelu LM PQI–Q můžete použı́t napřı́klad data potenciálnı́ evapotranspirace maximálnı́ch a minimálnı́ch teplot. Viz. popis dat pro dataset MOPE
