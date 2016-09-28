class Stack:
     def __init__(self):
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
            elif self.items[len(self.items)-1] == 's':
                self.items.pop()
                primo = self.items.pop()
                secondo = self.items.pop()
                self.items.append(primo)
                self.items.append(secondo)      
s = Stack()
while True:
    n = raw_input(">")
    if n == 'x':
        print 'bye'
        break
    elif n =='d':
        s.printReverse()
    elif n == 'e':
        s.evaluate()
    else: 
        s.push(n)