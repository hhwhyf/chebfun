function f = restrict(f, dom)
% RESTRICT  Restrict the domain of a CHEBFUN2.
%
% F = RESTRICT(F, DOM) approximates the CHEBFUN2 on the domain DOM.

% Copyright 2013 by The University of Oxford and The Chebfun2 Developers.
% See http://www.maths.ox.ac.uk/chebfun/ for Chebfun2 information.

% TODO: Better DOCs

if ( isa( dom, 'double' ) )    
    if ( numel( dom ) == 4 )                   % Restrict to DOM. 
        xlen = diff( dom(1:2) );
        ylen = diff( dom(3:4) );
        
        if ( ( xlen == 0 ) && ( ylen == 0) )   % DOM is a point.
            f = feval(f, dom(1), dom(3));
        elseif ( xlen == 0 )                   % DOM is a vertical line
            cols = restrict(f.cols, dom(3:4));
            rows = feval(f.rows, dom(1)); 
            d = 1./f.pivotValues; 
            % Set infinite values to zero.
            d(d == inf) = 0;                   
            f = cols * diag( d ) * rows.';  
        elseif ( ylen == 0 )                   % DOM is a horizontal line
            rows = restrict(f.rows, dom(1:2));
            cols = feval(f.cols, dom(3)); 
            d = 1./f.pivotValues; 
            % Set infinite values to zero.
            d(d == inf) = 0;  
            f = cols * diag( d ) * rows.'; 
        else                                   % DOM is not degenerate
            f.cols = restrict(f.cols, dom(3:4));
            f.rows = restrict(f.rows, dom(1:2));
            f.domain = dom;
        end
    else
        error('CHEBFUN2:RESTRICT', 'Domain not determined.');
    end
    
elseif (isa( dom, 'chebfun' ))
    f = feval(f, dom);
    
end

end