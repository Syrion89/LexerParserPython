

import java.util.ArrayList;

import javax.swing.JFrame;

import com.mxgraph.swing.mxGraphComponent;
import com.mxgraph.view.mxGraph;

public class GraphicTree extends JFrame
{
	
	int offsetX = 50;
	int offsetY = 80;
	
	private int widthBlock = 100;
	private int heightBlock = 30;
	private mxGraph graph = new mxGraph();
	private Object parent = graph.getDefaultParent();
	/**
	 * 
	 */
	private static final long serialVersionUID = -2707712944901661771L;

	public GraphicTree()
	{
		super("Graphic Tree");
		graph.getModel().beginUpdate();
		
	}
	
	public void printGraphicTree(){
	
		graph.getModel().endUpdate();
		mxGraphComponent graphComponent = new mxGraphComponent(graph);
		getContentPane().add(graphComponent);
	}

	private Object buildVertex(String name, int x, int y){
		
		
		return graph.insertVertex(parent, null, name , x, y,
				widthBlock, heightBlock);
		
	}
	
	public void addChild(Object v1, Object v2){
		
		graph.insertEdge(parent, null, "", v1, v2);
		
	
	}
	
	/*public static void main(String[] args)
	{
		GraphicTree frame = new GraphicTree();
		
		
		//SIMPLE TREE
		String p = "program";
		Tree<String> t = new Tree<String>(p);
		Node root = t.getRoot();
		
		root.addChild(new Node("prova1"));
		root.addChild(new Node("prova2"));
		root.addChild(new Node("prova3"));
		root.addChild(new Node("prova4"));
		
		Node<String> node = new Node<String>("prova5");
		node.addChild(new Node("prova6"));
		node.addChild(new Node("prova7"));
		node.addChild(new Node("prova8"));
		root.addChild(node);
		
		Node<String> node2 = new Node<String>("prova9");
		node2.addChild(new Node("prova10"));
		node2.addChild(new Node("prova11"));
		Plus pl = new Plus("plus",new Node("1"),new Node("6"));
		node2.addChild(new Plus("prova12", new Node("4"),pl));
		root.addChild(node2);
		
		frame.generateTree(root,null,0,0);
		
		frame.printGraphicTree();
		frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		frame.setSize(400, 320);
		frame.setVisible(true);
	}*/
	
	/*
	 * this method draw the tree from class Tree 
	 * 
	 */
	
	
	
	
        public void generateTree(Node<String> root,Object vertex, int x , int y,int treeWidth){
		Object v;
                int block = 0;
		if(vertex == null)
			 v = buildVertex(root.getData(), treeWidth/2, y);  //la prima volta creo la radice
		else 
			v = vertex;
		
		//get all childs from the node
		ArrayList<Node<String>> childList = (ArrayList)root.getChilds();
                if(childList.size() > 0 )
                    block = (int)treeWidth / childList.size();
		int localX = x;
		int localY = y + offsetY;
		for(int i = 0;i < childList.size();i++){
			Node<String> childNode = childList.get(i);
			Object child = buildVertex(childNode.getData(), localX , localY);
			//create the edge in the draw
			addChild(v, child);
			if(childNode.getChilds().size() > 0)
                            generateTree(childNode,child,localX , localY,block );
			localX += block;
			
		}
		
	}

}
