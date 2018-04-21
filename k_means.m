function [centroids] = k_means(K, hist)
    global SEED
    %rng(SEED)
    max_iterations = 1000;
    [N, M] = size(hist);
    
    C = [[randi(N, [1, K])]', [randi(M, [1, K])]']
    for iteration = 1 : max_iterations
        C_next = zeros(K, 2);
        count = zeros(K , 1);
        for i = 1 : N
            for j = 1 : M
                P = [i, j];
                dists = [];
                P_eucl = [];
                for k = 1 : K
                    [dists(end + 1), P_new] = get_dist(C(k, :), P, [N, M]);
                    P_eucl = [P_eucl; P_new];
                end
                [dist, k] = min(dists);
                
                if dist < 30
                    C_next(k, :) = C_next(k, :) + P_eucl(k, :) * hist(i, j);
                    count(k) = count(k) + hist(i, j);
                end
            end
        end
        C_next = C_next ./ count
        if isequal(C, C_next)
            break
        end
        for k = 1 : K
            if C_next(k, 1) < 1
                C_next(k, 1) = C_next(k, 1) + N;
            elseif C_next(K, 1) > N
                C_next(k, 1) = C_next(k, 1) - N;
            end
        end
        C = C_next;
        bar3(hist)
        hold on
        [x, y, z] = sphere;
        
        for k = 1 : K
            surf(x+C(k, 1), y + C(k, 2), z*0.01)
        end
        hold off
        waitforbuttonpress       
    end
    centroids = int8(C);
end    

function [dist, P_eucl] = get_dist(centroid, P, dim)
    P_eucl = P;
    if abs(centroid(1) - P(1)) > dim(1) - abs(centroid(1) - P(1))
        if P(1) > centroid(1)
            P_eucl(1) = P_eucl(1) - dim(1);
        else
            P_eucl(1) = P_eucl(1) + dim(1);
        end
    end
    dist = sqrt(sum((centroid - P_eucl).^2));
end