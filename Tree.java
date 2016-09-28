import java.util.ArrayList;
import java.util.List;

public class Tree<T> {
    private Node<T> root;

    public Tree(T rootData) {
        root = new Node<T>(rootData);
       
    }
    
    public Node<T> getRoot(){
    	return this.root;
    }
    
    public List<Node<T>> getRootChilds(){
    	return this.root.getChilds();
    }
    
    public void printTree(){
    	
    	printRecursive(this.root,0);
    }
    
    private void printRecursive(Node<T> node, int level){
		printTab(level);
                node.dump();
                System.out.println();
		for(int i = 0;i < node.getChilds().size();i++){
                    
                    printRecursive(node.getChilds().get(i),level+1);
		}
		
		
    }
   
    private void printTab(int n){
		
		for(int i = 0; i<n;i++)
			System.out.print("\t|_");
    }
	
}