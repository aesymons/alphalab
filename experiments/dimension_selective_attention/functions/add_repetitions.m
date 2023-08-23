function rep_vec = add_repetitions(vec,ind,nchanges,nreps)
    new_vec = true(1,length(vec)+nreps);
    new_vec(ind + (1:numel(ind))) = false;
    new_vec2(new_vec) = vec;
    numbers_to_duplicate = vec(ind);
    ind2 = (new_vec2 == 0);
    new_vec2(ind2) = numbers_to_duplicate;
    new_vector = new_vec2; 
    
    for i = 1:length(new_vector)
        n = repmat(new_vector(i),nchanges,1);
        rep_vec(:,i) = n;
    end
    rep_vec = reshape(rep_vec,length(rep_vec)*nchanges,1);
end
