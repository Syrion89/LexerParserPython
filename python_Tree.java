
public class python_Tree  {
    
	public static Tree<String> tree = new Tree<String>("Python_program");
        
}

class PythonNode<String> extends Node{
    int line;
    public PythonNode(String data,int line){
        super(data);
        this.line = line;
    }
    
}

class Identifier<String> extends PythonNode{
	
	public Identifier(String data,int line) {
		super(data,line);
	}
	
	
}

class Lista<String> extends PythonNode{
	
	public Lista(String data,int line) {
		super(data,line);
	}
		
}

class Import<String> extends PythonNode{
	public Import(String data,int line){
		super(data,line);
		
	}
	public void addChildren(Node<String> op){
		this.addChild(op);
	}
}


class Assignment<String> extends PythonNode{
	public Assignment(String assignment, Node<String> op1, Node<String> op2, int line){
		super(assignment,line);
		this.addChild(op1);
		this.addChild(op2);
	}
}

class As<String> extends PythonNode{
	public As(Identifier<String> op, int line){
		super("As",line);
		this.addChild(op);
	}
	public void addChildren(Node<String> op){
		this.addFirstChild(op);
	}
}

	
class Function<String> extends PythonNode{
	public Function(Node<String> name,Node<String> paramlist, Node<String> body, int line){
		super("Fun_Dec",line);
		this.addChild(name);
		this.addChild(paramlist);
		this.addChild(body);
	}
	public Function(Node<String> name, Node<String> body,int line){
		super("Fun_Dec",line);
		this.addChild(name);
		this.addChild(body);
	}
}

class Classe<String> extends PythonNode{
	public Classe(Node<String> name,Node<String> body, int line){
		super("Class",line);
		this.addChild(name);
		this.addChild(body);
	}
}

class Stringa<String> extends PythonNode{
	
	public Stringa(String data,int line) {
		super(data,line);
	}
		
}

class BoolOp<String> extends PythonNode{
	public BoolOp(String op,Node<String> op1,Node<String> op2, int line){
		super(op,line);
		this.addChild(op1);
		this.addChild(op2);
	}
	public BoolOp(String op,Node<String> op1, int line){
		super(op,line);
		this.addChild(op1);
	}
}


class Numeric<String> extends PythonNode{
	
	public Numeric(String data,int line) {
		super(data,line);
	}
		
}

class Boolean<String> extends PythonNode{
	
	public Boolean(String data,int line) {
		super(data,line);
	}
		
}

class ArithExp<String> extends PythonNode{
	public ArithExp(String op,Node<String> op1,Node<String> op2, int line){
		super(op,line);
		this.addChild(op1);
		this.addChild(op2);
	}
}

class Control<String> extends PythonNode{
	public Control(String op,Node<String> suite,int line){
		super(op,line);
		this.addChild(suite);
	}

	public Control(String op,Node<String> test, Node<String> suite,int line){
		super(op,line);
		this.addChild(test);
		this.addChild(suite);
	}
}

class TryFinally<String> extends PythonNode{
	public TryFinally(String op,Node<String> suite, int line){
		super(op,line);
		this.addChild(suite);
	}

}


class ArrayEle<String> extends PythonNode{
	public ArrayEle(Node<String> name,Node<String> param,int line){
		super("Array_Element",line);
		this.addChild(name);
		this.addChild(param);
	}
	public ArrayEle(Node<String> name,int line){
		super("Array_Element",line);
		this.addChild(name);
	}
}

class FunctionCall<String> extends PythonNode{
	public FunctionCall(Node<String> name,Node<String> paramlist,int line){
		super("Function_Call",line);
		this.addChild(name);
		this.addChild(paramlist);
	}
	public FunctionCall(Node<String> name,int line){
		super("Fun_Call",line);
		this.addChild(name);
	}
}

class ItemCall<String> extends PythonNode{
	public ItemCall(Node<String> op1,Node<String> op2, int line){
		super(".",line);
		this.addChild(op1);
		this.addChild(op2);
	}
}

