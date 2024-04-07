% tracker performance evaluation tool for our benchmark
% 07/19/2018


% check why there is -1


clc; clear; close all;

addpath('./utils/');
addpath('./sequence_evaluation_config/');

dataset_name = 'MV-RGBT'; % ['AntiUAV600', 'HalDrone']

tmp_mat_path  = './tmp_mat/';          % path to save temporary results
% path_anno     = ['./annos/' dataset_name '/'];            % path to annotations
path_anno     = ['./annos/' 'Annotations' '/'];            % path to annotations
% path_att      = './annos/att/';        % path to attribute
rp_all        = ['./results/', dataset_name '/'];          % path to results
save_fig_path = ['./res_fig/', dataset_name '/'];          % path to result figures
save_fig_suf  = 'png';                 % suffix of figures, 'png' or 'eps'

% use normalization or not
norm_dst = false;         

trackers   = config_tracker(dataset_name);

% files = dir(rp_all);
% size0 = size(files);
% files = files(3:size0-2);
% trackers = {};
% for i= 1:size(files)
%     trackers = [trackers, struct('name', files(i).name, 'type', 'txt', 'namePaper', '1111')];
% end

sequences  = config_sequence(dataset_name);
plot_style = config_plot_style();

% for debug
% sequences = sequences(154:310);

num_seq = numel(sequences);
num_tracker = numel(trackers);

% load tracker info
name_tracker_all = cell(num_tracker, 1);
for i = 1:num_tracker
    name_tracker_all{i} = trackers{i}.name;
end


% parameters for evaluation
% metric_type_set = {'overlap','error'};
switch dataset_name
    case 'HalDrone'
        metric_type_set = {'error'};
        ranking_type_set = {'threshold'};
    otherwise
        metric_type_set = {'overlap', 'error'};
        ranking_type_set = {'AUC', 'threshold'};
end
% metric_type_set = {'error'};
eval_type       = 'OPE';
ranking_type    = 'AUC';
% ranking_type    = 'threshold';   % change it to 'AUC' for success plots
rank_num        = 35;

threshold_set_error   = 0:50;
if norm_dst
    threshold_set_error = threshold_set_error / 100;
end
threshold_set_overlap = 0:0.05:1;

for i = 1:numel(metric_type_set)
    % error (for distance plots) or overlap (for success plots)
    metric_type = metric_type_set{i};
    ranking_type = ranking_type_set{i};
    switch metric_type
        case 'error'
            threshold_set = threshold_set_error;
            rank_idx      = 21;
            x_label_name  = 'Location error threshold';
            y_label_name  = 'Precision';
        case 'overlap'
            threshold_set = threshold_set_overlap;
            rank_idx      = 11;
            x_label_name  = 'Overlap threshold';
            y_label_name  = 'Success rate';
    end
    
    if (strcmp(metric_type, 'error') && strcmp(ranking_type, 'AUC')) || (strcmp(metric_type, 'overlap') && strcmp(ranking_type, 'threshold'))
        continue;
    end
   
    t_num = numel(threshold_set);
    
    % we only use OPE for evaluation
    plot_type = [metric_type '_' eval_type];
    
    switch metric_type
        case 'error'
            title_name = ['Precision plots of ' eval_type];
            if norm_dst
                title_name = ['Normalized ' title_name];
            end
            title_name =[title_name ' on ' dataset_name];
            
            dataName = [tmp_mat_path 'aveSuccessRatePlot_' num2str(num_tracker) ...
                'alg_'  plot_type '.mat'];
            
        case 'overlap'
            title_name = ['Success plots of ' eval_type];
            title_name =[title_name ' on ' dataset_name];
            
            dataName = [tmp_mat_path 'aveSuccessRatePlot_' num2str(num_tracker) ...
                'alg_' plot_type '.mat'];
    end
    
    % evaluate tracker performance
    if ~exist(dataName, 'file')
        eval_tracker(dataset_name, sequences, trackers, eval_type, name_tracker_all, ...
                    tmp_mat_path, path_anno, rp_all, norm_dst);
    end
    
    % plot performance
    load(dataName);
    
    switch metric_type
        case  'error'
            num_tracker = size(ave_success_rate_plot_err, 1);
            
        case 'overlap'
            num_tracker = size(ave_success_rate_plot, 1);
    end
    
%     num_tracker = size(ave_success_rate_plot, 1);
%      num_tracker = size(ave_success_rate_plot_err, 1);
%     num_tracker = size(ave_success_rate_SR_plot, 1);
    
    if rank_num > num_tracker || rank_num <0
        rank_num = num_tracker;
    end
    
    fig_name= [plot_type '_' ranking_type];
    idx_seq_set = 1:numel(sequences);
    
    % draw and save the overall performance plot
    switch metric_type
        case  'error'
            plot_draw_save(num_tracker, plot_style, ave_success_rate_plot_err, ...
                   idx_seq_set, rank_num, ranking_type, rank_idx, ...
                   name_tracker_all, threshold_set, title_name, ...
                   x_label_name, y_label_name, fig_name, save_fig_path, ...
                   save_fig_suf);
        case 'overlap'
            plot_draw_save(num_tracker, plot_style, ave_success_rate_plot, ...
                   idx_seq_set, rank_num, ranking_type, rank_idx, ...
                   name_tracker_all, threshold_set, title_name, ...
                   x_label_name, y_label_name, fig_name, save_fig_path, ...
                   save_fig_suf);
    end


end