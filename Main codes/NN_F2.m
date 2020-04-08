function output =NN_F2(traindata)
layer_nodes_num=[400,400,300,150];
[input_dimension,trainlength] = size(traindata);
pre_layer_nodes_num=input_dimension;
all_weights={};
for l=1:length(layer_nodes_num)
    curr_layer_nodes_num=layer_nodes_num(l);
    for it=1:curr_layer_nodes_num
        curr_node_input_weight=randn(1,pre_layer_nodes_num);
        all_weights{l,it}=curr_node_input_weight;
    end
    pre_layer_nodes_num=curr_layer_nodes_num;
end

clear output
for i=1:trainlength
    pre_layer_nodes_num=input_dimension;
    pre_layer_nodes_value=traindata(:,i);         % input
    for l=1:length(layer_nodes_num)
        curr_layer_nodes_num=layer_nodes_num(l);
        clear curr_layer_nodes_value;
        for it=1:curr_layer_nodes_num
            curr_node_input_weight=all_weights{l,it};
%              size(pre_layer_nodes_value) %
%              size(curr_node_input_weight)
            xx=sum(pre_layer_nodes_value.*curr_node_input_weight');
            curr_layer_nodes_value(it)=tanh(xx/2.5);
        end
        pre_layer_nodes_value=curr_layer_nodes_value';
        pre_layer_nodes_num=curr_layer_nodes_num;
    end
    output(:, i)=curr_layer_nodes_value;
end

end