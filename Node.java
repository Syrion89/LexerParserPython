import java.util.ArrayList;
import java.util.List;



public class Node<T> {
    	
    	private T data;
        private Node<T> parent;
        private List<Node<T>> children;
        
        public Node(T data){
    		this.data = data;
    		this.children = new ArrayList<Node<T>>();
    	}
        
          public Node(T data,Node<T> parent){
                this.parent = parent;
    		this.data = data;
    		this.children = new ArrayList<Node<T>>();
    	}
        
        public Node<T> getParent(){
            return this.parent;
        }
        
        public void setParent(Node<T> parent){
            this.parent = parent;
        }
        
        public List<Node<T>> getChilds(){
        	return this.children;
        }
        
        public void addChild(Node<T> child){
        	this.children.add(child);
        }
        public void addFirstChild(Node<T> child){
        	this.children.add(0,child);
        }
        
        public boolean hasChilds(){
        	return !this.children.isEmpty();
        }
        
        public T getData(){
        	return this.data;
        }
        
        public void setData(T data){
            this.data = data;
        }
        
        public void dump(){
        	System.out.print(this.data + " ");
        }
        
        
    }