function output =NN_F(input)

layer_nodes_num=[200,150,100,100];
bias=0.00001;
%input=traindata(:,1);
pre_layer_nodes_num=length(input);
pre_layer_nodes_value=input';         % input
for l=1:length(layer_nodes_num)
    curr_layer_nodes_num=layer_nodes_num(l);
    clear curr_layer_nodes_value;
    for it=1:curr_layer_nodes_num
        curr_node_input_weight=randn(1,pre_layer_nodes_num);
        xx=sum(pre_layer_nodes_value.*curr_node_input_weight);
        curr_layer_nodes_value(it)=tanh(xx/2.5);
    end
    pre_layer_nodes_value=curr_layer_nodes_value;
    pre_layer_nodes_num=curr_layer_nodes_num;
end
output=curr_layer_nodes_value;
end
