function exp_proposal = get_region_scores(imdir, ims, regiondir, opticalFlows, numTopRegions)
        %% Get Object Proposal Scores
        %% Dong Zhang, Center for Research in Computer Vision,UCF 6/20/2013
        %% Copyright (2014), UCF CRCV
        
        bdryPix = 30;
        max_regions=100;

        d = dir(imdir);
        file_surfix='';
        for d_index=1:length(d)
            d_name=d(d_index).name;
            if ~strcmp(d_name,'.')&&~strcmp(d_name,'..')
                if length(d_name)>4
                    file_surfix=d_name(end-2:end);
                    if strcmp(file_surfix,'png')||strcmp(file_surfix,'bmp')...
                            ||strcmp(file_surfix,'jpg')
                        break;
                    else
                    end
                end
            end
        end
        d=dir([imdir '/*.' file_surfix]);

%         try
%             matlabpool close
%         catch exception
%         end
%         matlabpool('open',8);
        %% Load and expand object proposals
        loaded_proposals={};
        loaded_superpixels={};
        loaded_unarys={};
        for imInd = 1:length(d)-1;    
            imname1 = d(imInd).name;        
            segname = [regiondir imname1 '.mat'];
            if ~exist(segname)
                fprintf('   KSVOS(%d/%d): Object proposals (Calculation)\n',imInd,length(d));
                [proposals superpixels image_data unary] = generate_proposals([imdir imname1]);
                saveParForProposals(segname, proposals, superpixels, unary);
            else
                fprintf('   KSVOS(%d/%d): Object proposals (Load)\n',imInd,length(d));
                loaded_data=load(segname, 'proposals', 'superpixels', 'unary');
                proposals=loaded_data.proposals;
                superpixels=loaded_data.superpixels;
                unary=loaded_data.unary;
            end
            diffUnary = diff(unary,1,1);
            ind = max(numTopRegions,find(diffUnary>0,1));
            ind=max(ind,max_regions);
            ind=min(ind,length(unary));
            loaded_proposals{imInd}=proposals(1:ind);
            loaded_superpixels{imInd}=superpixels;
            loaded_unarys{imInd}=unary(1:ind);
        end
        % Expand foward
        new_foward_proposals={};
        new_foward_unarys={};
        for frame_index_current=1:length(loaded_proposals)-1
            frame_index_next=frame_index_current+1
            new_foward_proposals{frame_index_next}={};
            new_foward_unarys{frame_index_next}=[];
            for proposal_index_current=1:length(loaded_proposals{frame_index_current})
                region_current=ismember(loaded_superpixels{frame_index_current},loaded_proposals{frame_index_current}{proposal_index_current});
                region_warped=warpByOpticalFlow_dong(region_current,opticalFlows{frame_index_current}.vx,opticalFlows{frame_index_current}.vy,'linear');
                new_proposal=[];
                new_proposal_unary=0;
                overlap_region_number=0;
                for proposal_index_next=1:length(loaded_proposals{frame_index_next})
                    tracked_region_temp=ismember(loaded_superpixels{frame_index_next}, loaded_proposals{frame_index_next}{proposal_index_next});
                    region_overlap=tracked_region_temp.*region_warped;
                    if double(sum(region_overlap(:)))/double(sum(tracked_region_temp(:)))>0.7
                        new_proposal=[new_proposal loaded_proposals{frame_index_next}{proposal_index_next}];
                        new_proposal_unary=new_proposal_unary+loaded_unarys{frame_index_next}(proposal_index_next);
                        overlap_region_number=overlap_region_number+1;
                    end
                end
                if (length(new_proposal)~=0)&&(overlap_region_number>1)
                    new_foward_proposals{frame_index_next}{length(new_foward_proposals{frame_index_next})+1}=new_proposal;
                    new_foward_unarys{frame_index_next}(length(new_foward_unarys{frame_index_next})+1)=new_proposal_unary/overlap_region_number;
                end
            end
        end
        % Expand backward
        new_backward_proposals={};
        new_backward_unarys={};
        new_backward_proposals{length(loaded_proposals)}={};
        new_backward_unarys{length(loaded_proposals)}=[];
        for frame_index_current=length(loaded_proposals):-1:2
            frame_index_next=frame_index_current-1
            new_backward_proposals{frame_index_next}={};
            new_backward_unarys{frame_index_next}=[];
            for proposal_index_current=1:length(loaded_proposals{frame_index_current})
                region_current=ismember(loaded_superpixels{frame_index_current},loaded_proposals{frame_index_current}{proposal_index_current});
                region_warped=warpByOpticalFlow_dong(region_current,opticalFlows{frame_index_current}.vx,opticalFlows{frame_index_current}.vy,'linear');
                new_proposal=[];
                new_proposal_unary=0;
                overlap_region_number=0;
                for proposal_index_next=1:length(loaded_proposals{frame_index_next})
                    tracked_region_temp=ismember(loaded_superpixels{frame_index_next}, loaded_proposals{frame_index_next}{proposal_index_next});
                    region_overlap=tracked_region_temp.*region_warped;
                    if double(sum(region_overlap(:)))/double(sum(tracked_region_temp(:)))>0.7
                        new_proposal=[new_proposal loaded_proposals{frame_index_next}{proposal_index_next}];
                        new_proposal_unary=new_proposal_unary+loaded_unarys{frame_index_next}(proposal_index_next);
                        overlap_region_number=overlap_region_number+1;
                    end
                end
                if (length(new_proposal)~=0)&&(overlap_region_number>1)
                    new_backward_proposals{frame_index_next}{length(new_backward_proposals{frame_index_next})+1}=new_proposal;
                    new_backward_unarys{frame_index_next}(length(new_backward_unarys{frame_index_next})+1)=new_proposal_unary/overlap_region_number;
                end
            end
        end
        % Add new proposals
        for frame_index=1:length(loaded_proposals)
            for foward_proposal_index=1:length(new_foward_proposals{frame_index})
                loaded_proposals{frame_index}{length(loaded_proposals{frame_index})+1}=new_foward_proposals{frame_index}{foward_proposal_index};    
            end
            loaded_unarys{frame_index}=[loaded_unarys{frame_index}; new_foward_unarys{frame_index}'];
            for backward_proposal_index=1:length(new_backward_proposals{frame_index})
                loaded_proposals{frame_index}{length(loaded_proposals{frame_index})+1}=new_backward_proposals{frame_index}{backward_proposal_index};  
            end
            loaded_unarys{frame_index}=[loaded_unarys{frame_index}; new_backward_unarys{frame_index}'];
            [values indexes]=sort(loaded_unarys{frame_index},'descend');
            loaded_proposals{frame_index}=loaded_proposals{frame_index}(indexes);
            loaded_unarys{frame_index}=values;
        end
        exp_proposal=loaded_proposals;
       
        end

        function saveParForProposals(save_path,proposals, superpixels, unary)
            save('-v7',save_path, 'proposals', 'superpixels', 'unary');
        end

        function saveParForFlows(save_path,vx,vy)
            save(save_path,'vx','vy');
        end