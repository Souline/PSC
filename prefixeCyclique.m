function [trameDMT_plus_prefixe] = prefixeCyclique(trameDMT)
    trameDMT_plus_prefixe = [ trameDMT(length(trameDMT)-31:length(trameDMT)) trameDMT(1:512) ];  
end