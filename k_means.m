function [centroids] = k_means(K, hist)
    global VERBOSE
    global SEED
    rng(SEED)
    max_iterations = 1000;
    [N, M] = size(hist);
    
    C = [[randi(N, [1, K])]', [randi(M, [1, K])]'];
    if VERBOSE
        show_centroids(C, hist);
    end
    for iteration = 1 : max_iterations
        C_next = zeros(K, 2);
        weights = zeros(K , 1);
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
                
                C_next(k, :) = C_next(k, :) + P_eucl(k, :) * hist(i, j);
                weights(k) = weights(k) + hist(i, j);
            end
        end
        C_next = floor(C_next ./ weights);
        C_next
        for k = 1 : K
            if C_next(k, 1) < 1
                C_next(k, 1) = C_next(k, 1) + N;
            elseif C_next(k, 1) > N
                C_next(k, 1) = C_next(k, 1) - N;
            end
        end
        if isequal(C, C_next)
            break
        end
        C = C_next;
        if VERBOSE
            show_centroids(C, hist);
        end
    end
    centroids = [struct('x', {}, 'y', {}, 'weight', {})];
    for k = 1 : K
        if ~isnan(C(k, 1)) && ~isnan(C(k, 2))
            centroids(end + 1) = struct('x', C(k, 1), 'y', C(k, 2), 'weight', weights(k));
        end
    end
    [values, indexes] = sort([centroids.weight],'descend');
    centroids = centroids(indexes);
end

function show_centroids(C, hist)
    K = length(C);
    bar3(hist)
    hold on
    [x, y, z] = sphere;
    C
    for k = 1 : K
        surf(x+floor(C(k, 2)), y + floor(C(k, 1)), z*0.01)
    end
    hold off
    waitforbuttonpress
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