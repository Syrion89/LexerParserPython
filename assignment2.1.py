#Per Python 2.7 (Molte librerie ancora non supportano Python 3)
#Esercizio con somma, sottrazione, moltiplicazione e divisione
# Dato che la mia macchina a stack sa fare solo la somma (ho aggiungo anche la sottrazione essendo simile) ho pensato di fare tutte le operazioni di moltiplicazione e divisione prima di dare la stringa in input alla macchina a stack
class Stack:
     def __init__(self):
         self.items = []
     def Empty(self):
         self.items = []
     def isEmpty(self):
         return self.items == []
     def push(self, item):
         self.items.append(item)
     def pop(self):
         return self.items.pop()
     def peek(self):
         return self.items[len(self.items)-1]

     def size(self):
         return len(self.items)
     def printReverse(self):
         for i in reversed(self.items):
            print i
     def evaluate(self):
            if self.items[len(self.items)-1] == '+':
                self.items.pop()
                primo = self.items.pop()
                secondo = self.items.pop()
                somma = int(primo)+int(secondo)
                self.items.append(somma)
            elif self.items[len(self.items)-1] == '-':
                self.items.pop()
                primo = self.items.pop()
                secondo = self.items.pop()
                somma = int(secondo)-int(primo)
                self.items.append(somma)    
            elif self.items[len(self.items)-1] == 's':
                self.items.pop()
                primo = self.items.pop()
                secondo = self.items.pop()
                self.items.append(primo)
                self.items.append(secondo)    
s = Stack()
flag = 0
while True:
    string = ""
    lista = []
    tmp = []
    n = raw_input(">")
    if n == "":
        flag = flag+1
        if flag == 2:
            print "bye"
            break
    else:   
        flag = 0
    if n == 'x':
        break
    while len(n) > 0 :
        if n[0].isdigit():
            string= string+ str(n[0])   
        else:
            lista.append(string)
            lista.append(n[0])
            string =""
        n = n[1:]
    lista.append(string)
    #rimuovo le moltiplicazioni e le divisioni sostituendole con i risultati
    i=0
    while len(lista) - i >0 :

        val = lista[i]
        if val == '*':
            valore = int(lista[i-1])*int(lista[i+1])
            lista[i-1] = valore
            lista.pop(i)
            lista.pop(i)
        elif val == '/':
            valore = int(lista[i-1])/int(lista[i+1])
            lista[i-1] = valore
            lista.pop(i)
            lista.pop(i)
        else:
            i=i+1
    tmp.append(lista.pop(0))
    while len(lista) > 0:
        tmp.append(lista.pop(0))
        tmp.append(lista.pop(0))
        tmp.append('s')
        tmp.append('e')
        tmp.append('e')
    while len(tmp) >0:
        val = tmp.pop(0)
        if val == 'e':
            s.evaluate()
        else:
            s.push(val)
    print s.pop()