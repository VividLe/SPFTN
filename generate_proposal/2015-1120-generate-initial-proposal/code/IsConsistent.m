function iscons=IsConsistent(allpixnum,pro_f,pro_b)
%设阈值，判断两次投影的结果是否一致
consth=0.2;

inconsistentpnum=sum(sum(xor(pro_f,pro_b)));
incpro=inconsistentpnum/allpixnum; 

if incpro<consth
    iscons=1;
else
    iscons=0;
end

end

